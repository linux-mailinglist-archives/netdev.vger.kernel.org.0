Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9B43FCCC0
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 20:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhHaSHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 14:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhHaSHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 14:07:16 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE34C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:06:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s11so17544173pgr.11
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 11:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=74EgbStd2JXgEibsoKNguM6+KY5W9PCFXp4q2NTThqs=;
        b=PBMCW4QOQVjUiVsIs2OgSS4SKFyw/LcqYTYOaxTVi7zARRd33dmk0cHlvkmruc2w+W
         j5eCZmB5Brit0fXhG7GvJzkgC0lp5WpEEx1Yu/FruvWPIUgg3PPu3GcVNnkqyYYxpI65
         IyDPxs0Mn0Dpmtgi4dyEWH7aSi38IaBg+FhFXuvIcNFtSaUEUJwlSN8AMKwLXlrP2F4K
         L5+G69zvxEsbTY1ICrb5CQh6Pcoa3yRJEgC7yNgmZeSWDJ/fNEJ2TUNMvtF9HKxYa8sH
         pWa8zF4YvgBa0hfayAnAB/NsvZd32BiWFzY0aAK2ZdnPCWVobRxSrmJZFoF9rX6If+yU
         o1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=74EgbStd2JXgEibsoKNguM6+KY5W9PCFXp4q2NTThqs=;
        b=Koiw/JDw6W8blMIXCLGgdP3EIxLIWBE6jb0TVZbSYySVaCoemLH1z4fq6gvvEY4NoQ
         2fNQ2uO6PNluOUp8bn3mtwzvf107rV/ATssmF89gMsizOumlu3DGq4ow2X4nrg/i4+1o
         FpEvpRfmgxAeWWqDPnoLMO4LrS4tujyfgHrhXuOKIOP8xmNMfK/kK0RCBXSxXwivfrm6
         oOj3tu7uKRkfhRMBG7vTNtoU831wFsyVynGlIZUun5Js0nPWWuCMKkUfJMhtrXA2dQuD
         Gbw/9WUuZkgGmjfpuh+L+dXFCRR47nAKN8FNAqZOPPlg7ghk4u4UQKMEVjkLFRXJKZ7I
         kioQ==
X-Gm-Message-State: AOAM532s2FLq4nJgyGD8PrCcK4Q6+MnJzgfmlmyEtdwvz6SWZHOGhRxt
        g4WrCjF3IJSYxtlNqdMhwtRBVz9gwczNpbyxH7A=
X-Google-Smtp-Source: ABdhPJyE+qk+uQXwMv7YDWi9AbDXMlZwUX6wL6J2DznACtneA0cP/cZI9Qkhh+xGmmsgXX2rxs999MBvVZpmn6xjlhY=
X-Received: by 2002:a62:520e:0:b0:3e2:1c21:f1ba with SMTP id
 g14-20020a62520e000000b003e21c21f1bamr29710679pfb.78.1630433180979; Tue, 31
 Aug 2021 11:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210830172137.325718-1-eric.dumazet@gmail.com>
In-Reply-To: <20210830172137.325718-1-eric.dumazet@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 31 Aug 2021 11:06:09 -0700
Message-ID: <CAM_iQpUVr8XxtMU_P1Lo7iUo7eGtor7xRNsMA8yKqPE+CzoYxQ@mail.gmail.com>
Subject: Re: [PATCH net-next] af_unix: fix potential NULL deref in unix_dgram_connect()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 10:21 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> @@ -1805,6 +1807,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>
>                         unix_state_unlock(sk);
>
> +                       sk->sk_state = TCP_CLOSE;

Does this need to be moved before the unix_state_unlock()?

The rest looks good to me.

Thanks.
