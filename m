Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E084357084
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353662AbhDGPiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhDGPh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A6E6112F;
        Wed,  7 Apr 2021 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617809870;
        bh=Qcnl1c4/Lap8XLlLJfybJvApxSxiWOM2q8GsKIuZkpo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VeofZoFg1YoJn7MtmogtTFVgvCconFdDaKkQXpwd079sn2r/JfA5wBIvmO9hht/8d
         oJG8/yKOwMTFlp/kQZdidvf1E+D2mqkyoyBmqYAj3pL6AfZef1jcAdio2oSJMJBdt6
         UwPHQ2+MDXv1MWkTea20nwQ+lOxbGPANOKgTTfXAHcrnzUBz24KqxCPVz+nrjrf7d2
         YhOmCMmfCOL5KyE1HLHvcgy+JIK6buUCcCxYXDryvHqdB2cJ/q4Tk7lhSiiiQLh1P7
         f/IfHZZfTruYkxJTCMHyguWivXY9EWW1DwL5AnzWBwZy0q5Q1h0Vq9+rdOse8fmrRt
         r7KlPkRUonZJg==
Date:   Wed, 7 Apr 2021 08:37:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
Message-ID: <20210407083748.56b9c261@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210407060053.wyo75mqwcva6w6ci@spock.localdomain>
References: <20210406123619.rhvtr73xwwlbu2ll@spock.localdomain>
        <20210406114734.0e00cb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210407060053.wyo75mqwcva6w6ci@spock.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 08:00:53 +0200 Oleksandr Natalenko wrote:
> Thanks for the effort, but reportedly [1] it made no difference,
> unfortunately.
> 
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=212573#c8

The only other option I see is that somehow the NAPI has no rings.

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a45cd2b416c8..24568adc2fb1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7980,7 +7980,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
        struct igb_q_vector *q_vector = container_of(napi,
                                                     struct igb_q_vector,
                                                     napi);
-       bool clean_complete = true;
+       bool clean_complete = q_vector->tx.ring || q_vector->rx.ring;
        int work_done = 0;
 
 #ifdef CONFIG_IGB_DCA
