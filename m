Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3D815651
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 01:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbfEFXai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 19:30:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:49720 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfEFXah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 19:30:37 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNmkx-0007So-C5; Tue, 07 May 2019 01:10:47 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNmkx-00061k-4J; Tue, 07 May 2019 01:10:47 +0200
Subject: Re: [PATCH v2 1/4] bpf: Add support for reading user pointers
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        duyuchao <yuchao.du@unisoc.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        bpf@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Song Liu <songliubraving@fb.com>
References: <20190506183116.33014-1-joel@joelfernandes.org>
 <3c6b312c-5763-0d9c-7c2c-436ee41f9be1@iogearbox.net>
 <20190506195711.GA48323@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7e0d07af-79ad-5ff3-74ce-c12b0b9b78cd@iogearbox.net>
Date:   Tue, 7 May 2019 01:10:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190506195711.GA48323@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06/2019 09:57 PM, Joel Fernandes wrote:
> On Mon, May 06, 2019 at 09:11:19PM +0200, Daniel Borkmann wrote:
>> On 05/06/2019 08:31 PM, Joel Fernandes (Google) wrote:
>>> The eBPF based opensnoop tool fails to read the file path string passed
>>> to the do_sys_open function. This is because it is a pointer to
>>> userspace address and causes an -EFAULT when read with
>>> probe_kernel_read. This is not an issue when running the tool on x86 but
>>> is an issue on arm64. This patch adds a new bpf function call based
>>> which calls the recently proposed probe_user_read function [1].
>>> Using this function call from opensnoop fixes the issue on arm64.
>>>
>>> [1] https://lore.kernel.org/patchwork/patch/1051588/
>>>
>>> Cc: Michal Gregorczyk <michalgr@live.com>
>>> Cc: Adrian Ratiu <adrian.ratiu@collabora.com>
>>> Cc: Mohammad Husain <russoue@gmail.com>
>>> Cc: Qais Yousef <qais.yousef@arm.com>
>>> Cc: Srinivas Ramana <sramana@codeaurora.org>
>>> Cc: duyuchao <yuchao.du@unisoc.com>
>>> Cc: Manjo Raja Rao <linux@manojrajarao.com>
>>> Cc: Karim Yaghmour <karim.yaghmour@opersys.com>
>>> Cc: Tamir Carmeli <carmeli.tamir@gmail.com>
>>> Cc: Yonghong Song <yhs@fb.com>
>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>> Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
>>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>>> Cc: Peter Ziljstra <peterz@infradead.org>
>>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>> Cc: Steven Rostedt <rostedt@goodmis.org>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: kernel-team@android.com
>>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>>> ---
>>> Masami, could you carry these patches in the series where are you add
>>> probe_user_read function?
>>>
>>> Previous submissions is here:
>>> https://lore.kernel.org/patchwork/patch/1069552/
>>> v1->v2: split tools uapi sync into separate commit, added deprecation
>>> warning for old bpf_probe_read function.
>>
>> Please properly submit this series to bpf tree once the base
>> infrastructure from Masami is upstream.
> 
> Could you clarify what do you mean by "properly submit this series to bpf
> tree" mean? bpf@vger.kernel.org is CC'd.

Yeah, send the BPF series to bpf@vger.kernel.org once Masami's patches have
hit mainline, and we'll then route yours as fixes the usual path through
bpf tree.

>> This series here should
>> also fix up all current probe read usage under samples/bpf/ and
>> tools/testing/selftests/bpf/.
> 
> Ok. Agreed, will do that.

Great, thanks!
Daniel
