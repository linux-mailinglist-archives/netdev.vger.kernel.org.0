Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA5524A1E6
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgHSOiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbgHSOiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 10:38:24 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7E052078D;
        Wed, 19 Aug 2020 14:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597847903;
        bh=8xz/VjRVV4BpGcOZYP02Lbcq6ZGKUYnAY0ghh4zsOlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eENPuUx2UY0IrjTdTM+/L7V8UqEKWGH2WGYUTFjbzG/Ea4EG5FsYa0nRgUxtjYZ8w
         c45HBvCYS1DyuV0dlQm2+fLYexE8iLDTpRICGxjhqvoMmnPofCqtiASu85cilezjaM
         ywPixZjl7BrbKBWJudG8d/5zKpGhtJULKOGyvyQA=
Received: by pali.im (Postfix)
        id 197E4582; Wed, 19 Aug 2020 16:38:21 +0200 (CEST)
Date:   Wed, 19 Aug 2020 16:38:21 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Joseph Hwang <josephsih@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Joseph Hwang <josephsih@google.com>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] Bluetooth: btusb: define HCI packet sizes of USB
 Alts
Message-ID: <20200819143821.qptlcrshcamlk4x3@pali>
References: <20200813084129.332730-1-josephsih@chromium.org>
 <20200813164059.v1.1.I56de28ec171134cb9f97062e2c304a72822ca38b@changeid>
 <CABBYNZ+GPmHuVe_TCUwCVYuOzH8m0=Nmwv48Tn-by_5PnqqwOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZ+GPmHuVe_TCUwCVYuOzH8m0=Nmwv48Tn-by_5PnqqwOg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 14 August 2020 13:07:25 Luiz Augusto von Dentz wrote:
> Hi Joseph,
> 
> On Thu, Aug 13, 2020 at 1:42 AM Joseph Hwang <josephsih@chromium.org> wrote:
> >
> > It is desirable to define the HCI packet payload sizes of
> > USB alternate settings so that they can be exposed to user
> > space.
> >
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> > ---
> >
> >  drivers/bluetooth/btusb.c        | 43 ++++++++++++++++++++++++--------
> >  include/net/bluetooth/hci_core.h |  1 +
> >  2 files changed, 33 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> > index 8d2608ddfd0875..df7cadf6385868 100644
> > --- a/drivers/bluetooth/btusb.c
> > +++ b/drivers/bluetooth/btusb.c
> > @@ -459,6 +459,22 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
> >  #define BTUSB_WAKEUP_DISABLE   14
> >  #define BTUSB_USE_ALT1_FOR_WBS 15
> >
> > +/* Per core spec 5, vol 4, part B, table 2.1,
> > + * list the hci packet payload sizes for various ALT settings.
> > + * This is used to set the packet length for the wideband speech.
> > + * If a controller does not probe its usb alt setting, the default
> > + * value will be 0. Any clients at upper layers should interpret it
> > + * as a default value and set a proper packet length accordingly.
> > + *
> > + * To calculate the HCI packet payload length:
> > + *   for alternate settings 1 - 5:
> > + *     hci_packet_size = suggested_max_packet_size * 3 (packets) -
> > + *                       3 (HCI header octets)
> > + *   for alternate setting 6:
> > + *     hci_packet_size = suggested_max_packet_size - 3 (HCI header octets)
> > + */
> > +static const int hci_packet_size_usb_alt[] = { 0, 24, 48, 72, 96, 144, 60 };
> > +
> >  struct btusb_data {
> >         struct hci_dev       *hdev;
> >         struct usb_device    *udev;
> > @@ -3958,6 +3974,15 @@ static int btusb_probe(struct usb_interface *intf,
> >         hdev->notify = btusb_notify;
> >         hdev->prevent_wake = btusb_prevent_wake;
> >
> > +       if (id->driver_info & BTUSB_AMP) {
> > +               /* AMP controllers do not support SCO packets */
> > +               data->isoc = NULL;
> > +       } else {
> > +               /* Interface orders are hardcoded in the specification */
> > +               data->isoc = usb_ifnum_to_if(data->udev, ifnum_base + 1);
> > +               data->isoc_ifnum = ifnum_base + 1;
> > +       }
> > +
> >  #ifdef CONFIG_PM
> >         err = btusb_config_oob_wake(hdev);
> >         if (err)
> > @@ -4021,6 +4046,10 @@ static int btusb_probe(struct usb_interface *intf,
> >                 hdev->set_diag = btintel_set_diag;
> >                 hdev->set_bdaddr = btintel_set_bdaddr;
> >                 hdev->cmd_timeout = btusb_intel_cmd_timeout;
> > +
> > +               if (btusb_find_altsetting(data, 6))
> > +                       hdev->sco_pkt_len = hci_packet_size_usb_alt[6];
> > +
> >                 set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks);
> >                 set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> >                 set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> > @@ -4062,15 +4091,6 @@ static int btusb_probe(struct usb_interface *intf,
> >                 btusb_check_needs_reset_resume(intf);
> >         }
> >
> > -       if (id->driver_info & BTUSB_AMP) {
> > -               /* AMP controllers do not support SCO packets */
> > -               data->isoc = NULL;
> > -       } else {
> > -               /* Interface orders are hardcoded in the specification */
> > -               data->isoc = usb_ifnum_to_if(data->udev, ifnum_base + 1);
> > -               data->isoc_ifnum = ifnum_base + 1;
> > -       }
> > -
> >         if (IS_ENABLED(CONFIG_BT_HCIBTUSB_RTL) &&
> >             (id->driver_info & BTUSB_REALTEK)) {
> >                 hdev->setup = btrtl_setup_realtek;
> > @@ -4082,9 +4102,10 @@ static int btusb_probe(struct usb_interface *intf,
> >                  * (DEVICE_REMOTE_WAKEUP)
> >                  */
> >                 set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
> > -               if (btusb_find_altsetting(data, 1))
> > +               if (btusb_find_altsetting(data, 1)) {
> >                         set_bit(BTUSB_USE_ALT1_FOR_WBS, &data->flags);
> > -               else
> > +                       hdev->sco_pkt_len = hci_packet_size_usb_alt[1];
> > +               } else
> >                         bt_dev_err(hdev, "Device does not support ALT setting 1");
> >         }
> >
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> > index 8caac20556b499..0624496328fc09 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -417,6 +417,7 @@ struct hci_dev {
> >         unsigned int    acl_pkts;
> >         unsigned int    sco_pkts;
> >         unsigned int    le_pkts;
> > +       unsigned int    sco_pkt_len;
> 
> Id use sco_mtu to so the following check actually does what it intended to do:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/tree/net/bluetooth/sco.c#n283
> 
> Right now it seems we are using the buffer length as MTU but I think
> we should actually use the packet length if it is lower than the
> buffer length, actually it doesn't seems SCO packets can be fragmented
> so the buffer length must always be big enough to carry a full packet
> so I assume setting the packet length as conn->mtu will always be
> correct.

I agree. We should use sco mtu for this purpose.

> >
> >         __u16           block_len;
> >         __u16           block_mtu;
> > --
> > 2.28.0.236.gb10cc79966-goog
> >
> 
> 
> -- 
> Luiz Augusto von Dentz
