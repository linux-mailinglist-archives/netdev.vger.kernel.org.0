Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF572348B4
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387504AbgGaPvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729488AbgGaPvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 11:51:49 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362AEC061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 08:51:49 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id g19so20027919ioh.8
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 08:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mWXKa1Sc5p1hrgsJYkTBC6jHOzmU2VYIHQ189M5bCl8=;
        b=o7KPymYNxFeY9UaTPnqxwE+cGBV3EqhUwYGpvHHM7xmfEQ6eSO1wLssKQdqy8cxByp
         c//w87d7janq7ZxBYgkEOZyU4gCifc4X/Zc2mf6p/CnDXCZYDtq6hAL2U8ewjGQMrDz/
         hKKwmBndVPjTLPBL1uUnc5QetF9UX6aqUZvSR1rU8meq1Xsat9LvggGyn4SgVWuAWfJf
         6UbhAjp9QVOYvEZCCD8dThOepYE9APWFu8d4i4RptI+9L3oVk3HOFfw7NY+ocaI7SlUv
         e4MQzNvZhE3mGIviAUd7DFwo35r5Ced1rEmVLPnj2Xcfw7OZSqi0CELQwkGbMfRWDH20
         AePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mWXKa1Sc5p1hrgsJYkTBC6jHOzmU2VYIHQ189M5bCl8=;
        b=VPvcuoOSH40fa6k581e2mctY2qyRw028jodDYpISpzo7GuG3yDYzIVUGRzUja2cqUv
         TZC/rL9DwgUOdiICKh7UN5zFMs+zj7xQzMc5QVMUkpoWDdZOgaQZUFDZAt9ky6U12lU0
         GVkXkZ62nEn1c4irhBF1Frt6EO3oLfJStjy7+zeGiw/kbOyCiQGA34nsrAx+uDYp74HD
         hIQcJXLnDbIgjq2V06xOgPRVUGAE0t/ahamzg04H3GS0IRDWeo9O1URlY+gnJT2qzMPV
         Jmy73k+lkUycXRdaWVcihPlkaCtAwyYj49t/bqUtEPrcEQNWL6/x+cA38SXeOws0rfob
         iu4w==
X-Gm-Message-State: AOAM531Nlps618G7i75Yj44bKfYsB3NpsuKXRMoG0wCrx+fjiF4J8+VI
        PipM4fE/21uZW7W/0N6doJf58cKUrqH21HsQt9N5QQ==
X-Google-Smtp-Source: ABdhPJy8TR2k9stPFavLcEBznOdYZ50ocCZzA4WyKUk3uhElv0WUTjILlRKiYWhL72kWmRPCg+awRBwflXIl0wGbKYs=
X-Received: by 2002:a05:6638:2653:: with SMTP id n19mr5797350jat.34.1596210707994;
 Fri, 31 Jul 2020 08:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200730205657.3351905-1-kafai@fb.com> <20200730205754.3355160-1-kafai@fb.com>
In-Reply-To: <20200730205754.3355160-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Jul 2020 08:51:36 -0700
Message-ID: <CANn89iLA5vongVK=kgS2creh+BiA821YfiiixkC1wa3QGCmvgg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 9/9] tcp: bpf: Optionally store mac header in TCP_SAVE_SYN
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 1:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch is adapted from Eric's patch in an earlier discussion [1].
>
> The TCP_SAVE_SYN currently only stores the network header and
> tcp header.  This patch allows it to optionally store
> the mac header also if the setsockopt's optval is 2.
>
> It requires one more bit for the "save_syn" bit field in tcp_sock.
> This patch achieves this by moving the syn_smc bit next to the is_mptcp.
> The syn_smc is currently used with the TCP experimental option.  Since
> syn_smc is only used when CONFIG_SMC is enabled, this patch also puts
> the "IS_ENABLED(CONFIG_SMC)" around it like the is_mptcp did
> with "IS_ENABLED(CONFIG_MPTCP)".
>
> The mac_hdrlen is also stored in the "struct saved_syn"
> to allow a quick offset from the bpf prog if it chooses to start
> getting from the network header or the tcp header.
>
> [1]: https://lore.kernel.org/netdev/CANn89iLJNWh6bkH7DNhy_kmcAexuUCccqERqe7z2QsvPhGrYPQ@mail.gmail.com/
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
