Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AC913FC0
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 15:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfEEN3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 09:29:53 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38506 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfEEN3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 09:29:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id d13so11896946qth.5
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 06:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FVTuUgZ01YXadVlQNhQr7mpUWbZJ7nrRUcoMljAwu28=;
        b=tzLDfizmuuEN3EDvcf4XM9cDHdXUAph2dIe3y0AZVgDhm7k8YTzTOql13AmZkoNXKP
         AdCkfE28TAUSfc7fRLSsuFb3zmW6oEMhF4Dyq+V+iStvd+QmTT9k+wNARfJYuLEpOqnW
         axxDCHA6jsB8j5nxPE3uCbG2ICPQV6whjfJYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FVTuUgZ01YXadVlQNhQr7mpUWbZJ7nrRUcoMljAwu28=;
        b=dOF8lslp5KVsIvat8NiYEbxy4cKWVLsNTzvLQmTCaqOokZN1K8YTUsLvJ7OhG8/x75
         6EQ0+RzqK8eRWY5T3HH+gjTWriK55ZuVdgiZ/Dv7FOZLO0g7K2nEMZmz80OBkguBjIqW
         tSLCwW9IRbPCd+64jQCr5p38MQP0BIJvhexzxd6fPLpipfEh/IBNy0diZcQFmr3SmLiS
         fvZQi/WrGo8uTfiPAETnp+Jj9PNMoOSbddAgedQ3ufpzUmqwIS603iRjNbSXW2Z8lHBp
         /SSmor4uuQ12ehqy9HYTLtfheRWFz/J4G36NlHM0wbOSnUHa0R+yVO6LoWNABoc/yAhJ
         OnVA==
X-Gm-Message-State: APjAAAUFVbzdJb5IvyWrwFN+57o5kXjoIbOmaVI+6SEWWDTXFrqr8wST
        nEr8DfdkdiMyVVW7Jr5IGFrLSA==
X-Google-Smtp-Source: APXvYqxRHi3AtOdmdImJITLNqF3AOrukJ4LuJFrE1MGsQVdKmdye4qeaGuBt0En+CU5rxu8BpWFWPQ==
X-Received: by 2002:a05:6214:242:: with SMTP id k2mr17039582qvt.168.1557062992107;
        Sun, 05 May 2019 06:29:52 -0700 (PDT)
Received: from localhost (c-73-216-90-110.hsd1.va.comcast.net. [73.216.90.110])
        by smtp.gmail.com with ESMTPSA id k53sm4815370qtb.65.2019.05.05.06.29.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 06:29:51 -0700 (PDT)
Date:   Sun, 5 May 2019 13:29:49 +0000
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
Message-ID: <20190505132949.GB3076@localhost>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com>
 <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 12:04:24PM +0100, Qais Yousef wrote:
> On 05/03/19 09:49, Joel Fernandes wrote:
> > On Fri, May 03, 2019 at 01:12:34PM +0100, Qais Yousef wrote:
> > > Hi Joel
> > > 
> > > On 05/02/19 16:49, Joel Fernandes (Google) wrote:
> > > > The eBPF based opensnoop tool fails to read the file path string passed
> > > > to the do_sys_open function. This is because it is a pointer to
> > > > userspace address and causes an -EFAULT when read with
> > > > probe_kernel_read. This is not an issue when running the tool on x86 but
> > > > is an issue on arm64. This patch adds a new bpf function call based
> > > 
> > > I just did an experiment and if I use Android 4.9 kernel I indeed fail to see
> > > PATH info when running opensnoop. But if I run on 5.1-rc7 opensnoop behaves
> > > correctly on arm64.
> > > 
> > > My guess either a limitation that was fixed on later kernel versions or Android
> > > kernel has some strict option/modifications that make this fail?
> > 
> > Thanks a lot for checking, yes I was testing 4.9 kernel with this patch (pixel 3).
> > 
> > I am not sure what has changed since then, but I still think it is a good
> > idea to make the code more robust against such future issues anyway. In
> > particular, we learnt with extensive discussions that user/kernel pointers
> > are not necessarily distinguishable purely based on their address.
> 
> Yes I wasn't arguing against that. But the commit message is misleading or
> needs more explanation at least. I tried 4.9.y stable and arm64 worked on that
> too. Why do you think it's an arm64 problem?

Well it is broken on at least on at least one arm64 device and the patch I
sent fixes it. We know that the bpf is using wrong kernel API so why not fix
it? Are you saying we should not fix it like in this patch? Or do you have
another fix in mind?

thanks.


> 
> --
> Qais Yousef
