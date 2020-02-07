Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86B3156081
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgBGVJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 16:09:55 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40532 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgBGVJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 16:09:54 -0500
Received: by mail-lj1-f194.google.com with SMTP id n18so766748ljo.7
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 13:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G6lJ3eVihQzhnpgygVKaGhku6xBoNivJFfNePtZ2oQs=;
        b=TrrZ3kVS5imwLo759RwTKG3OqsyLhZUlxnAA+DnvviLqnGblA3PndVuRaan5cEIn2B
         fDO/Eh0Y9ertNh2QXFLyHH7JFlC/NZfw8IQCgDzbnZWNJJMIDk4r6RxKlVQfHhc4yu/e
         AJBrqOK/YW7HtJ2q3NS8MvmmaiG223SOALKgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G6lJ3eVihQzhnpgygVKaGhku6xBoNivJFfNePtZ2oQs=;
        b=LfrsC39twGZ1Ik7yAbEWQ9SYOZm+PSoN/nBJ7Vy+V74GUE/maPY4a+bv9r9aF7Cu+S
         cPVskx+TvUnDD89gHPlToVgvV582Ksm2ujU53HEoPwPh9PSAAsPnEQKqFRXTD7ED5HVx
         rrlVZIGhcUuTaGWuDV3KcANJFGHnoCaH1jdk2QTXRxFq/kPuYgJf2GJrQJwkBvBlcrL8
         HplKywFZknnRydckLTUjUDlJHHTib0ufj2x8HXO0dhEs45cbjmtY6IZSkv9pF7wA8Tgb
         fPts5PMBumA8Ku5VVT8H5/8phLWqeZCwqIpEHPqPuoOj0RlRLAnJwhj0yG/J1Fw6+KB0
         5q9g==
X-Gm-Message-State: APjAAAUjhwSnvC8BMvJfp4HqChIDMtIFZA+28GwQscUu8L1e/EsMXngY
        utNagdaHbPMnKdy8sqdUBNmocycGBWhHgA==
X-Google-Smtp-Source: APXvYqwV2dRsaI9gjLH6/6jWJpmWIibPiSzrW9XCodJJ91XYxeTOlJQnRMUm/5w1OzrY6pk6926+sA==
X-Received: by 2002:a05:651c:3c4:: with SMTP id f4mr628013ljp.5.1581109790077;
        Fri, 07 Feb 2020 13:09:50 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id g15sm1872117ljk.8.2020.02.07.13.09.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 13:09:49 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id x14so730874ljd.13
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 13:09:48 -0800 (PST)
X-Received: by 2002:a2e:9d92:: with SMTP id c18mr682642ljj.265.1581109788445;
 Fri, 07 Feb 2020 13:09:48 -0800 (PST)
MIME-Version: 1.0
References: <20200207081810.3918919-1-kafai@fb.com> <CAHk-=wieADOQcYkehVN7meevnd3jZrq06NkmyH9GGR==2rEpuQ@mail.gmail.com>
 <20200207201301.wpq4abick4j3rucl@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200207201301.wpq4abick4j3rucl@ast-mbp.dhcp.thefacebook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Feb 2020 13:09:32 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgdCXgQyBSSx-ovfiZ7WFR6fStOZ_2R9mxkX3a+R5MkxQ@mail.gmail.com>
Message-ID: <CAHk-=wgdCXgQyBSSx-ovfiZ7WFR6fStOZ_2R9mxkX3a+R5MkxQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Improve bucket_log calculation logic
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 7, 2020 at 12:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> In addition to this patch I've tried:
> +#define __const_ilog2(n, unique_n) ({                  \
> +       typeof(n) unique_n = (n);                       \

Yeah, as you found out, this doesn't work for the case of having
global initializers or things like array sizes.

Which people do do - often nor directly, but through various size macros.

It's annoying, but one of the failures of C is having a nice form of
compile-time constant handling where you can do slightly smarter
arithmetic. The definition of a "const expression" is very very
limited, and hurts us exactly for the array declaration and constant
initializer case.

Oh well.

          Linus
