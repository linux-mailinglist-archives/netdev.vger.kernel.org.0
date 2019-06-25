Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5904E54FEE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfFYNM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 09:12:29 -0400
Received: from mga03.intel.com ([134.134.136.65]:64473 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfFYNM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 09:12:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 06:12:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,415,1557212400"; 
   d="scan'208";a="166672815"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.237.221.70]) ([10.237.221.70])
  by orsmga006.jf.intel.com with ESMTP; 25 Jun 2019 06:12:25 -0700
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf@vger.kernel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
References: <20190620083924.1996-1-kevin.laatz@intel.com>
 <CAJ+HfNijp8BgMgiOuohiuqDPz+spAutdG34gUqKzepYo2noE-w@mail.gmail.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <e90c81b0-a419-49b0-4e2a-3d20956feb6e@intel.com>
Date:   Tue, 25 Jun 2019 14:12:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNijp8BgMgiOuohiuqDPz+spAutdG34gUqKzepYo2noE-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/06/2019 16:38, Björn Töpel wrote:
> On Thu, 20 Jun 2019 at 18:55, Kevin Laatz <kevin.laatz@intel.com> wrote:
>>
>> This patchset adds the ability to use unaligned chunks in the XDP umem.
>>
>> Currently, all chunk addresses passed to the umem are masked to be chunk
>> size aligned (default is 2k, max is PAGE_SIZE). This limits where we can
>> place chunks within the umem as well as limiting the packet sizes 
>> that are
>> supported.
>>
>> The changes in this patchset removes these restrictions, allowing XDP 
>> to be
>> more flexible in where it can place a chunk within a umem. By 
>> relaxing where
>> the chunks can be placed, it allows us to use an arbitrary buffer 
>> size and
>> place that wherever we have a free address in the umem. These changes 
>> add the
>> ability to support jumboframes and make it easy to integrate with other
>> existing frameworks that have their own memory management systems, 
>> such as
>> DPDK.
>>
>
> Thanks for working on this, Kevin and Ciara!
>
> I have some minor comments on the series, but in general I think it's
> in good shape!
>
> For some reason the series was submitted twice (at least on my side)?
Apologies for the confusion... The first set had a typo in the bpf 
mailing list address (.com vs .org). Will fix for the v2.
>
>
> Thanks,
> Björn


Thanks for reviewing. Will address your comments in the v2.

>
>> Structure of the patchset:
>> Patch 1:
>>   - Remove unnecessary masking and headroom addition during zero-copy Rx
>>     buffer recycling in i40e. This change is required in order for the
>>     buffer recycling to work in the unaligned chunk mode.
>>
>> Patch 2:
>>   - Remove unnecessary masking and headroom addition during
>>     zero-copy Rx buffer recycling in ixgbe. This change is required in
>>     order for the  buffer recycling to work in the unaligned chunk mode.
>>
>> Patch 3:
>>   - Adds an offset parameter to zero_copy_allocator. This change will
>>     enable us to calculate the original handle in zca_free. This will be
>>     required for unaligned chunk mode since we can't easily mask back to
>>     the original handle.
>>
>> Patch 4:
>>   - Adds the offset parameter to i40e_zca_free. This change is needed 
>> for
>>     calculating the handle since we can't easily mask back to the 
>> original
>>     handle like we can in the aligned case.
>>
>> Patch 5:
>>   - Adds the offset parameter to ixgbe_zca_free. This change is 
>> needed for
>>     calculating the handle since we can't easily mask back to the 
>> original
>>     handle like we can in the aligned case.
>>
>>
>> Patch 6:
>>   - Add infrastructure for unaligned chunks. Since we are dealing
>>     with unaligned chunks that could potentially cross a physical page
>>     boundary, we add checks to keep track of that information. We can
>>     later use this information to correctly handle buffers that are
>>     placed at an address where they cross a page boundary.
>>
>> Patch 7:
>>   - Add flags for umem configuration to libbpf
>>
>> Patch 8:
>>   - Modify xdpsock application to add a command line option for
>>     unaligned chunks
>>
>> Patch 9:
>>   - Addition of command line argument to pass in a desired buffer size
>>     and buffer recycling for unaligned mode. Passing in a buffer size 
>> will
>>     allow the application to use unaligned chunks with the unaligned 
>> chunk
>>     mode. Since we are now using unaligned chunks, we need to recycle 
>> our
>>     buffers in a slightly different way.
>>
>> Patch 10:
>>   - Adds hugepage support to the xdpsock application
>>
>> Patch 11:
>>   - Documentation update to include the unaligned chunk scenario. We 
>> need
>>     to explicitly state that the incoming addresses are only masked 
>> in the
>>     aligned chunk mode and not the unaligned chunk mode.
>>
>> Kevin Laatz (11):
>>   i40e: simplify Rx buffer recycle
>>   ixgbe: simplify Rx buffer recycle
>>   xdp: add offset param to zero_copy_allocator
>>   i40e: add offset to zca_free
>>   ixgbe: add offset to zca_free
>>   xsk: add support to allow unaligned chunk placement
>>   libbpf: add flags to umem config
>>   samples/bpf: add unaligned chunks mode support to xdpsock
>>   samples/bpf: add buffer recycling for unaligned chunks to xdpsock
>>   samples/bpf: use hugepages in xdpsock app
>>   doc/af_xdp: include unaligned chunk case
>>
>>  Documentation/networking/af_xdp.rst           | 10 +-
>>  drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 21 ++--
>>  drivers/net/ethernet/intel/i40e/i40e_xsk.h    |  3 +-
>>  .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  3 +-
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 21 ++--
>>  include/net/xdp.h                             |  3 +-
>>  include/net/xdp_sock.h                        |  2 +
>>  include/uapi/linux/if_xdp.h                   |  4 +
>>  net/core/xdp.c                                | 11 ++-
>>  net/xdp/xdp_umem.c                            | 17 ++--
>>  net/xdp/xsk.c                                 | 60 +++++++++--
>>  net/xdp/xsk_queue.h                           | 60 +++++++++--
>>  samples/bpf/xdpsock_user.c                    | 99 ++++++++++++++-----
>>  tools/include/uapi/linux/if_xdp.h             |  4 +
>>  tools/lib/bpf/xsk.c                           |  7 ++
>>  tools/lib/bpf/xsk.h                           |  2 +
>>  16 files changed, 241 insertions(+), 86 deletions(-)
>>
>> -- 
>> 2.17.1
>>
>
