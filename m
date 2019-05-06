Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3D4154BE
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 21:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfEFT5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 15:57:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33834 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfEFT5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 15:57:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id b3so7334534pfd.1
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 12:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CLvXgkmEF2HuuDRz+thRTXD1OtlI2uKzA2+jsYBonhs=;
        b=S6iea+gwnFA7+UtQ38F/1k2BteEzmNzXl+aCRycK15pGhNFpdyCe6rhOEQHexmbGnQ
         e2CB8RFbWcPDfBoW2UNpy6UNA1V6tEYjkD1QsWLAowhee9HO2z/IKHMNWHNqjuT8lG2x
         O75FFPOK/kakEUTjZK1qAzPGXtVUQXnbi1kU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CLvXgkmEF2HuuDRz+thRTXD1OtlI2uKzA2+jsYBonhs=;
        b=og9wAo8Zl8TNPYpdKU4RHe0VEMBtxAzcbNdecKgLObK/GRfzqqysWEcQRoBySa+hF2
         4If1fGKEv7Um1QeAvn2wnqX3026sf4C2y+clAyrLep6Z9gLZX44JZ6dpPPZXBgWGYSkV
         tH8do1+jVRobA8nw2URn48/C0vYRoyu2G4iOkomlWvExZfWj1sghoRtzzSoSt4X5H8nj
         2kN5XzRE+g1rIJAUXb2CJPG6S4Sq1CC6u8U1Ox/wqJXyq2H8J167HLadgJEeOQlQy+Z0
         YDF4qbgrC3+EY55224Dg+p4VWCpcbCL2vxDq7awDBc34ACSjlJmzqiCDJcufNxQP2SH9
         vTPg==
X-Gm-Message-State: APjAAAUppeKEy+Jjzh1xzn8GvEyAEOD18TTR+SB4a5H5KPdeHHXY+7DS
        0e/toXVnTHvYn4igeTIWdlnlHA==
X-Google-Smtp-Source: APXvYqynLDYXDnI9TexIDiiHv8fM/e64HKHfby9Od5eT6nRpjknFGCFcb8PzLIcX0Va+gYVKgmJsnA==
X-Received: by 2002:aa7:8b8b:: with SMTP id r11mr35947156pfd.130.1557172633764;
        Mon, 06 May 2019 12:57:13 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id 128sm13713965pgb.47.2019.05.06.12.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 12:57:12 -0700 (PDT)
Date:   Mon, 6 May 2019 15:57:11 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
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
Subject: Re: [PATCH v2 1/4] bpf: Add support for reading user pointers
Message-ID: <20190506195711.GA48323@google.com>
References: <20190506183116.33014-1-joel@joelfernandes.org>
 <3c6b312c-5763-0d9c-7c2c-436ee41f9be1@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c6b312c-5763-0d9c-7c2c-436ee41f9be1@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 09:11:19PM +0200, Daniel Borkmann wrote:
> On 05/06/2019 08:31 PM, Joel Fernandes (Google) wrote:
> > The eBPF based opensnoop tool fails to read the file path string passed
> > to the do_sys_open function. This is because it is a pointer to
> > userspace address and causes an -EFAULT when read with
> > probe_kernel_read. This is not an issue when running the tool on x86 but
> > is an issue on arm64. This patch adds a new bpf function call based
> > which calls the recently proposed probe_user_read function [1].
> > Using this function call from opensnoop fixes the issue on arm64.
> > 
> > [1] https://lore.kernel.org/patchwork/patch/1051588/
> > 
> > Cc: Michal Gregorczyk <michalgr@live.com>
> > Cc: Adrian Ratiu <adrian.ratiu@collabora.com>
> > Cc: Mohammad Husain <russoue@gmail.com>
> > Cc: Qais Yousef <qais.yousef@arm.com>
> > Cc: Srinivas Ramana <sramana@codeaurora.org>
> > Cc: duyuchao <yuchao.du@unisoc.com>
> > Cc: Manjo Raja Rao <linux@manojrajarao.com>
> > Cc: Karim Yaghmour <karim.yaghmour@opersys.com>
> > Cc: Tamir Carmeli <carmeli.tamir@gmail.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
> > Cc: Masami Hiramatsu <mhiramat@kernel.org>
> > Cc: Peter Ziljstra <peterz@infradead.org>
> > Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: kernel-team@android.com
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> > Masami, could you carry these patches in the series where are you add
> > probe_user_read function?
> > 
> > Previous submissions is here:
> > https://lore.kernel.org/patchwork/patch/1069552/
> > v1->v2: split tools uapi sync into separate commit, added deprecation
> > warning for old bpf_probe_read function.
> 
> Please properly submit this series to bpf tree once the base
> infrastructure from Masami is upstream.

Could you clarify what do you mean by "properly submit this series to bpf
tree" mean? bpf@vger.kernel.org is CC'd.

> This series here should
> also fix up all current probe read usage under samples/bpf/ and
> tools/testing/selftests/bpf/.

Ok. Agreed, will do that.

thanks,

- Joel

