Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5218348477D
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiADSIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 13:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiADSIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 13:08:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B093BC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 10:08:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 849E2B817B9
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 18:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7755C36AE9;
        Tue,  4 Jan 2022 18:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641319717;
        bh=tzJNwzbQYjEHm+8zSBtVyaMtIQxHRpyqZ/EP3SIRP1Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X9N3rIMg+SRxzpJjS6ummS7E5T0soh+HtSgssOQuOemu0jcAbDk3mUwG/Ye5/MbOS
         WHbAfqDJja/vqPOSF6/mbUKZktsljH3MCV+eUhtfr3qFJpqmUIcAmpoapxqTZITJVB
         Tg5/bDOH09S73LE2nD1BnKoHVY9+GYJUuz3/e//T09dufYo2TYdNU7CirL3+pIo6Vj
         gBwtZOcQQA1NQLMqUgz/JRxXZbsn1on2KMX/sClk3E/4VDYUM58RBIPlESNpOlwRj8
         qpLQuUkqk62ygRL1hSvPaAjFUAM6X5yh5bBK/fs6slY2u1A9iQqKIRDXEA/Mfp+Dff
         JBZa2lhYzhaPA==
Date:   Tue, 4 Jan 2022 10:08:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, "Vlad Buslov" <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH net 1/1] net: openvswitch: Fix ct_state nat flags for
 conns arriving from tc
Message-ID: <20220104100835.57e51cb0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104082821.22487-1-paulb@nvidia.com>
References: <20220104082821.22487-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 10:28:21 +0200 Paul Blakey wrote:
> Netfilter conntrack maintains NAT flags per connection indicating
> whether NAT was configured for the connection. Openvswitch maintains
> NAT flags on the per packet flow key ct_state field, indicating
> whether NAT was actually executed on the packet.
> 
> When a packet misses from tc to ovs the conntrack NAT flags are set.
> However, NAT was not necessarily executed on the packet because the
> connection's state might still be in NEW state. As such, openvswitch wrongly
> assumes that NAT was executed and sets an incorrect flow key NAT flags.
> 
> Fix this, by flagging to openvswitch which NAT was actually done in
> act_ct via tc_skb_ext and tc_skb_cb to the openvswitch module, so
> the packet flow key NAT flags will be correctly set.

Fixes ?

> Signed-off-by: Paul Blakey <paulb@nvidia.com>

> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 4507d77d6941..bab45a009310 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -287,7 +287,9 @@ struct tc_skb_ext {
>  	__u32 chain;
>  	__u16 mru;
>  	__u16 zone;
> -	bool post_ct;
> +	bool post_ct:1;
> +	bool post_ct_snat:1;
> +	bool post_ct_dnat:1;

single bit bool variables seem weird, use a unsigned int type, like u8.

>  };
>  #endif
>  
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index 9e71691c491b..a171dfa91910 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -197,7 +197,9 @@ struct tc_skb_cb {
>  	struct qdisc_skb_cb qdisc_cb;
>  
>  	u16 mru;
> -	bool post_ct;
> +	bool post_ct: 1;

extra space

> +	bool post_ct_snat:1;
> +	bool post_ct_dnat:1;
>  	u16 zone; /* Only valid if post_ct = true */
>  };
