Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764D317D468
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 16:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgCHP0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 11:26:31 -0400
Received: from canardo.mork.no ([148.122.252.1]:53115 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCHP0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Mar 2020 11:26:30 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 028FQM2j015815
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 8 Mar 2020 16:26:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1583681182; bh=ScndAKvQHtkoAKJHKcvCgojYNjZdn3MZ2jAOKVkeCi8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=DAa3yPISwfc5HFbHxC4Eqrr99/KfNjwMIpo46lz5BuhenW6xjgocpIO6VT8ZQVpGk
         eIzuHguRgLLTVA7sHrWpgaKgTccjU5C1ad+b3pGQs6G5D5I1vlainOvt+g0fThSEkM
         azEPJVSsnNKZu7GwEMoSCCiLJKbn5hidZQjuBcxg=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1jAxor-0000VM-QV; Sun, 08 Mar 2020 16:26:21 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Paul Gildea <paul.gildea@gmail.com>
Cc:     "davem\@davemloft.net" <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Fix for packets being rejected in the ring buffer used by the xHCI controller.
Organization: m
References: <CA+4pmEueEiz0Act8X6t4y3+4LOaOh_-ZfzScH0CbOKT99x91NA@mail.gmail.com>
Date:   Sun, 08 Mar 2020 16:26:21 +0100
In-Reply-To: <CA+4pmEueEiz0Act8X6t4y3+4LOaOh_-ZfzScH0CbOKT99x91NA@mail.gmail.com>
        (Paul Gildea's message of "Wed, 4 Mar 2020 14:20:28 +0000")
Message-ID: <87wo7una02.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.1 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Gildea <paul.gildea@gmail.com> writes:

> When MTU of modem is set to less than 1500 and a packet larger than MTU
> arrives in Linux from a modem, it is discarded with -EOVERFLOW error
> (Babble error). This is seen on USB3.0 and USB2.0 busses. This is
> essentially because the MRU (Max Receive Size) is not a separate entity to
> the MTU (Max Transmit Size) and the received packets can be larger than
> those transmitted. Following the babble error there were an endless supply
> of zero-length URBs which are rejected with -EPROTO (increasing the rx
> input error counter each time). This is only seen on USB3.0. These contin=
ue
> to come ad infinitum until the modem is shutdown, rendering the modem
> unusable. There is a bug in the core USB handling code in Linux that
> doesn't deal well with network MTUs smaller than 1500 bytes. By default t=
he
> dev->hard_mtu (the "real" MTU) is in lockstep with dev->rx_urb_size
> (essentially an MRU), and it's the latter that is causing trouble. This h=
as
> nothing to do with the modems; the issue can be reproduced by getting a
> USB-Ethernet dongle, setting the MTU to 1430, and pinging with size great=
er
> than 1406.
>
> Signed-off-by: Paul Gildea <Paul.Gildea@gmail.com>
> ---
> drivers/net/usb/qmi_wwan.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 5754bb6..545c772 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -815,6 +815,13 @@ static int qmi_wwan_bind(struct usbnet *dev, struct
> usb_interface *intf)
>     }
>     dev->net->netdev_ops =3D &qmi_wwan_netdev_ops;
>     dev->net->sysfs_groups[0] =3D &qmi_wwan_sysfs_attr_group;
> +    /* LTE Networks don't always respect their own MTU on receive side;
> +    * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
> +    * far-end network. Make receive buffer large enough to accommodate
> +    * them, and add four bytes so MTU does not equal MRU on network
> +    * with 1500 MTU otherwise usbnet_change_mtu() will change both.
> +    */
> +   dev->rx_urb_size =3D ETH_DATA_LEN + 4;
>  err:
>     return status;
>  }
> --
> 1.9.1


This is fine as a first step towards saner buffer handling in qmi_wwan.
If real world devices use asymmetric MTUs, then we should just deal with
that.

So I was going to add my ack.  But the patch does not apply:


 bjorn@miraculix:/usr/local/src/git/linux$ git am /tmp/l
 Applying: net: usb: qmi_wwan: Fix for packets being rejected in the ring b=
uffer used by the xHCI controller.
 error: corrupt patch at line 10

and checkpatch says why:

 bjorn@miraculix:/usr/local/src/git/linux$ scripts/checkpatch.pl /tmp/l
 ERROR: patch seems to be corrupt (line wrapped?)
 #34: FILE: drivers/net/usb/qmi_wwan.c:814:
 usb_interface *intf)


Could you fix up and resend? You might have to use a different email
client.  See
https://www.kernel.org/doc/html/latest/process/email-clients.html#email-cli=
ents


Bj=C3=B8rn
