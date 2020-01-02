Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4ED12EAF9
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 21:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgABU6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 15:58:50 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36714 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgABU6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 15:58:50 -0500
Received: by mail-qv1-f66.google.com with SMTP id m14so15495787qvl.3
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 12:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=HbbQW1SNhxlXdo8dRCo3E6RQ6shpJULnhLge56/pWLw=;
        b=luXfpcsqbSZluOn7NXNq7cVW9QRBhsx0EZ3vnn61bEcip7knpE1Zq3mYr3UVFYKYDc
         dGqiOtnTJDDaGkhCbFCYJvsBmDawvWxi3Ui5k0FyJhwX1oGh8j7HT/3+jxT5/jXM3MuM
         iKCGgxV7rHTDeIUfZYlvagZoZz5kveuXD0auv3no2eAssAExqzfYaKmE3QvRHCO2hZkL
         3bTG2b3PmNDCG+4foUqOSfakc08OiX23xH7r8UrJkenXMu687xCE0vYBgrV13Udra8g1
         6s/Ll+Qht0zeDO+WjHfHhPbORPyjOLPo5KY2xjWk1d72zwfal4hAGvEFtCQCJNAwFqL8
         +IIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=HbbQW1SNhxlXdo8dRCo3E6RQ6shpJULnhLge56/pWLw=;
        b=rcISNXTycv8bLMWxUoWE/6T3EDDJOrGJDQuzDceWNseWXcc25rH2xENLCbrQIq03f5
         0k9u5DtSoXaIbZnEloiYnC6x4qL8o3GcY5oDdMvgz9N/dt8wPSy1pefUveRyCvi5UW8x
         KeP1mvHOcamTaCdkcwQkopiQOZs0zpLYZUN0wKSDWKMUq3nu0sjPoydm4rdy/oZvjfFZ
         ZRPlO2XZ+/eFENDO8+596rt9o7eIK6ROKpxLeHmHxGzOurRrptAgaXVWxEMK3M0GS10j
         lBo4h4LuJtkxC89biRX9eoCsdcWgoAcbt1F+I7tFajQtNV5u4aosistp1A09F2jMLl/G
         Id4g==
X-Gm-Message-State: APjAAAU0+Q3BoFjfDLy2h+jfgXQhoS2eryha0YmPf9mIGvG06u8iPzbo
        FSIC9pY3uTaERR+FoAcNCeKsoQ==
X-Google-Smtp-Source: APXvYqxdu7b7Fx1/rS3BQvK+CufVCJZ4TqFCc+X7ghDfnIN20RBoPM3aSN1SxVzaSDk84kwyh0PCPQ==
X-Received: by 2002:a0c:f685:: with SMTP id p5mr62193558qvn.44.1577998729075;
        Thu, 02 Jan 2020 12:58:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id o7sm15419804qkd.119.2020.01.02.12.58.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jan 2020 12:58:48 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1in7YO-0008Mv-0O; Thu, 02 Jan 2020 16:58:48 -0400
Date:   Thu, 2 Jan 2020 16:58:48 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Liran Alon <liran.alon@oracle.com>, Will Deacon <will@kernel.org>
Cc:     saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, eli@mellanox.com, tariqt@mellanox.com,
        danielm@mellanox.com,
        =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Subject: Re: [PATCH] net: mlx5: Use writeX() to ring doorbell and remove
 reduntant wmb()
Message-ID: <20200102205847.GJ9282@ziepe.ca>
References: <20200102174436.66329-1-liran.alon@oracle.com>
 <20200102192934.GH9282@ziepe.ca>
 <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6524AE07-2ED7-41B5-B761-9F6BE8D2049B@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 09:45:52PM +0200, Liran Alon wrote:
> 
> 
> > On 2 Jan 2020, at 21:29, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > On Thu, Jan 02, 2020 at 07:44:36PM +0200, Liran Alon wrote:
> >> Currently, mlx5e_notify_hw() executes wmb() to complete writes to cache-coherent
> >> memory before ringing doorbell. Doorbell is written to by mlx5_write64()
> >> which use __raw_writeX().
> >> 
> >> This is semantically correct but executes reduntant wmb() in some architectures.
> >> For example, in x86, a write to UC memory guarantees that any previous write to
> >> WB memory will be globally visible before the write to UC memory. Therefore, there
> >> is no need to also execute wmb() before write to doorbell which is mapped as UC memory.
> >> 
> >> The consideration regarding this between different architectures is handled
> >> properly by the writeX() macro. Which is defined differently for different
> >> architectures. E.g. On x86, it is just a memory write. However, on ARM, it
> >> is defined as __iowmb() folowed by a memory write. __iowmb() is defined
> >> as wmb().
> > 
> > This reasoning seems correct, though I would recommend directly
> > refering to locking/memory-barriers.txt which explains this.
> 
> I find memory-barriers.txt not explicit enough on the semantics of writeX().
> (For example: Should it flush write-combined buffers before writing to the UC memory?)
> That’s why I preferred to explicitly state here how I perceive it.

