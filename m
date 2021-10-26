Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8623F43A9C5
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhJZBiu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Oct 2021 21:38:50 -0400
Received: from mail-yb1-f176.google.com ([209.85.219.176]:33735 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhJZBip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 21:38:45 -0400
Received: by mail-yb1-f176.google.com with SMTP id v7so30881380ybq.0;
        Mon, 25 Oct 2021 18:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BBHYpRYDcXzID9sqdCZj+7QsUaSOUi23oDk/EOybqZg=;
        b=nXpZ1OXWH0k1QF4g7HdNRweV1/lv3dfnmEbLkpXh3Lhlg6tpxvymz3AOk29TmMvRIG
         U19EK366X4XMNOSqdrc7hlMOt5JzHaDFhPjFtG/tEdKsLr7gZ9uaeDnuCQQUkjDBl+eu
         AKUufo6oNsDFfssUiVBA2Tzeb/Jx74iWXZ/ZHDVpSLc7jfw2q9JJxAiJGACabp8qdM9d
         sKdLSoKc+vG+FCSRnYsRD1Wra53jhwbNCnkzKM9bfD8i0xwp115mQhw0uK4sqBFoZgBr
         xwi2Gmbm3ZJXd/IQduS9bbcZJ6mTI9lhRSIBv8kdWLsKwxptVek3fA7L41cjrvm5p9eO
         Ew1Q==
X-Gm-Message-State: AOAM531VByFWgwz+UUVNMiuDVlND65Q28Y/HMTOeGT/+sZVF3cOayrHZ
        wJ6CCxGuxJIjSMQSBI473EktaWdSzmvULLWsp+gxZtzlkkA=
X-Google-Smtp-Source: ABdhPJxQpQAPe3qJ6FgG3PVVRMLZeCgtO/zr3KsBmlZOwlIjNj/t+hTHd8fmLChxc4y7tmLfuMOMW60ru5o4S30wMlM=
X-Received: by 2002:a05:6902:72d:: with SMTP id l13mr13302212ybt.499.1635212181572;
 Mon, 25 Oct 2021 18:36:21 -0700 (PDT)
MIME-Version: 1.0
References: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
 <20211009131304.19729-2-mailhol.vincent@wanadoo.fr> <20211024183007.u5pvfnlawhf36lfn@pengutronix.de>
 <CAMZ6RqLw+B8ZioOyMFzha67Om3c8eKEK4P53U9xHiVxB4NBhkA@mail.gmail.com> <20211025190651.p4ivcrqinknmwuu5@pengutronix.de>
In-Reply-To: <20211025190651.p4ivcrqinknmwuu5@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 26 Oct 2021 10:36:10 +0900
Message-ID: <CAMZ6RqJ4b6JM5rNeXhECkLWa6Af2pBXvGqsfZm673vO02dUuZA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] can: dev: replace can_priv::ctrlmode_static by can_get_static_ctrlmode()
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 26 Oct 2021 at 04:06, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 26.10.2021 02:22:36, Vincent MAILHOL wrote:
> > Welcome back on the mailing list, hope you had some nice
> > holidays!
>
> Thanks was really nice, good weather, 1000km of cycling and hanging
> around in Vienna. :D
>
> > And also thanks a lot for your support over the last
> > few months on my other series to introduce the TDC netlink
> > interface :)
>
> The pleasure is on my side, working with you!
>
> > Le lun. 25 oct. 2021 à 03:30, Marc Kleine-Budde <mkl@pengutronix.de> a écrit :
> > >
> > > On 09.10.2021 22:13:02, Vincent Mailhol wrote:
> > > > The statically enabled features of a CAN controller can be retrieved
> > > > using below formula:
> > > >
> > > > | u32 ctrlmode_static = priv->ctrlmode & ~priv->ctrlmode_supported;
> > > >
> > > > As such, there is no need to store this information. This patch remove
> > > > the field ctrlmode_static of struct can_priv and provides, in
> > > > replacement, the inline function can_get_static_ctrlmode() which
> > > > returns the same value.
> > > >
> > > > A condition sine qua non for this to work is that the controller
> > > > static modes should never be set in can_priv::ctrlmode_supported. This
> > > > is already the case for existing drivers, however, we added a warning
> > > > message in can_set_static_ctrlmode() to check that.
> > >
> > > Please make the can_set_static_ctrlmode to return an error in case of a
> > > problem. Adjust the drivers using the function is this patch, too.
> >
> > I didn't do so initially because this is more a static
> > configuration issue that should only occur during
> > development. Nonetheless, what you suggest is really simple.
> >
> > I will just split the patch in two: one of the setter and one for
> > the getter and address your comments.
>
> Fine with me. Most important thing is, that the kernel compiles after
> each patch.

Yep, the v3 [1] compiles fine after each patch. The only limitation is
that I could not do a runtime test for rcar_fd and m_can (second
patch of the v3 [2]) because I do not own the hardware.

[1] https://lore.kernel.org/linux-can/20211025172247.1774451-1-mailhol.vincent@wanadoo.fr/T/#t
[2] https://lore.kernel.org/linux-can/20211025172247.1774451-3-mailhol.vincent@wanadoo.fr/


Yours sincerely,
Vincent Mailhol
