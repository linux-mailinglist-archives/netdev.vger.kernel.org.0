Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DC5179D56
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 02:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgCEBca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 20:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgCEBc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 20:32:29 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC15A20866;
        Thu,  5 Mar 2020 01:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583371949;
        bh=L98vC4kcXdjJbzOr2xCXnMAY1gyy3OHrovcLL2fx1Tw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BMydMQsWOxrHKMNP52gQbMwltPhQcwDyb37VmXsBh+aXrBeCdvRLja6fOfwVoys8F
         1Z2RwG0aVo5w5twnCE8uCgxMVVf/6ccBM4xQJpJQoG18UztomiOlsw4tFTglNbAC7B
         gWLCdr6ADFnWyzuP+2YdBShjx4kr7yvSN9c9MO9c=
Date:   Wed, 4 Mar 2020 17:32:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 5/8] ionic: support ethtool rxhash disable
Message-ID: <20200304173227.6e95d1a4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <39446ac7-9ce1-1c81-427b-a9821145fd1d@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
        <20200304042013.51970-6-snelson@pensando.io>
        <20200304115902.011ff647@kicinski-fedora-PC1C0HJN>
        <39446ac7-9ce1-1c81-427b-a9821145fd1d@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020 16:24:01 -0800 Shannon Nelson wrote:
> On 3/4/20 11:59 AM, Jakub Kicinski wrote:
> > On Tue,  3 Mar 2020 20:20:10 -0800 Shannon Nelson wrote:  
> >> We can disable rxhashing by setting rss_types to 0.  The user
> >> can toggle this with "ethtool -K <ethX> rxhash off|on",
> >> which calls into the .ndo_set_features callback with the
> >> NETIF_F_RXHASH feature bit set or cleared.  This patch adds
> >> a check for that bit and updates the FW if necessary.
> >>
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> >> ---
> >>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 11 +++++++++--
> >>   1 file changed, 9 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> >> index d1567e477b1f..4b953f9e9084 100644
> >> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> >> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> >> @@ -1094,6 +1094,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
> >>   	u64 vlan_flags = IONIC_ETH_HW_VLAN_TX_TAG |
> >>   			 IONIC_ETH_HW_VLAN_RX_STRIP |
> >>   			 IONIC_ETH_HW_VLAN_RX_FILTER;
> >> +	u64 old_hw_features;
> >>   	int err;
> >>   
> >>   	ctx.cmd.lif_setattr.features = ionic_netdev_features_to_nic(features);
> >> @@ -1101,9 +1102,13 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
> >>   	if (err)
> >>   		return err;
> >>   
> >> +	old_hw_features = lif->hw_features;
> >>   	lif->hw_features = le64_to_cpu(ctx.cmd.lif_setattr.features &
> >>   				       ctx.comp.lif_setattr.features);
> >>   
> >> +	if ((old_hw_features ^ lif->hw_features) & IONIC_ETH_HW_RX_HASH)
> >> +		ionic_lif_rss_config(lif, lif->rss_types, NULL, NULL);  
> >
> > Is this change coming from the HW or from ethtool? AFAIK hw_features
> > are what's supported, features is what's enabled..  
> 
> This is looking at the feature bits coming in from ndo_set_features - if 
> the RX_HASH bit has been turned off in the incoming features bitmask, 
> then I need to disable the hw hashing.
> 
> I believe the confusion is between lif->hw_features, describing what is 
> currently enabled in the hw, versus the netdev->hw_features, that is 
> what we've told the the stack we have available.

Ah, you're very right. So the problem is that the current handling only
sends the general IONIC_LIF_ATTR_FEATURES request, but the device also
needs an extra IONIC_LIF_ATTR_RSS to disable RSS? Got it.
