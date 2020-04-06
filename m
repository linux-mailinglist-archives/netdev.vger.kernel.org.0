Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2519F669
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgDFNGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:06:21 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41117 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbgDFNGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:06:20 -0400
Received: by mail-lf1-f68.google.com with SMTP id z23so11766405lfh.8
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 06:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7GN1YoLzsFU98PWBZxI+qjFmWQa/AZo0+frFBCofsJg=;
        b=xXF6AYFcB3ozl4D4kdHrr50LF1ZbAzFYv2AWyEbx3VdXDZdEgAFF7g0GDyLvkZ+X7j
         9M/LLUMmEvEJ+qwYkX6OKJl8UnuYxFGk4437Ue0Ul/SYyGtNWU7yTlR+xtE+DeHL70uz
         o/zUDbyphURIF0pjMrhsCPT56gpy6uSvJGGicPccenUoejHO1g+XCkhVV/i9rx+YuZ5I
         K+mVTdeE1Wfk1fuHpjfF9cqq8xZEiCTxBUeIO7f8sAiH5NUd6zch0P4a/7lr1XXvWGOj
         +3RM5Q/rtssVNH9lNrYeJ3ZVOEt5xNEfo2PQLvqeK27IvWeb8CsbnBf9e1uDbuPgiyEr
         jnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7GN1YoLzsFU98PWBZxI+qjFmWQa/AZo0+frFBCofsJg=;
        b=Ppfk6sIBik7FWbjvb6vY2O5bbr1olsF0o3GAbYH0WsXA6Y/0UaiA+tjHEXCDmXlgYH
         Fp6u3yxbVMPLlxDSasy11RpnZiHCbzCZLD9DO9D9UOK7+iMf0rfOZ4mH9LoZ2dtQRnmY
         1uXfuiTzNpjVp+A+DVPPGk8BJ3Wi1vBKOiNoX970DPH6O5xW3XM83kQi2UteQwyI8C2G
         vFrXgzJOGq5Yu4kCVLhbgdIX7aVngMgDpLzT3zFdtKrhBzIw4tQWlRrZYehmTGMy3Vul
         Ix2VbwmydcZVEuqzZf0A2+KnbhGSuNcXUR+pcd9xuxycccR3nD/2g7rE5b42O/2DRRHU
         Pm4g==
X-Gm-Message-State: AGi0PuaNSxn64Ya9iWILBn/H8X+rNUxoEqieMkK5bEMYTKp3R0leLZxa
        BjDZPhZn2Qx0OMRRJI0gqDOI3zJWYKrD6vIUoGBPkw==
X-Google-Smtp-Source: APiQypIK+bczDzGTeHW+lSUpdUeHqY1a2BN2ay+VHidmedYNAGHtBDA28bQ7bJLCQZwbaQ8u6riJa2KPaTes9V8Xvos=
X-Received: by 2002:ac2:5f63:: with SMTP id c3mr12844845lfc.15.1586178378339;
 Mon, 06 Apr 2020 06:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
 <87ftdgokao.fsf@tynnyri.adurom.net> <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
In-Reply-To: <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 6 Apr 2020 18:36:06 +0530
Message-ID: <CAFA6WYMxKUXjhAfK6pTu9merNwUaKmQp6_FaTmW4e=kfTMthmw@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Matthias=2DPeter_Sch=C3=B6pfer?= 
        <matthias.schoepfer@ithinx.io>,
        "Berg Philipp (HAU-EDS)" <Philipp.Berg@liebherr.com>,
        "Weitner Michael (HAU-EDS)" <Michael.Weitner@liebherr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Apr 2020 at 18:17, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
> >
> > >     user-space  ieee80211_register_hw()  RX IRQ
> > >     +++++++++++++++++++++++++++++++++++++++++++++
> > >        |                    |             |
> > >        |<---wlan0---wiphy_register()      |
> > >        |----start wlan0---->|             |
> > >        |                    |<---IRQ---(RX packet)
> > >        |              Kernel crash        |
> > >        |              due to unallocated  |
> > >        |              workqueue.          |
>
> [snip]
>
> > I have understood that no frames should be received until mac80211 calls
> > struct ieee80211_ops::start:
> >
> >  * @start: Called before the first netdevice attached to the hardware
> >  *         is enabled. This should turn on the hardware and must turn on
> >  *         frame reception (for possibly enabled monitor interfaces.)
>
> True, but I think he's saying that you can actually add and configure an
> interface as soon as the wiphy is registered?

Indeed, it's a call to "struct ieee80211_ops::start" just after wiphy
is registered that causes the frame to be received leading to RX IRQ.

>
> The "wlan0" is kinda wrong there, should be "phy0" I guess, and then
> interface added from iw?

Okay, will update the sequence diagram.

-Sumit

>
> johannes
>
