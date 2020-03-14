Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90DC185353
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCNAa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:30:26 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:40639 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbgCNAaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:30:25 -0400
Received: by mail-ua1-f67.google.com with SMTP id t20so4338488uao.7
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 17:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CSSGOQFqUBsEuqw+/YaPcaGtY5lpq/pZIaOm5vuOo4Y=;
        b=J4iIL1s/0t+a9p/MlqikrAVweJ0NzOkvjgXkcPcWbzoT6YC/USZnu6oztXCsx0mJaX
         FUZOoRwAiuDE3bTamYUrHJln4Aup8BBjgidW99M+YRz4t3slAK043/elWi4Qm0BOBGEF
         ww2nHT2MrQENe3fLNI19vxrnH/5bavH0ok7ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CSSGOQFqUBsEuqw+/YaPcaGtY5lpq/pZIaOm5vuOo4Y=;
        b=gXJunAn2q9lPXJRjSnQpHKamefQGXdF+TaMmxeoO5NO0nPuyDPhk760hN2ekKjxHnn
         y8bLVzWtWUq2qcdP3580ZH5pvo8wEg5OjfXBoUS3lbTlk+2AXV/VOW6t1JQByf5cBcee
         GUACERmDtR2TGPUyMfQVjIS0sAtlR1ImHoXAlUk8RMNWEGUgugpsgzNltzFNAzhnrKTU
         MRR5HtZ5yR5pmovgggM9FCyiOYkMkQwQaundS7c1aVie0/2gAhDU1iZ/by6ciq9R4o1b
         yYjIRc34XhMn0G0i3CJ337hPCnAuRQmGOzv7Qxf0W/A2DuuTPvYt+xjt1wzpZUj2xn2Y
         imWA==
X-Gm-Message-State: ANhLgQ3Fu/BKmOIF2LQJSYNZVCbj7zA3XbmxyUFSwBcnUqw50RjmUM62
        IgBRUjuQUrnGcVBQsWYPU8M3EWNm5GcybfjcL/3fxg==
X-Google-Smtp-Source: ADFU+vvvnSED1SHeW8qLCDG3BqwBI0VMKO+K9n4+XFHxpZ+OvuAaqBYxxcxBitGUqv9ChKcy9Y8MF18VRjEr6r2L148=
X-Received: by 2002:ab0:7802:: with SMTP id x2mr10385584uaq.100.1584145822528;
 Fri, 13 Mar 2020 17:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200312181055.94038-1-abhishekpandit@chromium.org>
 <20200312111036.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid> <A79B48D3-D342-473C-B94A-A2E0AA83B505@holtmann.org>
