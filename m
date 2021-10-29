Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12232440366
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 21:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhJ2TnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 15:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhJ2TnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 15:43:18 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF66AC061714;
        Fri, 29 Oct 2021 12:40:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so7898178pjd.1;
        Fri, 29 Oct 2021 12:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QqraygZVVv+CzliyCMN5Hd0ra7YrWQFASUvrUVbZW3w=;
        b=NCL3+qQmdtHaq0OCd7yzwyqypQiMnHS0cvZdFmBU9YOsurUs51zowng+rdyckHXEQ2
         JYYmS6IfZR8jUhzeGzqZmVFXvZQBJMTWEbDVzXUrFVkBmyGs1+SrvrCBXuKyaFG32fZj
         yJlt01F4zoS/yjnpsmiS2H77TJTzVaGu7sTt/ThH191q/Sr6Gvmjmd0sqUiFvxtky+Ye
         y4NhX9JjPY0ep2GmPZEHYSkta7amt1Q0vY6eI2dB99znTcvbFd2B4LJsuH3rRj28qnUL
         3kjEhiGovMAuge1l1XykS5FS9blJ9TZMgjli1hyyVtF3PuQR4t14U/O94vjUCVy6jDLx
         PSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QqraygZVVv+CzliyCMN5Hd0ra7YrWQFASUvrUVbZW3w=;
        b=OAGJ5A7bbSOzT+Ix2FdLk7oHf1ZI38hJAvGiLOZ4pbRR+9QiceM43DfID+7YMGreNd
         jp2K2iPNPhlzAiR4hEAYEnVhpt0VUqhpvh7m7SzZ8YM47BaYb5U3TIBBl+wLciZHEF+p
         EsNhUUCRfLoVGcfSNxvAS2j9e/FtBJsM/0lKA/F+PhtoZ9Y1IOEY70gEDrP5WCc2mWKT
         6EwlHSCrTlY8Kndm0GvBZDLXlstpUbMW1L/z0NWtenFBvmggRY2YIkGIkT8WQiNUjqwv
         JszJEjfDcTA8C9GWjg9i6tHw9rfYOCqrJeL5lr33hw1LnAjoRZlypa/uKOnfjw6zhsxa
         UbRQ==
X-Gm-Message-State: AOAM533MH07OEEIW446qbyXbOUdXckMmQ/MsDYZn+17oVSnGHnd83tVJ
        48vKSvhZNABH7w0cMybNe5fCebP+bDBpdLUVWaBZGdXV
X-Google-Smtp-Source: ABdhPJxmYbt1jrESoqsowWksKw9kFaZuOibFTBwmwnTtIkdUrf3SSyQyFCxvfE8584L+n9PK9oLbZW2BBoP2BIeiJKU=
X-Received: by 2002:a17:902:ea09:b0:13f:ac2:c5ae with SMTP id
 s9-20020a170902ea0900b0013f0ac2c5aemr11480261plg.3.1635536449455; Fri, 29 Oct
 2021 12:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20211029172216.88408-1-alexei.starovoitov@gmail.com> <c26c0f63-0ae3-a2d9-6c9c-05705152ae28@fb.com>
In-Reply-To: <c26c0f63-0ae3-a2d9-6c9c-05705152ae28@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 29 Oct 2021 12:40:38 -0700
Message-ID: <CAADnVQLHbcb+ZWNO8rvHVmaLYpvAFw5nvu2iuXRu_BDGxC8ebA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a testcase for 64-bit bounds
 propagation issue.
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 12:00 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 10/29/21 10:22 AM, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > ./test_progs-no_alu32 -vv -t twfw
> >
> > Before the fix:
>
> It is not clear which "fix" it is. I believe the fix is this one:
>
> https://lore.kernel.org/bpf/20211029163102.80290-1-alexei.starovoitov@gmail.com/
> Put this patch and the "fix" patch in the series will make it
> clear which kernel patch fixed the issue.

Right. I should have sent them as a set. Sorry I was in a rush.
