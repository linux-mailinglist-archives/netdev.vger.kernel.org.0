Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A0A3392EB
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhCLQSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:18:35 -0500
Received: from foss.arm.com ([217.140.110.172]:56682 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhCLQSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:18:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B392E1FB;
        Fri, 12 Mar 2021 08:18:33 -0800 (PST)
Received: from [10.57.52.136] (unknown [10.57.52.136])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A040A3F7D7;
        Fri, 12 Mar 2021 08:18:30 -0800 (PST)
Subject: Re: [PATCH 14/17] iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, freedreno@lists.freedesktop.org,
        kvm@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
References: <20210301084257.945454-1-hch@lst.de>
 <20210301084257.945454-15-hch@lst.de>
 <1658805c-ed28-b650-7385-a56fab3383e3@arm.com> <20210310091501.GC5928@lst.de>
 <20210310092533.GA6819@lst.de> <fdacf87a-be14-c92c-4084-1d1dd4fc7766@arm.com>
 <20210311082609.GA6990@lst.de>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <dff8eb80-8f74-972b-17e9-496c1fc0396f@arm.com>
Date:   Fri, 12 Mar 2021 16:18:24 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210311082609.GA6990@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-11 08:26, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 06:39:57PM +0000, Robin Murphy wrote:
>>> Actually... Just mirroring the iommu_dma_strict value into
>>> struct iommu_domain should solve all of that with very little
>>> boilerplate code.
>>
>> Yes, my initial thought was to directly replace the attribute with a
>> common flag at iommu_domain level, but since in all cases the behaviour
>> is effectively global rather than actually per-domain, it seemed
>> reasonable to take it a step further. This passes compile-testing for
>> arm64 and x86, what do you think?
> 
> It seems to miss a few bits, and also generally seems to be not actually
> apply to recent mainline or something like it due to different empty
> lines in a few places.

Yeah, that was sketched out on top of some other development patches, 
and in being so focused on not breaking any of the x86 behaviours I did 
indeed overlook fully converting the SMMU drivers... oops!

(my thought was to do the conversion for its own sake, then clean up the 
redundant attribute separately, but I guess it's fine either way)

> Let me know what you think of the version here:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/iommu-cleanup
> 
> I'll happily switch the patch to you as the author if you're fine with
> that as well.

I still have reservations about removing the attribute API entirely and 
pretending that io_pgtable_cfg is anything other than a SoC-specific 
private interface, but the reworked patch on its own looks reasonable to 
me, thanks! (I wasn't too convinced about the iommu_cmd_line wrappers 
either...) Just iommu_get_dma_strict() needs an export since the SMMU 
drivers can be modular - I consciously didn't add that myself since I 
was mistakenly thinking only iommu-dma would call it.

Robin.
