Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D524A9CFF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376604AbiBDQet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236680AbiBDQes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 11:34:48 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCA7C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 08:34:48 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id j2so20567366ybu.0
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 08:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+inoZ6G55cv0L/G3FtMl61q53XdfSUeWLxW65gEhofM=;
        b=E44OQ8g9UHVjH/FPLgbtA7EbCrlh06DgMcnK3zE7vypZZ6+7Zapme87i3jAhHIeMM8
         3YwE11xuioYpOwuFnGAtAFjPrGlhhhyyynZlREcznus5HKvqdGYM0RYEmC1hVsGwc0kf
         16GGzANutH1abju0D6/0t2eRRQBBm/Wc1dRRd9QGm0mwH/j1Vr43bVlmLDX714PFiJdp
         /b+APRnB5uCzI9+H3i//GVRtYpHCz3vEqDyq4XOfqj6Qw9Nv6S57Zdt9HFFiugNDUTbp
         +g99DwpJp0C05d+FCHNIgZbsjVI0qpZQiQaNaudzrq+Z9jj1FZyWQ1ibDjgLrggb6R8O
         QVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+inoZ6G55cv0L/G3FtMl61q53XdfSUeWLxW65gEhofM=;
        b=MAGOkv39U5NZcYUeDNO7Ji3AJPSqILeNsUFYXADdrmbKZZ77PYUX7YAGmU0fX82ukB
         YW/enORP/DwNCO/0mt5e0RrhTgp1/Q3FVxA1FvrLPwpkfnIMbUdXnv9yFJGHLmIYU/Zh
         W6enC4UTzBs+TofvIO3y36Y/Y4SW+3/hpV9LowytkSt0STRvOgNHiU3opOJhKUWnGeYh
         q++rQg3LFgdMoRPvsykHQH4shj3RdDBCSOd9x2bL+QFd8CA61mKeXu/YsyDPI7OzUPbO
         HwfRs7CWVMNgtCAIL5UkazXaP+myKKS3+208O0jTRQy3jBk0OjNNu5A4BREdaBdHD1U+
         tx6w==
X-Gm-Message-State: AOAM532e/75muOUNMLACWqEts9cprsHQ3NSWLZqSaVc9opCZI3An4lia
        0gJi5PU5jWZPRLV2gWxFIKje8Z47DiaoxurTCIXKZw==
X-Google-Smtp-Source: ABdhPJz8uU7WWX/yJ6cvm6+RB6InCL6zDx3ChBdnwrrL4MtAI7NOxY3p0aLajHff1vY/8nzOSfLdByDKXh28frmHkCs=
X-Received: by 2002:a25:3444:: with SMTP id b65mr3492658yba.5.1643992486708;
 Fri, 04 Feb 2022 08:34:46 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643972527.git.pabeni@redhat.com> <9903ebc67ba39368d7a1e93681c65305d868232c.1643972527.git.pabeni@redhat.com>
In-Reply-To: <9903ebc67ba39368d7a1e93681c65305d868232c.1643972527.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Feb 2022 08:34:35 -0800
Message-ID: <CANn89iK_HbZVCpjD2=yivkYXf5n_BoSSiaQqKAq4uxETwrtRjA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: gro: avoid re-computing truesize twice
 on recycle
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexander H Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 3:29 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> After commit 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb
> carring sock reference") and commit af352460b465 ("net: fix GRO
> skb truesize update") the truesize of the skb with stolen head is
> properly updated by the GRO engine, we don't need anymore resetting
> it at recycle time.
>
> v1 -> v2:
>  - clarify the commit message (Alexander)
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
