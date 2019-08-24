Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AD59BD19
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 12:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfHXKny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 06:43:54 -0400
Received: from canardo.mork.no ([148.122.252.1]:59953 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727010AbfHXKnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 06:43:53 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x7OAhcvW030437
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 24 Aug 2019 12:43:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1566643419; bh=AMwa+4lqRda9qfSOd4FninOupvCyii6oU4nIgEvSd2Q=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=cF4t8i7U0tasiBs/jRjX696hF7FjmWYIv1aH71tou+qt9X0jHkWuH3OBk4dPD+mXp
         cfPd5qBMWPenw15XIC663dUC/moDFpf/GEQQOFISxSnFt/81vHuUCJ9nLDDASIv+lK
         Y2C+S4F0vWAhNsxI9PAK783Y185FnlJDpcin3wGs=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1i1TWE-0002I4-2L; Sat, 24 Aug 2019 12:43:38 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     <Charles.Hyde@dellteam.com>
Cc:     <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <Mario.Limonciello@dell.com>,
        <oliver@neukum.org>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: Re: [RFC 4/4] net: cdc_ncm: Add ACPI MAC address pass through functionality
Organization: m
References: <ec7435e0529243a99f6949ee9efbede5@AUSX13MPS303.AMER.DELL.COM>
Date:   Sat, 24 Aug 2019 12:43:38 +0200
In-Reply-To: <ec7435e0529243a99f6949ee9efbede5@AUSX13MPS303.AMER.DELL.COM>
        (Charles Hyde's message of "Tue, 20 Aug 2019 22:23:15 +0000")
Message-ID: <877e722691.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<Charles.Hyde@dellteam.com> writes:

> @@ -930,11 +931,18 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct =
usb_interface *intf, u8 data_
>  	usb_set_intfdata(ctx->control, dev);
>=20=20
>  	if (ctx->ether_desc) {
> +		struct sockaddr sa;
> +
>  		temp =3D usbnet_get_ethernet_addr(dev, ctx->ether_desc->iMACAddress);
>  		if (temp) {
>  			dev_dbg(&intf->dev, "failed to get mac address\n");
>  			goto error2;
>  		}
> +		if (get_acpi_mac_passthru(&intf->dev, &sa) =3D=3D 0) {
> +			memcpy(dev->net->dev_addr, sa.sa_data, ETH_ALEN);
> +			if (usbnet_set_ethernet_addr(dev) < 0)
> +				usbnet_get_ethernet_addr(dev, ctx->ether_desc->iMACAddress);
> +		}
>  		dev_info(&intf->dev, "MAC-Address: %pM\n", dev->net->dev_addr);
>  	}

So you want to run a Dell specific ACPI method every time anyone plugs
some NCM class device into a host supporing ACPI?  That's going to annoy
the hell out of 99.9997% of the x86, ia64 and arm64 users of this
driver.

Call ACPI once when the driver loads, and only if running on an actual
Dell system where this method is supported.  There must be some ACPI
device ID you can match on to know if this method is supported or not?


Bj=C3=B8rn
