Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F254712F8D8
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 14:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgACNhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 08:37:52 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:39922 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgACNhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 08:37:51 -0500
Received: by mail-qv1-f66.google.com with SMTP id y8so16215832qvk.6
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 05:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=gZNZq3V1uCrbgfGqWICLfqmVUuafevWXFVX/Fr6naiI=;
        b=mT7dALzUerjgpNzHfuz9BoQQ639nJFFwlLuYyZTiAEVcBh/JlOfvUomXstJKyBg9lD
         4Vdep6q9DjpARGoQmh7O5QMTuzHzKecaf6bwS9z2j95xVt5XeGM2WlvNtGEHiYC5ITdt
         /4xJPnE2S5XJAsv38tZXk4KmSSY1MnMjcuXOimfvk170E70tEufMQAGFOjo1rllkPk5x
         OEQse/XbtPIOyfKdGPnfK1U4LzXo7e1N+XdjDLuq6A+79iTI1rGPgsyNFaal0eR3VjyS
         BPyrZV7zzTgRxXTTfcIVPOKchn02eSQGpTTloyvOTBVd0JBle8Tlj3NiB0Kky7Q6gghe
         xX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=gZNZq3V1uCrbgfGqWICLfqmVUuafevWXFVX/Fr6naiI=;
        b=Y8on4+YdgdRSmvkk32XIp8Ghy4CMCPbtwH2sJ6xfXcvlw9rfZhF7HhfSUSLJDTpVhq
         HulPGVWI/6yHS/kTWK+h1sS6qlRHBWTmB51BWv30wIxC8mTBUK6+FurOTDJZrz4aw6Uq
         y6zdiwQyZVRwNyCSqf3Iil7cqCtE2YbBJ9bShvpD5NH7HwxY1Mll4rKol15M//VGUQQS
         CaFifc4Zp2kYqD1dGO7yHOXUCCZ1P+AK8gibyRlSUu9SyP8ko7Q/QNWKVzpbNjRLMu11
         T9QQtv7nAhjWlZfHsasQZUEILwAL34nbFr2uVylhsDXRlLbqwkMLDyEx7rPcyK8/uVRo
         CO4Q==
X-Gm-Message-State: APjAAAWBdLxtkvkHV/UkbrC0H/bCfzud0HYZkyU/LRpJ7F4ucFRThxCA
        N4hxP+NkpCBlrk8NVeaTg2ruZQ==
X-Google-Smtp-Source: APXvYqxttDT7F82aSDnbhCM/USMIPE14gkD51euP2/jKPDmxmxaAZuj6xdvIkg9//lzjzgb+DSZ+5Q==
X-Received: by 2002:ad4:59c2:: with SMTP id el2mr65022462qvb.152.1578058670354;
        Fri, 03 Jan 2020 05:37:50 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id o7sm16363014qkd.119.2020.01.03.05.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Jan 2020 05:37:49 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1inN9B-0003T8-5K; Fri, 03 Jan 2020 09:37:49 -0400
Date:   Fri, 3 Jan 2020 09:37:49 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Will Deacon <will@kernel.org>, saeedm@mellanox.com,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
Message-ID: <20200103133749.GA9706@ziepe.ca>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
 <20200102205847.GJ9282@ziepe.ca>
 <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <79BB7EDF-406D-4FA1-ADDC-634D55F15C37@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 12:21:06AM +0200, Liran Alon wrote:

> > AFAIK WC is largely unspecified by the memory model. Is wmb() even
> > formally specified to interact with WC?
> 
> As I said, I haven’t seen such semantics defined in kernel
> documentation such as memory-barriers.txt.  However, in practice, it
> does flush WC buffers. At least for x86 and ARM which I’m familiar
> enough with.  I think it’s reasonable to assume that wmb() should
> flush WC buffers while dma_wmb()/smp_wmb() doesn’t necessarily have
> to do this.

