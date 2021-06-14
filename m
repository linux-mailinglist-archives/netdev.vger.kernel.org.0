Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461473A6936
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbhFNOsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhFNOsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:48:06 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23F6C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 07:46:03 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9e:6708:7fba:f3d4:906e:68a0])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 15EEjtUR022864
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 14 Jun 2021 16:45:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1623681955; bh=EfU28Grrt03CCrOmSOelKP8Bw5fwYa3u71dOmsiOoCM=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=jaH1iUy1cpaptJr/cRkfoM4hxBgThdJf2FQDseiwW18Dn2Q/EAxIG4mXqTlI7OdRF
         yjk/18uLL3l4pctMcbG9Em04uQxAz1/n7P5GQdgz1SjI08ZPv+MaQMXpRbbA1Nb5Qy
         iJdMCJRxgODEoEGnwUe8ncT273Z3GkG8wHm1b+eU=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1lsnqd-000W2c-9O; Mon, 14 Jun 2021 16:45:55 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org, subashab@codeaurora.org
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Organization: m
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
Date:   Mon, 14 Jun 2021 16:45:55 +0200
In-Reply-To: <20210614141849.3587683-1-kristian.evensen@gmail.com> (Kristian
        Evensen's message of "Mon, 14 Jun 2021 16:18:49 +0200")
Message-ID: <8735tky064.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kristian Evensen <kristian.evensen@gmail.com> writes:

> The skb that we pass to the rmnet driver is owned by usbnet and is freed
> soon after the rx_fixup() callback is called (in usbnet_bh()).  There is
> no guarantee that rmnet is done handling the skb before it is freed. We
> should clone the skb before we call netif_rx() to prevent use-after-free
> and misc. kernel oops.
>
> Fixes: 59e139cf0b32 ("net: qmi_wwan: Add pass through mode")
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index db8d3a4f2678..5ac307eb0bfd 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -620,6 +620,10 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, str=
uct sk_buff *skb)
>  		return qmimux_rx_fixup(dev, skb);
>=20=20
>  	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
> +		skb =3D skb_clone(skb, GFP_ATOMIC);
> +		if (!skb)
> +			return 0;
> +
>  		skb->protocol =3D htons(ETH_P_MAP);
>  		return (netif_rx(skb) =3D=3D NET_RX_SUCCESS);
>  	}


Thanks for pointing this out.  But it still looks strange to me.  Why do
we call netif_rx(skb) here instead of just returning 1 and leave that
for usbnet_skb_return()?  With cloning we end up doing eth_type_trans()
on the duplicate - is that wise?


Bj=C3=B8rn
