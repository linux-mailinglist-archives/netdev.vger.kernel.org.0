Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D329A52F67A
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354166AbiEUACC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345609AbiEUACB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:02:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FB55DE49;
        Fri, 20 May 2022 17:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653091320; x=1684627320;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=AWk5EzpwQakMCN7K4ikJj1LOGHAGUToZe4PbLyD2PRk=;
  b=bXc++wjzFb72gG0CPsprV/4WzqOKl9dPflakFJbabcHeZ8M24G4wVvZs
   MZVaKgFiuwpzUJIBOd/nLi8vETw4l86+acwJE58g+/vucQIKZKVIahuBE
   4f2qjrodNC2AmkMP5qHtTAu7wb06aTc+9T6EPC9/dEVNdA5IaMdCoaWU8
   wyQdvwTJcgeoWEaTB96AfyjmyUg+2HS02guybrqxDB1GYF8IGeZyJ2MTe
   u1iDit9Gl211pDT+oITdiZRrh3E/XzLaeFMwCrCLDuZjRbqDbUxVhPxL9
   sis1t/c7pVUEbqBX8JpEcTs07fV708UBTqK4EyoAwmiSfAFbYBIR+b5oK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="272749357"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="272749357"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 17:02:00 -0700
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="524882953"
Received: from ofirfata-mobl1.amr.corp.intel.com ([10.209.118.159])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 17:02:00 -0700
Date:   Fri, 20 May 2022 17:01:53 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
Subject: Re: [PATCH bpf-next v5 0/7] bpf: mptcp: Support for mptcp_sock
In-Reply-To: <CAEf4BzaZ07_VRN_z6xPogcx-YQuPQR8FCkC=K621r5oo1vBViQ@mail.gmail.com>
Message-ID: <1043967d-395f-aa6-680-9ab7eec780d3@linux.intel.com>
References: <20220519233016.105670-1-mathew.j.martineau@linux.intel.com> <CAEf4BzaZ07_VRN_z6xPogcx-YQuPQR8FCkC=K621r5oo1vBViQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022, Andrii Nakryiko wrote:

> On Thu, May 19, 2022 at 4:30 PM Mat Martineau
> <mathew.j.martineau@linux.intel.com> wrote:
>>
>> This patch set adds BPF access to mptcp_sock structures, along with
>> associated self tests. You may recognize some of the code from earlier
>> (https://lore.kernel.org/bpf/20200918121046.190240-6-nicolas.rybowski@tessares.net/)
>> but it has been reworked quite a bit.
>>
>>
>> v1 -> v2: Emit BTF type, add func_id checks in verifier.c and bpf_trace.c,
>> remove build check for CONFIG_BPF_JIT, add selftest check for CONFIG_MPTCP,
>> and add a patch to include CONFIG_IKCONFIG/CONFIG_IKCONFIG_PROC for the
>> BPF self tests.
>>
>> v2 -> v3: Access sysctl through the filesystem to work around CI use of
>> the more limited busybox sysctl command.
>>
>> v3 -> v4: Dropped special case kernel code for tcp_sock is_mptcp, use
>> existing bpf_tcp_helpers.h, and add check for 'ip mptcp monitor' support.
>>
>> v4 -> v5: Use BPF test skeleton, more consistent use of ASSERT macros,
>> drop some unnecessary parameters / checks, and use tracing to acquire
>> MPTCP token.
>>
>> Geliang Tang (6):
>>   bpf: add bpf_skc_to_mptcp_sock_proto
>>   selftests/bpf: Enable CONFIG_IKCONFIG_PROC in config
>>   selftests/bpf: test bpf_skc_to_mptcp_sock
>>   selftests/bpf: verify token of struct mptcp_sock
>>   selftests/bpf: verify ca_name of struct mptcp_sock
>>   selftests/bpf: verify first of struct mptcp_sock
>>
>> Nicolas Rybowski (1):
>>   selftests/bpf: add MPTCP test base
>>
>>  MAINTAINERS                                   |   1 +
>>  include/linux/bpf.h                           |   1 +
>>  include/linux/btf_ids.h                       |   3 +-
>>  include/net/mptcp.h                           |   6 +
>>  include/uapi/linux/bpf.h                      |   7 +
>>  kernel/bpf/verifier.c                         |   1 +
>>  kernel/trace/bpf_trace.c                      |   2 +
>>  net/core/filter.c                             |  18 ++
>>  net/mptcp/Makefile                            |   2 +
>>  net/mptcp/bpf.c                               |  21 +++
>>  scripts/bpf_doc.py                            |   2 +
>>  tools/include/uapi/linux/bpf.h                |   7 +
>>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |  13 ++
>>  tools/testing/selftests/bpf/config            |   3 +
>>  tools/testing/selftests/bpf/network_helpers.c |  40 +++-
>>  tools/testing/selftests/bpf/network_helpers.h |   2 +
>>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 174 ++++++++++++++++++
>>  .../testing/selftests/bpf/progs/mptcp_sock.c  |  89 +++++++++
>>  18 files changed, 382 insertions(+), 10 deletions(-)
>>  create mode 100644 net/mptcp/bpf.c
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
>>  create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
>>
>>
>> base-commit: 834650b50ed283d9d34a32b425d668256bf2e487
>> --
>> 2.36.1
>>
>
> I've added missing static for test_base and some other helper and
> replaced bzero and memcpy in BPF-side code with __builtin_memset and
> __builtin_memcpy (and dropped string.h include, it's not supposed to
> be used from BPF-side code). Applied to bpf-next, thanks.
>

Thanks for the fixups.

--
Mat Martineau
Intel
