Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8407610B9C
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 09:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJ1Hvl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Oct 2022 03:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiJ1Hvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 03:51:37 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECE11BF85E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 00:51:33 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-32-5DrEyXUYNVeSOoVba2Mbxw-1; Fri, 28 Oct 2022 08:51:30 +0100
X-MC-Unique: 5DrEyXUYNVeSOoVba2Mbxw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 28 Oct
 2022 08:51:28 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Fri, 28 Oct 2022 08:51:28 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jozsef Kadlecsik' <kadlec@netfilter.org>,
        Daniel Xu <dxu@dxuuu.xyz>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ppenkov@aviatrix.com" <ppenkov@aviatrix.com>
Subject: RE: ip_set_hash_netiface
Thread-Topic: ip_set_hash_netiface
Thread-Index: AQHY6Td/ZX+DEWvLgEGa9nnokIvRm64jbupg
Date:   Fri, 28 Oct 2022 07:51:28 +0000
Message-ID: <4a0da0bfe87b4e10a83b97508d3c853e@AcuMS.aculab.com>
References: <9a91603a-7b8f-4c6d-9012-497335e4373b@app.fastmail.com>
 <7fcf3bbb-95d2-a286-e3a-4d4dd87f713a@netfilter.org>
In-Reply-To: <7fcf3bbb-95d2-a286-e3a-4d4dd87f713a@netfilter.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik
> Sent: 26 October 2022 13:26
> 
> On Tue, 25 Oct 2022, Daniel Xu wrote:
> 
> > I'm following up with our hallway chat yesterday about how ipset
> > hash:net,iface can easily OOM.
> >
> > Here's a quick reproducer (stolen from
> > https://bugzilla.kernel.org/show_bug.cgi?id=199107):
> >
> >         $ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
> >         $ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -
> exist; done
> >
> > This used to cause a NULL ptr deref panic before
> > https://github.com/torvalds/linux/commit/2b33d6ffa9e38f344418976b06 .
> >
> > Now it'll either allocate a huge amount of memory or fail a
> > vmalloc():
> >
> >         [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
> >         <...>
> >         [Tue Oct 25 00:13:08 2022] Call Trace:
> >         [Tue Oct 25 00:13:08 2022]  <TASK>
> >         [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
> >         [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
> >         [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
> >         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
> >         [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
> >         [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
> >         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
> >         <...>
> >
> > Note that this behavior is somewhat documented
> > (https://ipset.netfilter.org/ipset.man.html):
> >
> > >  The internal restriction of the hash:net,iface set type is that the same
> > >  network prefix cannot be stored with more than 64 different interfaces
> > >  in a single set.
> >
> > I'm not sure how hard it would be to enforce a limit, but I think it would
> > be a bit better to error than allocate many GBs of memory.
> 
> That's a bug, actually the limit is not enforced in spite of the
> documentation. The next patch fixes it and I'm going to submit to Pablo:
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 6e391308431d..3f8853ed32e9 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -61,10 +61,6 @@ tune_bucketsize(u8 curr, u32 multi)
>  	 */
>  	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
>  }
> -#define TUNE_BUCKETSIZE(h, multi)	\
> -	((h)->bucketsize = tune_bucketsize((h)->bucketsize, multi))
> -#else
> -#define TUNE_BUCKETSIZE(h, multi)
>  #endif
> 
>  /* A hash bucket */
> @@ -936,7 +932,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
>  		goto set_full;
>  	/* Create a new slot */
>  	if (n->pos >= n->size) {
> -		TUNE_BUCKETSIZE(h, multi);
> +#ifdef IP_SET_HASH_WITH_MULTI
> +		if (h->bucketsize >= AHASH_MAX_TUNED)
> +			goto set_full;
> +		h->bucketsize = tune_bucketsize(h->bucketsize, multi);
> +#endif

AFAICT this is the only call of tune_bucketsize().
It is defined just above TUNE_BUCKETSIZE as:
static u8
tune_bucketsize(u8 curr, u32 multi)
{
	u32 n;

	if (multi < curr)
		return curr;

	n = curr + AHASH_INIT_SIZE;
	/* Currently, at listing one hash bucket must fit into a message.
	 * Therefore we have a hard limit here.
	 */
	return n > curr && n <= AHASH_MAX_TUNED ? n : curr;
}

If I'm reading it correctly this is just:
	return curr >= multi || curr >= 64 ? curr : curr + 2;
(the 'n > curr' test is unconditionally true).
The extra check is limiting it to 12 (AHASH_MAX_TUNED) not 64.

Quite why the change makes a significant difference to the validity
of the kvalloc() is another matter.
Changing a multiplier from 64 to 12 seems unlikely to be that
significant - if it is you wouldn't want to be multiplying by 12.

I've not looked what 'multi' is, but I'm sort of surprised it isn't
used as the new bucketsize.

Also it doesn't really look right to have lots of static functions
in a .h file?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

