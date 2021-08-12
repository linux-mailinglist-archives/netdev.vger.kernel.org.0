Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771163EAD35
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 00:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbhHLWgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 18:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhHLWgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 18:36:18 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E4CC061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 15:35:53 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id w17so14970949ybl.11
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 15:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2a7U/F9KpO4iwjZdv59naOpd7yKffBbAI4cM2w/UriE=;
        b=cxUhJjrujnXjYVOuBfR8kEyws3anmj9jxRX83zvYl83hS1UFpTGjbbvts5jzrHeaaQ
         qGjS/28nWb8vV6IKJ/mQrDCxikBgpqvcr8PEK261BTLfYD/mwd7lR4ycGbtxY1JpJlak
         WknW0d+4d52W/Q5P6aXdwQ6ucwFWvB4yEZhf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2a7U/F9KpO4iwjZdv59naOpd7yKffBbAI4cM2w/UriE=;
        b=jLpQmKvciLphScDuL4V/hxydIP4TCgixtarZIjLOk0XA41WhW1aiF+VERvcChfICRe
         +Ep6qZjJOxmYaKaw9uJlFNEJQ6KMHrDyiEkl/riZBxiY8shhCYNzJIE4jf+bIOkh5nMf
         HuKCfHsAlFXAiMpxosD1IMl/KcJq43fs2vIcTwUnkGD6ReJBcRJIxqdQgbtYoVSDtQ6Q
         szJwT0KZ/UqhxpHMl5DUeVmazyYaZt2y4j5nvsCNqAnG8mvK1ikbVXnGFrbe3TuPjs4R
         qzdan/6bp0mwiLAn8Hart2Ps2hBREbNKwu4iNxfipeZlWN92AU5BFp8lNMQwYeWx+HQI
         GBNA==
X-Gm-Message-State: AOAM533a/Wd93WebThpqCXMKJn6PFc+fFiUAOK74FOuAOkbDzmDzUiC5
        493wSatQrp3Wibl9ieq8jNu1XNKukwqg/+BkyE+gj093xgg=
X-Google-Smtp-Source: ABdhPJz7O7XZa5g3RQ5BGx6qyb6eVOzv8AmSl9PqQSYnBGO8SWiQzPJqdTf1FZ/hYw9uwZNGz2Dp/+xeCj2MWJt78qY=
X-Received: by 2002:a25:c2:: with SMTP id 185mr7950391yba.148.1628807752337;
 Thu, 12 Aug 2021 15:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210812214242.578039-1-kuba@kernel.org>
In-Reply-To: <20210812214242.578039-1-kuba@kernel.org>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Thu, 12 Aug 2021 15:35:15 -0700
Message-ID: <CAKOOJTywyN7+6udvgYLmt_coYNZvN-Tkk+UyPMSMOaZFxw4gzg@mail.gmail.com>
Subject: Re: [PATCH net v3 0/4] bnxt: Tx NAPI disabling resiliency improvements
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Regards,
Edwin Peer

On Thu, Aug 12, 2021 at 2:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> A lockdep warning was triggered by netpoll because napi poll
> was taking the xmit lock. Fix that and a couple more issues
> noticed while reading the code.
>
> Jakub Kicinski (4):
>   bnxt: don't lock the tx queue from napi poll
>   bnxt: disable napi before canceling DIM
>   bnxt: make sure xmit_more + errors does not miss doorbells
>   bnxt: count Tx drops
>
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 98 ++++++++++++++---------
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
>  2 files changed, 62 insertions(+), 37 deletions(-)
>
> --
> 2.31.1
>
