Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40196483C9
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfFQNVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:21:49 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:50846 "EHLO
        smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbfFQNVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:21:48 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2019 09:21:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1560777347;
        bh=ZvJvYkjr7iE1RIXRXDlijzKzJL0BitvNBM9T5FqQAmw=;
        h=Subject:To:From:Date:From;
        b=Nl+Gx2+KTHlZUrgrlD4OPdHaDIh8UJfTuRA5MZVnySfiilIiWgnddpiJk4/aln5DA
         OAo8bcON3aHKJNRIUHN2qprmbAq2BRvH2IUzshdVkvRvYeZuB2iOeftPYIjVWn6ziI
         KuJnFj51kem220yEC5D7kahxijPjmtFu66j0THaY=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp7.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id D9002A01B2;
        Mon, 17 Jun 2019 09:15:44 -0400 (EDT)
X-Sender-Id: abbotti@mev.co.uk
Received: from [10.0.0.62] (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher AES128-SHA)
        by 0.0.0.0:465 (trex/5.7.12);
        Mon, 17 Jun 2019 09:15:47 -0400
Subject: Re: [PATCH 12/16] staging/comedi: mark as broken
To:     Christoph Hellwig <hch@lst.de>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
References: <20190614134726.3827-1-hch@lst.de>
 <20190614134726.3827-13-hch@lst.de> <20190614140239.GA7234@kroah.com>
 <20190614144857.GA9088@lst.de> <20190614153032.GD18049@kroah.com>
 <20190614153428.GA10008@lst.de>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
Message-ID: <60c6af3d-d8e4-5745-8d2b-9791a2f4ff56@mev.co.uk>
Date:   Mon, 17 Jun 2019 14:15:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614153428.GA10008@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2019 16:34, Christoph Hellwig wrote:
> On Fri, Jun 14, 2019 at 05:30:32PM +0200, Greg KH wrote:
>> On Fri, Jun 14, 2019 at 04:48:57PM +0200, Christoph Hellwig wrote:
>>> On Fri, Jun 14, 2019 at 04:02:39PM +0200, Greg KH wrote:
>>>> Perhaps a hint as to how we can fix this up?  This is the first time
>>>> I've heard of the comedi code not handling dma properly.
>>>
>>> It can be fixed by:
>>>
>>>   a) never calling virt_to_page (or vmalloc_to_page for that matter)
>>>      on dma allocation
>>>   b) never remapping dma allocation with conflicting cache modes
>>>      (no remapping should be doable after a) anyway).
>>
>> Ok, fair enough, have any pointers of drivers/core code that does this
>> correctly?  I can put it on my todo list, but might take a week or so...
> 
> Just about everyone else.  They just need to remove the vmap and
> either do one large allocation, or live with the fact that they need
> helpers to access multiple array elements instead of one net vmap,
> which most of the users already seem to do anyway, with just a few
> using the vmap (which might explain why we didn't see blowups yet).

Avoiding the vmap in comedi should be do-able as it already has other 
means to get at the buffer pages.

When comedi makes the buffer from DMA coherent memory, it currently 
allocates it as a series of page-sized chunks.  That cannot be mmap'ed 
in one go with dma_mmap_coherent(), so I see the following solutions.

1. Change the buffer allocation to allocate a single chunk of DMA 
coherent memory and use dma_mmap_coherent() to mmap it.

2. Call dma_mmap_coherent() in a loop, adjusting vma->vm_start and 
vma->vm_end for each iteration (vma->vm_pgoff will be 0), and restoring 
the vma->vm_start and vma->vm_end at the end.

I'm not sure if 2 is a legal option.

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || Web: www.mev.co.uk )=-
-=( MEV Ltd. is a company registered in England & Wales. )=-
-=( Registered number: 02862268.  Registered address:    )=-
-=( 15 West Park Road, Bramhall, STOCKPORT, SK7 3JZ, UK. )=-
