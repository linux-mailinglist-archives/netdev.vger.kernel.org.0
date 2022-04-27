Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7ED75123C6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbiD0UXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiD0UXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:23:07 -0400
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E72891557;
        Wed, 27 Apr 2022 13:19:51 -0700 (PDT)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 23RKJdO9004481;
        Wed, 27 Apr 2022 22:19:39 +0200
Date:   Wed, 27 Apr 2022 22:19:39 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/7] secure_seq: return the full 64-bit of the siphash
Message-ID: <20220427201938.GC4326@1wt.eu>
References: <20220427065233.2075-1-w@1wt.eu>
 <20220427065233.2075-2-w@1wt.eu>
 <Yml6+PKmxW7VSHch@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yml6+PKmxW7VSHch@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

On Wed, Apr 27, 2022 at 07:18:48PM +0200, Jason A. Donenfeld wrote:
> Hi Willy,
> 
> On Wed, Apr 27, 2022 at 08:52:27AM +0200, Willy Tarreau wrote:
> > diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
> > index d7d2495f83c2..5cea9ed9c773 100644
> > --- a/include/net/secure_seq.h
> > +++ b/include/net/secure_seq.h
> > @@ -4,7 +4,7 @@
> >  
> >  #include <linux/types.h>
> >  
> > -u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
> > +u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
> >  u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
> >  			       __be16 dport);
> >  u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
> > diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
> > index 9b8443774449..2cdd43a63f64 100644
> > --- a/net/core/secure_seq.c
> > +++ b/net/core/secure_seq.c
> > @@ -142,7 +142,7 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
> >  }
> >  EXPORT_SYMBOL_GPL(secure_tcp_seq);
> >  
> > -u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
> > +u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
> >  {
> >  	net_secret_init();
> >  	return siphash_3u32((__force u32)saddr, (__force u32)daddr,
> 
> Should you be doing the same with secure_ipv6_port_ephemeral() too? Why
> the asymmetry?

I remember not finding it in the similar code path, but maybe I missed
something. It's used by inet6_sk_port_offset() which also returns a u32,
itself used by inet6_hash_connect() and passed to __inet_hash_connect().

Hmmm the loop is now closed, I don't know how I missed it. So yes I
agree that it would definitely be needed. I'll update the patch, many
thanks!

Willy
