Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842D979AD3
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388569AbfG2VON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:14:13 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34707 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388272AbfG2VON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:14:13 -0400
Received: by mail-qt1-f196.google.com with SMTP id k10so61009759qtq.1;
        Mon, 29 Jul 2019 14:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l1Ts0/pA7dfpqW0nmxkkAj3bDZZGCnMlGQqjtKQgKGI=;
        b=pOZ+lr2Eq0ItI4z72P9NVB6lARrEz4H2qjf4G38ZKwZGuC3nX8pa91J5LvhekOXPO5
         qfRVV1mPoaSkb31sasGmsEQVIk6kztlQPjOn4NYWi/ikraBDIyO5nv2O08xlsj9U5ema
         YjUpRTKvpI3CzQ/I6HCnNEJongS1yT+lzxeCLdSHYuOh7esJzYV8GCEbIYJrP05K5GSP
         /I6Xy0xlFAhzTEfTIYE9ih3C38qbOkndU+lZx+bssVHXSguv9paEnBa+TgpZopHPbbh8
         Ox0HzlLIpg7hkbC7ko3HOKMG589DB2cxfgiTUJ6dE/bCd31jpzENvGftjwqvSXgPaNHE
         xv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l1Ts0/pA7dfpqW0nmxkkAj3bDZZGCnMlGQqjtKQgKGI=;
        b=Ju78N82iDvm8LdOrxA8umgxr5zCpktO7NXAe+Zf6ZZNL9BEEEQZOOJYcPqR8s5Yrku
         wMia+v+Aa2V34uxIJ3Ewis0kve0E4GQ8jPOoRADIqjiUC+dJsvGqiFinnRWJOurHab8o
         ISlawf7AjvnfKwIjhOLeKQWDoYG0yJBEm6YUnSs5sZhgokX2kLJtSiPZaf7hX3/hkAg8
         HJAixHWZVrDE2lNuJ17TaiNpfCIdBbt1uBmwjrG7iQxwcwFIFCDOZa3dkyttjplYn+Pt
         zokt+BkKXO5gopSxbAlsBooVVGKH+vQcQfM9LfnU6BiXeEHDCklb+rdQ4vqXM1zN7FPD
         gA6A==
X-Gm-Message-State: APjAAAV8NKPMY3kP8Rqqnm7udfLSAd8pybRJRE0aTYQWT36rJkErdH9C
        sZQmN/kQTk7/Ucsgq/QzOMIaPPC+lqdB7ZXvsRg=
X-Google-Smtp-Source: APXvYqxZMqbg135w1gTkpwKn8mMI8lw49VdD7ah0SKJDff/8KKfeLLsK9mQMhDsvtUKmh7KgYezfnOmpMFAi0ZCGxys=
X-Received: by 2002:ac8:152:: with SMTP id f18mr76723340qtg.84.1564434852233;
 Mon, 29 Jul 2019 14:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-10-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-10-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 29 Jul 2019 14:14:01 -0700
Message-ID: <CAPhsuW58nDceGv0tia7+5s0wLnU3_157yjuCFm_=bUUH+zy7ZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/10] selftest/bpf: add CO-RE relocs
 ptr-as-array tests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 12:31 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add test validating correct relocation handling for cases where pointer
> to something is used as an array. E.g.:
>
>   int *ptr = ...;
>   int x = ptr[42];
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
