Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC95140DB
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfEEPw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:52:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37165 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfEEPw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:52:27 -0400
Received: by mail-qt1-f193.google.com with SMTP id o7so138217qtp.4
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ekhL+urX0SV3pO/WanUIad49ZFzCKRVsusysCBLgkOE=;
        b=xWWosPQHmUFheOe1Au0aHAuk81jiD4yI3tFMkCufMgZkpHgtxb9cCqBttPlxKzRAHV
         CrEPqOxXsAQiyW13TTg5vOY8UoMtKpL6DcTZe4PbEAXOnj8q+ze8NZrrvD041oNuuk4H
         iw8RMna6hLhRus1sL/wdsLDLpFCZQ/CWWSRm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ekhL+urX0SV3pO/WanUIad49ZFzCKRVsusysCBLgkOE=;
        b=IbImR5+H3SH5GIjxTH84ykDDh+khsJhLkvSAM41CFfwD+3QXH4plKFixLcriHsk9+C
         s3SFHrZ0+dj7lgIF9gAvVusSeE0/imQhHhi8Gaoji33aquoaKx1X1EV3WZ3SOxhaE7Jm
         +ogH0aFGUo6tG9YLA55380WdY5FtnxBU9nxULDD7Ih2bkw7FhExaZxD6+q81m1wFq6ry
         u+sN7vI87Bz/mfYZbZiWUD+371j1rZoK2YK2OpVBwHOU70KXNGl7VzCA37CWiOvhbysN
         aRkXn3/dJwukHnvKGe0rZbxJsYysQQInixt0j58rZ1AOvE7LM5Of/JVooyCRH3CvrnjD
         vm2A==
X-Gm-Message-State: APjAAAUrU+6u/ZOMqR0khTOJYLGkfTQS0agQ2jbbwn9GbClCyNf4OIHp
        Mer2PvRZB+OM6DJPC8SFpWwOdA==
X-Google-Smtp-Source: APXvYqxdnS53Vsd6DpWFcZxDUYJu/q/j2nWSZ9Nnur37CeMi31rblPWvkG2lQoVA6LDxw23Tzx8FZg==
X-Received: by 2002:a0c:8b6f:: with SMTP id d47mr17288737qvc.135.1557071546090;
        Sun, 05 May 2019 08:52:26 -0700 (PDT)
Received: from localhost ([2600:1003:b451:8ec8:55bc:61ad:9aa2:244e])
        by smtp.gmail.com with ESMTPSA id v141sm5000241qka.35.2019.05.05.08.52.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 08:52:25 -0700 (PDT)
Date:   Sun, 5 May 2019 15:52:23 +0000
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
Message-ID: <20190505155223.GA4976@localhost>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com>
 <20190505110423.u7g3f2viovvgzbtn@e107158-lin.cambridge.arm.com>
 <20190505132949.GB3076@localhost>
 <20190505144608.u3vsxyz5huveuskx@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505144608.u3vsxyz5huveuskx@e107158-lin.cambridge.arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 03:46:08PM +0100, Qais Yousef wrote:
> On 05/05/19 13:29, Joel Fernandes wrote:
> > On Sun, May 05, 2019 at 12:04:24PM +0100, Qais Yousef wrote:
> > > On 05/03/19 09:49, Joel Fernandes wrote:
> > > > On Fri, May 03, 2019 at 01:12:34PM +0100, Qais Yousef wrote:
> > > > > Hi Joel
> > > > > 
> > > > > On 05/02/19 16:49, Joel Fernandes (Google) wrote:
> > > > > > The eBPF based opensnoop tool fails to read the file path string passed
> > > > > > to the do_sys_open function. This is because it is a pointer to
> > > > > > userspace address and causes an -EFAULT when read with
> > > > > > probe_kernel_read. This is not an issue when running the tool on x86 but
> > > > > > is an issue on arm64. This patch adds a new bpf function call based
> > > > > 
> > > > > I just did an experiment and if I use Android 4.9 kernel I indeed fail to see
> > > > > PATH info when running opensnoop. But if I run on 5.1-rc7 opensnoop behaves
> > > > > correctly on arm64.
> > > > > 
> > > > > My guess either a limitation that was fixed on later kernel versions or Android
> > > > > kernel has some strict option/modifications that make this fail?
> > > > 
> > > > Thanks a lot for checking, yes I was testing 4.9 kernel with this patch (pixel 3).
> > > > 
> > > > I am not sure what has changed since then, but I still think it is a good
> > > > idea to make the code more robust against such future issues anyway. In
> > > > particular, we learnt with extensive discussions that user/kernel pointers
> > > > are not necessarily distinguishable purely based on their address.
> > > 
> > > Yes I wasn't arguing against that. But the commit message is misleading or
> > > needs more explanation at least. I tried 4.9.y stable and arm64 worked on that
> > > too. Why do you think it's an arm64 problem?
> > 
> > Well it is broken on at least on at least one arm64 device and the patch I
> > sent fixes it. We know that the bpf is using wrong kernel API so why not fix
> > it? Are you saying we should not fix it like in this patch? Or do you have
> > another fix in mind?
> 
> Again I have no issue with the new API. But the claim that it's a fix for
> a broken arm64 is a big stretch. AFAICT you don't understand the root cause of
> why copy_to_user_inatomic() fails in your case. Given that Android 4.9 has
> its own patches on top of 4.9 stable, it might be something that was introduced
> in one of these patches that breaks opensnoop, and by making it use the new API
> you might be simply working around the problem. All I can see is that vanilla
> 4.9 stable works on arm64.

Agreed that commit message could be improved. I believe issue is something to
do with differences in 4.9 PAN emulation backports. AIUI PAN was introduced
in upstream only in 4.10 so 4.9 needed backports.

I did not root cause this completely because "doing the right thing" fixed
the issue. I will look more closely once I am home.

Thank you.




> So I am happy about introducing the new API but not happy with the commit
> message or the explanation given in it. Unless you can investigate the root
> cause and relate how this fixes it (and not workaround a problem you're
> specifically having) I think it's better to introduce this patch as a generic
> new API that is more robust to handle reading __user data in BPF and drop
> reference to opensnoop failures. They raise more questions and the real
> intention of this patch anyway is to provide the new correct way for BPF
> programs to read __user data regardless opensnoop fails or not AFAIU.
> 
> Cheers
> 
> --
> Qais Yousef
