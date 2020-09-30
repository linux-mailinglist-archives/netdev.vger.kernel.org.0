Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2DC27F3D2
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgI3VBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:01:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:53930 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3VBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:01:51 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNjEQ-0003uY-Ax; Wed, 30 Sep 2020 23:01:46 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNjEQ-000JPF-5m; Wed, 30 Sep 2020 23:01:46 +0200
Subject: Re: [PATCH bpf-next v4 6/6] bpf, selftests: add redirect_neigh
 selftest
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <cover.1601477936.git.daniel@iogearbox.net>
 <0fc7d9c5f9a6cc1c65b0d3be83b44b1ec9889f43.1601477936.git.daniel@iogearbox.net>
 <20200930192004.acumndm6xfxwplzl@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7a454afe-9f5b-6e6f-5683-33fdc61dabaa@iogearbox.net>
Date:   Wed, 30 Sep 2020 23:01:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200930192004.acumndm6xfxwplzl@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25943/Wed Sep 30 15:54:21 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/20 9:20 PM, Alexei Starovoitov wrote:
> On Wed, Sep 30, 2020 at 05:18:20PM +0200, Daniel Borkmann wrote:
>> +
>> +#ifndef barrier_data
>> +# define barrier_data(ptr)	asm volatile("": :"r"(ptr) :"memory")
>> +#endif
>> +
>> +#ifndef ctx_ptr
>> +# define ctx_ptr(field)		(void *)(long)(field)
>> +#endif
> 
>> +static __always_inline bool is_remote_ep_v4(struct __sk_buff *skb,
>> +					    __be32 addr)
>> +{
>> +	void *data_end = ctx_ptr(skb->data_end);
>> +	void *data = ctx_ptr(skb->data);
> 
> please consider adding:
>          __bpf_md_ptr(void *, data);
>          __bpf_md_ptr(void *, data_end);
> to struct __sk_buff in a followup to avoid this casting headache.

You mean also for the other ctx types? I can take a look, yeah.

>> +SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
>> +{
>> +	int idx = dst_to_src_tmp;
>> +	__u8 zero[ETH_ALEN * 2];
>> +	bool redirect = false;
>> +
>> +	switch (skb->protocol) {
>> +	case __bpf_constant_htons(ETH_P_IP):
>> +		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_src));
>> +		break;
>> +	case __bpf_constant_htons(ETH_P_IPV6):
>> +		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_src);
>> +		break;
>> +	}
>> +
>> +	if (!redirect)
>> +		return TC_ACT_OK;
>> +
>> +	barrier_data(&idx);
>> +	idx = bpf_ntohl(idx);
> 
> I don't follow. Why force that constant into a register and force
> actual swap instruction?
> 
>> +
>> +	__builtin_memset(&zero, 0, sizeof(zero));
>> +	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
>> +		return TC_ACT_SHOT;
>> +
>> +	return bpf_redirect_neigh(idx, 0);
>> +}
> 
>> +xxd -p < test_tc_neigh.o   | sed "s/eeddddee/$veth_src/g" | xxd -r -p > test_tc_neigh.x.o
>> +xxd -p < test_tc_neigh.x.o | sed "s/eeffffee/$veth_dst/g" | xxd -r -p > test_tc_neigh.y.o
> 
> So the inline asm is because of the above?
> So after compiling you're hacking elf binary for this pattern ?
> Ouch. Please use global data or something. This is fragile.
> This type of hacks should be discouraged and having selftests do them
> goes as counter example.

Yeah, so the barrier_data() was to avoid compiler to optimize, and the bpf_ntohl()
to load target ifindex which was stored in big endian. Thanks for applying the set,
I'll look into reworking this to have a loader application w/ the global data and
then to pin it and have iproute2 pick this up from the pinned location, for example
(or directly interact with netlink wrt attaching ... I'll see which is better).

Thanks,
Daniel
