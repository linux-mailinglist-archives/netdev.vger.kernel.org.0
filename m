Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9251D117FBF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 06:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfLJFbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 00:31:41 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42421 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfLJFbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 00:31:41 -0500
Received: by mail-qt1-f194.google.com with SMTP id j5so1675354qtq.9;
        Mon, 09 Dec 2019 21:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0i5fqFii9h3zbWBDVAysAxtbLv8smZHCpf4SOKLHP/I=;
        b=tQ7NTeRHAxaLNx6IHMXSqyBmJf1gYVzude/M4QCDh2PlbjUzZWSuF/VGZ9HZuZ1qY/
         zRqG2q0O57zGo8OLc0aTt6cCoy+v728+FGFWdR3q4NrKc5WjmIkVRMxG3os3wTy71PiT
         e55ZNE+XG6nCfbyKVpnAkgeeWKHlZNhRQ2pyspfAXPPPcwlx3Qs98vs4K8I4qosdW2Ro
         qXfg99EKHSV0wBEGiSKUoP68UcF8Tv322d+Fl7Bw1C8DmiHyVq1vju8tDJqkLReeaFH6
         To+/5yzd/3j/0Rho77UBs+d9oMyT6eJTf2RTUyhuCIWKAECYHrVRoV5LGRzBUpHvrYq3
         P/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0i5fqFii9h3zbWBDVAysAxtbLv8smZHCpf4SOKLHP/I=;
        b=ViTHB/SypBe42WaZDzQkCSEIIK92PfDKFQVrUXfGGaL1l/N+idQJzpePShA0XFQ+Mr
         TSPls5iehU4bCBbJIURz+SvQPrFm/pnsvkwG61o22AAzee49/VzVgtne6Thdl2y1d0oD
         8nfFrSxnIZf5yIiItwA0T17/QJ2RENuVWVa+4IcLQBISBU3OPYACak/uyal8koZeil7k
         XncmLmAYQ7Ck3gNKWah0PqnIUkk6Ko3xLq7C01wxeJd5YsL4iTD9e1dxkjDA2308m5b2
         fS/nwkJeNiS27teCwMrqGFVlqZ499wB6R6QRhi8gL1rrAWIOt9BuzaU5ETPGmjqLf78D
         4wsA==
X-Gm-Message-State: APjAAAUCo/LNIcfbzhT+57CZp+NV+Aothuh3/dhSJ/ZYQnyeeo0CbXQX
        HAES4hpGj0ckSSv0/XZvpVgrypU5FGeftj94pIs=
X-Google-Smtp-Source: APXvYqyt0Hno3XoOYazUzPfoq8HIUPXgg2qVyO9UxGrvCfIciJG9wGyISvcyjdvUm+i1pmUEpuEObOvV8wUJni1oyws=
X-Received: by 2002:ac8:2310:: with SMTP id a16mr28240964qta.46.1575955899915;
 Mon, 09 Dec 2019 21:31:39 -0800 (PST)
MIME-Version: 1.0
References: <20191209173136.29615-1-bjorn.topel@gmail.com> <20191209173136.29615-3-bjorn.topel@gmail.com>
In-Reply-To: <20191209173136.29615-3-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 10 Dec 2019 06:31:28 +0100
Message-ID: <CAJ+HfNi=kDP--Vuuphdn4YhZDbBfoNXzcPDDaDo7vdvuJ0D1=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] riscv, bpf: add support for far branching
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     linux-riscv@lists.infradead.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 at 18:31, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
> This commit adds branch relaxation to the BPF JIT, and with that
> support for far (offset greater than 12b) branching.
>
> The branch relaxation requires more than two passes to converge. For
> most programs it is three passes, but for larger programs it can be
> more.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> ---
>  arch/riscv/net/bpf_jit_comp.c | 352 ++++++++++++++++++----------------
[...]
> +}
> +
> +static void emit_branch(u8 cond, u8 rd, u8 rs, int insn, int rvoff,

The "insn" is not used. I'll do a respin.
