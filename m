Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7181FC21C
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgFPXFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:05:34 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6492C061573;
        Tue, 16 Jun 2020 16:05:33 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id u25so136313lfm.1;
        Tue, 16 Jun 2020 16:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sp9lrnnNM8GZ75C2Sg5RKMdsbyVY5BHjy26aAWj8tkM=;
        b=Slw6adyE49VLxNBJ+ZGH5n4kSEmE0B82abgEubgYWNdVVPMV/wAb3yu0oh96b1FbJQ
         1xtlLicEjzq96EJM2FpS5S2pRjgQD6aFE5GxvUV1qgdFbXmcRjpxwdL6swexQHQm4H8i
         TYUeJ1Ov7d6YRZJFNwwk8sd6Et+E80eBloBrd3iX4fqsoCnCpl/v04iOqgEk3+FKWlqM
         fVzl3q+eZD9pTZGWIhPAU5Zec60H4NruRtYjqx8Vf2XHhc2tzYeocd9BNony8pLns33m
         /KKkuI7gr63FmWSDyFSvTDYlhngUtRiYhwRETHj4cMVx6NWAO4EDKolHWw5lMP1N/tZQ
         gg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sp9lrnnNM8GZ75C2Sg5RKMdsbyVY5BHjy26aAWj8tkM=;
        b=cGaCf0meZ+NXuJgSmkh4ysAVcjznaaIDR5LtatT//mtra/XvpA5nsPLydglVDJMt0F
         O/Xh4H6mhpE82s29VLpenlfco3jqdfwA6La3UQe1WohQTWWkoU9X1F26RxSs6FSZY6Z8
         Tz2K8htvTMs/xXV/GBwhfBipv6vzetLnGB0qFHbbaoBKcXzxaBEm5ZhdyJ54676AEpx+
         JY1QTUWI2OCSyzhsauOQyaVmY2EvoMJHK4qLkJxqODe5Tw4Y3m6T7Z/mgzerDM/GbFV9
         vJiPcCLgMu24i/CRjodOEI/wLeCek1HCSi/k8U/+mZaKaj5y5qWv1TKkMM1K1TSv6Bn0
         zYtA==
X-Gm-Message-State: AOAM531m7AexayMaPcWfi8QVXM9Erz/kDRUzVM56vdFfU3XGkPrzLgIH
        61Y1wmpZSnIhpU2caoLqt5kQE2x44/t1BH8P6WI=
X-Google-Smtp-Source: ABdhPJxyd65n4ikrdcSIeQr1v1Svm25qyupgfHJ8QzBsNNQgQ05vw43Wok+thYCutv+fRCegkcx8acA3yDuR1owaMvw=
X-Received: by 2002:a19:8307:: with SMTP id f7mr2885389lfd.174.1592348732397;
 Tue, 16 Jun 2020 16:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200616225256.246769-1-sdf@google.com>
In-Reply-To: <20200616225256.246769-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jun 2020 16:05:21 -0700
Message-ID: <CAADnVQLS7=UmT9ivyuUiq8i9ZJRUyPNhN0dvdeiF32sUi=A3NQ@mail.gmail.com>
Subject: Re: [PATCH bpf v4 1/2] bpf: don't return EINVAL from {get,set}sockopt
 when optlen > PAGE_SIZE
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Attaching to these hooks can break iptables because its optval is
> usually quite big, or at least bigger than the current PAGE_SIZE limit.
> David also mentioned some SCTP options can be big (around 256k).
>
> There are two possible ways to fix it:
> 1. Increase the limit to match iptables max optval. There is, however,
>    no clear upper limit. Technically, iptables can accept up to
>    512M of data (not sure how practical it is though).
>
> 2. Bypass the value (don't expose to BPF) if it's too big and trigger
>    BPF only with level/optname so BPF can still decide whether
>    to allow/deny big sockopts.
>
> The initial attempt was implemented using strategy #1. Due to
> listed shortcomings, let's switch to strategy #2. When there is
> legitimate a real use-case for iptables/SCTP, we can consider increasing
>  the PAGE_SIZE limit.
>
> To support the cases where len(optval) > PAGE_SIZE we can
> leverage upcoming sleepable BPF work by providing a helper
> which can do copy_from_user (sleepable) at the given offset
> from the original large buffer.
>
> v4:
> * use temporary buffer to avoid optval == optval_end == NULL;
>   this removes the corner case in the verifier that might assume
>   non-zero PTR_TO_PACKET/PTR_TO_PACKET_END.

just replied with another idea in v3 thread...
