Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDA0471197
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345955AbhLKEz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 23:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhLKEz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 23:55:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065BBC061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 20:52:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EAE7B82AC0
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 04:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0EBC004DD;
        Sat, 11 Dec 2021 04:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639198338;
        bh=NTzcZvXKTcjI9U0dL4UX4vkmgbHJ3jp0mcZ1DPPg1LE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JUyVTAzoDPAZMRv6Ym/R7tnurCoG8+8FRJ4LEc3X0x5uVfhTA6AzFXQlIso/f5/8q
         Wy49vemrmPYnhKiKwYLKD1dso6m1oG1Nhwwd0E62JgnlTCD1MzLrwGZv5sCh+o8E/z
         nL7VdB3oQ5PNhipxITy/TeAgoaYwjXC45WxYbpdZxq2vzv7IK99OREtEG4Zcv4hbf6
         Map3aLV3tahCheQPd7Yvth06bXEX2oDEDshx0OMng6C+EhxpBXtiOD4Jx16H5YYslc
         vi2KSpcH/14IXvzQs0jWs0va2a8+wjf2vFaH7K/YhxH5MSpopkjhRT+PtuTsSX8cQz
         a31/jXc8jIDpg==
Date:   Fri, 10 Dec 2021 20:52:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net v2 2/3] net/sched: flow_dissector: Fix matching on
 zone id for invalid conns
Message-ID: <20211210205216.1ec35b39@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211209075734.10199-3-paulb@nvidia.com>
References: <20211209075734.10199-1-paulb@nvidia.com>
        <20211209075734.10199-3-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Dec 2021 09:57:33 +0200 Paul Blakey wrote:
> @@ -238,10 +239,12 @@ void
>  skb_flow_dissect_ct(const struct sk_buff *skb,
>  		    struct flow_dissector *flow_dissector,
>  		    void *target_container, u16 *ctinfo_map,
> -		    size_t mapsize, bool post_ct)
> +		    size_t mapsize)
>  {
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> +	bool post_ct = tc_skb_cb(skb)->post_ct;
>  	struct flow_dissector_key_ct *key;
> +	u16 zone = tc_skb_cb(skb)->zone;
>  	enum ip_conntrack_info ctinfo;
>  	struct nf_conn_labels *cl;
>  	struct nf_conn *ct;
> @@ -260,6 +263,7 @@ skb_flow_dissect_ct(const struct sk_buff *skb,
>  	if (!ct) {
>  		key->ct_state = TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
>  				TCA_FLOWER_KEY_CT_FLAGS_INVALID;
> +		key->ct_zone = zone;
>  		return;
>  	}
>  

Why is flow dissector expecting skb cb to be TC now?
Please keep the appropriate abstractions intact.
