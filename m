Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07523F1617
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbhHSJZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:25:17 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:36603 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhHSJZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 05:25:16 -0400
Received: by mail-lf1-f46.google.com with SMTP id r9so11475552lfn.3;
        Thu, 19 Aug 2021 02:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILYDCppuvFZoKFobc82YakJdHXPK2hb0yUNeKSxvHzo=;
        b=N76JFLUtC2/HHO9Rxxkoxri46r0j4GUjLSa1Xlq4cLqOqnNl864gBi9Ra6A3RyWdHO
         WToSI8wyCEaJaNLkXetVwsxZPZQf3kP8xnGVmucRbFG3G86rOibHzGmzUUlGgHnPh4Ax
         itaq5bFLdDMZQDvw86138YsNDarnsrh1L43wa32cmSOb15WseA8aHN7jVP7lZn/UU+5r
         nz7XUnPZxkKk83ypeL9XxKZzcq06DIy0Ix92KTdINIyHP7PWQCy+7poIti3+O82PrpC7
         ATR2sG71d8QPs+QNLvSpRNTQh53H9POOh+No8iOTKyHIHabxTpjejV1QXOOxl1n1AiWG
         oaNw==
X-Gm-Message-State: AOAM5304xotFbE9afFbkX2uqa4iVA9XrYLG1/7+/W4uOrPo+twDIH9Aq
        ddUfNV+PaIly7PP6IJol8t0+CjJNQKER4BUl7LRzJpuuumo3Vw==
X-Google-Smtp-Source: ABdhPJx0oHSXYAd8W7hO0TM69SuIG7H5yBKVoSOniXVHQ2SQp7tDENYABHsqD3ZibNHGPVLycv5ngyB9FkaA0XM2wuQ=
X-Received: by 2002:a05:6512:3aa:: with SMTP id v10mr9936420lfp.393.1629365078821;
 Thu, 19 Aug 2021 02:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-2-mailhol.vincent@wanadoo.fr> <20210819074514.jkg7fwztzpxecrwb@pengutronix.de>
In-Reply-To: <20210819074514.jkg7fwztzpxecrwb@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 19 Aug 2021 18:24:27 +0900
Message-ID: <CAMZ6RqL0uT7tNNxRjAYaUNrnsSV6smMQvowttLaqjUrOZ5V1Fg@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] can: netlink: allow user to turn off unsupported features
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 19 Aug 2021 at 16:45, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 15.08.2021 12:32:42, Vincent Mailhol wrote:
> > The sanity checks on the control modes will reject any request related
> > to an unsupported features, even turning it off.
> >
> > Example on an interface which does not support CAN-FD:
> >
> > $ ip link set can0 type can bitrate 500000 fd off
> > RTNETLINK answers: Operation not supported
> >
> > This patch lets such command go through (but requests to turn on an
> > unsupported feature are, of course, still denied).
> >
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> I'm planing to send a pull request to net-next today. I want to do some
> more tests with this series

Ack, I am also preparing a new version. But first, I am just
waiting for your reply on the tdc-mode {auto, manual, off}. :)

> but this patch is more or less unrelated,
> so I can take it in this PR, should I?

FYI, the reason to add it to the series is that when setting TDC to
off, the ip tool sets both CAN_CTRLMODE_TDC_AUTO and
CAN_CTRLMODE_TDC_MANUAL to zero (which the corresponding bits in
can_ctrlmode::mask set to 1).  Without this patch, netlink would
return -ENOTSUPP if the driver only supported one of
CAN_CTRLMODE_TDC_{AUTO,MANUAL}.

Regardless, this patch makes sense as a standalone, I am fine if
you include it in your PR.


Also, if you want, you can include the latest patch of the series as well:
https://lore.kernel.org/linux-can/20210815033248.98111-8-mailhol.vincent@wanadoo.fr/

It's a comment fix, it should be pretty harmless.


Yours sincerely,
Vincent
