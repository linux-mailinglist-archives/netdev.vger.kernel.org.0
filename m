Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FAE1EBF1F
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 17:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgFBPf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 11:35:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:42790 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBPf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 11:35:57 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg8xH-0002dA-5Q; Tue, 02 Jun 2020 17:35:55 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jg8xG-000LL1-TM; Tue, 02 Jun 2020 17:35:54 +0200
Subject: Re: [PATCH bpf 2/3] bpf: Add csum_level helper for fixing up csum
 levels
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <cover.1591108731.git.daniel@iogearbox.net>
 <279ae3717cb3d03c0ffeb511493c93c450a01e1a.1591108731.git.daniel@iogearbox.net>
 <CACAyw982WPUfNN_9LD0bhGPTtBSca7t0UV_0UsO3dVGjtEZm9A@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5d317380-142e-c364-2793-68d0bed9efcd@iogearbox.net>
Date:   Tue, 2 Jun 2020 17:35:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CACAyw982WPUfNN_9LD0bhGPTtBSca7t0UV_0UsO3dVGjtEZm9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25831/Tue Jun  2 14:41:03 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/20 5:19 PM, Lorenz Bauer wrote:
> On Tue, 2 Jun 2020 at 15:58, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Add a bpf_csum_level() helper which BPF programs can use in combination
>> with bpf_skb_adjust_room() when they pass in BPF_F_ADJ_ROOM_NO_CSUM_RESET
>> flag to the latter to avoid falling back to CHECKSUM_NONE.
>>
>> The bpf_csum_level() allows to adjust CHECKSUM_UNNECESSARY skb->csum_levels
>> via BPF_CSUM_LEVEL_{INC,DEC} which calls __skb_{incr,decr}_checksum_unnecessary()
>> on the skb. The helper also allows a BPF_CSUM_LEVEL_RESET which sets the skb's
>> csum to CHECKSUM_NONE as well as a BPF_CSUM_LEVEL_QUERY to just return the
>> current level. Without this helper, there is no way to otherwise adjust the
>> skb->csum_level. I did not add an extra dummy flags as there is plenty of free
>> bitspace in level argument itself iff ever needed in future.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   include/uapi/linux/bpf.h       | 43 +++++++++++++++++++++++++++++++++-
>>   net/core/filter.c              | 38 ++++++++++++++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h | 43 +++++++++++++++++++++++++++++++++-
>>   3 files changed, 122 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 3ba2bbbed80c..46622901cba7 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3220,6 +3220,38 @@ union bpf_attr {
>>    *             calculation.
>>    *     Return
>>    *             Requested value, or 0, if flags are not recognized.
>> + *
>> + * int bpf_csum_level(struct sk_buff *skb, u64 level)
> 
> u64 flags? We can also stuff things into level I guess.

Yeah, I did mention it in the commit log. There is plenty of bit space to extend
with flags in there iff ever needed. Originally, helper was called bpf_csum_adjust()
but then renamed into bpf_csum_level() to be more 'topic specific' (aka do one thing
and do it well...) and avoid future api overloading, so if necessary level can be
used since I don't think the enum will be extended much further from what we have
here anyway.

[...]
> 
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>

Thanks!
