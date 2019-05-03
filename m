Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E99130EA
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbfECPJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:09:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40602 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfECPJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:09:28 -0400
Received: by mail-pg1-f194.google.com with SMTP id d31so2859643pgl.7
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 08:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hp/Tj1QYz56VfTMd1RiR2FT6yvDdqYC2zjWo8LyAtkA=;
        b=XVMEwTvgSW0fLQs1WlzPcg8PmDBpqQLEQk+l6MRhlmpMcbdm4grgueXWpP8gUgJHwa
         5UcAYa8QLpXmeyoTf4aZKyeRiUhlp6p8Exru114uSeqRCUSO4AT0Rj0P6+gAgzPfAdKv
         96iLl5UuNdjG1WzfWwaAMoL9pTj6QfEbQXLZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hp/Tj1QYz56VfTMd1RiR2FT6yvDdqYC2zjWo8LyAtkA=;
        b=aym6nPYHyweL9jnMoirVc3TDfAiNGJcQt4YSq++1fQ/UUzYQe5cPLduz4bmebZyaHQ
         6WtLIFxFdvg3MXbXiYC3uGQwA8GD9i7WAP9YIvvPoc7TZayy+q32V3ANPSyBNOW9Hfb9
         Y+4pczCdCM74QiTfai6H/8zWwRIB8qTQwkLp6kxg+zPFh0Fy4LS0OZkHfW0FJ2blWLAF
         AY4+73HTY9XzRrz17FjO9k8/qUZI676Su2tz3sryA2mjFp99EXb2DPpmCsDRRH3nxCwD
         6BuzVA90z8TpmsRqz8BcTyaW5Rlqp+Bq6fmNBhfmovO2YXNVJM+KScJedZmpJ1rTPFzt
         yUXA==
X-Gm-Message-State: APjAAAVFrYHrnuKoL53fptwpfuohyWXaKIvgLwtS2JAjWPteu/snW4jh
        xALdux5i4RpRw+cKZ6mYa5AGSQ==
X-Google-Smtp-Source: APXvYqy+kMyXCOYXt3tkQiqhn8ghrjZXjBP+x14BUTwqGUx5FSITGx6w6TqBrjvdy1o7gXfH68Aj5Q==
X-Received: by 2002:a65:6644:: with SMTP id z4mr10890842pgv.300.1556896167237;
        Fri, 03 May 2019 08:09:27 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h189sm5627185pfc.125.2019.05.03.08.09.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 08:09:26 -0700 (PDT)
Date:   Fri, 3 May 2019 11:09:24 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Qais Yousef <qais.yousef@arm.com>, linux-kernel@vger.kernel.org,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] bpf: Add support for reading user pointers
Message-ID: <20190503150924.GD253329@google.com>
References: <20190502204958.7868-1-joel@joelfernandes.org>
 <20190503121234.6don256zuvfjtdg6@e107158-lin.cambridge.arm.com>
 <20190503134935.GA253329@google.com>
 <20190503135426.GA2606@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503135426.GA2606@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 03:54:26PM +0200, Peter Zijlstra wrote:
> On Fri, May 03, 2019 at 09:49:35AM -0400, Joel Fernandes wrote:
> > In
> > particular, we learnt with extensive discussions that user/kernel pointers
> > are not necessarily distinguishable purely based on their address.
> 
> This is correct; a number of architectures have a completely separate
> user and kernel address space. Much like how the old i386 4G:4G patches
> worked.

Thanks Peter for confirming.

