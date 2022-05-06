Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BA451E267
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378730AbiEFXJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 19:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355923AbiEFXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 19:09:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1338C49F11;
        Fri,  6 May 2022 16:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651878370; x=1683414370;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=6xCto8HgjqyOAqSSXJ7ouSaD06rWT4pfATBVmW3c+gM=;
  b=bfLHp74PG/Z0KFbkPKhRmVGhvV6xxwE6DhRGskUVqjpf/l0MlcoXDgpl
   gDD8sXPe78Kt98WZzDu81DokgF6OLzwrwew4zD/0BWJkWyJKJ1PpxZavz
   S3/SWeGnX/GKaMblZES3D4A+5ddao1KseWP+Z1pbx5yLcq0Iyub1hq5TH
   kWDrOvjiqUfZyPSElD6M4WqV4yaBIMO+xI75EnWSTFNurqxoQUsyJdWYR
   bm7501wCqd+hQozVZhvDdlQ++ORQ64/FtuQGrsKS/fCgxGE9LybFb8367
   tkXFNxf+AE+KN3XrXtbvu6na5mhBPN8Ug+HYoJ+rnEPM11VYmPxYucWzR
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="355033395"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="355033395"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 16:06:09 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="569290890"
Received: from jrbond-mobl1.amr.corp.intel.com ([10.212.218.216])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 16:06:09 -0700
Date:   Fri, 6 May 2022 16:06:09 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, mptcp@lists.linux.dev
Subject: Re: [PATCH bpf-next v3 0/8] bpf: mptcp: Support for mptcp_sock and
 is_mptcp
In-Reply-To: <CAEf4BzY3wtCJa5O-k6e1qmJvu5-WBuq5p6=oBJWdCC5tj17LyA@mail.gmail.com>
Message-ID: <90f2f50-493e-8949-ea96-9fb6df9b263@linux.intel.com>
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com> <CAEf4BzY3wtCJa5O-k6e1qmJvu5-WBuq5p6=oBJWdCC5tj17LyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 May 2022, Andrii Nakryiko wrote:

> On Mon, May 2, 2022 at 2:12 PM Mat Martineau
> <mathew.j.martineau@linux.intel.com> wrote:
>>
>> This patch set adds BPF access to the is_mptcp flag in tcp_sock and
>> access to mptcp_sock structures, along with associated self tests. You
>> may recognize some of the code from earlier
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
>>
>> Geliang Tang (6):
>>   bpf: add bpf_skc_to_mptcp_sock_proto
>>   selftests: bpf: Enable CONFIG_IKCONFIG_PROC in config
>>   selftests: bpf: test bpf_skc_to_mptcp_sock
>>   selftests: bpf: verify token of struct mptcp_sock
>>   selftests: bpf: verify ca_name of struct mptcp_sock
>>   selftests: bpf: verify first of struct mptcp_sock
>>
>
> It would be nice to use more consistent with the majority of other
> commits "selftests/bpf: " prefix. Thank you.

Sure, we'll update those prefixes and address your comments in the 
individual patches. Thanks for the review.

- Mat

>
>> Nicolas Rybowski (2):
>>   bpf: expose is_mptcp flag to bpf_tcp_sock
>>   selftests: bpf: add MPTCP test base
>>
>>  MAINTAINERS                                   |   2 +
>>  include/linux/bpf.h                           |   1 +
>>  include/linux/btf_ids.h                       |   3 +-
>>  include/net/mptcp.h                           |   6 +
>>  include/uapi/linux/bpf.h                      |   8 +
>>  kernel/bpf/verifier.c                         |   1 +
>>  kernel/trace/bpf_trace.c                      |   2 +
>>  net/core/filter.c                             |  27 +-
>>  net/mptcp/Makefile                            |   2 +
>>  net/mptcp/bpf.c                               |  22 ++
>>  scripts/bpf_doc.py                            |   2 +
>>  tools/include/uapi/linux/bpf.h                |   8 +
>>  .../testing/selftests/bpf/bpf_mptcp_helpers.h |  17 ++
>>  tools/testing/selftests/bpf/bpf_tcp_helpers.h |   4 +
>>  tools/testing/selftests/bpf/config            |   3 +
>>  tools/testing/selftests/bpf/network_helpers.c |  43 ++-
>>  tools/testing/selftests/bpf/network_helpers.h |   4 +
>>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 272 ++++++++++++++++++
>>  .../testing/selftests/bpf/progs/mptcp_sock.c  |  80 ++++++
>>  19 files changed, 497 insertions(+), 10 deletions(-)
>>  create mode 100644 net/mptcp/bpf.c
>>  create mode 100644 tools/testing/selftests/bpf/bpf_mptcp_helpers.h
>>  create mode 100644 tools/testing/selftests/bpf/prog_tests/mptcp.c
>>  create mode 100644 tools/testing/selftests/bpf/progs/mptcp_sock.c
>>
>>
>> base-commit: 20b87e7c29dffcfa3f96f2e99daec84fd46cabdb
>> --
>> 2.36.0
>>
>

--
Mat Martineau
Intel
