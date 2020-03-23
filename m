Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F3A18FD57
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCWTK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:10:56 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:35441 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbgCWTK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 15:10:56 -0400
Received: by mail-vs1-f66.google.com with SMTP id m9so9556871vso.2
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 12:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1tp3bC93e0nUfPggrmvnMYoBNQ6UWOR58w4LV4ZhNS0=;
        b=QZFAJNVnkEz6tJ6FzoGWo4cS0Tr0c2wT3Gyl8gMiNmkTeIqbKiWYsC2rYDsKnGt2e8
         t0G0SzWlbvcpkKDxM0HH2DVdv5P7T3kTpraFDN528g94nBDdv0LJS3W0wP8SJBTPgyTD
         qgcvi04yAeh1TRoLfUD0Y6hp2xFWkCWWHiQaI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1tp3bC93e0nUfPggrmvnMYoBNQ6UWOR58w4LV4ZhNS0=;
        b=gNwAk3XNLrAdqWPKt1SSoJ0Jx9xE/uXOyEIXgYrTbJVdK52yrWkV9CfHxMDIJwrWHl
         YWTlRHEndbgdns/vMZlt7TBfP9ELXABYDRQLS75nzc/4VC2KqEbJavkoCNRms+2H9qZK
         K0gN/zZs/Ni6CXCytw4S4IgtjFUqcvouR1w4sCOZ+i/NpcaRnSNqXfe+X+M6y9Q5OTrk
         gGEPdYdlR9N53uYqE42YP1OtolZplUPv/LjjGrWALURTMoDEj4KKg1aICfWq53F78Nu0
         ilXNzSpaFoJ1PpvnFuHIf//WeaU0aCH7rMe8XJfQZv2+66E6JxI0/yXsd7eanxFxCxP7
         QHSA==
X-Gm-Message-State: ANhLgQ3dTLkqwdz1L8JolmQVsYQ8JZx2b/tGg/ancrU8UQM2f7/UU7yI
        E2MxMDbdNlU7958K3CmP8hrSFx6fBHiBUSKfN7/aCQ==
X-Google-Smtp-Source: ADFU+vuXszqaXED87ZaiMONJXX8a5RIeucsij/ir43q9RdI+5nS8boUUKde8aIEelt/LyWxeF7BRDsbfceIVon8FCw0=
X-Received: by 2002:a67:c01e:: with SMTP id v30mr17629845vsi.71.1584990652351;
 Mon, 23 Mar 2020 12:10:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200320231928.137720-1-abhishekpandit@chromium.org>
 <20200320161922.v2.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid> <C09DCA09-A2C9-4675-B17B-05CE0B5DE172@holtmann.org>
In-Reply-To: <C09DCA09-A2C9-4675-B17B-05CE0B5DE172@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Mon, 23 Mar 2020 12:10:40 -0700
Message-ID: <CANFp7mXG1HXKNQKn2YTsEOX6puNz=8WY6AHWac4UOiVMVQyEkg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Bluetooth: Prioritize SCO traffic
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 11:58 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > When scheduling TX packets, send all SCO/eSCO packets first, check for
> > pending SCO/eSCO packets after every ACL/LE packet and send them if any
> > are pending.  This is done to make sure that we can meet SCO deadlines
> > on slow interfaces like UART.
> >
> > If we were to queue up multiple ACL packets without checking for a SCO
> > packet, we might miss the SCO timing. For example:
> >
> > The time it takes to send a maximum size ACL packet (1024 bytes):
> > t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
> >        where 10/8 is uart overhead due to start/stop bits per byte
> >
> > Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666.
> >
> > At a baudrate of 3000000, if we didn't check for SCO packets within 1024
> > bytes, we would miss the 3.75ms timing window.
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> >
> > Changes in v2:
> > * Refactor to check for SCO/eSCO after each ACL/LE packet sent
> > * Enabled SCO priority all the time and removed the sched_limit variable
> >
> > net/bluetooth/hci_core.c | 111 +++++++++++++++++++++------------------
> > 1 file changed, 61 insertions(+), 50 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index dbd2ad3a26ed..a29177e1a9d0 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -4239,6 +4239,60 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
> >       }
> > }
> >
> > +/* Schedule SCO */
> > +static void hci_sched_sco(struct hci_dev *hdev)
> > +{
> > +     struct hci_conn *conn;
> > +     struct sk_buff *skb;
> > +     int quote;
> > +
> > +     BT_DBG("%s", hdev->name);
> > +
> > +     if (!hci_conn_num(hdev, SCO_LINK))
> > +             return;
> > +
> > +     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
> > +             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > +                     BT_DBG("skb %p len %d", skb, skb->len);
> > +                     hci_send_frame(hdev, skb);
> > +
> > +                     conn->sent++;
> > +                     if (conn->sent == ~0)
> > +                             conn->sent = 0;
> > +             }
> > +     }
> > +}
> > +
> > +static void hci_sched_esco(struct hci_dev *hdev)
> > +{
> > +     struct hci_conn *conn;
> > +     struct sk_buff *skb;
> > +     int quote;
> > +
> > +     BT_DBG("%s", hdev->name);
> > +
> > +     if (!hci_conn_num(hdev, ESCO_LINK))
> > +             return;
> > +
> > +     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
> > +                                                  &quote))) {
> > +             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > +                     BT_DBG("skb %p len %d", skb, skb->len);
> > +                     hci_send_frame(hdev, skb);
> > +
> > +                     conn->sent++;
> > +                     if (conn->sent == ~0)
> > +                             conn->sent = 0;
> > +             }
> > +     }
> > +}
> > +
> > +static void hci_sched_sync(struct hci_dev *hdev)
> > +{
> > +     hci_sched_sco(hdev);
> > +     hci_sched_esco(hdev);
> > +}
> > +
>
> scrap this function. It has almost zero benefit.

