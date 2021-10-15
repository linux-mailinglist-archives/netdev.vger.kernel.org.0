Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9066242FCA6
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 21:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242903AbhJOUBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhJOUA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 16:00:59 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2F7C061570;
        Fri, 15 Oct 2021 12:58:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k26so9244666pfi.5;
        Fri, 15 Oct 2021 12:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EpBL0d+zARonX4e/FdCBynNmNWbTS6+G42KxKb9lhC8=;
        b=Yp5b2HqyopTLlyq+F0z39XHmlgPs7aOcuIwqOjxxLevJITs+tLjbIvkLdoR7pSyHaS
         pSdD1norYLU8RnDg/GlUbeKd4+PM91tVieMKfT6nyoN2rEXTmLa/OyYeG328xQENFeNI
         Qnyk2FQ4eqXLrlqrIAfgB2lloO3L3PmdCmQNnb9Vs22z2LIUP86VwLoNp1jxUOXz2xS+
         6vmDeS24uPMEpJeL9ksl1aIcjq/N/8J4uz1jsqSqAuDzC/lpVrzmHTC0u2buYpt/PX+t
         o7mCHE7HTnzHm6r/7gINP18c8JDkmuj9+olsoBuaVVFCbzLCaLjawiuadDvH4K00wBLE
         zXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EpBL0d+zARonX4e/FdCBynNmNWbTS6+G42KxKb9lhC8=;
        b=Se6CcjunioSovMYuaF8O+TvnbFQgmod1c+eVvbADbYeXUQ2aDMTN+q6n2oDGM8nNjC
         85JHT324LGoaHdicMhksq24lFcwO3O4GSRgaNgbnGlC96PqDfRsKOliErfYlHJq/RPJO
         ePni1XJdOZr7XEmCMJP8hQe9aO4f0lwsqK9WcAm+5WbJo5mFIb2JjVJ8/qpWqwWyE4hY
         bldYe0B3kEMSIOZpx9TqfBqEzo/Q0XnzZmEwT63gWrPEtpQfZRzzDgmhh89ZhFsDqGqh
         EikQPm8IO6tMdNZFBmgSZhgIKQVMUizdUQ0oLCKze+Rumbb+Sf/q/eUbkKnVnYamgx2B
         Xlzw==
X-Gm-Message-State: AOAM532Tgu8BIYxWh2/zVEZDPGvf8lQTcll32rxC6vzVcbdDfGe1e4mv
        DQAYcwJNjbZUSNJAyJui7QxIw7md/Rv+NgLWGr8=
X-Google-Smtp-Source: ABdhPJz9duZk+yy0M1N2CMw5eP43R6dCaVdVYh1L+JZWF0kXl2A3MqE/VITrtXtpUfFOkHWoNF+Z1+Ew1KA3Dp9h51w=
X-Received: by 2002:a63:4f57:: with SMTP id p23mr10654618pgl.376.1634327932138;
 Fri, 15 Oct 2021 12:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20211015090353.31248-1-zhouchengming@bytedance.com>
In-Reply-To: <20211015090353.31248-1-zhouchengming@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 15 Oct 2021 21:58:40 +0200
Message-ID: <CAADnVQ+A5LdWQTXFugNTceGcz_biV-uEJma4oT5UJKeHQBHQPw@mail.gmail.com>
Subject: Re: [PATCH] bpf: use count for prealloc hashtab too
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 11:04 AM Chengming Zhou
<zhouchengming@bytedance.com> wrote:
>
> We only use count for kmalloc hashtab not for prealloc hashtab, because
> __pcpu_freelist_pop() return NULL when no more elem in pcpu freelist.
>
> But the problem is that __pcpu_freelist_pop() will traverse all CPUs and
> spin_lock for all CPUs to find there is no more elem at last.
>
> We encountered bad case on big system with 96 CPUs that alloc_htab_elem()
> would last for 1ms. This patch use count for prealloc hashtab too,
> avoid traverse and spin_lock for all CPUs in this case.
>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

It's not clear from the commit log what you're solving.
The atomic inc/dec in critical path of prealloc maps hurts performance.
That's why it's not used.
