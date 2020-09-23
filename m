Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C660B2755CA
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgIWKWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbgIWKWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 06:22:19 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 675632388B;
        Wed, 23 Sep 2020 10:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600856538;
        bh=f0ytXXEucpGE93ViGHIALMJMUGZXXZ/3klZgXM9sYQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PzHhAWPVRv6Ifdafcex0l+oJub9ySqOhEZUvP0/V4il+89AE1vfzTohvWFqcH/Y/6
         cT4eBmoM/OZfi6zW7i1v0O2VT7rwvdfzkpl9IbJ3xaYyh0iUonPZp2UxJusk3/VS8A
         NPFoG9QwIi7RK8ZYUomhKJpvZqqVmxNbRnvdAXYs=
Received: by pali.im (Postfix)
        id 1D8F8D0F; Wed, 23 Sep 2020 12:22:16 +0200 (CEST)
Date:   Wed, 23 Sep 2020 12:22:15 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Joseph Hwang <josephsih@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: define HCI packet sizes of USB
 Alts
Message-ID: <20200923102215.hrfzl7c7q2omeiws@pali>
References: <20200910060403.144524-1-josephsih@chromium.org>
 <20200910140342.v3.1.I56de28ec171134cb9f97062e2c304a72822ca38b@changeid>
 <20200910081842.yunymr2l4fnle5nl@pali>
 <CAHFy418Ln9ONHGVhg513g0v+GxUZMDtLpe5NFONO3HuAZz=r7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHFy418Ln9ONHGVhg513g0v+GxUZMDtLpe5NFONO3HuAZz=r7g@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Monday 14 September 2020 20:18:27 Joseph Hwang wrote:
> On Thu, Sep 10, 2020 at 4:18 PM Pali Rohár <pali@kernel.org> wrote:
> > And this part of code which you write is Realtek specific.
> 
> We currently only have Intel and Realtek platforms to test with. If
> making it generic without proper testing platforms is fine, I will
> make it generic. Or do you think it might be better to make it
> customized with particular vendors for now; and make it generic later
> when it works well with sufficient vendors?

I understood that those packet size changes are generic to bluetooth
specification and therefore it is not vendor specific code. Those packet
sizes for me really seems to be USB specific.

Therefore it should apply for all vendors, not only for Realtek and
Intel.

I would propose to fix it globally for all USB adapters and not only for
Intel and Realtek USB adapters.

> >
> > I thought that this is something generic to bluetooth usb as you pointed
> > to bluetooth documentation "core spec 5, vol 4, part B, table 2.1".
> >
> > > +             } else
> > >                       bt_dev_err(hdev, "Device does not support ALT setting 1");
> > >       }
> >
> > Also this patch seems to be for me incomplete or not fully correct as
> > USB altsetting is chosen in function btusb_work() and it depends on
> > selected AIR mode (which is configured by another setsockopt).
> >
> > So despite what is written in commit message, this patch looks for me
> > like some hack for Intel and Realtek bluetooth adapters and does not
> > solve problems in vendor independent manner.
> 
> You are right that sco_mtu should be changed according to the air
> mode. Here are some issues to handle and what I plan to do. I would
> like to solicit your comments before I submit the next series.
> 
> [Issue 1] The air mode is determined in btusb_work() which is
> triggered by hci_sync_conn_complete_evt(). So “conn->mtu =
> hdev->sco_mtu” should not be done in  sco_conn_add() in the early
> connecting stage. Instead, it will be moved to near the end of
> hci_sync_conn_complete_evt().
> 
> [Issue 2] The btusb_work() is performed by a worker. There would be a
> timing issue here if we let btusb_work() to do “hdev->sco_mtu =
> hci_packet_size_usb_alt[i]” because there is no guarantee how soon the
> btusb_work() can be finished and get “hdev->sco_mtu” value set
> correctly. In order to avoid the potential race condition, I suggest
> to determine air_mode in btusb_notify() before
> schedule_work(&data->work) is executed so that “hdev->sco_mtu =
> hci_packet_size_usb_alt[i]” is guaranteed to be performed when
> btusb_notify() finished. In this way, hci_sync_conn_complete_evt() can
> set conn->mtu correctly as described in [Issue 1] above.

If it really fixes this issue, I'm fine with it.

You have Realtek and Intel HW for testing, so I think if doing some
heavy tests did not trigger any issue / race condition then it should be
fine.

> [Issue 3] Concerning CVSD: The above flow is good when the transparent
> mode is selected. When it is the CVSD mode, we should set
> hdev->sco_mtu and conn->mtu back to the original mtu size returned by
> hci_cc_read_buffer_size().

Beware that kernel does not support CVSD mode between (USB) bluetooth
adapter and kernel yet. Therefore it does not make sense to discussion
this option.

MTU size affects packets between kernel (or userspace) and bluetooth
adapter. Bluetooth adapter then do HW encoding/decoding if
non-transparent mode is used.

So I think you rather mean PCMs16 mode between bluetooth adapter and
kernel because this mode is used for CVSD air codec (between two
bluetooth adapters over the air). This is default mode, userspace
application pass PCMs16 data to kernel which pass it over USB to
bluetooth adapter. And bluetooth adapter then do HW encoding, encodes
PCMs16 to CVSD codec and transmit it over the air. So over USB are sent
PCM data, not CVSD.

> This is because we do not have a reliable
> way to determine what size is used with CVSD. AFAIK, controllers
> connected through USB use 48 bytes; and controllers connected through
> UART use 60 bytes.

I think for USB adapters we have that size. From bluetooth specification
I understood that it is that size which you calculated in that array
based on alt interface.

I understood that bluetooth specification that packet size on USB
depends only on chosen alt interface. And choice of alt interface
depends on voice codec (PCM or transparent) and on number of active
transports.

But correct me, if I'm wrong. Maybe I did not understand bluetooth
specification correctly.

And for UART I do not know, I have not looked at it it yet.

> It seems to me that these numbers are not recorded
> in the kernel(?). It seems beyond the scope of this patch to set the
> proper value for CVSD. So we will let hdev->sco_mtu and conn->mtu go
> back to their original values and are not affected by this patch.
> 
> I am wondering if such directions of fixing this patch look good to you?
> 
> Thanks and regards!
> Joseph
