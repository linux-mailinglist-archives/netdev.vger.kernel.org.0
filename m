Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517E6210919
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 12:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgGAKR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 06:17:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:65263 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729226AbgGAKRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 06:17:54 -0400
IronPort-SDR: UA7j/NGZc672E0pj279sLbEV3EM8ayOjoZr8CDync9Uh8LCi3f0vUmjR1XQMwhWN8ddVrZFHPB
 WVnJrnxbD/og==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="231405050"
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="231405050"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 03:17:54 -0700
IronPort-SDR: 5MoAoKthMtffAjAf4xbx0GXdGvaC7TB4m9gWvV0bQ0XO+4ddVOvXKSxFN+AdHJEQMv2szwRaNc
 OGuQIuRAbGYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="481542314"
Received: from unknown (HELO btopel-mobl.ger.intel.com) ([10.249.43.154])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jul 2020 03:17:51 -0700
Subject: Re: [PATCH net] xsk: remove cheap_dma optimization
To:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     maximmi@mellanox.com, konrad.wilk@oracle.com,
        jonathan.lemon@gmail.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, magnus.karlsson@intel.com
References: <20200626134358.90122-1-bjorn.topel@gmail.com>
 <c60dfb5a-2bf3-20bd-74b3-6b5e215f73f8@iogearbox.net>
 <20200627070406.GB11854@lst.de>
 <88d27e1b-dbda-301c-64ba-2391092e3236@intel.com>
 <878626a2-6663-0d75-6339-7b3608aa4e42@arm.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <b8e1ef0d-20ae-0ea1-3c29-fc8db96e2afb@intel.com>
Date:   Wed, 1 Jul 2020 12:17:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <878626a2-6663-0d75-6339-7b3608aa4e42@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-29 17:41, Robin Murphy wrote:
> On 2020-06-28 18:16, Björn Töpel wrote:
[...]>
>> Somewhat related to the DMA API; It would have performance benefits for
>> AF_XDP if the DMA range of the mapped memory was linear, i.e. by IOMMU
>> utilization. I've started hacking a thing a little bit, but it would be
>> nice if such API was part of the mapping core.
>>
>> Input: array of pages Output: array of dma addrs (and obviously dev,
>> flags and such)
>>
>> For non-IOMMU len(array of pages) == len(array of dma addrs)
>> For best-case IOMMU len(array of dma addrs) == 1 (large linear space)
>>
>> But that's for later. :-)
> 
> FWIW you will typically get that behaviour from IOMMU-based 
> implementations of dma_map_sg() right now, although it's not strictly 
> guaranteed. If you can weather some additional setup cost of calling 
> sg_alloc_table_from_pages() plus walking the list after mapping to test 
> whether you did get a contiguous result, you could start taking 
> advantage of it as some of the dma-buf code in DRM and v4l2 does already 
> (although those cases actually treat it as a strict dependency rather 
> than an optimisation).
> 
> I'm inclined to agree that if we're going to see more of these cases, a 
> new API call that did formally guarantee a DMA-contiguous mapping 
> (either via IOMMU or bounce buffering) or failure might indeed be handy.
>

I forgot to reply to this one! My current hack is using the iommu code 
directly, similar to what vfio-pci does (hopefully not gutting the API 
this time ;-)).

Your approach sound much nicer, and easier. I'll try that out! Thanks a 
lot for the pointers, and I might be back with more questions.


Cheers,
Björn

> Robin.
