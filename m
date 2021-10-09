Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFF7427790
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 07:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244289AbhJIFjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 01:39:15 -0400
Received: from mail-yb1-f175.google.com ([209.85.219.175]:44782 "EHLO
        mail-yb1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhJIFjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 01:39:14 -0400
Received: by mail-yb1-f175.google.com with SMTP id s64so25518242yba.11;
        Fri, 08 Oct 2021 22:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIghcbJ60FBCmsTSZcidGZHdsZIgJ4C2Kwndg3+KdLc=;
        b=GSRQ1Iaf1jcG6jkjDcE0B8hBNwjtTQ4mbDh4TEU1M0ryezASe86tpYTv9qBlFiPagV
         0mOzC2xtjSIGX/LLi4BHeLJy0yDZkYncrVPdPuUleydzjo0GGcOF1zXVENu9wwUi8mr0
         QFCfJwknKg16eYQ19JaarW9giEtkdoIJCNn36fsdUT6BKWgRP17/fRIVV4SlgUaKA1iN
         f6QEw1wJP0XwSwpMn3LNUnUHrE0XkFp0zJlCWyNAgQdRU10qXhL40FqSD0ZyQsIfhHPv
         DuUS9Dk8SJi5XuhcFayv/JGNevgGZcnQrqeZdjcyIx3jgzOfj1ylaI0wQ6d7cP5FAUaZ
         Pdeg==
X-Gm-Message-State: AOAM532jXNoziPEEQG1Xma1tenb3tIzCE3M5Toi64XQfIIcIviqsRT9d
        HI1KThQXJpoZ2J45OshLZ4NdIbJiw/XNgA0vSsajTDd22nk=
X-Google-Smtp-Source: ABdhPJwapPhvRWOK7oAubzYHeJAPIsGJxNM1/egYo2N66jARLGywT7RkiLRh5RujnE7WH05gmBL1JvYmHW5mG+9ozEE=
X-Received: by 2002:a25:4146:: with SMTP id o67mr8514459yba.113.1633757837390;
 Fri, 08 Oct 2021 22:37:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211003044049.568441-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20211003044049.568441-1-mailhol.vincent@wanadoo.fr>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sat, 9 Oct 2021 14:37:06 +0900
Message-ID: <CAMZ6RqKm+nLPd2oHgNebeDh2hSOMVnV7cJn12FM6NLpVaOz2iA@mail.gmail.com>
Subject: Re: [PATCH v1] can: netlink: report the CAN controller mode supported flags
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun. 3 Oct 2021 at 13:40, Vincent Mailhol <mailhol.vincent@wanadoo.fr> wrote:
> This patch introduces a method for the user to check both the
> supported and the static capabilities.
>
> Currently, the CAN netlink interface provides no easy ways to check
> the capabilities of a given controller. The only method from the
> command line is to try each CAN_CTRLMODE_ individually to check
> whether the netlink interface returns an -EOPNOTSUPP error or not
> (alternatively, one may find it easier to directly check the source
> code of the driver instead...)
>
> It appears that, currently, the struct can_ctrlmode::mask field is
> only used in one direction: from the userland to the kernel. So we can
> just reuse this field in the other direction (from the kernel to
> userland). But, because the semantic is different, we use a union to
> give this field a proper name: supported.
>
> Below table explains how the two fields can_ctrlmode::supported and
> can_ctrlmode::flags, when masked with any of the CAN_CTRLMODE_* bit
> flags, allow us to identify both the supported and the static
> capabilities:
>
>  supported &    flags &         Controller capabilities
>  CAN_CTRLMODE_* CAN_CTRLMODE_*
>  ------------------------------------------------------------------------
>  false          false           Feature not supported (always disabled)
>  false          true            Static feature (always enabled)
>  true           false           Feature supported but disabled
>  true           true            Feature supported and enabled
>
> N.B.: This patch relies on the fact that a given CAN_CTRLMODE_*
> feature can not be set for both can_priv::ctrlmode_supported and
> can_priv::ctrlmode_static at the same time. c.f. comments in struct
> can_priv [1]. Else, there would be no way to distinguish which
> features were statically enabled.

Actually, can_priv::ctrlmode_static can be derived from the other
ctrlmode fields. I will send a v2 in which I will add a patch to
replace that field with an inline function.

Yours sincerely,
Vincent Mailhol
