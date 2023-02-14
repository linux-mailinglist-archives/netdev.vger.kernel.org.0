Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B389695EBC
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjBNJRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjBNJRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:17:23 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99C35120;
        Tue, 14 Feb 2023 01:16:15 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 049C21042;
        Tue, 14 Feb 2023 01:16:58 -0800 (PST)
Received: from [10.57.15.75] (unknown [10.57.15.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 933723F703;
        Tue, 14 Feb 2023 01:16:12 -0800 (PST)
Message-ID: <9d83e21c-01c8-9729-0e2b-54d405b6b1ee@arm.com>
Date:   Tue, 14 Feb 2023 09:16:07 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf-next] selftests/bpf: Cross-compile bpftool
Content-Language: en-US
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-riscv@lists.infradead.org,
        Quentin Monnet <quentin@isovalent.com>,
        linux-morello@op-lists.linaro.org
References: <20230210084326.1802597-1-bjorn@kernel.org>
 <87pmad63jb.fsf@all.your.base.are.belong.to.us>
From:   Zachary Leaf <zachary.leaf@arm.com>
In-Reply-To: <87pmad63jb.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/02/2023 14:30, Björn Töpel wrote:
> Björn Töpel <bjorn@kernel.org> writes:
> 
>> From: Björn Töpel <bjorn@rivosinc.com>
>>
>> When the BPF selftests are cross-compiled, only the a host version of
>> bpftool is built. This version of bpftool is used to generate various
>> intermediates, e.g., skeletons.
>>
>> The test runners are also using bpftool. The Makefile will symlink
>> bpftool from the selftest/bpf root, where the test runners will look
>> for the tool:
>>
>>   | ...
>>   | $(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
>>   |    $(OUTPUT)/$(if $2,$2/)bpftool
>>
>> There are two issues for cross-compilation builds:
>>
>>  1. There is no native (cross-compilation target) build of bpftool
>>  2. The bootstrap variant of bpftool is never cross-compiled (by
>>     design)
>>
>> Make sure that a native/cross-compiled version of bpftool is built,
>> and if CROSS_COMPILE is set, symlink to the native/non-bootstrap
>> version.
> 
> ...and the grand master plan is to add BPF CI support for riscv64, where
> this patch a prerequisite to [1]. I would suspect that other platforms
> might benefit from cross-compilation builds as well.

Similar use case. There also seems to be a lot of issues building these
tests out of tree.

I have some potential fixes up to 6.1 but linux-next seems to have
introduced a few more issues on top.

> 
> [1] https://github.com/kernel-patches/vmtest/pull/194
