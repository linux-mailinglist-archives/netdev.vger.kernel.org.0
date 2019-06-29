Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBA75A9AB
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 10:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfF2IuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 04:50:20 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43246 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbfF2IuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 04:50:20 -0400
Received: by mail-qk1-f193.google.com with SMTP id m14so7032225qka.10;
        Sat, 29 Jun 2019 01:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRCaPZUTNlS7a+mx62w/hxRGKkbBOJjALk1mlt6ypZY=;
        b=Q26SSSteIECh9v3cROEI0AGN/KtJ6LihDFal40Ppds5cLo962l/9aTdp1VA+nyhoiY
         jHu1r9dze84rI19Ft3K+pXx4S/hQADkTSWRXKkvPR713F3LtztNYL1SJRGzqIpyz6BJt
         Wiz+3lz219UG7SA+tPYyrYiOs+lytkoL490dgDBQpQRVQl2FxrXnvSnvZhuanr7QjczE
         vxvbolKbhO/sMo9ky4Kdc/MmPOycoG2c1unpis+qfZmnBL07uxxNRqM6s3Og1Yb86IxI
         sW7SNCaT2tdZEnIhdmdaVIa76rK23YOtIrNkSaXz07qKInm64f9K+IrKIdFQ5PFVZXVS
         ck6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRCaPZUTNlS7a+mx62w/hxRGKkbBOJjALk1mlt6ypZY=;
        b=JlIVtMDuEPmkckpr7t5M3fdQljkcDS3+qqGM6RJqbkMMv+0rpq2Q59rzsvNj5CDDXR
         earRKedgJNRpousP4etxy96NmZ7y+ZErEFTt/BwQpvLEWZzLAHr++g17PftIqo3z+Tnw
         V0Y6+PD6EOCZs2kmm1n/JrrFGaaj+CEN+ggaTnBfG4GbP7PqEm6TMb5CvFtD45OQrenl
         asJx4dAEGEJc2Zr0gfS7sF81Jat/fdxziLYgFOU66hQpSk3mmEQBMkNBklCieC0SynU4
         XNfI/zzKV+cRnN1JraNqNLRK8Qwg5lpXsS85gU404mSGL884jxSN7Bmp+cDSU2LBkkDY
         Vgbw==
X-Gm-Message-State: APjAAAWezNypPmO0LKSWhC97e/VyI3G1fOYbwl3jIV3zyvDbP9GKnpD1
        onQVjDzr0PhlpScWaEez1CAd9jgeIfagDcVDhf8=
X-Google-Smtp-Source: APXvYqwFGtClOquwzdwXU0rzZWXmX/Bq4+BGlgBrnI65uL7qt2P1B7Hrd3YMBiPfp12b0AdGGAo+Ui2DcQV113MFxMg=
X-Received: by 2002:ae9:e40f:: with SMTP id q15mr11396108qkc.241.1561798219303;
 Sat, 29 Jun 2019 01:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190629034906.1209916-1-andriin@fb.com> <20190629034906.1209916-5-andriin@fb.com>
In-Reply-To: <20190629034906.1209916-5-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 29 Jun 2019 01:50:08 -0700
Message-ID: <CAPhsuW6VUbGHYEW1egZv3R_L2wytME1CODfi2yijH_Bwe1S-3Q@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 8:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add ability to attach to kernel and user probes and retprobes.
> Implementation depends on perf event support for kprobes/uprobes.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
