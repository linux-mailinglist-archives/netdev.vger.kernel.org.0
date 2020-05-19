Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB381D8C0C
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgESAPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgESAPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:15:52 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52812C061A0C;
        Mon, 18 May 2020 17:15:51 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id t25so9788516qtc.0;
        Mon, 18 May 2020 17:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LSQ6bbK5QmZwJYC9jpLIrNTbJNjUMjJ5eQzgUn+LHiw=;
        b=eTT7Rr21sjGUotCwrUVISAfchfQWCiQ9yrJYlbMSF6liSgYlBIPz/l5fHjmqlL4c4w
         WMrbsSofwyJf/AnyRF9aV8MrqIQ6NcBrOEJ28mltRJh1Z5u+wLtJIQJ5aba+jKEZdv8M
         FtN0bmM8tTX7vaCRmvchx5hKoO0c+UA3KZawa7JVl2sCPMj6D4D7qh7jFS+9jUonALdW
         5wFGrn/m8syprshKI4qc5CfzksRNgkyfXX/3M0Csok8UIAD7BIJiwwnT80KWmrpoMcg0
         RBafdg0/7S2I5ceRa6Puur+IGTAcjj+hJpcFZNtF5PMp3YvCCF45FeUCS24V+a6uBqNf
         GBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LSQ6bbK5QmZwJYC9jpLIrNTbJNjUMjJ5eQzgUn+LHiw=;
        b=fZyBaOyZv8sbI8x4gtsoUIuV6HemeZmtLSKz1OYCa9jKM8DNaLD0lI/y2WmR8715P5
         7LOCW65K/Xpir1M3Kp6Jfpg7edVxZIf7aFkRt/ftbE7wXQa+yEEXBoP9hELasIkODdrO
         cJDoS/4arZCe3YDsyqw79Sxg2ysbc94yI1dabJhouXkcnjz2YWI96IkHbiMs8ZK29NuZ
         PQ/vppMT1JiC8cANsE1aNhcLWaUYEJp5Cu/oXqiqI16/jYZpaOtjgrP8qvsE4mHlUy0p
         PM7IxaGZVG9V1IIkvUP2KwERg2UwC1jq1Zfky4OPaYoahkTEvctALYL/Rp3bK5y9ucsl
         pXZw==
X-Gm-Message-State: AOAM530paCQhOGO4LdzZc1gRlVhMYDF5VKbzee1jQHENfk3mqIR0C8iM
        4zVuhT7lHEX662XNpduwTwVZ52VRsk064dXZgqc=
X-Google-Smtp-Source: ABdhPJz5rEWsMFhUBy4xS7xqMbRblS3+sZNU6SFhpT7v4u3/aqpCrpy3O0lHJLntkvFQ6C4BnXEyCfQsnuDDQpammU0=
X-Received: by 2002:ac8:1ae7:: with SMTP id h36mr19053242qtk.59.1589847350333;
 Mon, 18 May 2020 17:15:50 -0700 (PDT)
MIME-Version: 1.0
References: <158980712729.256597.6115007718472928659.stgit@firesoul>
In-Reply-To: <158980712729.256597.6115007718472928659.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 17:15:39 -0700
Message-ID: <CAEf4BzZJ4dHHtWK-Kfiy2RRNsoK=3t8c94x_jxs6SDRVpcS-HA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix too large copy from user in bpf_test_init
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 6:08 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Commit bc56c919fce7 ("bpf: Add xdp.frame_sz in bpf_prog_test_run_xdp().")
> recently changed bpf_prog_test_run_xdp() to use larger frames for XDP in
> order to test tail growing frames (via bpf_xdp_adjust_tail) and to have
> memory backing frame better resemble drivers.
>
> The commit contains a bug, as it tries to copy the max data size from
> userspace, instead of the size provided by userspace.  This cause XDP
> unit tests to fail sporadically with EFAULT, an unfortunate behavior.
> The fix is to only copy the size specified by userspace.
>
> Fixes: bc56c919fce7 ("bpf: Add xdp.frame_sz in bpf_prog_test_run_xdp().")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  net/bpf/test_run.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>

[...]
