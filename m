Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E98250E7D3
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 20:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbiDYSPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 14:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbiDYSPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 14:15:14 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7A211115E;
        Mon, 25 Apr 2022 11:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650910329; x=1682446329;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=mSQimSeit0qQYIR29FHzF1+b5hRzxzx/JMxX3mqAd+E=;
  b=nk37Qmh3vTaBhcHif9hN6gjotG3+dfZNLCPvsKRzqnsPaVHhxsNoJGK9
   n+KkQUANR6kXrq3XB5vAvW+EG12G4ggEV43auywxA2LRt6kW1G8WxXscL
   aBtQZSTn5N4F+Tk5ZMF2/OAk3ieU0Qha+17luKJ2JDDrXaWdvrXwC9X1G
   KU7oIFd+U+KcwMRGSdtNVWHh5eMKKYwEuu0iYGyq0fReu1COz89OPLVe6
   7ZMet3CSAae1AZjqLpdyUuiZkrYsOQpuQopS/hsZUhuZ+tnzbLMGJmQlc
   KIKwKdkE3ojBZe/hbfB6z6rzF+7tw3eZ1C8HqgqEf3RQBDAJTGcpqGQao
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265130816"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="265130816"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 11:11:56 -0700
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="729853515"
Received: from rderber-mobl.amr.corp.intel.com ([10.212.151.176])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 11:11:56 -0700
Date:   Mon, 25 Apr 2022 11:11:56 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Geliang Tang <geliang.tang@suse.com>
cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, mptcp@lists.linux.dev,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next 2/7] bpf: add bpf_skc_to_mptcp_sock_proto
In-Reply-To: <513485c6-82ea-9cf0-1df0-3ea75935809c@iogearbox.net>
Message-ID: <73d12683-df70-b77e-5d92-d37664559148@linux.intel.com>
References: <20220420222459.307649-1-mathew.j.martineau@linux.intel.com> <20220420222459.307649-3-mathew.j.martineau@linux.intel.com> <513485c6-82ea-9cf0-1df0-3ea75935809c@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022, Daniel Borkmann wrote:

> On 4/21/22 12:24 AM, Mat Martineau wrote:
> [...]
>> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
>> index 0a3b0fb04a3b..5b3a6f783182 100644
>> --- a/include/net/mptcp.h
>> +++ b/include/net/mptcp.h
>> @@ -283,4 +283,10 @@ static inline int mptcpv6_init(void) { return 0; }
>>   static inline void mptcpv6_handle_mapped(struct sock *sk, bool mapped) { 
>> }
>>   #endif
>>   +#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_JIT) && 
>> defined(CONFIG_BPF_SYSCALL)
>> +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
>> +#else
>> +static inline struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock 
>> *sk) { return NULL; }
>> +#endif
>> +
>
> Where is this relevant to JIT specifically?
>

That's carried over from the build conditions for bpf_tcp_ca.c in 
net/ipv4/Makefile:

ifeq ($(CONFIG_BPF_JIT),y)
obj-$(CONFIG_BPF_SYSCALL) += bpf_tcp_ca.o
endif

Looks like the reasoning for that (in the CA code) is the use of 
bpf_struct_ops in bpf_tcp_ca.c

While this patch series for MPTCP does not use bpf_struct_ops, and JIT is 
not necessary for bpf_mptcp_sock_from_subflow(), the upcoming MPTCP 
scheduler-in-BPF patches do use bpf_struct_ops. So that dependency found 
its way in to this series - but now that you point it out, 
bpf_mptcp_sock_from_subflow() shouldn't be limited by CONFIG_BPF_JIT and 
we can separately check for the JIT dependency for the scheduler code. 
Will fix that in v2.


--
Mat Martineau
Intel