It is because WC is rarely used and laregly undefined for the kernel
:(

> >>>> Therefore, change mlx5_write64() to use writeX() and remove wmb() from
> >>>> it's callers.
> >>> 
> >>> Yes, wmb(); writel(); is always redundant
> >> 
> >> Well, unfortunately not…
> >> See: https://urldefense.proofpoint.com/v2/url?u=https-3A__marc.info_-3Fl-3Dlinux-2Dnetdev-26m-3D157798859215697-26w-3D2&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=Jk6Q8nNzkQ6LJ6g42qARkg6ryIDGQr-yKXPNGZbpTx0&m=Ox1lCS1KAGBvJrf24kiFQrranIaNi_zeo05sqCUEf7Y&s=Mz6MJzUQ862DGjgGnj3neX4ZpjI88nOI9KpZhNF9TqQ&e=
> >> (See my suggestion to add flush_wc_writeX())
> > 
> > Well, the last time wmb & writel came up Linus was pretty clear that
> > writel is supposed to remain in program order and have the barriers
> > needed to do that.
> 
> Right. But that doesn’t take into account that WC writes are
> considered completed when they are still posted in CPU WC buffers.

> The semantics as I understand of writeX() is that it guarantees all
> prior writes have been completed.  It means that all prior stores
> have executed and that store-buffer is flushed. But it doesn’t mean
> that WC buffers is flushed as-well.

The semantic for writel is that prior program order stores will be
observable by DMA from the device receiving the writel. This is
required for UC and NC stores today. WC is undefined, I think.

This is why ARM has the additional barrier in writel.

It would logically make sense if WC followed the same rule, however,
adding a barrier to writel to make WC ordered would not be popular, so
I think we are left with using special accessors for WC and placing
the barrier there..

> > IMHO you should start there before going around and adding/removing wmbs
> > related to WC. Update membory-barriers.txt and related with the model
> > ordering for WC access and get agreement.
> 
> I disagree here. It’s more important to fix a real bug (e.g. Not
> flushing WC buffers on x86 AMD).  Then, we can later formalise this
> and refactor code as necessary. Which will also optimise it as-well.
> Bug fix can be merged before we finish all these discussions and get
> agreement.

Is it a real bug that people actually hit? It wasn't clear from the
commit message. If so, sure, it should be fixed and the commit message
clarified. (but I'd put the wmb near the WC writes..)

I am surprised that AMD is different here, the evolution of the WC
feature on x86 was to transparently speed up graphics, so I'm pretty
surprised AMD can get away with not ordering the same as Intel..

> I do completely agree we should have this discussion on WC and
> barriers and I already sent an email on this to all the
> memory-barriers.txt maintainers. Waiting to see how that discussion
> go and get community feedback before I will submit a patch-series
> that will introduce new changes to memory-barriers.txt and probably
> also new barrier macro.

The barrier macros have been unpopular, ie the confusing mmiowb was
dumped, and I strongly suspect to contain WC within a spinlock (which
is very important!) you need a barrier instruction on some archs.

New accessors might work better.

> >>>> 	doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
> >>>> 	doorbell[1] = cpu_to_be32(cq->cqn);
> >>> 
> >>>> static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
> >>>> {
> >>>> #if BITS_PER_LONG == 64
> >>>> -	__raw_writeq(*(u64 *)val, dest);
> >>>> +	writeq(*(u64 *)val, dest);
> >>> 
> >>> I want to say this might cause problems with endian swapping as writeq
> >>> also does some swaps that __raw does not? Is this true?
> >> 
> >> Hmm... Looking at ARM64 version, writeq() indeed calls cpu_to_le64()
> >> on parameter before passing it to __raw_writeq().  Quite surprising
> >> from API perspective to be honest.
> > 
> > For PCI-E devices writel(x) is defined to generate the same TLP on the
> > PCI-E bus, across all arches.
> 
> Good to know.
> Question: Where is this documented?

Hmm, haven't ever seen it documented like that. It is sort of a
logical requirement. If writel(x) produces different TLPs (ie
different byte order) how could a driver ever work with a PCI-E device
that requires only one TLP for x?

> >> So should I change this instead to iowrite64be(*(u64 *)val, dest)?
> > 
> > This always made my head hurt, but IIRC, when I looked at it years ago
> > the weird array construction caused problems with that simple conversion.
> > 
> > The userspace version looks like this now:
> > 
> >        uint64_t doorbell;
> >        uint32_t sn;
> >        uint32_t ci;
> >        uint32_t cmd;
> > 
> >        sn  = cq->arm_sn & 3;
> >        ci  = cq->cons_index & 0xffffff;
> >        cmd = solicited ? MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT;
> > 
> >        doorbell = sn << 28 | cmd | ci;
> >        doorbell <<= 32;
> >        doorbell |= cq->cqn;
> > 
> >        mmio_write64_be(ctx->uar[0].reg + MLX5_CQ_DOORBELL, htobe64(doorbell));
> > 
> > Where on all supported platforms the mmio_write64_be() expands to a
> > simple store (no swap)
> > 
> > Which does look functionally the same as
> > 
> >   iowrite64be(doorbell, dest);
> > 
> > So this patch should change the mlx5_write64 to accept a u64 like we
> > did in userspace when this was all cleaned there.
> 
> If I understand you correctly, you suggest to change callers to pass
> here a standard u64 and then modify mlx5_write64() to just call
> iowrite64be(). If so, I agree. Just want to confirm before sending
> v2.

Yes, this is what I did to userspace and it made this all make
sense. I strongly recommend to do the same in the kernel, particularly
now that we have iowrite64be()!

Jason
