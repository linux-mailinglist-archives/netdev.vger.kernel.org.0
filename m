Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B22B49B939
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585904AbiAYQuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586464AbiAYQtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:49:39 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1039C061793
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:46:35 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id c6so63418957ybk.3
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pk7dhqoTEmDOwNBtN7wWMsiKc977E7Kmuf33gW4rhuQ=;
        b=rzr5anZMM1Km5QmoiMWaFpPT4o1zjVJVVlVx6Iv+gfpjo3K4MbGm6aDed8zlPApdU+
         JsCqALWZlJWmorVZk9YpDKIZr6r/s/PsaS5G9BRo3HRh8H0HMo6LhtKveBXNNSAPiOAM
         Xdi0v9BcnYKaY51hpsLzg//NBFOCPC/yfwxFSac6oDuNmwKvNkAzl3tdGlN4pf3QxZyJ
         40ghX6GMV6Y2JX+BMUESG/VFERH7TT9ZDGvT9z86Pf6O6Lav2mtNBw/kvX78DnXkFOPp
         hDgDHa5+sFJR5EiLBqgBdtihduQXkVRtq0fIBaXMBOKMnGRpaF1cFPf1nVHkpiYNKSvx
         OO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pk7dhqoTEmDOwNBtN7wWMsiKc977E7Kmuf33gW4rhuQ=;
        b=NPSTj7LBJsH6usdYZ171WRimJ1Eq421pxKVO6xiaj96+lUJB/1ige46x+AKiC2BiFb
         kuDy/3YOKqpXEMqAZYYDq6BFDy5EvoDsqLP9nEuTcsZHaoLi9OzqVhAF+c8mc1MIMHxQ
         pHBjOV0MDQwzdckeNR7zYic31chalxAYedYbRqSi7RggvuhdUYTFoe3zxrCxdBTpigNj
         cFCeKJT1Hhbu8gqCLcsad3L2tMILk8ANF+1ygYxH5c+PjchR5hFq/PhkXFr4l6aswfI0
         Tfgmb6QoYXDcK1oM/vFSwA74WDRvLXRGe5RhJnvpE/n3SaEZUCEaVTrXO7+004qDXk2O
         m4cQ==
X-Gm-Message-State: AOAM533K8fIZCqnCalEAd68x7YRvMBmjuiuIKBol+3Q0CXKX0vZyLBm3
        zANnNRQ+y6BR9D4JqaBJ5XU4Ts2hM8VqlsnlHZriolgUVFk=
X-Google-Smtp-Source: ABdhPJxNsjHwCdLwpLK/aA8Zab9OKjGbj/1PKvffFAOXMJ98o7fVFuGP2uAXG4xVyauKoYZaqEq/9q54r6n1nf2UF1g=
X-Received: by 2002:a25:b683:: with SMTP id s3mr30544650ybj.293.1643129194785;
 Tue, 25 Jan 2022 08:46:34 -0800 (PST)
MIME-Version: 1.0
References: <20220125024511.27480-1-dsahern@kernel.org>
In-Reply-To: <20220125024511.27480-1-dsahern@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 25 Jan 2022 08:46:23 -0800
Message-ID: <CANn89i+b0phX3zfX7rwCHLzEYR6Y9JGXxRYa92M8PE9kbtg8Mg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Adjust sk_gso_max_size once when set
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 6:45 PM David Ahern <dsahern@kernel.org> wrote:
>
> sk_gso_max_size is set based on the dst dev. Both users of it
> adjust the value by the same offset - (MAX_TCP_HEADER + 1). Rather
> than compute the same adjusted value on each call do the adjustment
> once when set.
>
> Signed-off-by: David Ahern <dsahern@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>


SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
