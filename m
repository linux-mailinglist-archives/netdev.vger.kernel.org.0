Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58E612D45
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfECMMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:12:44 -0400
Received: from foss.arm.com ([217.140.101.70]:59566 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfECMMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 08:12:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55BFA374;
        Fri,  3 May 2019 05:12:41 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.194.71])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C486C3F220;
        Fri,  3 May 2019 05:12:37 -0700 (PDT)
Date:   Fri, 3 May 2019 13:12:34 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Michal Gregorczyk <michalgr@live.com>,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Mohammad Husain <russoue@gmail.com>,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-ID: <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
References: <20190502204958.7868-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190502204958.7868-1-joel@joelfernandes.org>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joel

On 05/02/19 16:49, Joel Fernandes (Google) wrote:
> The eBPF based opensnoop tool fails to read the file path string passed
> to the do_sys_open function. This is because it is a pointer to
> userspace address and causes an -EFAULT when read with
> probe_kernel_read. This is not an issue when running the tool on x86 but
> is an issue on arm64. This patch adds a new bpf function call based

I just did an experiment and if I use Android 4.9 kernel I indeed fail to see
PATH info when running opensnoop. But if I run on 5.1-rc7 opensnoop behaves
correctly on arm64.

My guess either a limitation that was fixed on later kernel versions or Android
kernel has some strict option/modifications that make this fail?




root@buildroot:/# uname -a
Linux buildroot 5.1.0-rc7-00164-ga00214620959-dirty #41 SMP PREEMPT Thu May 2 16:33:00 BST 2019 aarch64 GNU/Linux
root@buildroot:/# opensnoop
PID    COMM               FD ERR PATH
5180   default.script     -1   2 /etc/ld.so.cache
5180   default.script     -1   2 /lib/tls/v8l/neon/vfp/libresolv.so.2
5180   default.script     -1   2 /lib/tls/v8l/neon/libresolv.so.2
5180   default.script     -1   2 /lib/tls/v8l/vfp/libresolv.so.2
5180   default.script     -1   2 /lib/tls/v8l/libresolv.so.2
5180   default.script     -1   2 /lib/tls/neon/vfp/libresolv.so.2
5180   default.script     -1   2 /lib/tls/neon/libresolv.so.2
5180   default.script     -1   2 /lib/tls/vfp/libresolv.so.2
5180   default.script     -1   2 /lib/tls/libresolv.so.2
5180   default.script     -1   2 /lib/v8l/neon/vfp/libresolv.so.2
5180   default.script     -1   2 /lib/v8l/neon/libresolv.so.2
5180   default.script     -1   2 /lib/v8l/vfp/libresolv.so.2
5180   default.script     -1   2 /lib/v8l/libresolv.so.2
5180   default.script     -1   2 /lib/neon/vfp/libresolv.so.2
5180   default.script     -1   2 /lib/neon/libresolv.so.2
5180   default.script     -1   2 /lib/vfp/libresolv.so.2
5180   default.script      3   0 /lib/libresolv.so.2
5180   default.script      3   0 /lib/libc.so.6
5180   default.script      3   0 /usr/share/udhcpc/default.script
5180   default.script      3   0 /usr/share/udhcpc/default.script.d/




--
Qais Yousef
