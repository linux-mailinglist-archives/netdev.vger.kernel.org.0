Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FA21DB728
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 16:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgETOeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 10:34:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:26290 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgETOeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 10:34:17 -0400
IronPort-SDR: B+3LPz5J8KvRyoG2J35sy2xsZYCV501Ng39Ij+l9MBO9a472nkp+Slf1LqxJpiwAjrri9aVCsd
 YXio1EbeOyXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 07:34:16 -0700
IronPort-SDR: KT0TlJdT5CgYsXjQIEQi3y1yaUTbjn4SqyAukPNeonzcKiY/z1feQYVSQcBk4KzOK6uRTriwHM
 zMsxDpA/r1yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,414,1583222400"; 
   d="scan'208";a="308739120"
Received: from sbaldwin-mobl3.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.131])
  by FMSMGA003.fm.intel.com with ESMTP; 20 May 2020 07:34:06 -0700
Subject: Re: [PATCH bpf-next v4 01/15] xsk: fix xsk_umem_xdp_frame_sz()
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com, maximmi@mellanox.com,
        maciej.fijalkowski@intel.com
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
 <20200520094742.337678-2-bjorn.topel@gmail.com>
 <20200520151819.1d2254b7@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <17701885-c91d-5bfc-b96d-29263a0d08ab@intel.com>
Date:   Wed, 20 May 2020 16:34:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520151819.1d2254b7@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-20 15:18, Jesper Dangaard Brouer wrote:
> On Wed, 20 May 2020 11:47:28 +0200
> Björn Töpel <bjorn.topel@gmail.com> wrote:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Calculating the "data_hard_end" for an XDP buffer coming from AF_XDP
>> zero-copy mode, the return value of xsk_umem_xdp_frame_sz() is added
>> to "data_hard_start".
>>
>> Currently, the chunk size of the UMEM is returned by
>> xsk_umem_xdp_frame_sz(). This is not correct, if the fixed UMEM
>> headroom is non-zero. Fix this by returning the chunk_size without the
>> UMEM headroom.
>>
>> Fixes: 2a637c5b1aaf ("xdp: For Intel AF_XDP drivers add XDP frame_sz")
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   include/net/xdp_sock.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> index abd72de25fa4..6b1137ce1692 100644
>> --- a/include/net/xdp_sock.h
>> +++ b/include/net/xdp_sock.h
>> @@ -239,7 +239,7 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
>>   
>>   static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
>>   {
>> -	return umem->chunk_size_nohr + umem->headroom;
>> +	return umem->chunk_size_nohr;
> 
> Hmm, is this correct?
> 
> As you write "xdp_data_hard_end" is calculated as an offset from
> xdp->data_hard_start pointer based on the frame_sz.  Will your
> xdp->data_hard_start + frame_sz point to packet end?
>

Yes, I believe this is correct.

Say that a user uses a chunk size of 2k, and a umem headroom of, say,
64. This means that the kernel should (at least) leave 64B which the
kernel shouldn't touch.

umem->headroom | XDP_PACKET_HEADROOM | packet |          |
                ^                     ^        ^      ^   ^
                a                     b        c      d   e

a: data_hard_start
b: data
c: data_end
d: data_hard_end, (e - 320)
e: hardlimit of chunk, a + umem->chunk_size_nohr

Prior this fix the umem->headroom was *included* in frame_sz.

> #define xdp_data_hard_end(xdp)                          \
>          ((xdp)->data_hard_start + (xdp)->frame_sz -     \
>           SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> 
> Note the macro reserves the last 320 bytes (for skb_shared_info), but
> for AF_XDP zero-copy mode, it will never create an SKB that use this
> area.   Thus, in principle we can allow XDP-progs to extend/grow tail
> into this area, but I don't think there is any use-case for this, as
> it's much easier to access packet-data in userspace application.
> (Thus, it might not be worth the complexity to give AF_XDP
> bpf_xdp_adjust_tail access to this area, by e.g. "lying" via adding 320
> bytes to frame_sz).
> 

I agree, and in the picture (well...) above that would be "d". IOW
data_hard_end is 320 "off" the real end.


Björn
