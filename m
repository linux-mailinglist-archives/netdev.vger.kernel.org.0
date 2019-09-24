Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E229CBD0A3
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 19:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439510AbfIXR3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 13:29:40 -0400
Received: from foss.arm.com ([217.140.110.172]:34874 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729883AbfIXR3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 13:29:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A30F142F;
        Tue, 24 Sep 2019 10:29:39 -0700 (PDT)
Received: from [10.1.197.50] (e120937-lin.cambridge.arm.com [10.1.197.50])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FF443F694;
        Tue, 24 Sep 2019 10:29:38 -0700 (PDT)
Subject: Re: Linux 5.4 - bpf test build fails
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <742ecabe-45ce-cf6e-2540-25d6dc23c45f@linuxfoundation.org>
 <1d1bbc01-5cf4-72e6-76b3-754d23366c8f@arm.com>
 <34a9bd63-a251-0b4f-73b6-06b9bbf9d3fa@linuxfoundation.org>
 <a603ee8e-b0af-6506-0667-77269b0951b2@linuxfoundation.org>
From:   Cristian Marussi <cristian.marussi@arm.com>
Message-ID: <c3dda8d0-1794-ffd1-4d76-690ac2be8b8f@arm.com>
Date:   Tue, 24 Sep 2019 18:29:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a603ee8e-b0af-6506-0667-77269b0951b2@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shuah

On 24/09/2019 17:39, Shuah Khan wrote:
> On 9/24/19 10:03 AM, Shuah Khan wrote:
>> On 9/24/19 9:52 AM, Cristian Marussi wrote:
>>> Hi Shuah
>>>
>>> On 24/09/2019 16:26, Shuah Khan wrote:
>>>> Hi Alexei and Daniel,
>>>>
>>>> bpf test doesn't build on Linux 5.4 mainline. Do you know what's
>>>> happening here.
>>>>
>>>>
>>>> make -C tools/testing/selftests/bpf/
>>>
>>> side question, since I'm writing arm64/ tests.
>>>
>>> my "build-testcases" following the KSFT docs are:
>>>
>>> make kselftest
>>> make TARGETS=arm64 kselftest
>>> make -C tools/testing/selftests/
>>> make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
>>> make TARGETS=arm64 -C tools/testing/selftests/
>>> make TARGETS=arm64 -C tools/testing/selftests/ 
>>> INSTALL_PATH=<install-path> install
>>> ./kselftest_install.sh <install-path>
> 
> Cristian,
> 
> That being said, I definitely want to see this list limited to
> a few options.
> 
> One problem is that if somebody wants to do just a build, there
> is no option from the main makefile. I have sent support for that
> a few months ago and the patch didn't got lost it appears. I am
> working on resending those patches. The same is true for install.
> I sent in a patch for that a while back and I am going to resend.
> These will make it easier for users.
> 
> I would really want to get to supporting only these options:
> 
> These are supported now:
> 
> make kselftest
> make TARGETS=arm64 kselftest (one or more targets)
> 
> Replace the following:
> 
> make -C tools/testing/selftests/ with
> 
> make kselftes_build option from main makefile
> 
> Replace this:
> make -C tools/testing/selftests/ INSTALL_PATH=<install-path> install
> 
> with
> make kselftest_install

Yes these top level options would be absolutely useful to avoid multiplication
of build targets to support and test.

Moreover, currently, since there was a lot of test growing into arm64/
inside subdirs like arm64/signal, I support (still under review in fact) in the arm64/
toplevel makefile the possibility of building/installing by subdirs only, in order
to be able to limit what you want to build/install of a TARGET (resulting in quicker devel),
issuing something like:

make TARGETS=arm64 SUBTARGETS=signal -C tools/testing/selftests/

if possible, that would be useful if kept functional even in the
new schema. I mean being able to still issue:

make TARGETS=arm64 SUBTARGETS=signal kselftes_build 

with the SUBTARGETS= or whatever ENV var handling delegated to the lower level
makefiles (so not handled by the toplevel, but just let go through)

Cheers

Cristian

> 
> That way we can support all the use-cases from the main Makefile
> 
> thanks,
> -- Shuah
> 
> 

