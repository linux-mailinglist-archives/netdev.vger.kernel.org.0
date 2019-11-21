Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F181057C7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKURCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:02:23 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35046 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKURCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:02:23 -0500
Received: by mail-lf1-f65.google.com with SMTP id r15so287721lff.2;
        Thu, 21 Nov 2019 09:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vn0geSNKbyKltuimRsjjbTYKvo6OsWxaTuUb0pNrp54=;
        b=tQ2BdRcdT+zPYB9FATJU1joJrDuoCA1grSug2x4t3FgoPdkip68Uw2Tq4gdoWbmAnO
         0flbMb5fiRGX1bNlGjiFGQzUuWioIPZCeCH488LVBFNNUYwBmISeR2doGkOG+mcljeFz
         5wWWFNtbn5P6pg9PCOfjFFvyVjAC2wh9x++y1moL2/S8tPN5BljBJFgKoSahg64SNz09
         rminhIg4DXpb6/h+hzFSRzVHGw+1FCHzKF8EFrY1MzkckQbwq6BZQ29/FQt9nGtfXEhN
         /fbud3yfQtNLhtX8pg6mcg362sdsWMQmnFtXY10eLXFaw9SS/XANGMzEHgit77xCs9e3
         5w8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vn0geSNKbyKltuimRsjjbTYKvo6OsWxaTuUb0pNrp54=;
        b=WqR1lZLNHBuU5x5YkDZaiJKRerM5DEuchwpARp5//OsljojAByvNiTkz20MjMtUPrQ
         zSJ49HJAZn25zVhCbCENb2FmoH784zRvf2Rfa+tDOou+3ceHbDoRjery+9nwDC1hBbBf
         rKf6gAzsbXI2Bk+jDR/ZXXCtFmecrpR22XICCOJiFkQMtQOwQQGkb39RmVqZaAvF5H5S
         OL6N2g3LEhtQeZdKLGtgWQOY6+menT0pAJCTPA+N6kIskfL9VwxSML10CZcd8SX48Lk+
         YJO3p9ryYyXv7MZ/diFqIA+cZbyc+8aEPVKjNqdIzrqvxT4DkmKBe+9+Eop4wUnt8Utp
         AYzQ==
X-Gm-Message-State: APjAAAVpvCKr/1eBmH5gMf4AVpj0/1jviKYuZstHZtLdHR/n2NwaKDdz
        LgHTRjH39EycxP07TsG/57dB5oDRGgifnjGBIRg=
X-Google-Smtp-Source: APXvYqyTzmAJhaWJwFBTVX5FN+G4U0xezaExE9XOfsxW49ynFAd/ZdThB+sRaVabdoGhuDy4CZaCM/dGlpXjdQ080xI=
X-Received: by 2002:a19:9149:: with SMTP id y9mr8954553lfj.15.1574355739280;
 Thu, 21 Nov 2019 09:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20191120003548.4159797-1-andriin@fb.com>
In-Reply-To: <20191120003548.4159797-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Nov 2019 09:02:07 -0800
Message-ID: <CAADnVQK9XT1s36r4mj2HHj9M2W307qdgrURhwEPm_LO3S2vVhQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: integrate verbose verifier log
 into test_progs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 4:36 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add exra level of verboseness, activated by -vvv argument. When -vv is
> specified, verbose libbpf and verifier log (level 1) is output, even for
> successful tests. With -vvv, verifier log goes to level 2.
>
> This is extremely useful to debug verifier failures, as well as just see the
> state and flow of verification. Before this, you'd have to go and modify
> load_program()'s source code inside libbpf to specify extra log_level flags,
> which is suboptimal to say the least.
>
> Currently -vv and -vvv triggering verifier output is integrated into
> test_stub's bpf_prog_load as well as bpf_verif_scale.c tests.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
