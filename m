Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E52719CE87
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 04:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390182AbgDCCQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 22:16:26 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:38798 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731842AbgDCCQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 22:16:25 -0400
Received: by mail-vs1-f66.google.com with SMTP id x206so4007790vsx.5
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 19:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=64OPywlQgnmjCAJe4iab4kwGSIKCiDfuRZfFbaamGR8=;
        b=ZBeXNkHyyBpxDAciI8v0n6KQ6TIrCy4+YjnQyZ79Il318TIpMzTN44Gy2XD+I0MAVg
         yUfrPLrkhQsQ8HL/kxV8q7eml6lcvhpdRGn2BdRr3EOkSC3ULzPFV8/qwBW0fGNmR419
         0kqov14s10zCUhb9s9xugada3IDhNajyvMVwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=64OPywlQgnmjCAJe4iab4kwGSIKCiDfuRZfFbaamGR8=;
        b=DgLB8L6aHHUZi+bsqO0ZUT6YmVUnSG2BCENC2Xr/97TD6saCxW24iMNPzRreoD6/kM
         oG4KNfIMX7ZkhpfJH4+8nt30R+oAWADlbM3bc1jcoubOg/G4SYGj8MdWZzmhKpw51Yoo
         mamWjhl7LxO5rdKJUsqz6B93vFIZrc5az4XQttJD02iXBKCPrU752cf4bKY98/L1DBlw
         5XtSvuH/q8RFz1JJPOPL5DdG6/3uRweaqDkASwu2C8KBSP60QunfdvJOd8e/gkG5WvsQ
         0lq9gS67wBCtFaiSGHKvTVzZvcKpQ0f/qoXofg6nqHrX3DtNrbFNOl93RvPKbWPXe/b6
         LJQQ==
X-Gm-Message-State: AGi0PuY/+pR6dvb8IjzG/KNFN85P7YhPCRplpWqrBNZFqcd8biHmpGru
        NkdSrxW0y1hKn+Xek3rkA+qwXnZzhOii61rQzK3BBg==
X-Google-Smtp-Source: APiQypIXa44nB4RalY6sk42qNy+zgRVrtsa9/gMqL6cr2XgwUzEI+osnNuHYGHwb3azV09ono88vo7jVytKzOZ36N9g=
X-Received: by 2002:a67:b60c:: with SMTP id d12mr4461805vsm.196.1585880183647;
 Thu, 02 Apr 2020 19:16:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200323194507.90944-1-abhishekpandit@chromium.org> <20200323124503.v3.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
In-Reply-To: <20200323124503.v3.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Thu, 2 Apr 2020 19:16:12 -0700
Message-ID: <CANFp7mV=ugPr4ZotxS9n=Dgy5ZTvKb-t9xbwUq-AJ5MoBiCDcA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] Bluetooth: Prioritize SCO traffic
To:     Marcel Holtmann <marcel@holtmann.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>
Cc:     ChromeOS Bluetooth Upstreaming 
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

Hi Marcel,

Reminder to review this patch.

Thanks,
Abhishek

