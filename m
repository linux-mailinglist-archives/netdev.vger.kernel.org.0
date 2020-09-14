Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E826840E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 07:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgINF0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 01:26:21 -0400
Received: from ni.piap.pl ([195.187.100.5]:38692 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgINF0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 01:26:19 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id 77894443565;
        Mon, 14 Sep 2020 07:26:12 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 77894443565
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1600061173; bh=b36UtK65i/l+Kip5dYP2VFfv1iztlojBnFJGyz/GjAw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Di22R3LDlfbvvRM14LvwQ60tBgCi+6aHC2m/aMRXjoYKX8lqTy70Kg61mDLX5Gg+G
         jSSPi0X4GxPgHeHWKaMvfwvZLps/7dN27hp+vbDX4TliQrYN1CL/ROkAKdS7avZERR
         hH2u55sL7H/+eboAzYBgHGr+x4fBD5SgYFSKhpVU=
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net v2] drivers/net/wan/hdlc_fr: Add needed_headroom for
 PVC devices
References: <20200903000658.89944-1-xie.he.0141@gmail.com>
        <20200904151441.27c97d80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com>
Date:   Mon, 14 Sep 2020 07:26:12 +0200
In-Reply-To: <CAJht_EN+=WTuduvm43_Lq=XWL78AcF5q6Zoyg8S5fao_udL=+Q@mail.gmail.com>
        (Xie He's message of "Fri, 4 Sep 2020 18:28:38 -0700")
Message-ID: <m3v9ghgc97.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 4
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, not scanned, whitelist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xie He <xie.he.0141@gmail.com> writes:

> The HDLC device is not actually prepending any header when it is used
> with this driver. When the PVC device has prepended its header and
> handed over the skb to the HDLC device, the HDLC device just hands it
> over to the hardware driver for transmission without prepending any
> header.

That's correct. IIRC:
- Cisco and PPP modes add 4 bytes
- Frame Relay adds 4 (specific protocols - mostly IPv4) or 10 (general
  case) bytes. There is that pvcX->hdlcX transition which adds nothing
  (the header is already in place when the packet leaves pvcX device).
- Raw mode adds nothing (IPv4 only, though it could be modified for
  both IPv4/v6 easily)
- Ethernet (hdlc_raw_eth.c) adds normal Ethernet header.

(I had been "unplugged" for some time).
--=20
Krzysztof Halasa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
