Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272446688B1
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 01:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240589AbjAMAtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 19:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbjAMAtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 19:49:17 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90D8621A4;
        Thu, 12 Jan 2023 16:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673570928; x=1705106928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5DJhPhyTPYZUC+Q0Y4NJeiMhiQyq2unFpEyaenv0cBs=;
  b=auGbLHOJ5/VrNkrG/Spkv91hA1v6D5CczcxqupgqeArLOhLjriwlf4/H
   VkbRwM5bIU7aelC7jAZ35m9OWagEB6bOIKVfW9xaFNXgWuvrfRsW4BK4Z
   ap0MA7zrmT8ok8BDdV2gWjEIU2p1dOtvSQBSDvO2kAdK+lgjmM/eQRVzs
   U=;
X-IronPort-AV: E=Sophos;i="5.97,212,1669075200"; 
   d="scan'208";a="170739339"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-fad5e78e.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 00:48:38 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-fad5e78e.us-west-2.amazon.com (Postfix) with ESMTPS id 730D8A110F;
        Fri, 13 Jan 2023 00:48:37 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Fri, 13 Jan 2023 00:48:36 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Fri, 13 Jan 2023 00:48:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <borrello@diag.uniroma1.it>
CC:     <c.giuffrida@vu.nl>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <h.j.bos@vu.nl>, <jkl820.git@gmail.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <yoshfuji@linux-ipv6.org>, <kuniyu@amazon.com>
Subject: Re: [PATCH] inet: fix fast path in __inet_hash_connect()
Date:   Fri, 13 Jan 2023 09:48:13 +0900
Message-ID: <20230113004813.82874-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it>
References: <20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D28UWC002.ant.amazon.com (10.43.162.145) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Thu, 12 Jan 2023 15:39:23 +0000
> __inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
> equal to the sk parameter.
> sk_head() returns the list_entry() with respect to the sk_node field.

nit: s/list_entry/hlist_entry/

> However entries in the tb->owners list are inserted with respect to the
> sk_bind_node field with sk_add_bind_node().
> Thus the check would never pass and the fast path never execute.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>

Good catch!
Other than the nit above, looks good to me.

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thank you.


> ---
>  include/net/sock.h         | 10 ++++++++++
>  net/ipv4/inet_hashtables.c |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b2..23fc403284db 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -860,6 +860,16 @@ static inline void sk_nulls_add_node_rcu(struct sock *sk, struct hlist_nulls_hea
>  	__sk_nulls_add_node_rcu(sk, list);
>  }
>  
> +static inline struct sock *__sk_bind_head(const struct hlist_head *head)
> +{
> +	return hlist_entry(head->first, struct sock, sk_bind_node);
> +}
> +
> +static inline struct sock *sk_bind_head(const struct hlist_head *head)
> +{
> +	return hlist_empty(head) ? NULL : __sk_bind_head(head);
> +}
> +
>  static inline void __sk_del_bind_node(struct sock *sk)
>  {
>  	__hlist_del(&sk->sk_bind_node);
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index d039b4e732a3..a805e086fb48 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -998,7 +998,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  						  hinfo->bhash_size)];
>  		tb = inet_csk(sk)->icsk_bind_hash;
>  		spin_lock_bh(&head->lock);
> -		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
> +		if (sk_bind_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
>  			inet_ehash_nolisten(sk, NULL, NULL);
>  			spin_unlock_bh(&head->lock);
>  			return 0;
> 
> ---
> base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
> change-id: 20230112-inet_hash_connect_bind_head-8f2dc98f08b1
> 
> Best regards,
> -- 
> Pietro Borrello <borrello@diag.uniroma1.it>
