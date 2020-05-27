Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830831E3409
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgE0A17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:27:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:60944 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgE0A16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 20:27:58 -0400
IronPort-SDR: Ht0xLvmJvkh5fsDrZnQCEIarakOcJfxQM4dsa5z7HkSO9Udf/9odwe0RlHbXrwf7lgf4F80cU2
 ym+p1qlghLbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 17:27:58 -0700
IronPort-SDR: G7cwKbdMIJC6XaNVa8hEvW392OYDVsCtXR2eTBiWRTqTycTDlyRnNB/hpo1ZYupdpfcvNhwQzg
 h7VNV31jHK6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,439,1583222400"; 
   d="scan'208";a="468508626"
Received: from anambiar-mobl.amr.corp.intel.com (HELO [10.209.177.241]) ([10.209.177.241])
  by fmsmga005.fm.intel.com with ESMTP; 26 May 2020 17:27:57 -0700
Subject: Re: [bpf-next PATCH v2] bpf: Add rx_queue_mapping to bpf_sock
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        davem@davemloft.net, ast@kernel.org
Cc:     kafai@fb.com, sridhar.samudrala@intel.com
References: <159017210823.76267.780907394437543496.stgit@anambiarhost.jf.intel.com>
 <a648441b-6546-c904-d2a0-583b4c9e77d7@iogearbox.net>
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
Message-ID: <c2aa1fe8-606c-bee7-672d-2fcfed86a263@intel.com>
Date:   Tue, 26 May 2020 17:27:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a648441b-6546-c904-d2a0-583b4c9e77d7@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/2020 4:34 PM, Daniel Borkmann wrote:
> On 5/22/20 8:28 PM, Amritha Nambiar wrote:
>> Add "rx_queue_mapping" to bpf_sock. This gives read access for the
>> existing field (sk_rx_queue_mapping) of struct sock from bpf_sock.
>> Semantics for the bpf_sock rx_queue_mapping access are similar to
>> sk_rx_queue_get(), i.e the value NO_QUEUE_MAPPING is not allowed
>> and -1 is returned in that case.
> 
> This adds the "what this patch does" but could you also add a 
> description for
> the use-case in here?
> 

Will fix in v3.

>> v2: fixed build error for CONFIG_XPS wrapping, reported by
>>      kbuild test robot <lkp@intel.com>
>>
>> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
>> ---
>>   include/uapi/linux/bpf.h |    1 +
>>   net/core/filter.c        |   18 ++++++++++++++++++
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 97e1fd19ff58..d2acd5aeae8d 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3530,6 +3530,7 @@ struct bpf_sock {
>>       __u32 dst_ip4;
>>       __u32 dst_ip6[4];
>>       __u32 state;
>> +    __u32 rx_queue_mapping;
>>   };
>>   struct bpf_tcp_sock {
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index bd2853d23b50..c4ba92204b73 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -6829,6 +6829,7 @@ bool bpf_sock_is_valid_access(int off, int size, 
>> enum bpf_access_type type,
>>       case offsetof(struct bpf_sock, protocol):
>>       case offsetof(struct bpf_sock, dst_port):
>>       case offsetof(struct bpf_sock, src_port):
>> +    case offsetof(struct bpf_sock, rx_queue_mapping):
>>       case bpf_ctx_range(struct bpf_sock, src_ip4):
>>       case bpf_ctx_range_till(struct bpf_sock, src_ip6[0], src_ip6[3]):
>>       case bpf_ctx_range(struct bpf_sock, dst_ip4):
>> @@ -7872,6 +7873,23 @@ u32 bpf_sock_convert_ctx_access(enum 
>> bpf_access_type type,
>>                               skc_state),
>>                          target_size));
>>           break;
>> +    case offsetof(struct bpf_sock, rx_queue_mapping):
>> +#ifdef CONFIG_XPS
>> +        *insn++ = BPF_LDX_MEM(
>> +            BPF_FIELD_SIZEOF(struct sock, sk_rx_queue_mapping),
>> +            si->dst_reg, si->src_reg,
>> +            bpf_target_off(struct sock, sk_rx_queue_mapping,
>> +                       sizeof_field(struct sock,
>> +                            sk_rx_queue_mapping),
>> +                       target_size));
>> +        *insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE_MAPPING,
>> +                      1);
>> +        *insn++ = BPF_MOV64_IMM(si->dst_reg, -1);
>> +#else
>> +        *insn++ = BPF_MOV64_IMM(si->dst_reg, 0);
> 
> This should be -1 as queue mapping as well if XPS is not configured, no?
> Otherwise, how do you tell it apart from an actual mapping to 0 if XPS is
> built-in?
> 

Agree. My bad. Will fix in v3.

>> +        *target_size = 2;
>> +#endif
>> +        break;
>>       }
>>       return insn - insn_buf;
>>
> 
