Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A997935EF3B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349919AbhDNII6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 04:08:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237927AbhDNIIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 04:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618387705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ncnzXsMB1Lmg3QO5E45b/0YMwJoUyHq/D8nx9QO3N8=;
        b=hOBGMy/PSa4LVM9Z4Qby6rHTc+fhduiZSoArIgctUx1sgDq33R/cZXTb5ZwFuATLY2AdIh
        FZ4hNMWzRUUdFg5kbKsKdOdKT6ksIE/IBHnwwjFtTjrgqlXzePOM+mgBos0vrBQBYfvAjR
        tSwFGqvwRqrGTAj+0whXKgGlaVTogRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-MZQdkqqkOFifSQ3AEAR6RA-1; Wed, 14 Apr 2021 04:08:24 -0400
X-MC-Unique: MZQdkqqkOFifSQ3AEAR6RA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D202A6D4E6;
        Wed, 14 Apr 2021 08:08:21 +0000 (UTC)
Received: from [10.36.113.50] (ovpn-113-50.ams2.redhat.com [10.36.113.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7256214106;
        Wed, 14 Apr 2021 08:08:09 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, jasowang@redhat.com, alexander.duyck@gmail.com,
        saeed@kernel.org, maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 09/14] bpd: add multi-buffer support to xdp
 copy helpers
Date:   Wed, 14 Apr 2021 10:08:05 +0200
Message-ID: <2C9C83D0-933E-4F3E-9569-503064E06E21@redhat.com>
In-Reply-To: <20210408210409.m76rfs65zbpo4sk7@skbuf>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <cc517a20ac0908fa070ee6ba019936a8037a6d8c.1617885385.git.lorenzo@kernel.org>
 <20210408210409.m76rfs65zbpo4sk7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8 Apr 2021, at 23:04, Vladimir Oltean wrote:

> On Thu, Apr 08, 2021 at 02:51:01PM +0200, Lorenzo Bianconi wrote:
>> From: Eelco Chaudron <echaudro@redhat.com>
>>
>> This patch adds support for multi-buffer for the following helpers:
>>   - bpf_xdp_output()
>>   - bpf_perf_event_output()
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>
> Also there is a typo in the commit message: bpd -> bpf.

ACK, will fix in next version.

>>  net/core/filter.c                             |  63 ++++++++-
>>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 
>> ++++++++++++------
>>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   3 +-
>>  3 files changed, 149 insertions(+), 44 deletions(-)
>>
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index c4eb1392f88e..c00f52ab2532 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -4549,10 +4549,56 @@ static const struct bpf_func_proto 
>> bpf_sk_ancestor_cgroup_id_proto = {
>>  };
>>  #endif
>>
>> -static unsigned long bpf_xdp_copy(void *dst_buff, const void 
>> *src_buff,
>> +static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
>>  				  unsigned long off, unsigned long len)
>>  {
>> -	memcpy(dst_buff, src_buff + off, len);
>> +	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
>
> There is no need to cast a void pointer in C.

I added this as the void pointer is a const. However, looking at it 
again, we should probably change xdp_get_shared_info_from_buff() to also 
take a const pointer, i.e.:

    static inline struct xdp_shared_info *
   -xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
   +xdp_get_shared_info_from_buff(const struct xdp_buff *xdp)
    {
           BUILD_BUG_ON(sizeof(struct xdp_shared_info) >
                        sizeof(struct skb_shared_info));

What do you think Lorenzo?

>> +	struct xdp_shared_info *xdp_sinfo;
>> +	unsigned long base_len;
>> +
>> +	if (likely(!xdp->mb)) {
>> +		memcpy(dst_buff, xdp->data + off, len);
>> +		return 0;
>> +	}
>> +
>> +	base_len = xdp->data_end - xdp->data;
>
> Would a static inline int xdp_buff_head_len() be useful?

Guess everybody is using the xdp->data_end - xdp->data, in there code. 
But I guess we can add a static inline and change all code, but I 
don’t think we should do it as part of this patchset. I would also 
call it something like xdp_buff_data_len()?

>> +	xdp_sinfo = xdp_get_shared_info_from_buff(xdp);
>> +	do {
>> +		const void *src_buff = NULL;
>> +		unsigned long copy_len = 0;
>> +
>> +		if (off < base_len) {
>> +			src_buff = xdp->data + off;
>> +			copy_len = min(len, base_len - off);
>> +		} else {
>> +			unsigned long frag_off_total = base_len;
>> +			int i;
>> +
>> +			for (i = 0; i < xdp_sinfo->nr_frags; i++) {
>> +				skb_frag_t *frag = &xdp_sinfo->frags[i];
>> +				unsigned long frag_len, frag_off;
>> +
>> +				frag_len = xdp_get_frag_size(frag);
>> +				frag_off = off - frag_off_total;
>> +				if (frag_off < frag_len) {
>> +					src_buff = xdp_get_frag_address(frag) +
>> +						   frag_off;
>> +					copy_len = min(len,
>> +						       frag_len - frag_off);
>> +					break;
>> +				}
>> +				frag_off_total += frag_len;
>> +			}
>> +		}
>> +		if (!src_buff)
>> +			break;
>> +
>> +		memcpy(dst_buff, src_buff, copy_len);
>> +		off += copy_len;
>> +		len -= copy_len;
>> +		dst_buff += copy_len;
>> +	} while (len);
>> +
>>  	return 0;
>>  }

