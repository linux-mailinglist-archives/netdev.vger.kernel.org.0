Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB793096AE
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhA3QWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhA3Ovn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:51:43 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20979C061573
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 06:43:06 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10UEg3V8022490
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 30 Jan 2021 15:42:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1612017725; bh=Zwx0hJSSdQGX8d2305wfRk6tfR31pnVjuGlBZhLxENU=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=X92tyvAbJKjY5C0yDK36r1bCPJkhiRBwQ7FhW6++OVMCun52g+yOek1VfA5egkBlB
         /RX1INQWNxVxotIPQUIBsJxG1wMbRa74EfLVEAKHbBDnLd63bxnKp+vOLGmOfv0UXC
         TO0Xw69odc7c6t6b6xiuiD4DVdec+bBX0uUp9mx4=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l5rRr-000dn5-BC; Sat, 30 Jan 2021 15:42:03 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        carl.yin@quectel.com
Subject: Re: [PATCH net-next 3/3] net: mhi: Add mbim proto
Organization: m
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
        <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
Date:   Sat, 30 Jan 2021 15:42:03 +0100
In-Reply-To: <1611766877-16787-3-git-send-email-loic.poulain@linaro.org> (Loic
        Poulain's message of "Wed, 27 Jan 2021 18:01:17 +0100")
Message-ID: <87ft2izdtw.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> writes:

> MBIM has initially been specified by USB-IF for transporting data (IP)
> between a modem and a host over USB. However some modern modems also
> support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet), it
> allows to aggregate IP packets and to perform context multiplexing.
>
> This change adds minimal MBIM support to MHI, allowing to support MBIM
> only modems. MBIM being based on USB NCM, it reuses some helpers from
> the USB stack, but the cdc-mbim driver is too USB coupled to be reused.

Sure, the guts of the MBIM protocol is in cdc_ncm. But you did copy most
of cdc_mbim_rx_fixup() from cdc_mbim.c so this comment doesn't make
much sense...

> At some point it would be interesting to move on a factorized solution,
> having a generic MBIM network lib or dedicated MBIM netlink virtual
> interface support.

I believe that is now or never.  Sorry.  No one is going to fix it
later.

> +static int mbim_rx_verify_nth16(struct sk_buff *skb)
> +{
> +	struct usb_cdc_ncm_nth16 *nth16;
> +	int ret =3D -EINVAL;
> +
> +	if (skb->len < (sizeof(struct usb_cdc_ncm_nth16) +
> +			sizeof(struct usb_cdc_ncm_ndp16))) {
> +		goto error;
> +	}
> +
> +	nth16 =3D (struct usb_cdc_ncm_nth16 *)skb->data;
> +
> +	if (nth16->dwSignature !=3D cpu_to_le32(USB_CDC_NCM_NTH16_SIGN))
> +		goto error;
> +
> +	ret =3D le16_to_cpu(nth16->wNdpIndex);
> +error:
> +	return ret;
> +}


This is a copy of  cdc_ncm_rx_verify_nth16() except that you've dropped
the debug messages and verification of wBlockLength and wSequence.  It's
unclear to me why you don't need to verify those fields?

This function could easily be shared with cdc_ncm instead of duplicating
it.

> +static int mbim_rx_verify_ndp16(struct sk_buff *skb, int ndpoffset)
> +{
> +	struct usb_cdc_ncm_ndp16 *ndp16;
> +	int ret =3D -EINVAL;
> +
> +	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb->len)
> +		goto error;
> +
> +	ndp16 =3D (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
> +
> +	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN)
> +		goto error;
> +
> +	ret =3D ((le16_to_cpu(ndp16->wLength) -
> +					sizeof(struct usb_cdc_ncm_ndp16)) /
> +					sizeof(struct usb_cdc_ncm_dpe16));
> +	ret--; /* Last entry is always a NULL terminator */
> +
> +	if ((sizeof(struct usb_cdc_ncm_ndp16) +
> +	     ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb->len) {
> +		ret =3D -EINVAL;
> +	}
> +error:
> +	return ret;
> +}

This is an exact replica of cdc_ncm_rx_verify_ndp16() AFAICS, except for
the removed debug messages.   You do know that netif_dbg() is
conditional? There is nothing to be saved by removing those lines.

