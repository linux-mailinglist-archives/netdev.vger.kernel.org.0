Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDDB8F197
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbfHORJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 13:09:50 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38577 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729176AbfHORJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:09:50 -0400
Received: by mail-qk1-f194.google.com with SMTP id u190so2407860qkh.5;
        Thu, 15 Aug 2019 10:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVw50docbCucFZcX8efnr7ur3I8ofy1+v8Gj33nvc3E=;
        b=plhLcnBpL2A7sRJXrVP5IeqRyjIvaEZQuc7too2ySY84ytDyRRgaBKvTKrtizVzkOi
         l/6hIyCy11pg3fSEw0P9AzDUMp7sWH6q9iHN2StW4H6Zul/LQ3/fdyCbY0f2/hBVqTS0
         VssUL+w34ZBJYm9F4HodzrRFXseo0TcqmHqI2n0qwIdT15/rxcO+lyEKcD5ddNjvAijv
         tkaaTgpYkyiQ51V1SXmpYI6LuRod4N7CPE3UGkLR181jVvyB9TfDHZhfwmE+qNHWSgPZ
         hYmfUJisQhmdjCHAi0OaYOFDj2IAZddeg1EQ/k3zTHyMAaveIp4lSXMxFWRTDAaK0x/3
         76Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVw50docbCucFZcX8efnr7ur3I8ofy1+v8Gj33nvc3E=;
        b=PI81CHJ1LvqrIu2kCF7lt79Y/Sw/YIdMeO8Dlqs8sRAlrqJOA5WXcVuwemAIR4JCsf
         b5alNVbGVLl9uC363Hgf78xwSaDLYbM8aOPArqb2zTehSik5ErQWDcqpRFkQBW8GgaZz
         bInHQiIvc8yZ2syjRSvISj/L76AJpNiH+sYe+SNhT2znJfoaAcjyktvoMsGGoH1+2D68
         lBGMntMydY4a80qAIgrI7kzPBwacPDMYw0A0tEQO62JIsF/SCqHehx/VWdQFQJf3LHmu
         M1H3DIXhzH5I5ORNs07mcHdL2eQkSf2Cmd9q7c1PcnzuvvqBgp0Kr7gku1B34RB85q6l
         R5ew==
X-Gm-Message-State: APjAAAXYJXVCrIYombM487vL6oyV6cQTLGo7fx8+WTu1vgA4DgP5l//Q
        lsB4uzaVd+3GGYQnFrBwmokAaPK9SXlRA04+bKXoiEWk7Ab9cA==
X-Google-Smtp-Source: APXvYqzj+3xz8dCH20gJ31BorJo9amkxXSJf8ZQtxaK0k/JYXgktkGF8KbLR8GOJ3HJQLZLVYXMzHJbmv4EuFVMsMEU=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr5091381qkf.437.1565888989649;
 Thu, 15 Aug 2019 10:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190815142223.2203-1-quentin.monnet@netronome.com>
In-Reply-To: <20190815142223.2203-1-quentin.monnet@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Aug 2019 10:09:38 -0700
Message-ID: <CAEf4BzbL3K5XWSyY6BxrVeF3+3qomsYbXh67yzjyy7ApsosVBw@mail.gmail.com>
Subject: Re: [PATCH bpf] tools: bpftool: close prog FD before exit on showing
 a single program
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 7:24 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> When showing metadata about a single program by invoking
> "bpftool prog show PROG", the file descriptor referring to the program
> is not closed before returning from the function. Let's close it.
>
> Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  tools/bpf/bpftool/prog.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 66f04a4846a5..43fdbbfe41bb 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -363,7 +363,9 @@ static int do_show(int argc, char **argv)
>                 if (fd < 0)
>                         return -1;
>
> -               return show_prog(fd);
> +               err = show_prog(fd);
> +               close(fd);
> +               return err;

There is a similar problem few lines above for special case of argc ==
2, which you didn't fix.
Would it be better to make show_prog(fd) close provided fd instead or
is it used in some other context where FD should live longer (I
haven't checked, sorry)?

>         }
>
>         if (argc)
> --
> 2.17.1
>