AFAIK WC is largely unspecified by the memory model. Is wmb() even
formally specified to interact with WC?

At least in this mlx5 case there is no WC, right? The kernel UAR is
mapped UC?

So we don't need to worry about the poor specification of WC access
and you can refer to memory-barriers.txt at least for this patch.

> > 
> >> Therefore, change mlx5_write64() to use writeX() and remove wmb() from
> >> it's callers.
> > 
> > Yes, wmb(); writel(); is always redundant
> 
> Well, unfortunately not…
> See: https://marc.info/?l=linux-netdev&m=157798859215697&w=2
> (See my suggestion to add flush_wc_writeX())

Well, the last time wmb & writel came up Linus was pretty clear that
writel is supposed to remain in program order and have the barriers
needed to do that.

I don't think WC was considered when that discussion happened, but we
really don't have a formal model for how WC works at all within the
kernel.

The above patch is really not a wmb(); writel() pairing, the wmb() is
actually closing/serializing an earlier WC transaction, and yes you need various
special things to keep WC working right.

IMHO you should start there before going around and adding/removing wmbs
related to WC. Update membory-barriers.txt and related with the model
ordering for WC access and get agreement.

For instance does wmb() even effect WC? Does WC have to be contained
by spinlocks? Do we need extra special barriers like flush_wc and
flush_wc_before_spin_unlock ? etc.

Perhaps Will has some advice?

> >> diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
> >> index 40748fc1b11b..28744a725e64 100644
> >> +++ b/include/linux/mlx5/cq.h
> >> @@ -162,11 +162,6 @@ static inline void mlx5_cq_arm(struct mlx5_core_cq *cq, u32 cmd,
> >> 
> >> 	*cq->arm_db = cpu_to_be32(sn << 28 | cmd | ci);
> >> 
> >> -	/* Make sure that the doorbell record in host memory is
> >> -	 * written before ringing the doorbell via PCI MMIO.
> >> -	 */
> >> -	wmb();
> >> -
> > 
> > Why did this one change? The doorbell memory here is not a writel():
> 
> Well, it’s not seen in the diff but actually the full code is:
> 
>     /* Make sure that the doorbell record in host memory is
>      * written before ringing the doorbell via PCI MMIO.
>      */
>     wmb();
> 
>     doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
>     doorbell[1] = cpu_to_be32(cq->cqn);
> 
>     mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);

Ah OK, we have another thing called doorbell which is actually DMA'ble
memory.

> >> 	doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
> >> 	doorbell[1] = cpu_to_be32(cq->cqn);
> > 
> >> static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
> >> {
> >> #if BITS_PER_LONG == 64
> >> -	__raw_writeq(*(u64 *)val, dest);
> >> +	writeq(*(u64 *)val, dest);
> > 
> > I want to say this might cause problems with endian swapping as writeq
> > also does some swaps that __raw does not? Is this true?
> 
> Hmm... Looking at ARM64 version, writeq() indeed calls cpu_to_le64()
> on parameter before passing it to __raw_writeq().  Quite surprising
> from API perspective to be honest.

For PCI-E devices writel(x) is defined to generate the same TLP on the
PCI-E bus, across all arches. __raw_* does something arch specific and
should not be called from drivers. It is a long standing bug that this
code is written like this.

> So should I change this instead to iowrite64be(*(u64 *)val, dest)?

This always made my head hurt, but IIRC, when I looked at it years ago
the weird array construction caused problems with that simple conversion.

The userspace version looks like this now:

        uint64_t doorbell;
        uint32_t sn;
        uint32_t ci;
        uint32_t cmd;

        sn  = cq->arm_sn & 3;
        ci  = cq->cons_index & 0xffffff;
        cmd = solicited ? MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT;

        doorbell = sn << 28 | cmd | ci;
        doorbell <<= 32;
        doorbell |= cq->cqn;

        mmio_write64_be(ctx->uar[0].reg + MLX5_CQ_DOORBELL, htobe64(doorbell));

Where on all supported platforms the mmio_write64_be() expands to a
simple store (no swap)

Which does look functionally the same as

   iowrite64be(doorbell, dest);

So this patch should change the mlx5_write64 to accept a u64 like we
did in userspace when this was all cleaned there.

Jason
