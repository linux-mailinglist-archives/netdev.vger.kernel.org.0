Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9625D515346
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 20:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379879AbiD2SIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 14:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379880AbiD2SIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 14:08:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D6DD4C79
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 11:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D6996241D
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94936C385A4;
        Fri, 29 Apr 2022 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651255481;
        bh=9AEYN5fAYZjlShYB+ddmZ65AzZ68U/H2Pq8lKjidat0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q/5Vx/PWGS7lUQW11vg0cVru5WvVZwnlMUZXG5Gu225W7eRLDHoArPZu9KZPmxb1L
         vojyee+WAS295T3ibk5xnFFGrKRXOYO7JpF0/CgS7FU4epBXSN55nIgboFwI0JT5W9
         fmcrxZ6yVAOamG+chNAMn5EfmcF9oYmmGUd0LtrQwg7wAhmrycR8+QOnYtyoBidQ1i
         fGqvbxFqCxNUAT13O0uIXshrdCa9nI8rlV8CyQYhVXZaS000LL4IaBeQYIVvO7oVjx
         3fzyN33EsrCJ/IIqzvY+c22hvDs11jUlWgOPh506PhVgEYiUGPyH6sJAU+w0DTaHd8
         Y7SZ/RqnMjn4g==
Date:   Fri, 29 Apr 2022 11:04:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bin Chen <bin.chen@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next] nfp: VF rate limit support
Message-ID: <20220429110440.497350d0@kernel.org>
In-Reply-To: <20220429110347.1d563c7b@kernel.org>
References: <20220422131945.948311-1-simon.horman@corigine.com>
        <20220425165321.1856ebb7@kernel.org>
        <SA1PR13MB5491A2994E4170BA33CCB7CEECFC9@SA1PR13MB5491.namprd13.prod.outlook.com>
        <20220429110347.1d563c7b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 11:03:47 -0700 Jakub Kicinski wrote:
> On Fri, 29 Apr 2022 08:54:53 +0000 Bin Chen wrote:
> > We agree with your suggestion, thanks. We plan to do this in two steps:
> > 1.The firmware that currently support this feature will reject the nonzero min_tx_rate configuration, so the check here will not step in.  We will remove the check from driver site and upstream the patch. 
> > 2.We will do more investigation jobs and add an appropriate check in the core.
> > What do you think?  
> 
> Sorry, I meant the second part of the condition only, basically
> something like:

I hit the wrong shortcut :) Here's the patch:

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 73f2cbc440c9..8de191cedaf7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2368,6 +2368,19 @@ static int handle_vf_guid(struct net_device *dev, struct ifla_vf_guid *ivt, int
 	return handle_infiniband_guid(dev, ivt, guid_type);
 }
 
+static int rtnl_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate,
+			    int max_tx_rate)
+{
+	int err;
+
+	if (!ops->ndo_set_vf_rate)
+		return -EOPNOTSUPP;
+	if (min_tx_rate > max_tx_rate)
+		return -EINVAL;
+
+	return ops->ndo_set_vf_rate(dev, vf, min_tx_rate, max_tx_rate);
+}
+
 static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
@@ -2443,11 +2456,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 		if (err < 0)
 			return err;
 
-		err = -EOPNOTSUPP;
-		if (ops->ndo_set_vf_rate)
-			err = ops->ndo_set_vf_rate(dev, ivt->vf,
-						   ivf.min_tx_rate,
-						   ivt->rate);
+		err = rtnl_set_vf_rate(dev, ivt->vf,
+				       ivf.min_tx_rate, ivt->rate);
 		if (err < 0)
 			return err;
 	}
@@ -2457,11 +2467,8 @@ static int do_setvfinfo(struct net_device *dev, struct nlattr **tb)
 
 		if (ivt->vf >= INT_MAX)
 			return -EINVAL;
-		err = -EOPNOTSUPP;
-		if (ops->ndo_set_vf_rate)
-			err = ops->ndo_set_vf_rate(dev, ivt->vf,
-						   ivt->min_tx_rate,
-						   ivt->max_tx_rate);
+		err = rtnl_set_vf_rate(dev, ivt->vf,
+				       ivt->min_tx_rate, ivt->max_tx_rate);
 		if (err < 0)
 			return err;
 	}
