Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B1833BA68
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhCOOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbhCOOIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:08:11 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C844C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 07:08:09 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id k184so1287003ybf.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 07:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rZa7oXn8FPO12VZ0x64x4sDQ8vnUc61eKClZmqwcy/8=;
        b=YxjrSEubUAWmz8dp1NOmxpXDk5b8Z4P3CFmBATBSq186oB/IpfhhDmT4ad6wedN0jk
         PgTYE3T6a1w+01B0dssXWKHkgA0VIAipeKCw31mE60yywu+mRbybnEYn44yznsUcEfun
         DxHcgBoKYUtrZ2HIFT6aLbsXxA0RHM9u8DkX3SbiToxNfCdt00ZoY0tB0AWskphN1ZhZ
         k15eEbEvB0rxfDApgf1Fgmz7TEtEb3Rd5kVwpOSXeOQwQvljcIRm9ZqFcZ2h8+ApCdFT
         XsABOeii4WJ32dqGndCtpeBYNDeOZuJwyk7bcY8wyhBSM6Ot8LCuMgWURHXDMBV7zMTj
         DjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZa7oXn8FPO12VZ0x64x4sDQ8vnUc61eKClZmqwcy/8=;
        b=Oo0FvfE9dYm5TRt46O8jFFs0lyDOFp/U46+8KZKUEE1H4RPPCCw0iQEIL/qA/bkebv
         qr+O5nT38AGdUrJgBEWTNyt4p6sS18xG9+7/OosRjKjZqaiYJ0II9Y4JQIbipSBJ1jYA
         EflGtIgubhJJCqzJIw89DXG295TDsmG2JLwEAI6l1wfIaTCgsoRMsNVTYPeNGPSpoWcz
         CiJUt1yU5yCkSqCKMoN7h2rvob7tEVleCa9PyhD/jIyIxuphgGep+RYjsxE1OdzIv350
         iQqlBsft7G/oRullISjtXZckCK4N1QQjCCuL+i3VanOU6JzEUIZgX+96MSmikVR/IEqY
         Qg2w==
X-Gm-Message-State: AOAM5302Z15T0Z4rRvm5O4Fjx9OmhcjVnx5eXJgoxYmGI5Erm3bq7wC+
        A0kZCqZyTINnGyreDRVvbNfpdSPfrXDROV/H7bmfMixcLq1ShA==
X-Google-Smtp-Source: ABdhPJy+zwM77JSkOf1b7F3VOLb1cLCryV24+2qHKGuifbhpjtO1V/EVLNQ6i1WbVqCNYU/qjL4BzJYFOFom7eck+jA=
X-Received: by 2002:a25:ccc5:: with SMTP id l188mr39929936ybf.253.1615817287556;
 Mon, 15 Mar 2021 07:08:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210315110545.111555-1-ovov@yandex-team.ru>
In-Reply-To: <20210315110545.111555-1-ovov@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 15 Mar 2021 15:07:55 +0100
Message-ID: <CANn89iKUUT0ZwMKrS6BzL_35Pjz0G5T8jd6pt6q3=f=LiDWzvw@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: relookup sock for RST+ACK packets handled by
 obsolete req sock
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, zeil@yandex-team.ru,
        dmtrmonakhov@yandex-team.ru, olegsenin@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 12:06 PM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>
> Currently tcp_check_req can be called with obsolete req socket for which big
> socket have been already created (because of CPU race or early demux
> assigning req socket to multiple packets in gro batch).
>
> Commit e0f9759f530bf789e984 ("tcp: try to keep packet if SYN_RCV race
> is lost") added retry in case when tcp_check_req is called for PSH|ACK packet.
> But if client sends RST+ACK immediatly after connection being
> established (it is performing healthcheck, for example) retry does not
> occur. In that case tcp_check_req tries to close req socket,
> leaving big socket active.
>
> Fixes: e0f9759f530 ("tcp: try to keep packet if SYN_RCV race is lost")
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Reported-by: Oleg Senin <olegsenin@yandex-team.ru>
> ---

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
