Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5442558C1
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 12:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgH1KnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 06:43:18 -0400
Received: from ni.piap.pl ([195.187.100.5]:41266 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgH1KnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 06:43:14 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Aug 2020 06:43:12 EDT
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id 0E631442480;
        Fri, 28 Aug 2020 12:37:37 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 0E631442480
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1598611058; bh=mX0r45ob5AWEtdzdyfUiUKYeTekKi7l1NPoWWKilQlM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OoDPMwtJFpQc2LrfhaaKDD+q447F4tx4ZJIgcWgin8MXQFyoe/ma+LcEzzIaf0pkR
         bFoLkUIoCJ9LpCjRDDPiALP5H+B6obenk7u2NHdYrUemrqSsxY8lkWIXacpxh55Vyo
         KTRPVV7xsjc2BjcBmM/h+1+HMgxj81wqtrNwFIw8=
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: Re: [PATCH net] drivers/net/wan/hdlc_cisco: Add hard_header_len
References: <20200828070752.54444-1-xie.he.0141@gmail.com>
Date:   Fri, 28 Aug 2020 12:37:37 +0200
In-Reply-To: <20200828070752.54444-1-xie.he.0141@gmail.com> (Xie He's message
        of "Fri, 28 Aug 2020 00:07:52 -0700")
Message-ID: <m3pn7b6opa.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 4
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.721, not scanned, whitelist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Xie,

Xie He <xie.he.0141@gmail.com> writes:

> This driver didn't set hard_header_len. This patch sets hard_header_len
> for it according to its header_ops->create function.

BTW it's 4 bytes long:

struct hdlc_header {
        u8 address;
        u8 control;
        __be16 protocol;
}__packed;

OTOH hdlc_setup_dev() initializes hard_header_len to 16,
but in this case I guess 4 bytes are better.

Acked-by: Krzysztof Halasa <khc@pm.waw.pl>

> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---

> --- a/drivers/net/wan/hdlc_cisco.c
> +++ b/drivers/net/wan/hdlc_cisco.c
> @@ -370,6 +370,7 @@ static int cisco_ioctl(struct net_device *dev, struct=
 ifreq *ifr)
>  		memcpy(&state(hdlc)->settings, &new_settings, size);
>  		spin_lock_init(&state(hdlc)->lock);
>  		dev->header_ops =3D &cisco_header_ops;
> +		dev->hard_header_len =3D sizeof(struct hdlc_header);
>  		dev->type =3D ARPHRD_CISCO;
>  		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
>  		netif_dormant_on(dev);

--=20
Krzysztof Halasa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
