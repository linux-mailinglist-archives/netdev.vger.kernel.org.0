Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D381F999C
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgFOOHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:07:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42075 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728510AbgFOOG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 10:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592230018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+CEyzIoDyDg6IvRlSw0NzhWny8g4aZ57B381D0/2cjw=;
        b=KBj8q/Qe7SJUG77/mNip91/fJcGV3/x2XxsKk0OufYfgf483KTlm6/0t2LOybxaWt0Pb5/
        O0aNlpagE6Sq2Fe30PoNUeY8HX5QZW/fo9r0Si9w+0e5bqOXTXMBzpZpXR1OVJQYmF664K
        +S/b0ykhkMuM2pifhO9K5qfbIdxd0VY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-4_Q951MFMNSUlufOlzQfWg-1; Mon, 15 Jun 2020 10:06:47 -0400
X-MC-Unique: 4_Q951MFMNSUlufOlzQfWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C7A0100CCC8;
        Mon, 15 Jun 2020 14:06:46 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 309BA5D9CC;
        Mon, 15 Jun 2020 14:06:46 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2FA45C08D9; Mon, 15 Jun 2020 11:06:44 -0300 (-03)
Date:   Mon, 15 Jun 2020 11:06:44 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Alaa Hleihel <alaa@mellanox.com>
Subject: Re: [PATCH net 1/2] net/sched: act_ct: Make
 tcf_ct_flow_table_restore_skb inline
Message-ID: <20200615140644.GR47542@localhost.localdomain>
References: <20200614111249.6145-1-roid@mellanox.com>
 <20200614111249.6145-2-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614111249.6145-2-roid@mellanox.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 02:12:48PM +0300, Roi Dayan wrote:
> From: Alaa Hleihel <alaa@mellanox.com>
> 
> Currently, tcf_ct_flow_table_restore_skb is exported by act_ct
> module, therefore modules using it will have hard-dependency
> on act_ct and will require loading it all the time.
> 
> This can lead to an unnecessary overhead on systems that do not
> use hardware connection tracking action (ct_metadata action) in
> the first place.
> 
> To relax the hard-dependency between the modules, we unexport this
> function and make it a static inline one.
> 
> Fixes: 30b0cf90c6dd ("net/sched: act_ct: Support restoring conntrack info on skbs")
> Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/tc_act/tc_ct.h | 11 ++++++++++-
>  net/sched/act_ct.c         | 11 -----------
>  2 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
> index 79654bcb9a29..8250d6f0a462 100644
> --- a/include/net/tc_act/tc_ct.h
> +++ b/include/net/tc_act/tc_ct.h
> @@ -66,7 +66,16 @@ static inline struct nf_flowtable *tcf_ct_ft(const struct tc_action *a)
>  #endif /* CONFIG_NF_CONNTRACK */
>  
>  #if IS_ENABLED(CONFIG_NET_ACT_CT)
> -void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie);
> +static inline void
> +tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie)
> +{
> +	enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
> +	struct nf_conn *ct;
> +
> +	ct = (struct nf_conn *)(cookie & NFCT_PTRMASK);
> +	nf_conntrack_get(&ct->ct_general);
> +	nf_ct_set(skb, ct, ctinfo);
> +}
>  #else
>  static inline void
>  tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie) { }
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index e29f0f45d688..e9f3576cbf71 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -1543,17 +1543,6 @@ static void __exit ct_cleanup_module(void)
>  	destroy_workqueue(act_ct_wq);
>  }
>  
> -void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie)
> -{
> -	enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
> -	struct nf_conn *ct;
> -
> -	ct = (struct nf_conn *)(cookie & NFCT_PTRMASK);
> -	nf_conntrack_get(&ct->ct_general);
> -	nf_ct_set(skb, ct, ctinfo);
> -}
> -EXPORT_SYMBOL_GPL(tcf_ct_flow_table_restore_skb);
> -
>  module_init(ct_init_module);
>  module_exit(ct_cleanup_module);
>  MODULE_AUTHOR("Paul Blakey <paulb@mellanox.com>");
> -- 
> 2.8.4
> 

