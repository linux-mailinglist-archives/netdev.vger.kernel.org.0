Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1E66C789
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbjAPQbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjAPQa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:30:59 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59DB27983;
        Mon, 16 Jan 2023 08:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673885974; x=1705421974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XA15097QYDciCmETFZhq+PQFlZZKGneg72S6JUcVy5o=;
  b=IWUq43Xu5B/TFaZ+fYtivCBLhOI41qp7yTDzT4nLnU2sLNa8UFQTtHcC
   9hzM09UtjD9raJjJthRXZnPYzs2HxD8bg4/xM292zmWdabtpTtbLFy+4/
   3jeH41JpjVJtUFlF8QIgABbREr310Z7ProlUCza5PFDeRT22unBaOTy0I
   o=;
X-IronPort-AV: E=Sophos;i="5.97,221,1669075200"; 
   d="scan'208";a="288936403"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 16:19:31 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com (Postfix) with ESMTPS id 424D79F0CF;
        Mon, 16 Jan 2023 16:19:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 16 Jan 2023 16:19:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Mon, 16 Jan 2023 16:19:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <borrello@diag.uniroma1.it>
CC:     <c.giuffrida@vu.nl>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <h.j.bos@vu.nl>, <jkl820.git@gmail.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next v3] inet: fix fast path in __inet_hash_connect()
Date:   Mon, 16 Jan 2023 08:19:08 -0800
Message-ID: <20230116161908.27799-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
References: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D34UWA002.ant.amazon.com (10.43.160.245) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Sat, 14 Jan 2023 13:11:41 +0000
> __inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
> equal to the sk parameter.
> sk_head() returns the hlist_entry() with respect to the sk_node field.
> However entries in the tb->owners list are inserted with respect to the
> sk_bind_node field with sk_add_bind_node().
> Thus the check would never pass and the fast path never execute.
> 
> This fast path has never been executed or tested as this bug seems
> to be present since commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), thus
> remove it to reduce code complexity.
> 
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thank you!

> ---
> Changes in v3:
> - remove the fast path to reduce code complexity
> - Link to v2: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it
> 
> Changes in v2:
> - nit: s/list_entry/hlist_entry/
> - Link to v1: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it
> ---
>  net/ipv4/inet_hashtables.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index d039b4e732a3..b832e7a545d4 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -994,17 +994,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>  	u32 index;
>  
>  	if (port) {
> -		head = &hinfo->bhash[inet_bhashfn(net, port,
> -						  hinfo->bhash_size)];
> -		tb = inet_csk(sk)->icsk_bind_hash;
> -		spin_lock_bh(&head->lock);
> -		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
> -			inet_ehash_nolisten(sk, NULL, NULL);
> -			spin_unlock_bh(&head->lock);
> -			return 0;
> -		}
> -		spin_unlock(&head->lock);
> -		/* No definite answer... Walk to established hash table */
> +		local_bh_disable();
>  		ret = check_established(death_row, sk, port, NULL);
>  		local_bh_enable();
>  		return ret;
> 
> ---
> base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
> change-id: 20230112-inet_hash_connect_bind_head-8f2dc98f08b1
> 
> Best regards,
> -- 
> Pietro Borrello <borrello@diag.uniroma1.it>