In-Reply-To: <A79B48D3-D342-473C-B94A-A2E0AA83B505@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Fri, 13 Mar 2020 17:30:10 -0700
Message-ID: <CANFp7mXwWGZF80EBqEmacc5uQWkaC0pL1rp+x5Qa40kkAcod-Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] Bluetooth: Prioritize SCO traffic on slow interfaces
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Fri, Mar 13, 2020 at 12:01 PM Marcel Holtmann <marcel@holtmann.org> wrot=
e:
>
> Hi Abhishek,
>
> > When scheduling TX packets, send all SCO/eSCO packets first and then
> > send only 1 ACL/LE packet in a loop while checking that there are no SC=
O
> > packets pending. This is done to make sure that we can meet SCO
> > deadlines on slow interfaces like UART. If we were to queue up multiple
> > ACL packets without checking for a SCO packet, we might miss the SCO
> > timing. For example:
> >
> > The time it takes to send a maximum size ACL packet (1024 bytes):
> > t =3D 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
> >        where 10/8 is uart overhead due to start/stop bits per byte
> >
> > Replace t =3D 3.75ms (SCO deadline), which gives us a baudrate of 27306=
66
> > and is pretty close to a common baudrate of 3000000 used for BT. At thi=
s
> > baudrate, if we sent two 1024 byte ACL packets, we would miss the 3.75m=
s
> > timing window.
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> >
> > include/net/bluetooth/hci_core.h |  1 +
> > net/bluetooth/hci_core.c         | 91 +++++++++++++++++++++++++-------
> > 2 files changed, 73 insertions(+), 19 deletions(-)
> >
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index d4e28773d378..f636c89f1fe1 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -315,6 +315,7 @@ struct hci_dev {
> >       __u8            ssp_debug_mode;
> >       __u8            hw_error_code;
> >       __u32           clock;
> > +     __u8            sched_limit;
>
> why do you need this parameter?

This is really only necessary on systems where the data transfer rate
to the controller is low. I want the driver to set whether we should
aggressively schedule SCO packets. A quirk might actually be better
than a variable (wasn't sure what is preferable).

>
> >
> >       __u16           devid_source;
> >       __u16           devid_vendor;
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index dbd2ad3a26ed..00a72265cd96 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -4239,18 +4239,32 @@ static void __check_timeout(struct hci_dev *hde=
v, unsigned int cnt)
> >       }
> > }
> >
> > -static void hci_sched_acl_pkt(struct hci_dev *hdev)
> > +/* Limit packets in flight when SCO/eSCO links are active. */
> > +static bool hci_sched_limit(struct hci_dev *hdev)
> > +{
> > +     return hdev->sched_limit && hci_conn_num(hdev, SCO_LINK);
> > +}
> > +
> > +static bool hci_sched_acl_pkt(struct hci_dev *hdev)
> > {
> >       unsigned int cnt =3D hdev->acl_cnt;
> >       struct hci_chan *chan;
> >       struct sk_buff *skb;
> >       int quote;
> > +     bool sched_limit =3D hci_sched_limit(hdev);
> > +     bool resched =3D false;
> >
> >       __check_timeout(hdev, cnt);
> >
> >       while (hdev->acl_cnt &&
> >              (chan =3D hci_chan_sent(hdev, ACL_LINK, &quote))) {
> >               u32 priority =3D (skb_peek(&chan->data_q))->priority;
> > +
> > +             if (sched_limit && quote > 0) {
> > +                     resched =3D true;
> > +                     quote =3D 1;
> > +             }
> > +
> >               while (quote-- && (skb =3D skb_peek(&chan->data_q))) {
> >                       BT_DBG("chan %p skb %p len %d priority %u", chan,=
 skb,
> >                              skb->len, skb->priority);
> > @@ -4271,19 +4285,26 @@ static void hci_sched_acl_pkt(struct hci_dev *h=
dev)
> >                       chan->sent++;
> >                       chan->conn->sent++;
> >               }
> > +
> > +             if (resched && cnt !=3D hdev->acl_cnt)
> > +                     break;
> >       }
> >
> > -     if (cnt !=3D hdev->acl_cnt)
> > +     if (hdev->acl_cnt =3D=3D 0 && cnt !=3D hdev->acl_cnt)
> >               hci_prio_recalculate(hdev, ACL_LINK);
> > +
> > +     return resched;
> > }
> >
> > -static void hci_sched_acl_blk(struct hci_dev *hdev)
> > +static bool hci_sched_acl_blk(struct hci_dev *hdev)
> > {
> >       unsigned int cnt =3D hdev->block_cnt;
> >       struct hci_chan *chan;
> >       struct sk_buff *skb;
> >       int quote;
> >       u8 type;
> > +     bool sched_limit =3D hci_sched_limit(hdev);
> > +     bool resched =3D false;
> >
> >       __check_timeout(hdev, cnt);
> >
> > @@ -4297,6 +4318,12 @@ static void hci_sched_acl_blk(struct hci_dev *hd=
ev)
> >       while (hdev->block_cnt > 0 &&
> >              (chan =3D hci_chan_sent(hdev, type, &quote))) {
> >               u32 priority =3D (skb_peek(&chan->data_q))->priority;
> > +
> > +             if (sched_limit && quote > 0) {
> > +                     resched =3D true;
> > +                     quote =3D 1;
> > +             }
> > +
> >               while (quote > 0 && (skb =3D skb_peek(&chan->data_q))) {
> >                       int blocks;
> >
> > @@ -4311,7 +4338,7 @@ static void hci_sched_acl_blk(struct hci_dev *hde=
v)
> >
> >                       blocks =3D __get_blocks(hdev, skb);
> >                       if (blocks > hdev->block_cnt)
> > -                             return;
> > +                             return false;
> >
> >                       hci_conn_enter_active_mode(chan->conn,
> >                                                  bt_cb(skb)->force_acti=
ve);
> > @@ -4325,33 +4352,39 @@ static void hci_sched_acl_blk(struct hci_dev *h=
dev)
> >                       chan->sent +=3D blocks;
> >                       chan->conn->sent +=3D blocks;
> >               }
> > +
> > +             if (resched && cnt !=3D hdev->block_cnt)
> > +                     break;
> >       }
> >
> > -     if (cnt !=3D hdev->block_cnt)
> > +     if (hdev->block_cnt =3D=3D 0 && cnt !=3D hdev->block_cnt)
> >               hci_prio_recalculate(hdev, type);
> > +
> > +     return resched;
> > }
> >
> > -static void hci_sched_acl(struct hci_dev *hdev)
> > +static bool hci_sched_acl(struct hci_dev *hdev)
> > {
> >       BT_DBG("%s", hdev->name);
> >
> >       /* No ACL link over BR/EDR controller */
> >       if (!hci_conn_num(hdev, ACL_LINK) && hdev->dev_type =3D=3D HCI_PR=
IMARY)
> > -             return;
> > +             goto done;
>
> Style wise the goto done is overkill. Just return false.

Will do.

>
> >
> >       /* No AMP link over AMP controller */
> >       if (!hci_conn_num(hdev, AMP_LINK) && hdev->dev_type =3D=3D HCI_AM=
P)
> > -             return;
> > +             goto done;
> >
> >       switch (hdev->flow_ctl_mode) {
> >       case HCI_FLOW_CTL_MODE_PACKET_BASED:
> > -             hci_sched_acl_pkt(hdev);
> > -             break;
> > +             return hci_sched_acl_pkt(hdev);
> >
> >       case HCI_FLOW_CTL_MODE_BLOCK_BASED:
> > -             hci_sched_acl_blk(hdev);
> > -             break;
> > +             return hci_sched_acl_blk(hdev);
>
> So the block based mode is for AMP controllers and not used on BR/EDR con=
trollers. Since AMP controllers only transport ACL packet and no SCO/eSCO p=
ackets, we can ignore this here.

Ok, I'll remove it there.

>
> >       }
> > +
> > +done:
> > +     return false;
> > }
> >
> > /* Schedule SCO */
> > @@ -4402,16 +4435,18 @@ static void hci_sched_esco(struct hci_dev *hdev=
)
> >       }
> > }
> >
> > -static void hci_sched_le(struct hci_dev *hdev)
> > +static bool hci_sched_le(struct hci_dev *hdev)
> > {
> >       struct hci_chan *chan;
> >       struct sk_buff *skb;
> >       int quote, cnt, tmp;
> > +     bool sched_limit =3D hci_sched_limit(hdev);
> > +     bool resched =3D false;
> >
> >       BT_DBG("%s", hdev->name);
> >
> >       if (!hci_conn_num(hdev, LE_LINK))
> > -             return;
> > +             return resched;
> >
> >       cnt =3D hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
> >
> > @@ -4420,6 +4455,12 @@ static void hci_sched_le(struct hci_dev *hdev)
> >       tmp =3D cnt;
> >       while (cnt && (chan =3D hci_chan_sent(hdev, LE_LINK, &quote))) {
> >               u32 priority =3D (skb_peek(&chan->data_q))->priority;
> > +
> > +             if (sched_limit && quote > 0) {
> > +                     resched =3D true;
> > +                     quote =3D 1;
> > +             }
> > +
> >               while (quote-- && (skb =3D skb_peek(&chan->data_q))) {
> >                       BT_DBG("chan %p skb %p len %d priority %u", chan,=
 skb,
> >                              skb->len, skb->priority);
> > @@ -4437,6 +4478,9 @@ static void hci_sched_le(struct hci_dev *hdev)
> >                       chan->sent++;
> >                       chan->conn->sent++;
> >               }
> > +
> > +             if (resched && cnt !=3D tmp)
> > +                     break;
> >       }
> >
> >       if (hdev->le_pkts)
> > @@ -4444,24 +4488,33 @@ static void hci_sched_le(struct hci_dev *hdev)
> >       else
> >               hdev->acl_cnt =3D cnt;
> >
> > -     if (cnt !=3D tmp)
> > +     if (cnt =3D=3D 0 && cnt !=3D tmp)
> >               hci_prio_recalculate(hdev, LE_LINK);
> > +
> > +     return resched;
> > }
> >
> > static void hci_tx_work(struct work_struct *work)
> > {
> >       struct hci_dev *hdev =3D container_of(work, struct hci_dev, tx_wo=
rk);
> >       struct sk_buff *skb;
> > +     bool resched;
> >
> >       BT_DBG("%s acl %d sco %d le %d", hdev->name, hdev->acl_cnt,
> >              hdev->sco_cnt, hdev->le_cnt);
> >
> >       if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
> >               /* Schedule queues and send stuff to HCI driver */
> > -             hci_sched_acl(hdev);
> > -             hci_sched_sco(hdev);
> > -             hci_sched_esco(hdev);
> > -             hci_sched_le(hdev);
> > +             do {
> > +                     /* SCO and eSCO send all packets until emptied */
> > +                     hci_sched_sco(hdev);
> > +                     hci_sched_esco(hdev);
> > +
> > +                     /* Acl and Le send based on quota (priority on AC=
L per
> > +                      * loop)
> > +                      */
> > +                     resched =3D hci_sched_acl(hdev) || hci_sched_le(h=
dev);
> > +             } while (resched);
> >       }
>
> I am not in favor of this busy loop. We might want to re-think the whole =
scheduling by connection type and really only focus on scheduling ACL (BR/E=
DR and LE) and audio packets (SCO/eSCO and ISO).

I think the busy loop is the simplest solution if we want to solve the
problem: don't send 2 ACL packets without checking if there is a SCO
packet scheduled (which is the worst case I'm worried about on UART
interfaces).

If we get rid of the connection type scheduling and only do audio and
ACL, we would still need some mechanism to guarantee that you don't
send >~1100 bytes without checking if SCO is queued (assuming 3000000
baudrate and 3.75ms latency requirement).

>
> In addition, we also need to check that SCO scheduling and A2DP media cha=
nnel ACL packets do work together. I think that generally it would be best =
to have a clear rate at which SCO packets are require to pushed down to the=
 hardware. So you really reserve bandwidth and not blindly prioritize them =
via a busy loop.
>
I am less worried about bandwidth and more about latency. If I start
sending really large ACL packets through UART, it could take multiple
milliseconds. It really has to be reserved bandwidth per small
timeslice (like 3.75ms) so I can guarantee that if a SCO packet is
seen within that time slice, it will be transferred. There will still
have to be a busy loop though because the amount of data you can send
in the time slice will probably be less than the data that can be
in-flight to the controller (i.e. acl_max_pkts).

> Regards
>
> Marcel
>

Thanks,

Abhishek
