Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A75E102FAA
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfKSXCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:02:54 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36215 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfKSXCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:02:54 -0500
Received: by mail-qk1-f196.google.com with SMTP id d13so19539990qko.3;
        Tue, 19 Nov 2019 15:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2xERTRmJkn8A29y4CERFgsstygPQ5mYlKpryEA6rTbI=;
        b=NAgp+QDKn6s1v5jYuCJEsGXVSD06frSc/Q7adOKXO5aypkuw1PR9IwEpnNOre6CvYe
         ta3oivX265bDrU1AOX7iNhn2fHhE1N5NYkAUX3iAO798hI7ilwo1ggRknPtwxir3q5Gv
         p4uEJoPIB9oB1MMBYPIJQVQwtWEH1+z4hmjxaSxqnDdKwYheBkBbzLUDk4Nc1ZgZOYYJ
         YCNnuV3Pr28hhtgao2CuOGLSDNSXBQX3egIQOhdQ9i7n3ykYmygz7XnfS/Hipr/bZ043
         JiYTcOvNzEqV+IBLdGbEn2DGu56n56trdhq5SSidGMQyZnelcCnjx1HYME4sywlmyXG1
         26EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2xERTRmJkn8A29y4CERFgsstygPQ5mYlKpryEA6rTbI=;
        b=K6WRC0K1eanfdHCbLzVp/8wY/JUU/GUYwiF8sSc+HHo56UKl/rmMIOyXErLXHHwqTO
         e2dSzflQCdUsfOMv7GaAHN0mXXfusGEd1Uh6yQnMzekfN8uuK7ZV1S2YIuBnk4kjeCa0
         m6986DmZrGrJ6pOwSuIAS968CdQPQsp6ai8M3l82hb2KBekoPYreT3uHuvIT0iyGrGcf
         DrZIlEI+OXTM04P70ulbJ4GnbarlAJp2VL1qt0FxzxpgaM7o/uQzW2REKGppcd82VpDy
         eOyJovUB3fbwGOAjNmULZ+wYGQa5kMv9mIUjGXrYibENupxo75zNWAI9/ns8boaugJ8A
         oGWA==
X-Gm-Message-State: APjAAAVcnoSEu79Q3mKXoFwkNWJ4TnfS4jDkmjfH0BJljPJJFyUot2Yp
        Nn5w+uxODmsmuR7r5V2ML4E3+MfgyXNv4KtRm8A=
X-Google-Smtp-Source: APXvYqwC+K/Hj4qfCDvMwMlstfHwJK8NSsvKh02vZrSXrSWJ7EMOuaYrhHIDy8MzlhwBB1F5f0Sit6FP2G8cVDjYCko=
X-Received: by 2002:a05:620a:12b2:: with SMTP id x18mr50135qki.437.1574204573084;
 Tue, 19 Nov 2019 15:02:53 -0800 (PST)
MIME-Version: 1.0
References: <20191119224447.3781271-1-andriin@fb.com> <CAADnVQKQZB04iuHeOMB_yTEnwZs1NYN=Vn-XyJ6PrA1ZZG7q5A@mail.gmail.com>
In-Reply-To: <CAADnVQKQZB04iuHeOMB_yTEnwZs1NYN=Vn-XyJ6PrA1ZZG7q5A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Nov 2019 15:02:41 -0800
Message-ID: <CAEf4BzbdmYseBQiR1zWTVvcMC2RvaLvjYKNEEgKGFWER6jEDcg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: fix call relocation offset
 calculation bug
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 3:01 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Nov 19, 2019 at 2:45 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Convert few selftests relying on bpf-to-bpf calls to use global functions
> > instead of static ones.
> >
> > Reported-by: Alexei Starovoitov <ast@kernel.org>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> This one works. Applied.
> I manually added Fixes tag and Yonghong's Ack.

Oh, right, tags :( Sorry and thanks for fixing up!
