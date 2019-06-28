Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAED35A29A
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfF1Rlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:41:31 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37437 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfF1Rla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:41:30 -0400
Received: by mail-io1-f65.google.com with SMTP id e5so14245870iok.4
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uqJ6r1Mjakiqpd0ZD9iGpyAkpv+xSUcUqESly9SnS30=;
        b=lOFXls3FkwUg97CyPjvyXgrcjW6i3Y09TjD9O1sKjz+4VVLO0kGXwLk7Lh5Ks/8aAW
         JijWwpKYFieazAh57d6dT1oO3AO01TZnC7WoBmE1OSNdS8W3PrRrtsH2CbmHSwhjVWw+
         zeSbiFOvp9Kpu25n4n1vGhIUhGVzJdYcNha8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uqJ6r1Mjakiqpd0ZD9iGpyAkpv+xSUcUqESly9SnS30=;
        b=TF9KFfyc9xHzUxhe7wh9UQnXVXArQlsD31gZbJPNyVHtWD1KccybI8Rkh5uro+aGHr
         CHe018liybWCBFEWWxycKsmuneWcsuw1TfVnk8N9gFLjj8wM4JfCpILkMjRuJjNvEoS5
         uNY0Y5mg5zahWbBw0X99V4Np68PxgMLKaq3kY0FaVy+Hq7Xd6MMHzAirZVbVjyef/CKw
         w42EwDypVFi2MCgwlRldTqNshH47HsLhpmVUJAR+LSjwSWgKIMUQ4R5hYHPLhxeRC5Sc
         fYmczjNSRtIZnCYB6Me2+uk1gp33AUawXN0OfxK47qi5mIyaA4iR+G5XGC0kS6pF9xFG
         lM5Q==
X-Gm-Message-State: APjAAAUGIDdFV4Mx+LdryaVInWx//kyHMZdq/juuAgCb4veiY5v2aj1j
        zTrKAHMU4AQWLo4mvwXoCpLc/JD0PvfaMEtPkg+6AA==
X-Google-Smtp-Source: APXvYqwcltk4JmdpNvtJF1qrqeEE0+mFopXztg8enMwMB7rkn3G9Vg90wC0+Jkas2dqkKaCJf2/GoPK0tBQW9eKSXf8=
X-Received: by 2002:a6b:f90f:: with SMTP id j15mr12016235iog.43.1561743689556;
 Fri, 28 Jun 2019 10:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190626231257.14495-1-lukenels@cs.washington.edu> <87y31nuspw.fsf@netronome.com>
In-Reply-To: <87y31nuspw.fsf@netronome.com>
From:   Luke Nelson <lukenels@cs.washington.edu>
Date:   Fri, 28 Jun 2019 10:41:18 -0700
Message-ID: <CADasFoAqjZVnMFGZNgQMhXsBC78vbb-u1PPv_aZx3fMXeHBXKg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] RV32G eBPF JIT
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, Netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 5:18 AM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> #define BPF_ZEXT_REG(DST)
>         ((struct bpf_insn) {
>                  .code  = BPF_ALU | BPF_MOV | BPF_X
>
> So it can't be BPF_ALU64. It is safe to remove this chunk of code.
>

Thanks! I'll fix this in the next revision.

- Luke