FWIW, you will have to fix the copyright attribution of this file if you
want to keep this copy here.  Otherwise it just looks like you are
stealing. And I'll wonder where the rest of the code came from and
whether you have the right to license that as GPL. Better be clear about
where you found this and who owns the copyright.  There is no question
about the rights to use, given the GPL license of the original.

> +static int mbim_rx_fixup(struct net_device *ndev, struct sk_buff *skb)
> +{
> +	int ndpoffset;
> +
> +	/* Check NTB header signature and retrieve first NDP offset */
> +	ndpoffset =3D mbim_rx_verify_nth16(skb);
> +	if (ndpoffset < 0) {
> +		netdev_err(ndev, "MBIM: Incorrect NTB header\n");
> +		goto error;
> +	}
> +
> +	/* Process each NDP */
> +	while (1) {
> +		struct usb_cdc_ncm_ndp16 *ndp16;
> +		struct usb_cdc_ncm_dpe16 *dpe16;
> +		int nframes, n;
> +
> +		/* Check NDP header and retrieve number of datagrams */
> +		nframes =3D mbim_rx_verify_ndp16(skb, ndpoffset);
> +		if (nframes < 0) {
> +			netdev_err(ndev, "MBIM: Incorrect NDP16\n");
> +			goto error;
> +		}
> +
> +		/* Only support the IPS session 0 for now */
> +		ndp16 =3D (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
> +		switch (ndp16->dwSignature & cpu_to_le32(0x00ffffff)) {
> +		case cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN):
> +			break;
> +		default:
> +			netdev_err(ndev, "MBIM: Unsupported NDP type\n");
> +			goto next_ndp;
> +		}

You don't support DSS?  Why?  That's mandatory in the MBIM spec, isn't
it?  Can we have an MBIM driver without that support?  And if so, should
completely valid MBIM frames cause an error message?

And IP multiplexing isn't supported either?  And you simply ignore the
session ID?  How is that intended to work?  What happens here when the
driver receives IP packets from two different APNs?

But please, just implement the IP multiplexing.  You do that for rmnet,
right?

At least provide some plan on how you want to add it. Don't paint
yourself into a corner.  Userspace will need a way to manage the MBIM
transport and the multiplexed IP sessions independently.  E.g. take down
the netdev associated with IPS session 0 without breaking IPS session 1.

Locking this netdev to one session will be a problem.  I know, because
I've made that mistake.

> +
> +		/* de-aggregate and deliver IP packets */
> +		dpe16 =3D ndp16->dpe16;
> +		for (n =3D 0; n < nframes; n++, dpe16++) {
> +			u16 dgram_offset =3D le16_to_cpu(dpe16->wDatagramIndex);
> +			u16 dgram_len =3D le16_to_cpu(dpe16->wDatagramLength);
> +			struct sk_buff *skbn;
> +
> +			if (!dgram_offset || !dgram_len)
> +				break; /* null terminator */
> +
> +			skbn =3D netdev_alloc_skb(ndev, dgram_len);
> +			if (!skbn)
> +				continue;
> +
> +			skb_put(skbn, dgram_len);
> +			memcpy(skbn->data, skb->data + dgram_offset, dgram_len);
> +
> +			switch (skbn->data[0] & 0xf0) {
> +			case 0x40:
> +				skbn->protocol =3D htons(ETH_P_IP);
> +				break;
> +			case 0x60:
> +				skbn->protocol =3D htons(ETH_P_IPV6);
> +				break;
> +			default:
> +				netdev_err(ndev, "MBIM: unknown protocol\n");
> +				continue;
> +			}
> +
> +			netif_rx(skbn);
> +		}
> +next_ndp:
> +		/* Other NDP to process? */
> +		ndpoffset =3D le16_to_cpu(ndp16->wNextNdpIndex);
> +		if (!ndpoffset)
> +			break;
> +	}
> +
> +	/* free skb */
> +	dev_consume_skb_any(skb);
> +	return 0;
> +error:
> +	dev_kfree_skb_any(skb);
> +	return -EIO;
> +}


Except for the missing feature, this is still mostly a copy
cdc_mbim_rx_fixup(). Please respect the copyright on code you are
copying.  You are obviously free to use this under the GPL, but the
original author still retains copyright on it.

FWIW, I can understand why you want to use a slightly modified copy in
this case, since the original is tied both to usbnet and to the weird
VLAN mapping.  So that's fine with me.


Bj=C3=B8rn
