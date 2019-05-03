Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28B012F91
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 15:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfECNtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 09:49:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44750 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbfECNtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 09:49:39 -0400
Received: by mail-pl1-f196.google.com with SMTP id l2so2734425plt.11
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 06:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YbV5zA2MeNWo1HH53CUwXHZxLjGUUubpf5kENAQ1Fww=;
        b=H5yn1xC39sPwBsUQ5J0XTmkSV9bjL93S9mGPkFTB/vh0detwjvTV64fXThu4RUOqC0
         HhZAG5qZEtWdCBJJ50pexgIWqFvy7pyo1qlpyaSLNMvkf4gCRSX4BcpyVytSD/im5iZ1
         eCQk23OM+5y5ILdVE+GKyBh0UgOSqK60kQZh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YbV5zA2MeNWo1HH53CUwXHZxLjGUUubpf5kENAQ1Fww=;
        b=R7XB6Ey7szYLqgVfUb+yTT3NweFaPJHM2N0LW6YYK+fu3paxbj9IoJ21fw7VZuD4fy
         oofsf9Hoi2it3Y4YdQya1M6fYOiJRJ7tLWl4UBnfXKYkQkEjuGq/WRUdkSErHo7WgLKo
         VKmvXkMY20PU/5ZZyPj8MPwVLHC5C0d4X4Rw61Cu6MiVy91FACHBQMdJaPe9pQjapYjU
         oUqWHNsNlFDAeQDoBNQMAOv/5Svjpowhc7orVgDknQcT8+3pveBoX44m4vNQcLa6m8r4
         dkFFGDr4VEpoV1pwSJlh5tgqWMirOvmZCDjXdUp1pTYTVuyDYiAGUUwQgGmlqTbfHkK4
         2X+Q==
X-Gm-Message-State: APjAAAUb9aU+TgRsv2SuszVvVVFTLspthoNkoqEfIuDNx7lAf/LqNewG
        KXT/Fd60MULdSGL2GRnzf+/W5Q==
X-Google-Smtp-Source: APXvYqxQsBZWi9tsT/JvmLNRNM33IIB1VC3PH1gufecOj+UUiec8QQGJW1P3EWJqeqotfRxBUidUUA==
X-Received: by 2002:a17:902:784d:: with SMTP id e13mr10589818pln.152.1556891378169;
        Fri, 03 May 2019 06:49:38 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id z9sm2717911pga.92.2019.05.03.06.49.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 06:49:37 -0700 (PDT)
Date:   Fri, 3 May 2019 09:49:35 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Qais Yousef <qais.yousef@arm.com>
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
Message-ID: <20190503134935.GA253329@google.com>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 01:12:34PM +0100, Qais Yousef wrote:
> Hi Joel
> 
> On 05/02/19 16:49, Joel Fernandes (Google) wrote:
> > The eBPF based opensnoop tool fails to read the file path string passed
> > to the do_sys_open function. This is because it is a pointer to
> > userspace address and causes an -EFAULT when read with
> > probe_kernel_read. This is not an issue when running the tool on x86 but
> > is an issue on arm64. This patch adds a new bpf function call based
> 
> I just did an experiment and if I use Android 4.9 kernel I indeed fail to see
> PATH info when running opensnoop. But if I run on 5.1-rc7 opensnoop behaves
> correctly on arm64.
> 
> My guess either a limitation that was fixed on later kernel versions or Android
> kernel has some strict option/modifications that make this fail?

Thanks a lot for checking, yes I was testing 4.9 kernel with this patch (pixel 3).

I am not sure what has changed since then, but I still think it is a good
idea to make the code more robust against such future issues anyway. In
particular, we learnt with extensive discussions that user/kernel pointers
are not necessarily distinguishable purely based on their address.

I hope agree this is an issue we need to fix.

See these discussions:

https://lkml.kernel.org/r/20190220171019.5e81a4946b56982f324f7c45@kernel.org
https://lore.kernel.org/lkml/20190220171019.5e81a4946b56982f324f7c45@kernel.org/T/#mf81816dbfe25ac5d0e96fbab029050e892f73af2

thanks,

 - Joel

> root@buildroot:/# uname -a
> Linux buildroot 5.1.0-rc7-00164-ga00214620959-dirty #41 SMP PREEMPT Thu May 2 16:33:00 BST 2019 aarch64 GNU/Linux
> root@buildroot:/# opensnoop
> PID    COMM               FD ERR PATH
> 5180   default.script     -1   2 /etc/ld.so.cache
> 5180   default.script     -1   2 /lib/tls/v8l/neon/vfp/libresolv.so.2
> 5180   default.script     -1   2 /lib/tls/v8l/neon/libresolv.so.2
> 5180   default.script     -1   2 /lib/tls/v8l/vfp/libresolv.so.2
> 5180   default.script     -1   2 /lib/tls/v8l/libresolv.so.2
> 5180   default.script     -1   2 /lib/tls/neon/vfp/libresolv.so.2
> 5180   default.script     -1   2 /lib/tls/neon/libresolv.so.2
> 5180   default.script     -1   2 /lib/tls/vfp/libresolv.so.2
> 5180   default.script     -1   2 /lib/tls/libresolv.so.2
> 5180   default.script     -1   2 /lib/v8l/neon/vfp/libresolv.so.2
> 5180   default.script     -1   2 /lib/v8l/neon/libresolv.so.2
> 5180   default.script     -1   2 /lib/v8l/vfp/libresolv.so.2
> 5180   default.script     -1   2 /lib/v8l/libresolv.so.2
> 5180   default.script     -1   2 /lib/neon/vfp/libresolv.so.2
> 5180   default.script     -1   2 /lib/neon/libresolv.so.2
> 5180   default.script     -1   2 /lib/vfp/libresolv.so.2
> 5180   default.script      3   0 /lib/libresolv.so.2
> 5180   default.script      3   0 /lib/libc.so.6
> 5180   default.script      3   0 /usr/share/udhcpc/default.script
> 5180   default.script      3   0 /usr/share/udhcpc/default.script.d/
> 
> 
> 
> 
> --
> Qais Yousef
