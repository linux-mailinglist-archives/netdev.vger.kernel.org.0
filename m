Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F7423B2AE
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 04:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgHDCRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 22:17:47 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:48754
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1725975AbgHDCRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 22:17:46 -0400
Received: from [166.111.139.118] (unknown [166.111.139.118])
        by app-3 (Coremail) with SMTP id EQQGZQAH6sY2xShf9izvAw--.9502S2;
        Tue, 04 Aug 2020 10:17:28 +0800 (CST)
Subject: Re: [PATCH] net: vmxnet3: avoid accessing the data mapped to
 streaming DMA
To:     David Miller <davem@davemloft.net>
Cc:     doshir@vmware.com, pv-drivers@vmware.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200802131107.15857-1-baijiaju@tsinghua.edu.cn>
 <20200803.155949.39743839019093809.davem@davemloft.net>
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Message-ID: <6d4a6167-2480-0091-33a1-6b0cb81e4645@tsinghua.edu.cn>
Date:   Tue, 4 Aug 2020 10:17:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200803.155949.39743839019093809.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: EQQGZQAH6sY2xShf9izvAw--.9502S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw4xCr47tFWDKF18tF4ktFb_yoW3uFg_Cw
        4Iywn3C398CwsruFn5tFy3Arn293yqqr1jvr1FqF1Ik343AFZFga1Uur97Jrn3tw4SyFZ3
        uw1YqrWDXr1UWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIkYjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY
        02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r12
        6r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf
        9x07j5wIDUUUUU=
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/8/4 6:59, David Miller wrote:
> From: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
> Date: Sun,  2 Aug 2020 21:11:07 +0800
>
>> In vmxnet3_probe_device(), "adapter" is mapped to streaming DMA:
>>    adapter->adapter_pa = dma_map_single(..., adapter, ...);
>>
>> Then "adapter" is accessed at many places in this function.
>>
>> Theses accesses may cause data inconsistency between CPU cache and
>> hardware.
>>
>> To fix this problem, dma_map_single() is called after these accesses.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
> 'adapter' is accessed everywhere, in the entire driver, not just here
> in the probe function.

Okay, replacing dma_map_single() with dma_alloc_coherent() may be better.
If you think this solution is okay, I can submit a new patch.


Best wishes,
Jia-Ju Bai

