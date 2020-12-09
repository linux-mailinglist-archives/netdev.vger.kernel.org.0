Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1325F2D3826
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLIBO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgLIBO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 20:14:27 -0500
Date:   Wed, 9 Dec 2020 02:13:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607476419;
        bh=4A8yCWIxhznzmlI1ZPuNu4AS4l63xedVoBbtG2oxRU8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=kOqJnToMislpKdi65lyRTW3iZmg1MA/IKwdGlZMJI6lYPrenh1pJx13qV+qBo9rGr
         yU2EoZAr4k6gkLeO2BdE8AxZMpUQUNuSFqbqVL3zSbpHOXwAJi9vIkQnvHtl3DP8KN
         clxjxKOTIRGRGLupfvpraZQv1W5VA7lX/xSCNQA2+pa4M07nH/Fj8qnFa/jQZ+Yas6
         rlzSwF0EMkpXp4DNkMovpvELBH0IFaepsu3ROleJZIUj1ZCsVk0ldzBZYlSdY6H70D
         EbE+Zzz9vxO6zltwmGKaF1vS4ot+o2EtriQ4ggnAX+CpC5d3VW11WMaUb/5BuK7cBt
         0LA4TxZohzHqA==
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Trent Piepho <tpiepho@gmail.com>
Cc:     Joseph Hwang <josephsih@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
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
Message-ID: <20201209011336.4qdnnehnz3kdlqid@pali>
References: <20200910060403.144524-1-josephsih@chromium.org>
 <CAHFy418Ln9ONHGVhg513g0v+GxUZMDtLpe5NFONO3HuAZz=r7g@mail.gmail.com>
 <20200923102215.hrfzl7c7q2omeiws@pali>
 <9810329.nUPlyArG6x@zen.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9810329.nUPlyArG6x@zen.local>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 08 December 2020 15:04:29 Trent Piepho wrote:
> On Wednesday, September 23, 2020 3:22:15 AM PST Pali Rohár wrote:
> > On Monday 14 September 2020 20:18:27 Joseph Hwang wrote:
> > > On Thu, Sep 10, 2020 at 4:18 PM Pali Rohár <pali@kernel.org> wrote:
> > > > And this part of code which you write is Realtek specific.
> > > 
> > > We currently only have Intel and Realtek platforms to test with. If
> > > making it generic without proper testing platforms is fine, I will
> > > make it generic. Or do you think it might be better to make it
> > > customized with particular vendors for now; and make it generic later
> > > when it works well with sufficient vendors?
> > 
> > I understood that those packet size changes are generic to bluetooth
> > specification and therefore it is not vendor specific code. Those packet
> > sizes for me really seems to be USB specific.
> > 
> > Therefore it should apply for all vendors, not only for Realtek and
> > Intel.
> 
> I have tried to test WBS with some different USB adapters.  So far, all use 
> these packet sizes.  Tested were:
> 
> Broadcom BRCM20702A
> Realtek RTL8167B
> Realtek RTL8821C
> CSR CSR8510 (probably fake)
> 
> In all cases, WBS works best with packet size of (USB packet size for alt mode 
> selected) * 3 packets - 3 bytes HCI header.  None of these devices support alt 
> 6 mode, where supposedly one packet is better, but I can find no BT adapter on 
> which to test this.
> 
> > +static const int hci_packet_size_usb_alt[] = { 0, 24, 48, 72, 96, 144, 60};
> 
> Note that the packet sizes here are based on the max isoc packet length for 
> the USB alt mode used, e.g. alt 1 is 9 bytes.  That value is only a 
> "recommended" value from the bluetooth spec.  It seems like it would be more 
> correct use (btusb_data*)->isoc_tx_ep->wMaxPacketSize to find the MTU.

Yea, wMaxPacketSize looks like a candidate for determining MTU. Can we
use it or are there any known issues with it?

> > > [Issue 2] The btusb_work() is performed by a worker. There would be a
> > > timing issue here if we let btusb_work() to do “hdev->sco_mtu =
> > > hci_packet_size_usb_alt[i]” because there is no guarantee how soon the
> > > btusb_work() can be finished and get “hdev->sco_mtu” value set
> > > correctly. In order to avoid the potential race condition, I suggest
> > > to determine air_mode in btusb_notify() before
> > > schedule_work(&data->work) is executed so that “hdev->sco_mtu =
> > > hci_packet_size_usb_alt[i]” is guaranteed to be performed when
> > > btusb_notify() finished. In this way, hci_sync_conn_complete_evt() can
> > > set conn->mtu correctly as described in [Issue 1] above.
> 
> Does this also give userspace a clear point at which to determine MTU setting, 
> _before_ data is sent over SCO connection?  It will not work if sco_mtu is not 
> valid until after userspace sends data to SCO connection with incorrect mtu.

IIRC connection is established after sync connection (SCO) complete
event. And sending data is possible after connection is established. So
based on these facts I think that userspace can determinate MTU settings
prior sending data over SCO socket.

Anyway, to whole MTU issue for SCO there is a nice workaround which
worked fine with more tested USB adapters and headsets. As SCO socket is
synchronous and most bluetooth headsets have own clocks, you can
synchronize sending packets to headsets based on time events when you
received packets from other side and also send packets of same size as
you received. I.e. for every received packet send own packet of the same
size.
