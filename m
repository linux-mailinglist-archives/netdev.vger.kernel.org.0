Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A19370B0F
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbfGVVNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:13:20 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35317 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732272AbfGVVNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:13:20 -0400
Received: by mail-qk1-f195.google.com with SMTP id r21so29611230qke.2
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BKxiGWjC+5P401jeWuqAwXoma7yfPGk4/g2Ytyh5U30=;
        b=BFaD/7jUsYikt25fnCeLunhpd4nXxRG1xIUkQlhVAPFQXJyx/6r2vVBCFl/NMqD8+U
         pbeanWTIc9BMwg32VoB/9EstVkIA1Quz19bbbkvvpefdgBlJXn01fqZYsfFJ2B8u6umk
         K+PQDVU84pJTf/VW30aLeOw9iatqrmyi1M7EUzyX2bhFdOPQdmlBf9AehzVOynsPESXe
         7kvsKl82+LmMohjq+ELusDXm62Z369AQbp87hp0WoRk2eC8qsdvxghIhHcwbTz6XPLPk
         E1fPPylZLIDB1qiXxnwk7wQCr1VaAq+Nl0jRYC9RB+Q5Sd/U4eZpdjuXVxKCeRnDJ8rT
         Y85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BKxiGWjC+5P401jeWuqAwXoma7yfPGk4/g2Ytyh5U30=;
        b=uECVyrY2wrttrFiOEs9GW/EGlNIFrfRzfdunwL94oscC4mBmJRjTIYTSl1pU41OQY9
         xFLUguyDxBQzo4ATprstOLzyPtmSYc3WPiVMTszXk90u5555b94s4CHEzpgAtmGON4I8
         uo7KdyuRU7ZgFbxn8m40xeEVHOifrODly1YqiHPTEZIx0szY7sLSSlx2aw+8XPocyWoL
         MFuO86H45P7yqCVZ94aEg/JxYPB7urkv1qzcNPdQM+h7ScDnncNcjjqp/m4NNfdnKMOC
         QsQYnFUiUeeMLsKhBek1Zn05qYq7SXnx45Gg4gu292AXutnh8pQalf8DY2vTAXIg2654
         eMlg==
X-Gm-Message-State: APjAAAVDv48F3E4T2P7sTl9zwuezU5RToo5NAaEmuJvUxCXy4Xircwwr
        CSuf8twd8ywktaRDWyEzHbbL7sBLlD+3Wg==
X-Google-Smtp-Source: APXvYqwsFCj6xytMhGmclxHIaeQskKQrC4psHIw5WW42v731oBjjDbzmgqJHveBylv4SkFw7Rlp47Q==
X-Received: by 2002:a37:a010:: with SMTP id j16mr48945457qke.152.1563829999256;
        Mon, 22 Jul 2019 14:13:19 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z1sm19024894qke.122.2019.07.22.14.13.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:13:18 -0700 (PDT)
Message-ID: <1563829996.11067.4.camel@lca.pw>
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
From:   Qian Cai <cai@lca.pw>
To:     David Miller <davem@davemloft.net>
Cc:     morbo@google.com, ndesaulniers@google.com, jyknight@google.com,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        arnd@arndb.de, dhowells@redhat.com, hpa@zytor.com,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, natechancellor@gmail.com,
        Jakub Jelinek <jakub@redhat.com>
Date:   Mon, 22 Jul 2019 17:13:16 -0400
In-Reply-To: <1563572871.11067.2.camel@lca.pw>
References: <CAKwvOdkCfqfpJYYX+iu2nLCUUkeDorDdVP3e7koB9NYsRwgCNw@mail.gmail.com>
         <CAGG=3QUvdwJs1wW1w+5Mord-qFLa=_WkjTsiZuwGfcjkoEJGNQ@mail.gmail.com>
         <75B428FC-734C-4B15-B1A7-A3FC5F9F2FE5@lca.pw>
         <20190718.162928.124906203979938369.davem@davemloft.net>
         <1563572871.11067.2.camel@lca.pw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-07-19 at 17:47 -0400, Qian Cai wrote:
> On Thu, 2019-07-18 at 16:29 -0700, David Miller wrote:
> > From: Qian Cai <cai@lca.pw>
> > Date: Thu, 18 Jul 2019 19:26:47 -0400
> > 
> > >  
> > >  
> > > > On Jul 18, 2019, at 5:21 PM, Bill Wendling <morbo@google.com> wrote:
> > > >  
> > > > [My previous response was marked as spam...]
> > > >  
> > > > Top-of-tree clang says that it's const:
> > > >  
> > > > $ gcc a.c -O2 && ./a.out
> > > > a is a const.
> > > >  
> > > > $ clang a.c -O2 && ./a.out
> > > > a is a const.
> > > 
> > >  
> > >  
> > > I used clang-7.0.1. So, this is getting worse where both GCC and clang
> > > will
> > 
> > start to suffer the
> > > same problem.
> > 
> > Then rewrite the module parameter macros such that the non-constness
> > is evident to all compilers regardless of version.
> > 
> > That is the place to fix this, otherwise we will just be adding hacks
> > all over the place rather than in just one spot.
> 
> The problem is that when the compiler is compiling be_main.o, it has no
> knowledge about what is going to happen in load_module().  The compiler can
> only
> see that a "const struct kernel_param_ops" "__param_ops_rx_frag_size" at the
> time with
> 
> __param_ops_rx_frag_size.arg = &rx_frag_size
> 
> but only in load_module()->parse_args()->parse_one()->param_set_ushort(), it
> changes "__param_ops_rx_frag_size.arg" which in-turn changes the value
> of "rx_frag_size".

Even for an obvious case, the compilers still go ahead optimizing a variable as
a constant. Maybe it is best to revert the commit d66acc39c7ce ("bitops:
Optimise get_order()") unless some compiler experts could improve the situation.

#include <stdio.h>

int a = 1;

int main(void)
{
        int *p;

        p = &a;
        *p = 2;

        if (__builtin_constant_p(a))
                printf("a is a const.\n");

        printf("a = %d\n", a);

        return 0;
}

# gcc -O2 const.c -o const

# ./const
a is a const.
a = 2
