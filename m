Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBF79A768
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 08:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403958AbfHWGKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 02:10:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:60504 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392300AbfHWGKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 02:10:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 23:10:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,420,1559545200"; 
   d="scan'208";a="170030314"
Received: from arappl-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.53.140])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 23:10:27 -0700
Subject: Re: [PATCH net v3] ixgbe: fix double clean of tx descriptors with xdp
To:     William Tu <u9012063@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Ilya Maximets <i.maximets@samsung.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>
References: <CGME20190822171243eucas1p12213f2239d6c36be515dade41ed7470b@eucas1p1.samsung.com>
 <20190822171237.20798-1-i.maximets@samsung.com>
 <CAKgT0UepBGqx=FiqrdC-r3kvkMxVAHonkfc6rDt_HVQuzahZPQ@mail.gmail.com>
 <CALDO+SYhU4krmBO8d4hsDGm+BuUAR4qMv=WzVa=jAx27+g9KnA@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <217e90f5-206a-bb80-6699-f6dd750b57d9@intel.com>
Date:   Fri, 23 Aug 2019 08:10:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALDO+SYhU4krmBO8d4hsDGm+BuUAR4qMv=WzVa=jAx27+g9KnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-08-22 19:32, William Tu wrote:
> On Thu, Aug 22, 2019 at 10:21 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
>>
>> On Thu, Aug 22, 2019 at 10:12 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>
>>> Tx code doesn't clear the descriptors' status after cleaning.
>>> So, if the budget is larger than number of used elems in a ring, some
>>> descriptors will be accounted twice and xsk_umem_complete_tx will move
>>> prod_tail far beyond the prod_head breaking the completion queue ring.
>>>
>>> Fix that by limiting the number of descriptors to clean by the number
>>> of used descriptors in the tx ring.
>>>
>>> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
>>> 'ixgbe_xsk_clean_tx_ring()' since we're allowed to directly use
>>> 'next_to_clean' and 'next_to_use' indexes.
>>>
>>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>>> ---
>>>
>>> Version 3:
>>>    * Reverted some refactoring made for v2.
>>>    * Eliminated 'budget' for tx clean.
>>>    * prefetch returned.
>>>
>>> Version 2:
>>>    * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
>>>      'ixgbe_xsk_clean_tx_ring()'.
>>>
>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 29 ++++++++------------
>>>   1 file changed, 11 insertions(+), 18 deletions(-)
>>
>> Thanks for addressing my concerns.
>>
>> Acked-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Thanks.
> 
> Tested-by: William Tu <u9012063@gmail.com>
> 

Will, thanks for testing! For this patch, did you notice any performance
degradation?


Cheers,
Björn
