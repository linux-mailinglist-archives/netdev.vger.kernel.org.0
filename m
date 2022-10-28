Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3FD610F37
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiJ1K7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiJ1K7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:59:17 -0400
X-Greylist: delayed 166407 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 28 Oct 2022 03:59:15 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFE71A1B3C;
        Fri, 28 Oct 2022 03:59:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 56B3ECC029F;
        Fri, 28 Oct 2022 12:59:13 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 28 Oct 2022 12:59:10 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 66B8DCC029E;
        Fri, 28 Oct 2022 12:59:10 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 505633431DF; Fri, 28 Oct 2022 12:59:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 4ECC6343155;
        Fri, 28 Oct 2022 12:59:10 +0200 (CEST)
Date:   Fri, 28 Oct 2022 12:59:10 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     Daniel Xu <dxu@dxuuu.xyz>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ppenkov@aviatrix.com" <ppenkov@aviatrix.com>
Subject: RE: ip_set_hash_netiface
In-Reply-To: <4a0da0bfe87b4e10a83b97508d3c853e@AcuMS.aculab.com>
Message-ID: <bc15b193-683b-d2ae-776-22bf5bd65939@netfilter.org>
References: <9a91603a-7b8f-4c6d-9012-497335e4373b@app.fastmail.com> <7fcf3bbb-95d2-a286-e3a-4d4dd87f713a@netfilter.org> <4a0da0bfe87b4e10a83b97508d3c853e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Fri, 28 Oct 2022, David Laight wrote:

> From: Jozsef Kadlecsik
> > Sent: 26 October 2022 13:26
> > 
> > On Tue, 25 Oct 2022, Daniel Xu wrote:
> > 
> > > I'm following up with our hallway chat yesterday about how ipset
> > > hash:net,iface can easily OOM.
> > >
> > > Here's a quick reproducer (stolen from
> > > https://bugzilla.kernel.org/show_bug.cgi?id=199107):
> > >
> > >         $ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
> > >         $ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -
> > exist; done
> > >
> > > This used to cause a NULL ptr deref panic before
> > > https://github.com/torvalds/linux/commit/2b33d6ffa9e38f344418976b06 .
> > >
> > > Now it'll either allocate a huge amount of memory or fail a
> > > vmalloc():
> > >
> > >         [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
> > >         <...>
> > >         [Tue Oct 25 00:13:08 2022] Call Trace:
> > >         [Tue Oct 25 00:13:08 2022]  <TASK>
> > >         [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
> > >         [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
> > >         [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
> > >         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
> > >         [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
> > >         [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
> > >         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
> > >         <...>
> > >
> > > Note that this behavior is somewhat documented
> > > (https://ipset.netfilter.org/ipset.man.html):
> > >
> > > >  The internal restriction of the hash:net,iface set type is that the same
> > > >  network prefix cannot be stored with more than 64 different interfaces
> > > >  in a single set.
> > >
> > > I'm not sure how hard it would be to enforce a limit, but I think it would
> > > be a bit better to error than allocate many GBs of memory.
> > 
> > That's a bug, actually the limit is not enforced in spite of the
> > documentation. The next patch fixes it and I'm going to submit to Pablo:
> > 
> > diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> > index 6e391308431d..3f8853ed32e9 100644
> > --- a/net/netfilter/ipset/ip_set_hash_gen.h
> > +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> > @@ -61,10 +61,6 @@ tune_bucketsize(u8 curr, u32 multi)
> >  	 */
> >  	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
> >  }
> > -#define TUNE_BUCKETSIZE(h, multi)	\
> > -	((h)->bucketsize = tune_bucketsize((h)->bucketsize, multi))
> > -#else
> > -#define TUNE_BUCKETSIZE(h, multi)
> >  #endif
> > 
> >  /* A hash bucket */
> > @@ -936,7 +932,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> >  		goto set_full;
> >  	/* Create a new slot */
> >  	if (n->pos >= n->size) {
> > -		TUNE_BUCKETSIZE(h, multi);
> > +#ifdef IP_SET_HASH_WITH_MULTI
> > +		if (h->bucketsize >= AHASH_MAX_TUNED)
> > +			goto set_full;
> > +		h->bucketsize = tune_bucketsize(h->bucketsize, multi);
> > +#endif
> 
> AFAICT this is the only call of tune_bucketsize().
> It is defined just above TUNE_BUCKETSIZE as:
> static u8
> tune_bucketsize(u8 curr, u32 multi)
> {
> 	u32 n;
> 
> 	if (multi < curr)
> 		return curr;
> 
> 	n = curr + AHASH_INIT_SIZE;
> 	/* Currently, at listing one hash bucket must fit into a message.
> 	 * Therefore we have a hard limit here.
> 	 */
> 	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
> }
> 
> If I'm reading it correctly this is just:
> 	return curr >= multi || curr >= 64 ? curr : curr + 2;

Actually, because a new condition was added before calling the function, 
the whole thing could simply be changed to

#ifdef IP_SET_HASH_WITH_MULTI
          if (h->bucketsize >= AHASH_MAX_TUNED)
                  goto set_full;
	  else if (h->bucketsize < multi)
          	h->bucketsize += AHASH_INIT_SIZE;
#endif

I'm going to submit a new patch.

> (the 'n > curr' test is unconditionally true).

Yes, correct.

> The extra check is limiting it to 12 (AHASH_MAX_TUNED) not 64.

No, because AHASH_MAX_TUNED is defined to be 64.

> Quite why the change makes a significant difference to the validity of 
> the kvalloc() is another matter. Changing a multiplier from 64 to 12 
> seems unlikely to be that significant - if it is you wouldn't want to be 
> multiplying by 12.

We are hashing elements into the same bucket and the original code 
continued to resize the hash without a real limit (expect the memory). The 
new condition checking the bucket size was critical here.

> I've not looked what 'multi' is, but I'm sort of surprised it isn't
> used as the new bucketsize.

If 'multi' were used as the new size then bucketsize were shrinked. The 
expected general use case is to build up sets containing attackers and the 
peaks are common, therefore there's no point to shrink back. The maximal 
number of elements is defined at set creation time and cannot be added 
more.

> Also it doesn't really look right to have lots of static functions
> in a .h file?

That .h file is a template to generate the code for all of the individual 
functions of the different hash types, therefore it contains lot of static 
function definitions.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
