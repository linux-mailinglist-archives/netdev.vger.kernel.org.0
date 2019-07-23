Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9367213D
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391948AbfGWVFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:05:04 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40648 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbfGWVFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:05:04 -0400
Received: by mail-lf1-f67.google.com with SMTP id b17so30364205lff.7;
        Tue, 23 Jul 2019 14:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qcfBtddUDGxtuLrQYEwSn4QGSpSwm80McK2bcIkP2g=;
        b=PePmZq3uP71w0dtJQalylUXJjNvrfQyafAscVBm19DLCa/n7DPM/qABpzkeERK+DBB
         +1tpO9G0NQbpfOumCNjZHoQTfE37oKapHdMFXy73Nx21uUxRU+ou18aeoJ2ompRruVK0
         P5EG2ioSITVag347MGzmAxkTWW3T6ZGHqB87pV8rO9VOgS5dZG8K/Z4noV4NpqR93A4h
         tWBDkUpCo7XzaFT7YMHfhpFX589z0YA7dIGgDUV/0CqR4R6csvXGywlKFZP6ZTHvRERR
         Ku61sdRY5H5I153R6x1pjYl9afxp0TFkZg4V787uEEetkUJPGZCv1gcp2rZxeZCryvs4
         mnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2qcfBtddUDGxtuLrQYEwSn4QGSpSwm80McK2bcIkP2g=;
        b=uZ5pdhZsrkO90Hru4qxheQt8Kvfx31t2/8nt0qiL2Wl7GpCwKBruz3GpU5muuNpMVt
         ivnri1STlSHXITkJKHs1stlcB53f05S6P3RvHLSOIedWL/DQQaJS1LQnd/PFsx9ceSoF
         xqeyXoE7a+4XCCkMa6wguZZPNwqqkrlp9s9KPdeFCMFzl9DpXHqorby8UNHrf5pv7WR8
         LIZ+GLgyBxtAOrYVl9ANBhGhuQZj2KUb24pu4N6w1gaS1tt6PmTdplU9w0F6Geq+3Vc3
         tQiBqgSfPr/jcymtJ/3Y+FunwBbHUo2cgE6A9FkvO1jPwllT2/m2WXoKtVfyLlH0Em57
         x96A==
X-Gm-Message-State: APjAAAXE8j5Lrv5bcojDNlJ5n0SSyEGcUtl5/JOqgEL9QGfzF1IBPV8b
        Kl26uRGliCwwMZVvYSIF+rIl/Yt7Oi9ONJInUsw=
X-Google-Smtp-Source: APXvYqylEKFH9EWshYGR3jEROtQxArLVgSFcymJH2GiN16FaAwqYK2PzJIBvvjRLlnoBcvFKIV2Hw2M0x2W4VYoN7I0=
X-Received: by 2002:a19:6e4d:: with SMTP id q13mr36754383lfk.6.1563915902486;
 Tue, 23 Jul 2019 14:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190719091815.92181-1-iii@linux.ibm.com>
In-Reply-To: <20190719091815.92181-1-iii@linux.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jul 2019 14:04:50 -0700
Message-ID: <CAADnVQKkS=fFAffiFeN3ugnmp_NKZd3f2VAgYmbkOh3nGvGkdQ@mail.gmail.com>
Subject: Re: [PATCH bpf v3] bpf: fix narrower loads on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>, gor@linux.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 2:18 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> The very first check in test_pkt_md_access is failing on s390, which
> happens because loading a part of a struct __sk_buff field produces
> an incorrect result.
>
> The preprocessed code of the check is:
>
> {
>         __u8 tmp = *((volatile __u8 *)&skb->len +
>                 ((sizeof(skb->len) - sizeof(__u8)) / sizeof(__u8)));
>         if (tmp != ((*(volatile __u32 *)&skb->len) & 0xFF)) return 2;
> };
>
> clang generates the following code for it:
>
>       0:        71 21 00 03 00 00 00 00 r2 = *(u8 *)(r1 + 3)
>       1:        61 31 00 00 00 00 00 00 r3 = *(u32 *)(r1 + 0)
>       2:        57 30 00 00 00 00 00 ff r3 &= 255
>       3:        5d 23 00 1d 00 00 00 00 if r2 != r3 goto +29 <LBB0_10>
>
> Finally, verifier transforms it to:
>
>   0: (61) r2 = *(u32 *)(r1 +104)
>   1: (bc) w2 = w2
>   2: (74) w2 >>= 24
>   3: (bc) w2 = w2
>   4: (54) w2 &= 255
>   5: (bc) w2 = w2
>
> The problem is that when verifier emits the code to replace a partial
> load of a struct __sk_buff field (*(u8 *)(r1 + 3)) with a full load of
> struct sk_buff field (*(u32 *)(r1 + 104)), an optional shift and a
> bitwise AND, it assumes that the machine is little endian and
> incorrectly decides to use a shift.
>
> Adjust shift count calculation to account for endianness.
>
> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied to bpf tree. Thanks
