Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B53467B81A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 18:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbjAYRL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 12:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbjAYRLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 12:11:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D20111E87;
        Wed, 25 Jan 2023 09:11:15 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b10so19232729pjo.1;
        Wed, 25 Jan 2023 09:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8c7LV3ey5/jndWOsw3zFfpHQ/PQXTWRmuu1Ym9dxgEc=;
        b=LcXSMHaGunKxlOQT6W1iRnSxHAIo3civ+Kg8/OdwV+Het6+UkpArXPLi3r83lFaqoF
         zVF2Ej9QlomENND48e4uTj7GCj2kdwmhxNM/QIbm32o2hnHdbnEKkpmLl2pbZ5iCUZ8i
         nzzJFR2QjZIQNlvOHmRzklF7cctHCVE8t4RVgnRGvm5fHIRxUYjdoxG8RSMNrtWCh4+U
         zUMMm0owqfoi3Vw85P+tXuEH6WKvJtxqCdVHNONQfT9QdiTdU2Vni+GvovfkwhN3WZnv
         kCDxq4zckJQyiuopMDr/ltoaw1wKhrjcmPaSQT9Qmshe/Hv2DaJQ9EVHhxhhD49IaI/V
         oogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8c7LV3ey5/jndWOsw3zFfpHQ/PQXTWRmuu1Ym9dxgEc=;
        b=ywUsabMpOeJ0rCnwSlAP3CuDFelKAQHmEVRAAsGtMcb+5+3qmR1kIPwGw6sVGZlVR9
         pxGngln3gU41ZvtaAI26rmXxvYhvrGArffcM5wtinfyh2EMlgL9Nm4T6lLZR2X2KVZBK
         64o1kAVz2E7NLjXTZfkOLyM7v7GbNV7seejecQwG3fNpU2BvF+E/PEei5vkEqNrqMMCL
         n41F2XPjbZmTB7jYsJQzvItCZsIY0Lkvfz5N95mh+YPp9/xkgE4INnIU9zfJdaZ1TBh5
         zOwNxyL3ixBQwd7pqdsmaOxsPhaK21FTtKhiBV9bdf8nTCFo8IO38GVp3cMOdrt8ftuz
         3sIg==
X-Gm-Message-State: AFqh2kqU2S14FfflNnXM6GhgJ22XC6sD46sHZY1UZg/+VfxNaAE2zUwn
        +Pyb3FZeOyNqbfaPWGMRKCE=
X-Google-Smtp-Source: AMrXdXuecBgEgfVZ9nkrhunBOWWRYTkv+ZU3i+nwDJrIrFLwQJjiT4GU3mj+m54xxn43PFWwKoyRXA==
X-Received: by 2002:a17:902:7c0e:b0:192:afb0:8960 with SMTP id x14-20020a1709027c0e00b00192afb08960mr30897021pll.3.1674666666446;
        Wed, 25 Jan 2023 09:11:06 -0800 (PST)
Received: from [192.168.0.128] ([98.97.116.5])
        by smtp.googlemail.com with ESMTPSA id az3-20020a170902a58300b001885d15e3c1sm3905055plb.26.2023.01.25.09.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 09:11:05 -0800 (PST)
Message-ID: <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Date:   Wed, 25 Jan 2023 09:11:04 -0800
In-Reply-To: <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name>
References: <20230124124300.94886-1-nbd@nbd.name>
         <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
         <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name>
         <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
         <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-24 at 22:30 +0100, Felix Fietkau wrote:
> On 24.01.23 22:10, Alexander H Duyck wrote:
> > On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
> > > On 24.01.23 15:11, Ilias Apalodimas wrote:
> > > > Hi Felix,
> > > >=20
> > > > ++cc Alexander and Yunsheng.
> > > >=20
> > > > Thanks for the report
> > > >=20
> > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
> > > > >=20
> > > > > While testing fragmented page_pool allocation in the mt76 driver,=
 I was able
> > > > > to reliably trigger page refcount underflow issues, which did not=
 occur with
