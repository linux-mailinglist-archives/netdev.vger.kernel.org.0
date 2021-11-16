Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D24529DD
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 06:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhKPFk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 00:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbhKPFkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 00:40:42 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC67FC0E6479
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 18:57:34 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id w29so34485713wra.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 18:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MzAij31W9B3XKGFqlAtXQ6ERlu6BOm9NGEpEVcT3O8M=;
        b=ARz9RwzbivbmPLwT4LNDSSOfBEmhDhN+gkTAzgmYdBBEgzODQBc8IZ9z19zDStna4r
         XREK+FADIpBuzuoJHAmnkWDD0rNPmZCVJlbIzZmLCYMpnJO1E+EP6FSRAeGqn34iauzy
         5zcbZfGf3bb4qPBKMleB67/I6ltM1U9RXMYIV3PLq552xG4odZ9kcF72EjKOQU0dBXZT
         K/N4ArYa+AeWwCla5RTYT9vqjkbNOULIIEKqd2AEYW6WVzkgwkSXC0AZQXvoqwNjKV1B
         r2DN0MWJgxfAOAcEGKC9lYLNyAQU28AfXH8SSg3ejUzTx4qxjExwD9ehaxGx+YqbN+Z7
         W6gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MzAij31W9B3XKGFqlAtXQ6ERlu6BOm9NGEpEVcT3O8M=;
        b=mJaxMkgnh7DVI7jNackcFIgGIfO6LgJZTJMtlZFV2JBC7MJg9kXzJtZGfGMY3+twU9
         kmk+DuUvfo+9ClTlc8xPH+zEb+8j0Qfay3Jmu2VGHYR+lofgm2KKvIm8Lfl0inFNJyGx
         LKjmyz7gRFI28wJg088Yodo19ICaKkUUC79w8tNUsJjfCATItGrmCLUvyf/AdBJkZBfz
         MJuJtZFyzUbnK2GBXRIrTSXEDfYZfI0Icx3IIB95fFyWsDiF/nxt+Xp83kukZDM/ANRZ
         GHwPYp7nBQaFRs5+FXANfJqg8TaL4nyrSeplM5gs87YttKRpjZjy8vwlLpQvtDEITPCa
         eR1Q==
X-Gm-Message-State: AOAM532A+KSdtPpZL5y3WLi3PblCFO0yhc0q0vBzZuE0PgnZJu9DY+KH
        NU5VTR7V2RXaImozsiQIwmoiBPH5AAwQ1GuFflt7VQ==
X-Google-Smtp-Source: ABdhPJx3PTmpf+Y9Huq4bQcXu1oPXF2olDHxdActSoh6ftC1BMIhrGWdnJSXGBnHesh6b0Ey34u027YQXWAm52kCsrs=
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr5355179wrq.221.1637031452909;
 Mon, 15 Nov 2021 18:57:32 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <20211115190249.3936899-3-eric.dumazet@gmail.com> <45a9fde2-5c6d-dd9c-00a2-2681d0a8ab40@gmail.com>
In-Reply-To: <45a9fde2-5c6d-dd9c-00a2-2681d0a8ab40@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 15 Nov 2021 18:57:21 -0800
Message-ID: <CANn89iK8p-ZogyBF81M7nEnh=KEDZqS1s=5qzYmfb_J-BGDf-Q@mail.gmail.com>
Subject: Re: [PATCH net-next 02/20] tcp: remove dead code in __tcp_v6_send_check()
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 6:48 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/15/21 12:02 PM, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > For some reason, I forgot to change __tcp_v6_send_check() at
> > the same time I removed (ip_summed == CHECKSUM_PARTIAL) check
> > in __tcp_v4_send_check()
> >
> > Fixes: 98be9b12096f ("tcp: remove dead code after CHECKSUM_PARTIAL adoption")
>
> Given the Fixes, should this go one through -net?

It is only removing dead code, and going through net-next is not a big deal.

No real 'bug', just a way for me to point out that we had a similar
change in IPv4 for years and nothing bad happened.
