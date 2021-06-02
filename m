Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE23983DA
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhFBILX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:11:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:32908 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFBILV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:11:21 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1loLwV-0002ok-8U; Wed, 02 Jun 2021 10:09:35 +0200
Received: from [85.7.101.30] (helo=linux-2.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1loLwU-000CT0-Vm; Wed, 02 Jun 2021 10:09:35 +0200
Subject: Re: Regression 5.12.0-rc4 net: ice: significant throughput drop
To:     Jussi Maki <joamaki@gmail.com>, Robin Murphy <robin.murphy@arm.com>
Cc:     jroedel@suse.de, netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com, hch@lst.de,
        iommu@lists.linux-foundation.org, suravee.suthikulpanit@amd.com,
        gregkh@linuxfoundation.org
References: <CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com>
 <cc58c09e-bbb5-354a-2030-bf8ebb2adc86@iogearbox.net>
 <7f048c57-423b-68ba-eede-7e194c1fea4e@arm.com>
 <CAHn8xckNt3smeQPi3dgq5i_3vP7KwU45pnP5OCF8nOV_QEdyMA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7c04eeea-22d3-c265-8e1e-b3f173f2179f@iogearbox.net>
Date:   Wed, 2 Jun 2021 10:09:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAHn8xckNt3smeQPi3dgq5i_3vP7KwU45pnP5OCF8nOV_QEdyMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26188/Tue Jun  1 13:07:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 7:42 PM, Jussi Maki wrote:
> Hi Robin,
> 
> On Tue, Jun 1, 2021 at 2:39 PM Robin Murphy <robin.murphy@arm.com> wrote:
>>>> The regression shows as a significant drop in throughput as measured
>>>> with "super_netperf" [0],
>>>> with measured bandwidth of ~95Gbps before and ~35Gbps after:
>>
>> I guess that must be the difference between using the flush queue
>> vs. strict invalidation. On closer inspection, it seems to me that
>> there's a subtle pre-existing bug in the AMD IOMMU driver, in that
>> amd_iommu_init_dma_ops() actually runs *after* amd_iommu_init_api()
>> has called bus_set_iommu(). Does the patch below work?
> 
> Thanks for the quick response & patch. I tried it out and indeed it
> does solve the issue:
> 
> # uname -a
> Linux zh-lab-node-3 5.13.0-rc3-amd-iommu+ #31 SMP Tue Jun 1 17:12:57
> UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
> root@zh-lab-node-3:~# ./super_netperf 32 -H 172.18.0.2
> 95341.2
> 
> root@zh-lab-node-3:~# uname -a
> Linux zh-lab-node-3 5.13.0-rc3-amd-iommu-unpatched #32 SMP Tue Jun 1
> 17:29:34 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
> root@zh-lab-node-3:~# ./super_netperf 32 -H 172.18.0.2
> 33989.5

Robin, probably goes without saying, but please make sure to include ...

Fixes: a250c23f15c2 ("iommu: remove DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE")

... to your fix in [0], maybe along with another Fixes tag pointing to the original
commit adding this issue. But certainly a250c23f15c2 would be good given the regression
was uncovered on that one first, so that Greg et al have a chance to pick this fix up
for stable kernels.

Thanks everyone!

   [0] https://lore.kernel.org/bpf/7f048c57-423b-68ba-eede-7e194c1fea4e@arm.com/
