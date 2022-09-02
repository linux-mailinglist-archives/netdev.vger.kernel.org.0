Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8475AB4BB
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235989AbiIBPML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235741AbiIBPLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:11:54 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C680157D04;
        Fri,  2 Sep 2022 07:41:35 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oU7rN-000AUD-GO; Fri, 02 Sep 2022 16:41:29 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oU7rN-000HxJ-27; Fri, 02 Sep 2022 16:41:29 +0200
Subject: Re: [PATCH bpf-next 0/4] Introduce bpf_ct_set_nat_info kfunc helper
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, brouer@redhat.com,
        toke@redhat.com, memxor@gmail.com, deso@posteo.net
References: <cover.1662050126.git.lorenzo@kernel.org>
 <aec3e8d1-6b80-c344-febe-809bbb0308eb@iogearbox.net>
 <YxIUvxY8S256TTUf@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <df144f34-b44c-cc96-69eb-32eaaf1ac1fb@iogearbox.net>
Date:   Fri, 2 Sep 2022 16:41:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YxIUvxY8S256TTUf@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26646/Fri Sep  2 09:55:25 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/22 4:35 PM, Lorenzo Bianconi wrote:
> On Sep 02, Daniel Borkmann wrote:
>> On 9/1/22 6:43 PM, Lorenzo Bianconi wrote:
>>> Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
>>> destination nat addresses/ports in a new allocated ct entry not inserted
>>> in the connection tracking table yet.
>>> Introduce support for per-parameter trusted args.
>>>
>>> Kumar Kartikeya Dwivedi (2):
>>>     bpf: Add support for per-parameter trusted args
>>>     selftests/bpf: Extend KF_TRUSTED_ARGS test for __ref annotation
>>>
>>> Lorenzo Bianconi (2):
>>>     net: netfilter: add bpf_ct_set_nat_info kfunc helper
>>>     selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
>>>
>>>    Documentation/bpf/kfuncs.rst                  | 18 +++++++
>>>    kernel/bpf/btf.c                              | 39 ++++++++++-----
>>>    net/bpf/test_run.c                            |  9 +++-
>>>    net/netfilter/nf_conntrack_bpf.c              | 49 ++++++++++++++++++-
>>>    .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
>>>    .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 +++++++++-
>>>    tools/testing/selftests/bpf/verifier/calls.c  | 38 +++++++++++---
>>>    7 files changed, 156 insertions(+), 25 deletions(-)
>>>
>>
>> Looks like this fails BPF CI, ptal:
>>
>> https://github.com/kernel-patches/bpf/runs/8147936670?check_suite_focus=true
> 
> Hi Daniel,
> 
> it seems CONFIG_NF_NAT is not set in the kernel config file.
> Am I supposed to enable it in bpf-next/tools/testing/selftests/bpf/config?

This would have to be set there and added to the patches, yes. @Andrii/DanielM, is
this enough or are other steps needed on top of that?

>> [...]
>>    All error logs:
>>    test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
>>    test_bpf_nf_ct:PASS:iptables 0 nsec
>>    test_bpf_nf_ct:PASS:start_server 0 nsec
>>    connect_to_server:PASS:socket 0 nsec
>>    connect_to_server:PASS:connect_fd_to_fd 0 nsec
>>    test_bpf_nf_ct:PASS:connect_to_server 0 nsec
>>    test_bpf_nf_ct:PASS:accept 0 nsec
>>    test_bpf_nf_ct:PASS:sockaddr len 0 nsec
>>    test_bpf_nf_ct:PASS:bpf_prog_test_run 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for NULL bpf_tuple 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for reserved not set to 0 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for netns_id < -1 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ 0 nsec
>>    test_bpf_nf_ct:PASS:Test EPROTO for l4proto != TCP or UDP 0 nsec
>>    test_bpf_nf_ct:PASS:Test ENONET for bad but valid netns_id 0 nsec
>>    test_bpf_nf_ct:PASS:Test ENOENT for failed lookup 0 nsec
>>    test_bpf_nf_ct:PASS:Test EAFNOSUPPORT for invalid len__tuple 0 nsec
>>    test_bpf_nf_ct:PASS:Test for alloc new entry 0 nsec
>>    test_bpf_nf_ct:PASS:Test for insert new entry 0 nsec
>>    test_bpf_nf_ct:PASS:Test for successful lookup 0 nsec
>>    test_bpf_nf_ct:PASS:Test for min ct timeout update 0 nsec
>>    test_bpf_nf_ct:PASS:Test for max ct timeout update 0 nsec
>>    test_bpf_nf_ct:PASS:Test for ct status update  0 nsec
>>    test_bpf_nf_ct:PASS:Test existing connection lookup 0 nsec
>>    test_bpf_nf_ct:PASS:Test existing connection lookup ctmark 0 nsec
>>    test_bpf_nf_ct:FAIL:Test for source natting unexpected Test for source natting: actual -22 != expected 0
>>    test_bpf_nf_ct:FAIL:Test for destination natting unexpected Test for destination natting: actual -22 != expected 0
>>    #16/1    bpf_nf/xdp-ct:FAIL
>>    test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
>>    test_bpf_nf_ct:PASS:iptables 0 nsec
>>    test_bpf_nf_ct:PASS:start_server 0 nsec
>>    connect_to_server:PASS:socket 0 nsec
>>    connect_to_server:PASS:connect_fd_to_fd 0 nsec
>>    test_bpf_nf_ct:PASS:connect_to_server 0 nsec
>>    test_bpf_nf_ct:PASS:accept 0 nsec
>>    test_bpf_nf_ct:PASS:sockaddr len 0 nsec
>>    test_bpf_nf_ct:PASS:bpf_prog_test_run 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for NULL bpf_tuple 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for reserved not set to 0 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for netns_id < -1 0 nsec
>>    test_bpf_nf_ct:PASS:Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ 0 nsec
>>    test_bpf_nf_ct:PASS:Test EPROTO for l4proto != TCP or UDP 0 nsec
>>    test_bpf_nf_ct:PASS:Test ENONET for bad but valid netns_id 0 nsec
>>    test_bpf_nf_ct:PASS:Test ENOENT for failed lookup 0 nsec
>>    test_bpf_nf_ct:PASS:Test EAFNOSUPPORT for invalid len__tuple 0 nsec
>>    test_bpf_nf_ct:PASS:Test for alloc new entry 0 nsec
>>    test_bpf_nf_ct:PASS:Test for insert new entry 0 nsec
>>    test_bpf_nf_ct:PASS:Test for successful lookup 0 nsec
>>    test_bpf_nf_ct:PASS:Test for min ct timeout update 0 nsec
>>    test_bpf_nf_ct:PASS:Test for max ct timeout update 0 nsec
>>    test_bpf_nf_ct:PASS:Test for ct status update  0 nsec
>>    test_bpf_nf_ct:PASS:Test existing connection lookup 0 nsec
>>    test_bpf_nf_ct:PASS:Test existing connection lookup ctmark 0 nsec
>>    test_bpf_nf_ct:FAIL:Test for source natting unexpected Test for source natting: actual -22 != expected 0
>>    test_bpf_nf_ct:FAIL:Test for destination natting unexpected Test for destination natting: actual -22 != expected 0
>>    #16/2    bpf_nf/tc-bpf-ct:FAIL
>>    #16      bpf_nf:FAIL
>> [...]
>>

