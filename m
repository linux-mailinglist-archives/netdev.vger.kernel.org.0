Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FC3170635
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgBZRhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:37:05 -0500
Received: from www62.your-server.de ([213.133.104.62]:42022 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgBZRhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:37:05 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j70c8-0002db-0I; Wed, 26 Feb 2020 18:36:52 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j70c7-000Is6-Fc; Wed, 26 Feb 2020 18:36:51 +0100
Subject: Re: [PATCH bpf-next v4 0/5] Make probes which emit dmesg warnings
 optional
To:     Quentin Monnet <quentin@isovalent.com>,
        Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
References: <20200226165941.6379-1-mrostecki@opensuse.org>
 <e4777396-dbf0-855d-beaf-ba7fd533a4fb@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <03558a25-d07c-d4df-6840-4a171f18d893@iogearbox.net>
Date:   Wed, 26 Feb 2020 18:36:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e4777396-dbf0-855d-beaf-ba7fd533a4fb@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 6:22 PM, Quentin Monnet wrote:
> 2020-02-26 17:59 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
>> Feature probes in bpftool related to bpf_probe_write_user and
>> bpf_trace_printk helpers emit dmesg warnings which might be confusing
>> for people running bpftool on production environments. This patch series
>> addresses that by filtering them out by default and introducing the new
>> positional argument "full" which enables all available probes.
>>
>> The main motivation behind those changes is ability the fact that some
>> probes (for example those related to "trace" or "write_user" helpers)
>> emit dmesg messages which might be confusing for people who are running
>> on production environments. For details see the Cilium issue[0].
>>
>> v1 -> v2:
>> - Do not expose regex filters to users, keep filtering logic internal,
>> expose only the "full" option for including probes which emit dmesg
>> warnings.
>>
>> v2 -> v3:
>> - Do not use regex for filtering out probes, use function IDs directly.
>> - Fix bash completion - in v2 only "prefix" was proposed after "macros",
>>    "dev" and "kernel" were not.
>> - Rephrase the man page paragraph, highlight helper function names.
>> - Remove tests which parse the plain output of bpftool (except the
>>    header/macros test), focus on testing JSON output instead.
>> - Add test which compares the output with and without "full" option.
>>
>> v3 -> v4:
>> - Use enum to check for helper functions.
>> - Make selftests compatible with older versions of Python 3.x than 3.7.
>>
>> [0] https://github.com/cilium/cilium/issues/10048
>>
>> Michal Rostecki (5):
>>    bpftool: Move out sections to separate functions
>>    bpftool: Make probes which emit dmesg warnings optional
>>    bpftool: Update documentation of "bpftool feature" command
>>    bpftool: Update bash completion for "bpftool feature" command
>>    selftests/bpf: Add test for "bpftool feature" command
>>
>>   .../bpftool/Documentation/bpftool-feature.rst |  19 +-
>>   tools/bpf/bpftool/bash-completion/bpftool     |   3 +-
>>   tools/bpf/bpftool/feature.c                   | 283 +++++++++++-------
>>   tools/testing/selftests/.gitignore            |   5 +-
>>   tools/testing/selftests/bpf/Makefile          |   3 +-
>>   tools/testing/selftests/bpf/test_bpftool.py   | 178 +++++++++++
>>   tools/testing/selftests/bpf/test_bpftool.sh   |   5 +
>>   7 files changed, 373 insertions(+), 123 deletions(-)
>>   create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
>>   create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh
>>
> 
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
> (Please keep tags between versions.)
> 
> Your change looks good. The tests in patch 5 still pass with Python 3.7.5 (but I have not tried to run with an older version of Python).

Looks better now ...

# ./test_bpftool.sh
test_feature_dev_json (test_bpftool.TestBpftool) ... ok
test_feature_kernel (test_bpftool.TestBpftool) ... ok
test_feature_kernel_full (test_bpftool.TestBpftool) ... ok
test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool) ... ok
test_feature_macros (test_bpftool.TestBpftool) ... ok

----------------------------------------------------------------------
Ran 5 tests in 0.253s

OK

... applied, thanks!
