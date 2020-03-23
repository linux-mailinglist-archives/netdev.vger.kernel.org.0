Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9F018FC36
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgCWR7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:59:52 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:43409 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgCWR7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:59:51 -0400
Received: by mail-vk1-f193.google.com with SMTP id t3so4044180vkm.10
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 10:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N1lNiHO6xPgUYO8vpSF+umT+MsS9oLeQwMA1IUK4msY=;
        b=oac+Na4QF5JdaT66BiopNbxc1KdXssKfiBlw2slQLPbJQBivpZ0EN0e6Sgvlv3MlYt
         LFkGEQSOGmkteEnbM8Sa5xhzWzDoK40s+TbvrvTQ4l0I2NLeiOBlHX3V2ZDM+gX9fHCA
         dE2zVE+twtdZnNDIfr1GiogTDw8RQHAcUZxP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N1lNiHO6xPgUYO8vpSF+umT+MsS9oLeQwMA1IUK4msY=;
        b=K/SGjjXuLOama+oRzbXJ5Ko1mDXBAQCJbdLvaPY6WBQHcQXptMHG+Glnz6JT56mE7J
         7LqUwio5JuWdwflDIslEovkLcvkbgRGFOxnJG4b22pPPQ7qLlXs/0azBVPEv6UJry2xC
         6VtYUNJoF5nXfUs2+M0dm1VbbjUMi4qENW+Ne6Ep5/3EwIxlpOyvin5Y9u2VZKckwYJe
         ybUQtsHyMPeqIsuI4QchFdQA+kXm2rM/Tg9oS8RqQfy7HUsSDLm/FqvB7Wn+PsrPhY+v
         bm2341Zy5Iob4DVFnGSrKXhadIPYsHqUGAWA5yy66/GGR2dDtyhCAvSb+Iw5jlGHOiHb
         +bpQ==
X-Gm-Message-State: ANhLgQ0NWSJwPvM/eVyncWVynn974yDqwiXTclMkcK5vPU70yFiv7X/S
        xX9kkYzGc6gbbvl3x03DRHrfpzs4ziNO9uvthf8w3A==
X-Google-Smtp-Source: ADFU+vuVSdd2udzk4DKElzSYL+hMRvTEKcwyCXXYbubzZcZarmIuxkLsTjU4cHyyKYLHSKOKQBZQbz5oZXm8FdykO60=
X-Received: by 2002:a1f:43:: with SMTP id 64mr15772046vka.100.1584986389210;
 Mon, 23 Mar 2020 10:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200320000713.32899-1-abhishekpandit@chromium.org> <DB1736FA-94F3-4BD7-806E-7AC2E25D7D1E@holtmann.org>
In-Reply-To: <DB1736FA-94F3-4BD7-806E-7AC2E25D7D1E@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 23 Mar 2020 10:59:37 -0700
Message-ID: <CANFp7mXaWKpsNPFZ9kNC5PVZO+LbzvjoTb4ivcb4EjzMbaKNhg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Bluetooth: Suspend related bugfixes
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Marcel.

On Mon, Mar 23, 2020 at 10:50 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > After further automated testing of the upstreamed suspend patches,
> > I found two issues:
> > - A failure in PM_SUSPEND_PREPARE wasn't calling PM_POST_SUSPEND.
> >  I misread the docs and thought it would call it for all notifiers
> >  already run but it only does so for the ones that returned
> >  successfully from PM_SUSPEND_PREPARE.
> > - hci_conn_complete_evt wasn't completing on auto-connects (an else
> >  block was removed during a refactor incorrectly)
> >
> > With the following patches, I've run a suspend stress test on a couple
> > of Chromebooks for several dozen iterations (each) successfully.
> >
> > Thanks
> > Abhishek
> >
> >
> >
> > Abhishek Pandit-Subedi (2):
> >  Bluetooth: Restore running state if suspend fails
> >  Bluetooth: Fix incorrect branch in connection complete
> >
> > net/bluetooth/hci_core.c  | 39 ++++++++++++++++++++-------------------
> > net/bluetooth/hci_event.c | 17 +++++++++--------
> > 2 files changed, 29 insertions(+), 27 deletions(-)
>
> both patches have been applied to bluetooth-next tree.
>
> Regards
>
> Marcel
>
