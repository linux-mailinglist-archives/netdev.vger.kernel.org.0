Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E66301E1B
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 19:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAXS1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 13:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbhAXS07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 13:26:59 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA3CC061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 10:26:19 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id j67so2604242vkh.11
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 10:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UAkEDtlQ5yuUlRRmD1TBwNh+PfUWubxFOonrUnGHlyg=;
        b=YTn2MAZK1yrZZEtPuJl2ZllC4jC6eab1DTa36PJQBm/3b1HtO9cbK+Sm7T9N9nlUBc
         oPQwcMFsYVMf/wbsay8cdw0/gdklr/LS/0xzKUgb1le1rHyVF+Te2vZXJWPlW5la/tdi
         M1B8Uia1lWnOdx0gpTESxm86ChfJDEhSJhTWmO/A5rj1nVRmvc/os6adpIqKj3Oej4Yw
         YkaiBNvvIPD5vQ/cw02BWMcLR9g2Fcl3UTva8/fE/z9UI4f7ZW00ccje2eKABspJCBjW
         5x0ugcAaf2vEgM3YTGubh3KcUpoTs0w4lHMbzdA116gJY1xXmODCRfnYS8U8Puc7Rn88
         xP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UAkEDtlQ5yuUlRRmD1TBwNh+PfUWubxFOonrUnGHlyg=;
        b=eRHQWMJDo9UHtPMydPFabrrZs3+ioSVY5j1bCgE96BiiBYHnR/NcrAzAH928GZRxL7
         ZNgclO3jmXKqlDMorlnmjhn4MFUj1ktMGZQLlFL3MQbVWlJQFmIQpwk1gzpxpTHEGczs
         ZnHJCCrQxXshiMDqZXyDx1JGiQh26PzyoPR0LBuaPx0oHw7l1ZtMtDRdBKBEFvPYffJL
         VzXYJg83RnddQC6C4kHKWHIEbzY9AafIFiu0V/raX0zQOx2mmDsQAAcfjv06AQtGlZW2
         SlBkevHfJtXt+z7as9EzXeYGM9ToVTZWtAOOEa0dSbuXBGs7XCVG0A+4v50/8YFq19gW
         541w==
X-Gm-Message-State: AOAM5318HXdjF2ZVLOw78r0msaNbO2tAdwQhjH7ab3g2ZmZ9AOa0Je71
        n1t/3Q8ht2Of3Ax7BBH9T9eSIkvZqza3KHBML5h1Hg==
X-Google-Smtp-Source: ABdhPJyGbNHjh9EPDS4AAGX/wvRrCvsWdNhRtJssI3h9UKZFUlMXVbg0oJrHqGxaaRooGHPccoD95XfFnBqRzha1nI4=
X-Received: by 2002:a1f:4901:: with SMTP id w1mr57576vka.17.1611512777831;
 Sun, 24 Jan 2021 10:26:17 -0800 (PST)
MIME-Version: 1.0
References: <1611464834-23030-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611464834-23030-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sun, 24 Jan 2021 13:26:01 -0500
Message-ID: <CADVnQynaaO5SyM=Lvax8A_OZ7328P9dY=6dNGEJznV7Okdk1Lg@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp: fix TLP timer not set when CA_STATE changes
 from DISORDER to OPEN
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 12:11 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Upon receiving a cumulative ACK that changes the congestion state from
> Disorder to Open, the TLP timer is not set. If the sender is app-limited,
> it can only wait for the RTO timer to expire and retransmit.
>
> The reason for this is that the TLP timer is set before the congestion
> state changes in tcp_ack(), so we delay the time point of calling
> tcp_set_xmit_timer() until after tcp_fastretrans_alert() returns and
> remove the FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer
> is set.
>
> This commit has two additional benefits:
> 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> avoid spurious RTO caused by RTO timer early expires.
> 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> timer is set.
>
> Link: https://lore.kernel.org/netdev/1611311242-6675-1-git-send-email-yangpc@wangsu.com
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
> v2:
>  - modify the commit message according to Yuchung's suggestion
>

Thanks, Pengcheng! This seems to be missing the Fixes tag, but I guess
the maintainers can add it:

Fixes: df92c8394e6e ("tcp: fix xmit timer to only be reset if data
ACKed/SACKed")

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
