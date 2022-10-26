Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E3B60E173
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiJZNFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbiJZNFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:05:47 -0400
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Oct 2022 06:05:45 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73919ACF4E;
        Wed, 26 Oct 2022 06:05:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 314E0CC016B;
        Wed, 26 Oct 2022 14:26:11 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 26 Oct 2022 14:26:08 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 754C6CC010C;
        Wed, 26 Oct 2022 14:26:08 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3E6B03431DF; Wed, 26 Oct 2022 14:26:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 3CF51343155;
        Wed, 26 Oct 2022 14:26:08 +0200 (CEST)
Date:   Wed, 26 Oct 2022 14:26:08 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Daniel Xu <dxu@dxuuu.xyz>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppenkov@aviatrix.com
Subject: Re: ip_set_hash_netiface
In-Reply-To: <9a91603a-7b8f-4c6d-9012-497335e4373b@app.fastmail.com>
Message-ID: <7fcf3bbb-95d2-a286-e3a-4d4dd87f713a@netfilter.org>
References: <9a91603a-7b8f-4c6d-9012-497335e4373b@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Tue, 25 Oct 2022, Daniel Xu wrote:

> I'm following up with our hallway chat yesterday about how ipset 
> hash:net,iface can easily OOM.
> 
> Here's a quick reproducer (stolen from
> https://bugzilla.kernel.org/show_bug.cgi?id=199107):
> 
>         $ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
>         $ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -exist; done
> 
> This used to cause a NULL ptr deref panic before
> https://github.com/torvalds/linux/commit/2b33d6ffa9e38f344418976b06 .
> 
> Now it'll either allocate a huge amount of memory or fail a
> vmalloc():
> 
>         [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
>         <...>
>         [Tue Oct 25 00:13:08 2022] Call Trace:
>         [Tue Oct 25 00:13:08 2022]  <TASK>
>         [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
>         [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
>         [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
>         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
>         [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
>         [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
>         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
>         <...>
> 
> Note that this behavior is somewhat documented
> (https://ipset.netfilter.org/ipset.man.html):
> 
> >  The internal restriction of the hash:net,iface set type is that the same
> >  network prefix cannot be stored with more than 64 different interfaces
> >  in a single set.
> 
> I'm not sure how hard it would be to enforce a limit, but I think it would
> be a bit better to error than allocate many GBs of memory.

That's a bug, actually the limit is not enforced in spite of the 
documentation. The next patch fixes it and I'm going to submit to Pablo:

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6e391308431d..3f8853ed32e9 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -61,10 +61,6 @@ tune_bucketsize(u8 curr, u32 multi)
 	 */
 	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
 }
-#define TUNE_BUCKETSIZE(h, multi)	\
-	((h)->bucketsize = tune_bucketsize((h)->bucketsize, multi))
-#else
-#define TUNE_BUCKETSIZE(h, multi)
 #endif
 
 /* A hash bucket */
@@ -936,7 +932,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		goto set_full;
 	/* Create a new slot */
 	if (n->pos >= n->size) {
-		TUNE_BUCKETSIZE(h, multi);
+#ifdef IP_SET_HASH_WITH_MULTI
+		if (h->bucketsize >= AHASH_MAX_TUNED)
+			goto set_full;
+		h->bucketsize = tune_bucketsize(h->bucketsize, multi);
+#endif
 		if (n->size >= AHASH_MAX(h)) {
 			/* Trigger rehashing */
 			mtype_data_next(&h->next, d);

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
