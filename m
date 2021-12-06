Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C49E46AA68
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351665AbhLFVaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236938AbhLFVaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:30:21 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1158C061746;
        Mon,  6 Dec 2021 13:26:52 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id f186so35081567ybg.2;
        Mon, 06 Dec 2021 13:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qd0RlontxaO6s33Aw+sFbxzkHeQiyT5wpIK2eDz8lA=;
        b=a8fe4BCEiflaVndKh84ion0/MS0nvXEdB4lAvx+k5Xm/7eyXks0oCNCF7SmC5e5Me8
         kwHVKUOWSplPHAvTKGp4yOV7JM9+XATBxf3PzUSWbz2vp3GB/AjKgYrcnX/7Q8iYis5J
         8QMC8Ss+CAT0lKPGS5EG7o9lD76ESt/edE6haOicMFQeUOtr5WfZTOyQpNOSohnrDuyW
         5qUTKiZyN+mPTwP0nPNVt/LIUiCfByHdPHP23kW7EjjrBZkNRzqCqHT9c1olm0AdJmVD
         kRJ/OdmRLAV4hM1xdop+swb49tQsInx8XHEMQ8jg09rh1YqVcxtJ9e8NxxS1aVG+xyvR
         oFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qd0RlontxaO6s33Aw+sFbxzkHeQiyT5wpIK2eDz8lA=;
        b=JcBfNQgAfee6dey7Oi9dXlp4TIaGA9BMAm1vA5+tkrGuYCYbhDonGTrPO0A0mEt3nF
         R7+WM4+oEzCtSgayex2lOS6fDwjlDlPzSYbaCMU13VdscoiakgHCpTdWY11lQnsfRrIS
         FKXsJwB1a0uBQBpGMibFaz8ippKIfbWgZ5IZMwiNjAPgvufSaNbKr9+57S2ngGLqzNXF
         BgCJl674dUo6QU2VLWiWCzZzAuhH0wj7xYdEAGByhTAsr1UBMzpGyjk6djwCIgbRVa4Q
         uDILLTd+TPBm4WXLPButscBvBYrWVep8Bpzr6caxNVmOO9Qr5q5SER13+SVbmTDD6id1
         gFvg==
X-Gm-Message-State: AOAM531N32SPo/yOND+ZirTI6OAqK2VrRxjpmafoM1SQCsbiMEyRbZbf
        bB4enwJTH/pu5aFSiCsGihtYeQr8h13V5bn8l+Q=
X-Google-Smtp-Source: ABdhPJwA16XyeYBD/g3WV2Q1LNeZ/Z0vAa2Ag6jE4/aE/ilQmOHHkClF9fOceKHyu+qrpD6VQ6ZU42gkX4ZbRabqvlQ=
X-Received: by 2002:a25:abaa:: with SMTP id v39mr45762924ybi.367.1638826012000;
 Mon, 06 Dec 2021 13:26:52 -0800 (PST)
MIME-Version: 1.0
References: <20211204140700.396138-1-jolsa@kernel.org> <20211204140700.396138-2-jolsa@kernel.org>
In-Reply-To: <20211204140700.396138-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 13:26:41 -0800
Message-ID: <CAEf4Bzb0FBh0cGecgQG8p53WH8tCoibWfp0wu9PPnT1MRMsWCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf, x64: Replace some stack_size usage with
 offset variables
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 4, 2021 at 6:07 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> As suggested by Andrii, adding variables for registers and ip
> address offsets, which makes the code more clear, rather than
> abusing single stack_size variable for everything.
>
> Also describing the stack layout in the comment.
>
> There is no function change.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Thanks for the stack layout diagram!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  arch/x86/net/bpf_jit_comp.c | 42 ++++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
>

[...]
