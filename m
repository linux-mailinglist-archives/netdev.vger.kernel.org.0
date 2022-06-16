Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3BC54E22F
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377132AbiFPNkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377129AbiFPNkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:40:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241FD2CCBA
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655386820; x=1686922820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+gcrk5ojC4k34KO0aCaiFUfe+GetFi9kurrs8AjQJbs=;
  b=KiB2ZgobRhUip69pnQjxnJ2OfC/ExbyxYRqeYk+uOIWhp8lSH/1azVOa
   AlqmBoVVS1q70otMChAiRf+H3y8200v+Geki6p5b1C5iZ5SzI6agd25hC
   X0eUnCsT65z5gQPAsR5H2n2ylWqSHyrKd7/Qk6B0tZNPxWbV6W/vsYfso
   ouRf85fIFa/532lgqnrAwpijNAazgU4b45+WSY7Wh5nmDrjSKDKlPkkw+
   FN+XDUWxMpcgxNyE6G4Pe1LgOcR7nxHnotc778EOW+N/m0ZMb0IhkQqjC
   Caz8rhjXHrI7cDc3mZDJvrYC60/nsVWcfFLKYn8vhV4StkQBziVpB5B3v
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="343208180"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="343208180"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 06:40:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="675027164"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jun 2022 06:40:17 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25GDeGYP031608;
        Thu, 16 Jun 2022 14:40:16 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: don't check skb_count twice
Date:   Thu, 16 Jun 2022 15:38:23 +0200
Message-Id: <20220616133823.1293740-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616020453.GA39@DESKTOP-8REGVGF.localdomain>
References: <20220615032426.17214-1-liew.s.piaw@gmail.com> <20220615153525.1270806-1-alexandr.lobakin@intel.com> <20220616020453.GA39@DESKTOP-8REGVGF.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sieng Piaw Liew <liew.s.piaw@gmail.com>
Date: Thu, 16 Jun 2022 10:04:53 +0800

> On Wed, Jun 15, 2022 at 05:35:25PM +0200, Alexander Lobakin wrote:
> > From: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> > Date: Wed, 15 Jun 2022 11:24:26 +0800
> > 
> > > NAPI cache skb_count is being checked twice without condition. Change to
> > > checking the second time only if the first check is run.
> > > 
> > > Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> > > ---
> > >  net/core/skbuff.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 5b3559cb1d82..c426adff6d96 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -172,13 +172,14 @@ static struct sk_buff *napi_skb_cache_get(void)
> > >  	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> > >  	struct sk_buff *skb;
> > >  
> > > -	if (unlikely(!nc->skb_count))
> > > +	if (unlikely(!nc->skb_count)) {
> > >  		nc->skb_count = kmem_cache_alloc_bulk(skbuff_head_cache,
> > >  						      GFP_ATOMIC,
> > >  						      NAPI_SKB_CACHE_BULK,
> > >  						      nc->skb_cache);
> > > -	if (unlikely(!nc->skb_count))
> > > -		return NULL;
> > > +		if (unlikely(!nc->skb_count))
> > > +			return NULL;
> > > +	}
> > 
> > I was sure the compilers are able to see that if the condition is
> > false first time, it will be the second as well. Just curious, have
> > you consulted objdump/objdiff to look whether anything changed?
> 
> I'm a total noob at this. Thanks for the guidance.
> Here is the diff I just generated:
> 
> < before patch
> > after patch
> 
> 619,620c619,620
> <   14: 24630000        addiu   v1,v1,0
> <   18: 00021080        sll     v0,v0,0x2
> ---
> >   14: 00021080        sll     v0,v0,0x2
> >   18: 24630000        addiu   v1,v1,0
> 626,635c626,635
> <   30: 8e030010        lw      v1,16(s0)
> <   34: 1060000b        beqz    v1,64 <napi_skb_cache_get+0x64>
> <   38: 3c020000        lui     v0,0x0
> <   3c: 24620003        addiu   v0,v1,3
> <   40: 2463ffff        addiu   v1,v1,-1
> <   44: ae030010        sw      v1,16(s0)
> <   48: 8fbf0014        lw      ra,20(sp)
> <   4c: 00021080        sll     v0,v0,0x2
> <   50: 02028021        addu    s0,s0,v0
> <   54: 8e020004        lw      v0,4(s0)
> ---
> >   30: 8e020010        lw      v0,16(s0)
> >   34: 1040000b        beqz    v0,64 <napi_skb_cache_get+0x64>
> >   38: 26070014        addiu   a3,s0,20
> >   3c: 24430003        addiu   v1,v0,3
> >   40: 00031880        sll     v1,v1,0x2
> >   44: 2442ffff        addiu   v0,v0,-1
> >   48: ae020010        sw      v0,16(s0)
> >   4c: 02038021        addu    s0,s0,v1
> >   50: 8e020004        lw      v0,4(s0)
> >   54: 8fbf0014        lw      ra,20(sp)
> 639,640c639,640
> <   64: 8c440000        lw      a0,0(v0)
> <   68: 26070014        addiu   a3,s0,20
> ---
> >   64: 3c020000        lui     v0,0x0
> >   68: 8c440000        lw      a0,0(v0)
> 644c644
> <   78: 00401825        move    v1,v0
> ---
> >   78: 1440fff0        bnez    v0,3c <napi_skb_cache_get+0x3c>
> 646c646
> <   80: 1460ffee        bnez    v1,3c <napi_skb_cache_get+0x3c>
> ---
> >   80: 1000fff4        b       54 <napi_skb_cache_get+0x54>
> 648,651d647
> <   88: 8fbf0014        lw      ra,20(sp)
> <   8c: 8fb00010        lw      s0,16(sp)
> <   90: 03e00008        jr      ra
> <   94: 27bd0018        addiu   sp,sp,24
> 1736c1732
> <  244: 24050ae8        li      a1,2792
> ---
> >  244: 24050ae9        li      a1,2793
> 
> ...(More similar li instruction diffs)
> I think there are slightly more instructions before patch.

Ok, thank you! Then it makes sense. I'll recheck my recent code
whether I did it that way again somewhere :D

> 
> > 
> > Also, please use scripts/get_maintainers.pl or at least git blame
> > and add the original authors to Ccs next time, so that they won't
> > miss your changes and will be able to review them in time. E.g. I
> > noticed this patch only when it did hit the net-next tree already,
> > as I don't monitor LKML 24/7 (but I do that with my mailbox).
> > 
> 
> Thanks for the tip.
> 
> > >  
> > >  	skb = nc->skb_cache[--nc->skb_count];
> > >  	kasan_unpoison_object_data(skbuff_head_cache, skb);
> > > -- 
> > > 2.17.1
> > 
> > Thanks,
> > Olek

Thanks,
Olek