> > > > > full-page page_pool allocation.
> > > > > It appears to me, that handling refcounting in two separate count=
ers
> > > > > (page->pp_frag_count and page refcount) is racy when page refcoun=
t gets
> > > > > incremented by code dealing with skb fragments directly, and
> > > > > page_pool_return_skb_page is called multiple times for the same f=
ragment.
> > > > >=20
> > > > > Dropping page->pp_frag_count and relying entirely on the page ref=
count makes
> > > > > these underflow issues and crashes go away.
> > > > >=20
> > > >=20
> > > > This has been discussed here [1].  TL;DR changing this to page
> > > > refcount might blow up in other colorful ways.  Can we look closer =
and
> > > > figure out why the underflow happens?
> > > I don't see how the approch taken in my patch would blow up. From wha=
t I=20
> > > can tell, it should be fairly close to how refcount is handled in=20
> > > page_frag_alloc. The main improvement it adds is to prevent it from=
=20
> > > blowing up if pool-allocated fragments get shared across multiple skb=
s=20
> > > with corresponding get_page and page_pool_return_skb_page calls.
> > >=20
> > > - Felix
> > >=20
> >=20
> > Do you have the patch available to review as an RFC? From what I am
> > seeing it looks like you are underrunning on the pp_frag_count itself.
> > I would suspect the issue to be something like starting with a bad
> > count in terms of the total number of references, or deducing the wrong
> > amount when you finally free the page assuming you are tracking your
> > frag count using a non-atomic value in the driver.
> The driver patches for page pool are here:
> https://patchwork.kernel.org/project/linux-wireless/patch/64abb23f4867c07=
5c19d704beaae5a0a2f8e8821.1673963374.git.lorenzo@kernel.org/
> https://patchwork.kernel.org/project/linux-wireless/patch/68081e02cbe2afa=
2d35c8aa93194f0adddbd0f05.1673963374.git.lorenzo@kernel.org/
>=20
> They are also applied in my mt76 tree at:
> https://github.com/nbd168/wireless
>=20
> - Felix

So one thing I am thinking is that we may be seeing an issue where we
are somehow getting a mix of frag and non-frag based page pool pages.
That is the only case I can think of where we might be underflowing
negative. If you could add some additional debug info on the underflow
WARN_ON case in page_pool_defrag_page that might be useful.
Specifically I would be curious what the actual return value is. I'm
assuming we are only hitting negative 1, but I would want to verify we
aren't seeing something else.

Also just to confirm this is building on 64b kernel correct? Just want
to make sure we don't have this running on a 32b setup where the frag
count and the upper 32b of the DMA address are overlapped.

As far as the patch set I only really see a few minor issues which I am
going to post a few snippets below.


> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c
> b/drivers/net/wireless/mediatek/mt76/dma.c
> index 611769e445fa..7fd9aa9c3d9e 100644

...

> @@ -593,25 +593,28 @@  mt76_dma_rx_fill(struct mt76_dev *dev, struct
> mt76_queue *q)
> =20
>  	while (q->queued < q->ndesc - 1) {
>  		struct mt76_queue_buf qbuf;
> -		void *buf =3D NULL;
> +		dma_addr_t addr;
> +		int offset;
> +		void *buf;
> =20
> -		buf =3D page_frag_alloc(&q->rx_page, q->buf_size,
> GFP_ATOMIC);
> +		buf =3D mt76_get_page_pool_buf(q, &offset, q-
> >buf_size);
>  		if (!buf)
>  			break;
> =20
> -		addr =3D dma_map_single(dev->dma_dev, buf, len,
> DMA_FROM_DEVICE);
> +		addr =3D dma_map_single(dev->dma_dev, buf + offset,
> len,
> +				      DMA_FROM_DEVICE);

Offset was already added to buf in mt76_get_page_pool_buf so the DMA
mapping offset doesn't look right to me.

>  		if (unlikely(dma_mapping_error(dev->dma_dev, addr)))
> {
> -			skb_free_frag(buf);
> +			mt76_put_page_pool_buf(buf, allow_direct);
>  			break;
>  		}
> =20

I'm not a fan of the defensive programming in mt76_put_page_pool_buf.
If you are in an area that is using page pool you should be using the
page pool version of the freeing operations instead of adding
additional overhead that can mess things up by having it have to also
check for if the page is a page pool page or not.

> -		qbuf.addr =3D addr + offset;
> -		qbuf.len =3D len - offset;
> +		qbuf.addr =3D addr + q->buf_offset;
> +		qbuf.len =3D len - q->buf_offset;
>  		qbuf.skip_unmap =3D false;
>  		if (mt76_dma_add_rx_buf(dev, q, &qbuf, buf) < 0) {
>  			dma_unmap_single(dev->dma_dev, addr, len,
>  					 DMA_FROM_DEVICE);
> -			skb_free_frag(buf);
> +			mt76_put_page_pool_buf(buf, allow_direct);
>  			break;
>  		}
>  		frames++;

...

> @@ -848,6 +847,8 @@  mt76_dma_rx_process(struct mt76_dev *dev, struct
> mt76_queue *q, int budget)
>  			goto free_frag;
> =20
>  		skb_reserve(skb, q->buf_offset);
> +		if (mt76_is_page_from_pp(data))
> +			skb_mark_for_recycle(skb);
> =20
>  		*(u32 *)skb->cb =3D info;
> =20

More defensive programming here. Is there a path that allows for a
mixed setup?

The only spot where I can see there being anything like that is in=20
/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c. But it doesn't make
any sense to me as to why it was included in the patch. It might be
easier to sort out the issue if we were to get rid of some of the
defensive programming.
