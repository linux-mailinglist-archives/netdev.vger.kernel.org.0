Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74816CF13B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 05:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfJHDYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 23:24:34 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:32926 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfJHDYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 23:24:34 -0400
Received: by mail-lf1-f66.google.com with SMTP id y127so10808825lfc.0;
        Mon, 07 Oct 2019 20:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MjDMaoPPyrDz7wCqiv3xz2rB+qVxdenvCbo7vmknjX8=;
        b=sNZaQI9hlCJ7Y4Y7sJa87W26Z8DAkVlCw8m0dtZ36QKEUP+ViRg7I/ULalVLbTE8mD
         ajaEkAt6qO8dI7Dwj1uIn/OnzpRF8c8OHyv8Phyb8CJEK/WfGhd3yN4qAMW/71tikQ8R
         /dpMnSd2ixvHYJaNZ6kj9H06lTJlyUKwlbFaU3d5XzVhxdfIXdd64YjQCMPUwWTZPgYO
         QMe+ivZ9FPc09XJOTUYjT0IeqqmutK0hbb4h7qcQkK/k5J5AQojaC15pNahU09a8Ndej
         ABPoKtncD4R4KURKVLRRG64jyt+/6cxH/tR5fia2/Cw46IR4UzpU8WeTPNVfUat+3Igj
         Iqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MjDMaoPPyrDz7wCqiv3xz2rB+qVxdenvCbo7vmknjX8=;
        b=F4BwbbuEm2CBw5WpM/Ydx8kfBLdpgvoPPxs2gkuIT1gPWZWXxRQ5WwzuuOe6rg129i
         b+VQF4/HjNP39VoneqZq8j/GpwP/9GqRlfanKa0b5CakdG35+jL88ns3SLCm+NrkXs9L
         qrQEXAEFmmapurXdKjhDGscVvVgnyaiAmQ+w4pAU/8uRMnWUND/d2nhnN0MmDxMg69hK
         etLS1tnArV/gLMMLcK1/R1BHVMNad+pzWH1O7dvjvl8jQTUdzhGm6To7vl7gl3mK6X/5
         U/j/8ncqXaLSVsq7/NXp6h9iX/+Z2y5K/15ILA3WQLc7a7FGNBFEWXkqcLWGPy0Kw1u5
         48hg==
X-Gm-Message-State: APjAAAXRjFEColUszr+SDL+9/QTpkEAt9gyRWNAIYwiTD85T7ZblqWBK
        R7ImBp9AJyXsdpjBxYbkgAEQsK9Fj7T32nqBpDZUgA==
X-Google-Smtp-Source: APXvYqyP2FrrqASzOp51dODNygt650LS/x7Y3vxi7q1TgRsJ2mFXJ4zPeQy5jrb7mNYbeGrseDKq6zyhrOOM8+DhasE=
X-Received: by 2002:a19:2c1:: with SMTP id 184mr539088lfc.100.1570505070630;
 Mon, 07 Oct 2019 20:24:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191007172117.3916-1-danieltimlee@gmail.com>
In-Reply-To: <20191007172117.3916-1-danieltimlee@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 7 Oct 2019 20:24:19 -0700
Message-ID: <CAADnVQLYuNmVSdq3to2Sjpg3WmZF54A_OPTngMRZwToiDF5PoQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 7, 2019 at 10:21 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> to 600. To make this size flexible, static global variable
> 'max_pcktsz' is added.
>
> By updating new packet size from the user space, xdp_adjust_tail_kern.o
> will use this value as a new max packet size.
>
> This static global variable can be accesible from .data section with
> bpf_object__find_map* from user space, since it is considered as
> internal map (accessible with .bss/.data/.rodata suffix).
>
> If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> will be 600 as a default.
>
> For clarity, change the helper to fetch map from 'bpf_map__next'
> to 'bpf_object__find_map_fd_by_name'. Also, changed the way to
> test prog_fd, map_fd from '!= 0' to '< 0', since fd could be 0
> when stdin is closed.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---
> Changes in v6:
>     - Remove redundant error message

Applied.
Please keep Acks if you're only doing minor tweaks between versions.
