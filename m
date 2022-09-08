Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B84315B10B6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 02:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiIHACf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 20:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiIHACe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 20:02:34 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8631A0240
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 17:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1662595353; x=1694131353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K2ukI4S2/0sme/FzTlPXG2ZHrPEZe1rhbzmFLhpyqJE=;
  b=IhoWuhexS4GWlN7AeJxzT1GumOpD7DZI73JK26Gf2IX1aNVYDJJV3C5V
   ckRgxR7J8Y3LbZIu2me9XcqsuoZhyAjoFj8LG4U6EiyhQkzW0J7N6eDJM
   Q8giR/AQgfWg2kLAnkFtur6Sor9BjJ0+ndd0cqZhhJyAA/k7SWq/q0Krp
   4=;
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 00:02:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com (Postfix) with ESMTPS id 10171C08CA;
        Thu,  8 Sep 2022 00:02:21 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 8 Sep 2022 00:02:18 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.137) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 8 Sep 2022 00:02:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <eric.dumazet@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v5 net-next 6/6] tcp: Introduce optional per-netns ehash.
Date:   Wed, 7 Sep 2022 17:02:06 -0700
Message-ID: <20220908000206.41237-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <8c70c1f8-68df-a9cb-9bba-f26edaebd4a6@gmail.com>
References: <8c70c1f8-68df-a9cb-9bba-f26edaebd4a6@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.137]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 7 Sep 2022 16:45:17 -0700
> On 9/6/22 17:55, Kuniyuki Iwashima wrote:
> > The more sockets we have in the hash table, the longer we spend looking
> > up the socket.  While running a number of small workloads on the same
> > host, they penalise each other and cause performance degradation.
> >
> >
> > +
> > +struct inet_hashinfo *inet_pernet_hashinfo_alloc(struct inet_hashinfo *hashinfo,
> > +						 unsigned int ehash_entries)
> > +{
> > +	struct inet_hashinfo *new_hashinfo;
> > +	int i;
> > +
> > +	new_hashinfo = kmalloc(sizeof(*new_hashinfo), GFP_KERNEL);
> 
> You probably could use kmemdup(hashinfo, sizeof(*hashinfo), GFP_KERNEL);

Exactly, I'll use it and remove the manual copy.
Thank you!


> > +	if (!new_hashinfo)
> > +		goto err;
> > +
> > +	new_hashinfo->ehash = kvmalloc_array(ehash_entries,
> > +					     sizeof(struct inet_ehash_bucket),
> > +					     GFP_KERNEL_ACCOUNT);
> > +	if (!new_hashinfo->ehash)
> > +		goto free_hashinfo;
> > +
> > +	new_hashinfo->ehash_mask = ehash_entries - 1;
> > +
> > +	if (inet_ehash_locks_alloc(new_hashinfo))
> > +		goto free_ehash;
> > +
> > +	for (i = 0; i < ehash_entries; i++)
> > +		INIT_HLIST_NULLS_HEAD(&new_hashinfo->ehash[i].chain, i);
> > +
> > +	new_hashinfo->bind_bucket_cachep = hashinfo->bind_bucket_cachep;
> > +	new_hashinfo->bhash = hashinfo->bhash;
> > +	new_hashinfo->bind2_bucket_cachep = hashinfo->bind2_bucket_cachep;
> > +	new_hashinfo->bhash2 = hashinfo->bhash2;
> > +	new_hashinfo->bhash_size = hashinfo->bhash_size;
> > +
> > +	new_hashinfo->lhash2_mask = hashinfo->lhash2_mask;
> > +	new_hashinfo->lhash2 = hashinfo->lhash2;
> 
> 
> This would avoid copying all these @hashinfo fields.
