Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A48618574
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiKCQ6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiKCQ6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:58:46 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E458114A;
        Thu,  3 Nov 2022 09:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667494723; x=1699030723;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kboXdMjcsKsIE8jS4v8fnCLzRg8lOmzZkqPiEreydfs=;
  b=HWTms2jMDZ0ma3rqdZyDLUHKDb6NUOxrcZEsqZQD4yPwj84dAb/jKukr
   yPHVQKTK0xat0q0m64Zooad7OGBhxDaXZB+r/toEF7fbWJesmQz29nxUa
   sGhbs68qujajnadGKFM8c0gvqyOwFy4zMpitbEKZtqja0U7DbK2oKLrb4
   k=;
X-IronPort-AV: E=Sophos;i="5.96,134,1665446400"; 
   d="scan'208";a="147209612"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 16:58:39 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 29CD6A0B52;
        Thu,  3 Nov 2022 16:58:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 3 Nov 2022 16:58:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 3 Nov 2022 16:58:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <chenzhongjin@huawei.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <lorenzo@google.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>, <kuniyu@amazon.com>
Subject: Re: [PATCH net] net: ping6: Fix possible leaked pernet namespace in pingv6_init()
Date:   Thu, 3 Nov 2022 09:58:27 -0700
Message-ID: <20221103165827.19428-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221103090345.187989-1-chenzhongjin@huawei.com>
References: <20221103090345.187989-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Chen Zhongjin <chenzhongjin@huawei.com>
Date:   Thu, 3 Nov 2022 17:03:45 +0800
> When IPv6 module initializing in pingv6_init(), inet6_register_protosw()
> is possible to fail but returns without any error cleanup.

The change itself looks sane, but how does it fail ?
It seems inet6_register_protosw() never fails for pingv6_protosw.
Am I missing something ?

---8<---
static struct inet_protosw pingv6_protosw = {
	.type =      SOCK_DGRAM,         <-- .type < SOCK_MAX
	.protocol =  IPPROTO_ICMPV6,
	.prot =      &pingv6_prot,
	.ops =       &inet6_sockraw_ops,
	.flags =     INET_PROTOSW_REUSE,  <-- always makes `answer` NULL
};

int inet6_register_protosw(struct inet_protosw *p)
{
	struct list_head *lh;
	struct inet_protosw *answer;
	struct list_head *last_perm;
	int protocol = p->protocol;
	int ret;

	spin_lock_bh(&inetsw6_lock);

	ret = -EINVAL;
	if (p->type >= SOCK_MAX)
		goto out_illegal;

	/* If we are trying to override a permanent protocol, bail. */
	answer = NULL;
	ret = -EPERM;
	last_perm = &inetsw6[p->type];
	list_for_each(lh, &inetsw6[p->type]) {
		answer = list_entry(lh, struct inet_protosw, list);

		/* Check only the non-wild match. */
		if (INET_PROTOSW_PERMANENT & answer->flags) {
			if (protocol == answer->protocol)
				break;
			last_perm = lh;
		}

		answer = NULL;
	}
	if (answer)
		goto out_permanent;
...
	list_add_rcu(&p->list, last_perm);
	ret = 0;
out:
	spin_unlock_bh(&inetsw6_lock);
	return ret;

out_permanent:
	pr_err("Attempt to override permanent protocol %d\n", protocol);
	goto out;

out_illegal:
	pr_err("Ignoring attempt to register invalid socket type %d\n",
	       p->type);
	goto out;
}
---8<---

> 
> This leaves wild ops in namespace list and when another module tries to
> add or delete pernet namespace it triggers page fault.
> Although IPv6 cannot be unloaded now, this error should still be handled
> to avoid kernel panic during IPv6 initialization.
> 
> BUG: unable to handle page fault for address: fffffbfff80bab69
> CPU: 0 PID: 434 Comm: modprobe
> RIP: 0010:unregister_pernet_operations+0xc9/0x450
> Call Trace:
>  <TASK>
>  unregister_pernet_subsys+0x31/0x3e
>  nf_tables_module_exit+0x44/0x6a [nf_tables]
>  __do_sys_delete_module.constprop.0+0x34f/0x5b0
>  ...
> 
> Fix it by adding error handling in pingv6_init(), and add a helper

I'm wondering this could be another place.


> function pingv6_ops_unset to avoid duplicate code.
> 
> Fixes: d862e5461423 ("net: ipv6: Implement /proc/net/icmp6.")
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---
>  net/ipv6/ping.c | 30 ++++++++++++++++++++++--------
>  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
> index 86c26e48d065..5df688dd5208 100644
> --- a/net/ipv6/ping.c
> +++ b/net/ipv6/ping.c
> @@ -277,10 +277,21 @@ static struct pernet_operations ping_v6_net_ops = {
>  };
>  #endif
>  
> +static void pingv6_ops_unset(void)
> +{
> +	pingv6_ops.ipv6_recv_error = dummy_ipv6_recv_error;
> +	pingv6_ops.ip6_datagram_recv_common_ctl = dummy_ip6_datagram_recv_ctl;
> +	pingv6_ops.ip6_datagram_recv_specific_ctl = dummy_ip6_datagram_recv_ctl;
> +	pingv6_ops.icmpv6_err_convert = dummy_icmpv6_err_convert;
> +	pingv6_ops.ipv6_icmp_error = dummy_ipv6_icmp_error;
> +	pingv6_ops.ipv6_chk_addr = dummy_ipv6_chk_addr;
> +}
> +
>  int __init pingv6_init(void)
>  {
> +	int ret;
>  #ifdef CONFIG_PROC_FS
> -	int ret = register_pernet_subsys(&ping_v6_net_ops);
> +	ret = register_pernet_subsys(&ping_v6_net_ops);
>  	if (ret)
>  		return ret;
>  #endif
> @@ -291,7 +302,15 @@ int __init pingv6_init(void)
>  	pingv6_ops.icmpv6_err_convert = icmpv6_err_convert;
>  	pingv6_ops.ipv6_icmp_error = ipv6_icmp_error;
>  	pingv6_ops.ipv6_chk_addr = ipv6_chk_addr;
> -	return inet6_register_protosw(&pingv6_protosw);
> +
> +	ret = inet6_register_protosw(&pingv6_protosw);
> +	if (ret) {
> +		pingv6_ops_unset();
> +#ifdef CONFIG_PROC_FS
> +		unregister_pernet_subsys(&ping_v6_net_ops);
> +#endif
> +	}
> +	return ret;
>  }
>  
>  /* This never gets called because it's not possible to unload the ipv6 module,
> @@ -299,12 +318,7 @@ int __init pingv6_init(void)
>   */
>  void pingv6_exit(void)
>  {
> -	pingv6_ops.ipv6_recv_error = dummy_ipv6_recv_error;
> -	pingv6_ops.ip6_datagram_recv_common_ctl = dummy_ip6_datagram_recv_ctl;
> -	pingv6_ops.ip6_datagram_recv_specific_ctl = dummy_ip6_datagram_recv_ctl;
> -	pingv6_ops.icmpv6_err_convert = dummy_icmpv6_err_convert;
> -	pingv6_ops.ipv6_icmp_error = dummy_ipv6_icmp_error;
> -	pingv6_ops.ipv6_chk_addr = dummy_ipv6_chk_addr;
> +	pingv6_ops_unset();
>  #ifdef CONFIG_PROC_FS
>  	unregister_pernet_subsys(&ping_v6_net_ops);
>  #endif
> -- 
> 2.17.1
