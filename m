Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4275F373F57
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhEEQPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbhEEQPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 12:15:10 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E2CC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 09:14:13 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id o27so2026490qkj.9
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 09:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JxTHlbm4WKHqk+xGKq+ygsRkmHxeCfrcVr5ByQaa41M=;
        b=h0VOH/ZUw2e16TvQANv0GphYyvJ8+yl9RqR+2ftE3tX3EEY6e7BchvwpJmQd3r3OBX
         QR9E4uL7ES3DKcmBjEVktml+uO2UAcwxStw/9VaC5iamWRCTAjjkdkh+f0Thc4WrBDqQ
         hLcHc3r5Okk5Zcwi3qTws548DgLqW2IVixVSMbmVnJc0Uzda2Aypg81c3vpCTOviF49Q
         sFJDzBdYo1trdAZdvDQfTabSyGnF/yErJoDPaURnaQ/Z+7/c3U2ZEJnoNeCg9KzJxxrO
         kcWS9ryoK4vDjV9TCjWQeJOHmJBXmHI/u6G7TqHLQEr37RB20vNE03Xub91fPYw0xQHt
         uwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JxTHlbm4WKHqk+xGKq+ygsRkmHxeCfrcVr5ByQaa41M=;
        b=buCJidRzFNIkXLEzKF1Qo5h9CyHXSdZFH5g+tAVfqVaOVDG1GKzJ7hMXgmjg1BbXb6
         bcWoN7mjH9vqdXskSjg+AU9rcPPP9pPBIxX3/T5v+zq11WcypNkiSrLdr9K1ta49VIZR
         Wg3V1oYY/nUFMa9g18IZbYXxMYaTrWubmYlAoRkwYgQLvB2Sp5KT7MdV7wY+aukNla4O
         P1QOnq159jbU67Xf5OdEzwJ9LZR0kWhTs1bxyNCZcStOQbC8TcPKjredyebRECgSoltL
         Rn4C2WZRrnsihMaQO8equwxQjHSBD9sr8MZZvIVMaAzttk3wguNp7B6QkSiXMOxcf6e/
         g3+g==
X-Gm-Message-State: AOAM530nLDgfCVXBZocu1dOATxqt3q7tdsDqiF772zTpyTKnLImnnf3G
        0tBqT54v1F7K7mtMG+uirJ3a9T92RMX48OYAeIBWXsqD
X-Google-Smtp-Source: ABdhPJzvQUMFQ68GJSiVBLIk11yM06dI9TWbbrCIQ78+oz9XkgD6vBBkgDVWhORJCzeTTRLlLrFr1ZDCiuVt/05+4fg=
X-Received: by 2002:a37:9d86:: with SMTP id g128mr19643402qke.141.1620231252690;
 Wed, 05 May 2021 09:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620223174.git.pabeni@redhat.com> <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
In-Reply-To: <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 May 2021 12:13:36 -0400
Message-ID: <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 11:37 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> While segmenting a SKB_GSO_FRAGLIST GSO packet, if the destructor
> callback is available, the skb destructor is invoked on each
> aggregated packet via skb_release_head_state().
>
> Such field (and the pairer skb->sk) is left untouched, so the same
> destructor is invoked again when the segmented skbs are freed, leading
> to double-free/UaF of the relevant socket.

Similar to skb_segment, should the destructor be swapped with the last
segment and callback delayed, instead of called immediately as part of
segmentation?

        /* Following permits correct backpressure, for protocols
         * using skb_set_owner_w().
         * Idea is to tranfert ownership from head_skb to last segment.
         */
        if (head_skb->destructor == sock_wfree) {
                swap(tail->truesize, head_skb->truesize);
                swap(tail->destructor, head_skb->destructor);
                swap(tail->sk, head_skb->sk);
        }