On Mon, Mar 23, 2020 at 12:45 PM Abhishek Pandit-Subedi
<abhishekpandit@chromium.org> wrote:
>
> When scheduling TX packets, send all SCO/eSCO packets first, check for
> pending SCO/eSCO packets after every ACL/LE packet and send them if any
> are pending.  This is done to make sure that we can meet SCO deadlines
> on slow interfaces like UART.
>
> If we were to queue up multiple ACL packets without checking for a SCO
> packet, we might miss the SCO timing. For example:
>
> The time it takes to send a maximum size ACL packet (1024 bytes):
> t = 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
>         where 10/8 is uart overhead due to start/stop bits per byte
>
> Replace t = 3.75ms (SCO deadline), which gives us a baudrate of 2730666.
>
> At a baudrate of 3000000, if we didn't check for SCO packets within 1024
> bytes, we would miss the 3.75ms timing window.
>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
>
> Changes in v3:
> * Removed hci_sched_sync
>
> Changes in v2:
> * Refactor to check for SCO/eSCO after each ACL/LE packet sent
> * Enabled SCO priority all the time and removed the sched_limit variable
>
>  net/bluetooth/hci_core.c | 106 +++++++++++++++++++++------------------
>  1 file changed, 57 insertions(+), 49 deletions(-)
>
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index dbd2ad3a26ed..9e5d7662a047 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -4239,6 +4239,54 @@ static void __check_timeout(struct hci_dev *hdev, unsigned int cnt)
>         }
>  }
>
> +/* Schedule SCO */
> +static void hci_sched_sco(struct hci_dev *hdev)
> +{
> +       struct hci_conn *conn;
> +       struct sk_buff *skb;
> +       int quote;
> +
> +       BT_DBG("%s", hdev->name);
> +
> +       if (!hci_conn_num(hdev, SCO_LINK))
> +               return;
> +
> +       while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
> +               while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> +                       BT_DBG("skb %p len %d", skb, skb->len);
> +                       hci_send_frame(hdev, skb);
> +
> +                       conn->sent++;
> +                       if (conn->sent == ~0)
> +                               conn->sent = 0;
> +               }
> +       }
> +}
> +
> +static void hci_sched_esco(struct hci_dev *hdev)
> +{
> +       struct hci_conn *conn;
> +       struct sk_buff *skb;
> +       int quote;
> +
> +       BT_DBG("%s", hdev->name);
> +
> +       if (!hci_conn_num(hdev, ESCO_LINK))
> +               return;
> +
> +       while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
> +                                                    &quote))) {
> +               while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> +                       BT_DBG("skb %p len %d", skb, skb->len);
> +                       hci_send_frame(hdev, skb);
> +
> +                       conn->sent++;
> +                       if (conn->sent == ~0)
> +                               conn->sent = 0;
> +               }
> +       }
> +}
> +
>  static void hci_sched_acl_pkt(struct hci_dev *hdev)
>  {
>         unsigned int cnt = hdev->acl_cnt;
> @@ -4270,6 +4318,10 @@ static void hci_sched_acl_pkt(struct hci_dev *hdev)
>                         hdev->acl_cnt--;
>                         chan->sent++;
>                         chan->conn->sent++;
> +
> +                       /* Send pending SCO packets right away */
> +                       hci_sched_sco(hdev);
> +                       hci_sched_esco(hdev);
>                 }
>         }
>
> @@ -4354,54 +4406,6 @@ static void hci_sched_acl(struct hci_dev *hdev)
>         }
>  }
>
> -/* Schedule SCO */
> -static void hci_sched_sco(struct hci_dev *hdev)
> -{
> -       struct hci_conn *conn;
> -       struct sk_buff *skb;
> -       int quote;
> -
> -       BT_DBG("%s", hdev->name);
> -
> -       if (!hci_conn_num(hdev, SCO_LINK))
> -               return;
> -
> -       while (hdev->sco_cnt && (conn = hci_low_sent(hdev, SCO_LINK, &quote))) {
> -               while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> -                       BT_DBG("skb %p len %d", skb, skb->len);
> -                       hci_send_frame(hdev, skb);
> -
> -                       conn->sent++;
> -                       if (conn->sent == ~0)
> -                               conn->sent = 0;
> -               }
> -       }
> -}
> -
> -static void hci_sched_esco(struct hci_dev *hdev)
> -{
> -       struct hci_conn *conn;
> -       struct sk_buff *skb;
> -       int quote;
> -
> -       BT_DBG("%s", hdev->name);
> -
> -       if (!hci_conn_num(hdev, ESCO_LINK))
> -               return;
> -
> -       while (hdev->sco_cnt && (conn = hci_low_sent(hdev, ESCO_LINK,
> -                                                    &quote))) {
> -               while (quote-- && (skb = skb_dequeue(&conn->data_q))) {
> -                       BT_DBG("skb %p len %d", skb, skb->len);
> -                       hci_send_frame(hdev, skb);
> -
> -                       conn->sent++;
> -                       if (conn->sent == ~0)
> -                               conn->sent = 0;
> -               }
> -       }
> -}
> -
>  static void hci_sched_le(struct hci_dev *hdev)
>  {
>         struct hci_chan *chan;
> @@ -4436,6 +4440,10 @@ static void hci_sched_le(struct hci_dev *hdev)
>                         cnt--;
>                         chan->sent++;
>                         chan->conn->sent++;
> +
> +                       /* Send pending SCO packets right away */
> +                       hci_sched_sco(hdev);
> +                       hci_sched_esco(hdev);
>                 }
>         }
>
> @@ -4458,9 +4466,9 @@ static void hci_tx_work(struct work_struct *work)
>
>         if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
>                 /* Schedule queues and send stuff to HCI driver */
> -               hci_sched_acl(hdev);
>                 hci_sched_sco(hdev);
>                 hci_sched_esco(hdev);
> +               hci_sched_acl(hdev);
>                 hci_sched_le(hdev);
>         }
>
> --
> 2.25.1.696.g5e7596f4ac-goog
>
