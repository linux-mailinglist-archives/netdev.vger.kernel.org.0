Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C767D9B10D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 15:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405628AbfHWNfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 09:35:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:31234 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfHWNfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 09:35:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 06:35:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="330723926"
Received: from klaatz-mobl1.ger.corp.intel.com (HELO [10.237.221.61]) ([10.237.221.61])
  by orsmga004.jf.intel.com with ESMTP; 23 Aug 2019 06:35:41 -0700
Subject: Re: [PATCH bpf-next v5 03/11] xsk: add support to allow unaligned
 chunk placement
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
References: <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190822014427.49800-4-kevin.laatz@intel.com>
 <3AEEC88E-8D45-41C5-AFBF-51512826B1A7@gmail.com>
From:   "Laatz, Kevin" <kevin.laatz@intel.com>
Message-ID: <e549e399-089e-f423-169f-81ac9f831cad@intel.com>
Date:   Fri, 23 Aug 2019 14:35:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3AEEC88E-8D45-41C5-AFBF-51512826B1A7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/08/2019 19:43, Jonathan Lemon wrote:
> On 21 Aug 2019, at 18:44, Kevin Laatz wrote:
>> Currently, addresses are chunk size aligned. This means, we are very
>> restricted in terms of where we can place chunk within the umem. For
>> example, if we have a chunk size of 2k, then our chunks can only be 
>> placed
>> at 0,2k,4k,6k,8k... and so on (ie. every 2k starting from 0).
>>
>> This patch introduces the ability to use unaligned chunks. With these
>> changes, we are no longer bound to having to place chunks at a 2k (or
>> whatever your chunk size is) interval. Since we are no longer dealing 
>> with
>> aligned chunks, they can now cross page boundaries. Checks for page
>> contiguity have been added in order to keep track of which pages are
>> followed by a physically contiguous page.
>>
>> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
>> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
>> Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
>>
>> ---
>> v2:
>>   - Add checks for the flags coming from userspace
>>   - Fix how we get chunk_size in xsk_diag.c
>>   - Add defines for masking the new descriptor format
>>   - Modified the rx functions to use new descriptor format
>>   - Modified the tx functions to use new descriptor format
>>
>> v3:
>>   - Add helper function to do address/offset masking/addition
>>
>> v4:
>>   - fixed page_start calculation in __xsk_rcv_memcpy().
>>   - move offset handling to the xdp_umem_get_* functions
>>   - modified the len field in xdp_umem_reg struct. We now use 16 bits 
>> from
>>     this for the flags field.
>>   - removed next_pg_contig field from xdp_umem_page struct. Using low 12
>>     bits of addr to store flags instead.
>>   - other minor changes based on review comments
>>
>> v5:
>>   - Added accessors for getting addr and offset
>>   - Added helper function to add offset to addr
>>   - Fixed offset handling in xsk_rcv
>>   - Removed bitfields from xdp_umem_reg
>>   - Added struct size checking for xdp_umem_reg in xsk_setsockopt to 
>> handle
>>     different versions of the struct.
>>   - fix conflicts after 'bpf-af-xdp-wakeup' was merged.
>> ---
>>  include/net/xdp_sock.h      | 75 +++++++++++++++++++++++++++--
>>  include/uapi/linux/if_xdp.h |  9 ++++
>>  net/xdp/xdp_umem.c          | 19 ++++++--
>>  net/xdp/xsk.c               | 96 +++++++++++++++++++++++++++++--------
>>  net/xdp/xsk_diag.c          |  2 +-
>>  net/xdp/xsk_queue.h         | 68 ++++++++++++++++++++++----
>>  6 files changed, 232 insertions(+), 37 deletions(-)
>>
>>
[...]

>> @@ -196,17 +221,17 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct 
>> xdp_buff *xdp)
>>          goto out_unlock;
>>      }
>>
>> -    if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>> +    if (!xskq_peek_addr(xs->umem->fq, &addr, xs->umem) ||
>>          len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
>>          err = -ENOSPC;
>>          goto out_drop;
>>      }
>>
>> -    addr += xs->umem->headroom;
>> -
>> -    buffer = xdp_umem_get_data(xs->umem, addr);
>> +    buffer = xdp_umem_get_data(xs->umem, addr + offset);
>>      memcpy(buffer, xdp->data_meta, len + metalen);
>> -    addr += metalen;
>> +    offset += metalen;
>> +
>> +    addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
>>      err = xskq_produce_batch_desc(xs->rx, addr, len);
>>      if (err)
>>          goto out_drop;
>
> Can't just add address and offset any longer.  This should read:
>
>     addr = xsk_umem_adjust_offset(xs->umem, addr, offset);
>     buffer = xdp_umem_get_data(xs->umem, addr);
>
>     addr = xsk_umem_adjust_offset(xs->umem, addr, metalen);
>
>
> so that offset and then metalen are added.  (or preserve the
> address across the calls like memcpy_addr earlier).


Will fix this, thanks!

-Kevin

