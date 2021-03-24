Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68233480EC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbhCXStn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237522AbhCXStP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:49:15 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA575C0613DF
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:49:14 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id a15so11873445vsi.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2xQeOsBIewt8ZgUK9t8HEZ9lSbkOzfS8qbc/ekQA/6k=;
        b=g1SQTFNnKeuOKt+oNIwnqTljgmASJYgdu5HhzDRCfulgYaksQOv1CpA9JUWHEOfsR9
         wKr4dgj9ZG60AbA1Fsm8lRvR59XN7+YXCws1G9lufH3Jl8jbRmB4BYe50pM+CxhjlFAB
         /xeeke8NCCswPdWLTCsP1b/aGDLHAZ+O+sEfG79G0kj9OhB//aspZvJ/5SnCQOzLAXOZ
         vc4v9yBFQB7v9p9EnqMbT05rVP4X2aDqbXB/XObhWh5Iutjr9o4MH+gUdM3sCeSVjbdo
         roRVYwhEW5M8pzT7jlKxjjvfX80Onh1Xx3nDlOV5W6hW6NRPd44XuiTmdwVrbDFPYQyz
         tcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2xQeOsBIewt8ZgUK9t8HEZ9lSbkOzfS8qbc/ekQA/6k=;
        b=l+G9wpdH8n9PXv4gdmpTcxhgGIKGSfOXyP8KkPwE5EHQ7fJZZdmeYgK13qx/ZyTVyI
         tFMJryfk/sAJHGMS/OosUlOPXM25E6Sncj39L42+BMO1Mbv654lGTLYFrDUqa2Zkbd7a
         4aShzVt7Zc4MTaslq15dZRPpX1ZoFTXIwg2NlJbirUYWt+hgioSxE2NAR1gTUZxr/JBX
         pkVSaPQhxl6XipnZ5Ofr/REZrR2u1p8jTsoowz9S14bdVdWFEcM0mPRlAoAl02kaxoSe
         lPkoOpV7GhrMW7ldGHvV7x1Nxes7NPcZjPBjnYuWqYTLk8HIw2EjBbmlNCFE01VTh35C
         /I/A==
X-Gm-Message-State: AOAM5339IGyRhQPkIBYoyKd7AOia+IVSwcDEc7ub4dI4gFiJBvDBf4R/
        IuCjsjQwQjkJ6bsUHt8/6IZ9w467MgsBS1pHQT4xww==
X-Google-Smtp-Source: ABdhPJwGan1W0m9mZstMi1JdW4zm0+2vYu8Z3FKLGhV/7CiqgQ2dlLGOKgSMScz/C0X2MqKpoacwj28dDqe7KsR1TX0=
X-Received: by 2002:a67:6786:: with SMTP id b128mr3102602vsc.9.1616611753841;
 Wed, 24 Mar 2021 11:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210323141653.1.I53e6be1f7df0be198b7e55ae9fc45c7f5760132d@changeid>
 <8E70C497-BDCE-471F-9ECD-790E2FE3B024@holtmann.org>
In-Reply-To: <8E70C497-BDCE-471F-9ECD-790E2FE3B024@holtmann.org>
From:   Daniel Winkler <danielwinkler@google.com>
Date:   Wed, 24 Mar 2021 11:49:02 -0700
Message-ID: <CAP2xMbseUhKhxdw93Q320euOdUZ39GtpiHNy49m_p0U7j58u8Q@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: Always call advertising disable before setting params
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marcel,

Thank you for the feedback. I have just sent a V2 with a btmon snippet
showing the HCI Set Advertising Parameters "Command Disallowed"
failure that occurs as a result of this issue. I tried to provide some
annotation for context. Please take a look.

Thanks!
Daniel


On Wed, Mar 24, 2021 at 12:06 AM Marcel Holtmann <marcel@holtmann.org> wrot=
e:
>
> Hi Daniel,
>
> > In __hci_req_enable_advertising, the HCI_LE_ADV hdev flag is temporaril=
y
> > cleared to allow the random address to be set, which exposes a race
> > condition when an advertisement is configured immediately (<10ms) after
> > software rotation starts to refresh an advertisement.
> >
> > In normal operation, the HCI_LE_ADV flag is updated as follows:
> >
> > 1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
> >   __hci_req_enable_advertising, but hci_req configures an enable
> >   request
> > 2. hci_req is run, enable callback re-sets HCI_LE_ADV flag
> >
> > However, in this race condition, the following occurs:
> >
> > 1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
> >   __hci_req_enable_advertising, but hci_req configures an enable
> >   request
> > 2. add_advertising is called, which also calls
> >   __hci_req_enable_advertising. Because HCI_LE_ADV was cleared in Step
> >   1, no "disable" command is queued.
> > 3. hci_req for adv_timeout_expire is run, which enables advertising and
> >   re-sets HCI_LE_ADV
> > 4. hci_req for add_advertising is run, but because no "disable" command
> >   was queued, we try to set advertising parameters while advertising is
> >   active, causing a Command Disallowed error, failing the registration.
> >
> > To resolve the issue, this patch removes the check for the HCI_LE_ADV
> > flag, and always queues the "disable" request, since HCI_LE_ADV could b=
e
> > very temporarily out-of-sync. According to the spec, there is no harm i=
n
> > calling "disable" when advertising is not active.
> >
> > Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> > Signed-off-by: Daniel Winkler <danielwinkler@google.com>
> > ---
> >
> > net/bluetooth/hci_request.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> > index 8ace5d34b01efe..2b4b99f4cedf21 100644
> > --- a/net/bluetooth/hci_request.c
> > +++ b/net/bluetooth/hci_request.c
> > @@ -1547,8 +1547,10 @@ void __hci_req_enable_advertising(struct hci_req=
uest *req)
> >       if (!is_advertising_allowed(hdev, connectable))
> >               return;
> >
> > -     if (hci_dev_test_flag(hdev, HCI_LE_ADV))
> > -             __hci_req_disable_advertising(req);
> > +     /* Request that the controller stop advertising. This can be call=
ed
> > +      * whether or not there is an active advertisement.
> > +      */
> > +     __hci_req_disable_advertising(req);
>
> can you include a btmon trace that shows that we don=E2=80=99t get a HCI =
error. Since if we get one, then the complete request will fail. And that h=
as further side effects.
>
> Regards
>
> Marcel
>
