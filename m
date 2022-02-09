Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5431A4AE8CF
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiBIFGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356419AbiBIE1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 23:27:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF49C03FEDB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 20:11:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5DA260C1D
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5C7C340E7;
        Wed,  9 Feb 2022 04:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644379917;
        bh=7yckry4AJ9raOYHp7fEw7V3Gvuezxql8YV8p80lNSFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GFYw16E8mecw/22sUOMfWQYImIu80RfSNwnsaAqz+3rC1blbpMO7MwsyYvP7GZfQY
         Ua4DZGcneExn+O0i2410xLW4RDyYQ6z4B+aBPAzonNxN0fNgwNI6EkHMyYCfyZ1V+8
         eAvSogfvIpdUz+4MzOrLp9vsGOIoHMAT3wvr1y3Oc9RufRTnz9lV0rCQ86tG69VRPu
         TtSsO7ET0PxcePP0DmEaZUSqP/KJpghYDcuEQ2XQhJO6Rssuy9sc+LjUhpizpQ/u4L
         hfMcY1DnxPg76SLHVPNs6b28K7n1T+tjcahncT3AwxvyiWGIX5//lmAtNAobwrJQma
         A4pYSCaU210QA==
Date:   Tue, 8 Feb 2022 20:11:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net 1/1] openvswitch: Fix setting ipv6 fields causing hw
 csum failure
Message-ID: <20220208201155.7cc582cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220207144101.17200-1-paulb@nvidia.com>
References: <20220207144101.17200-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Feb 2022 16:41:01 +0200 Paul Blakey wrote:
> Ipv6 ttl, label and tos fields are modified without first
> pulling/pushing the ipv6 header, which would have updated
> the hw csum (if available). This might cause csum validation
> when sending the packet to the stack, as can be seen in
> the trace below.
> 
> Fix this by calling postpush/postpull checksum calculation
> which will update the hw csum if needed.

> -static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
> +static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, __u8 ipv6_tclass, __u8 mask)
>  {
> +	skb_postpull_rcsum(skb, nh, 4);
> +
> +	ipv6_change_dsfield(nh, ~mask, ipv6_tclass);
> +
> +	skb_postpush_rcsum(skb, nh, 4);
> +}

The calls seem a little heavy for single byte replacements.
Can you instead add a helper based on csum_replace4() maybe?

BTW doesn't pedit have the same problem?
