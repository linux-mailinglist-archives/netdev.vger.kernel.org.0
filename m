Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD802DC573
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgLPRjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbgLPRjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 12:39:36 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D54C06179C;
        Wed, 16 Dec 2020 09:38:55 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id s85so13397953vsc.3;
        Wed, 16 Dec 2020 09:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivcK08caZZpoN1ZixfR4m9AZkXskR+IDVI5I3mZZ1W0=;
        b=Q2WhlXpSOrFAkTIkgLomhRbAzVNJqXIUKy94qMUMY36tCt+P6iNHZKbt/cVcgoYXJC
         t3T3ZnnwH5Al6wB6BFQ+1WTKkSfqdT06cn4Fm3K4ngN0bJX9vvtEu4gar1QKoYnwSKhe
         KheBc3UDbmplodeawzH8TtMN9qepBrwI+vwkXobEdD95X5TjyUAfJs4+53Ru7/LslhLZ
         uXwz9hEtXIsL7WmhZCWSsMs20Ek5QE57Oiq4nrabuIgfmH2YhmKzo02OcDfe5mj+cYaO
         DxIkrv0Jkm2I9yY1YIuAYA8I85NfbLlFhYdtjra7Ke6Lu4o2QYnV8K+V99vw/CIYTfmn
         xc3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ivcK08caZZpoN1ZixfR4m9AZkXskR+IDVI5I3mZZ1W0=;
        b=kD7FY0G5VnzbHy7iR0jnl21Jx6+stktrq6qHuYlr7QjHtSjMrteYS7I4abAdcVV2aW
         e9+cnDibVjgJyu26WTdnsBjfK/R2o/zw2EX1mOaWd13NeVjZQAX4PnaJaY0nG2dkizBM
         0eE1ZRJqQL00Go3k0Mdfhn6scUHsCPcxF4a0Yw2Ovihz/+p2GMkO3CpWAj299VfwawgH
         s4QcZ1I/CPm9JoErWguR0x0gFFWSkNN0jKDCaCRmqvr+r/NxWQoSw9Ej9DG4h7CgKF/D
         kh0or3/LWkerjMaX2q2VN3IHPKF99JnyJvrAxaXxfcPtvO8XBrjElycFKxDnsGDBKrRp
         kcEg==
X-Gm-Message-State: AOAM533fPDY1Erx7QLbwyDLh2sTVD2TRjiLKTxUSsyyY1zddl1UrnyLp
        R3/Decied3iFWdnbnFLIICd+fE+LuyPQrLq4M+yMNdvmbrk=
X-Google-Smtp-Source: ABdhPJwMPTgBMnfNCuaCTKzi+sbAcAtDhCA5OB3Cih3KNZ+T+fXP4wmG9GCoVvDZ53HAtUnRf4jTwdTDsDjszoMOJKs=
X-Received: by 2002:a67:507:: with SMTP id 7mr26156541vsf.42.1608140334981;
 Wed, 16 Dec 2020 09:38:54 -0800 (PST)
MIME-Version: 1.0
References: <20201215161954.5950-1-TheSven73@gmail.com> <20201216090316.1c273267@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216090316.1c273267@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 16 Dec 2020 12:38:43 -0500
Message-ID: <CAGngYiUCpMoROFCXaE+Mkaf-EnWa_WT3a1mo1g+hK+TNYEFZHg@mail.gmail.com>
Subject: Re: [PATCH net v4] lan743x: fix rx_napi_poll/interrupt ping-pong
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Dec 16, 2020 at 12:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Applied, thanks Sven.
>
> I'll leave it out of our stable submission, and expect Sasha's
> autoselection bot to pick it up. This should give us more time
> for testing before the patch makes its way to stable trees.
> Let's see how this idea works out for us in practice.

Thank you !

While I believe that this patch is sound, I can also understand
your caution: it's not a simple bug-fix, and I also don't
have the opportunity to test this on x86.