Done.

>
> > static void hci_sched_acl_pkt(struct hci_dev *hdev)
> > {
> >       unsigned int cnt = hdev->acl_cnt;
> > @@ -4270,6 +4324,9 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
> >                       hdev->acl_cnt--;
> >                       chan->sent++;
> >                       chan->conn->sent++;
> > +
> > +                     /* Send pending SCO packets right away */
> > +                     hci_sched_sync(hdev);
>
>                         hci_sched_esco();
>                         hci_sched_sco();
>
> >               }
> >       }
> >
> > @@ -4354,54 +4411,6 @@ static void hci_sched_acl(struct hci_dev *hdev)
> >       }
> > }
> >
> > -/* Schedule SCO */
> > -static void hci_sched_sco(struct hci_dev *hdev)
> > -{
> > -     struct hci_conn *conn;
> > -     struct sk_buff *skb;
> > -     int quote;
> > -
> > -     BT_DBG("%s", hdev->name);
> > -
> > -     if (!hci_conn_num(hdev, SCO_LINK))
> > -             return;
> > -
> > -     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
> > -             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > -                     BT_DBG("skb %p len %d", skb, skb->len);
> > -                     hci_send_frame(hdev, skb);
> > -
> > -                     conn->sent++;
> > -                     if (conn->sent == ~0)
> > -                             conn->sent = 0;
> > -             }
> > -     }
> > -}
> > -
> > -static void hci_sched_esco(struct hci_dev *hdev)
> > -{
> > -     struct hci_conn *conn;
> > -     struct sk_buff *skb;
> > -     int quote;
> > -
> > -     BT_DBG("%s", hdev->name);
> > -
> > -     if (!hci_conn_num(hdev, ESCO_LINK))
> > -             return;
> > -
> > -     while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
> > -                                                  &quote))) {
> > -             while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> > -                     BT_DBG("skb %p len %d", skb, skb->len);
> > -                     hci_send_frame(hdev, skb);
> > -
> > -                     conn->sent++;
> > -                     if (conn->sent == ~0)
> > -                             conn->sent = 0;
> > -             }
> > -     }
> > -}
> > -
> > static void hci_sched_le(struct hci_dev *hdev)
> > {
> >       struct hci_chan *chan;
> > @@ -4436,6 +4445,9 @@ static void hci_sched_le(struct hci_dev *hdev)
> >                       cnt--;
> >                       chan->sent++;
> >                       chan->conn->sent++;
> > +
> > +                     /* Send pending SCO packets right away */
> > +                     hci_sched_sync(hdev);
>
> Same as above. Just call the two functions.

Done

>
> >               }
> >       }
> >
> > @@ -4458,9 +4470,8 @@ static void hci_tx_work(struct work_struct *work)
> >
> >       if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> >               /* Schedule queues and send stuff to HCI driver */
> > +             hci_sched_sync(hdev);
> >               hci_sched_acl(hdev);
> > -             hci_sched_sco(hdev);
> > -             hci_sched_esco(hdev);
> >               hci_sched_le(hdev);
>
> I would actually just move _le up after _acl and then keep _sco and _esco at the bottom. The calls here are just for the case there are no ACL nor LE packets.

Then we would send at least 1 ACL/LE packet before SCO even if there
were SCO pending when we entered this function. I think it is still
better to keep SCO/eSCO at the top.

>
> Regards
>
> Marcel
>
