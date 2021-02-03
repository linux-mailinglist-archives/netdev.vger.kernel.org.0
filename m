Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F4A30E72A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhBCXUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:20:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232745AbhBCXUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:20:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F6E264F55;
        Wed,  3 Feb 2021 23:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612394369;
        bh=Lrat3WBTqpjIT1TsWzSis+tJX1IZJKuzcUA+W+L8+x4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CZOEvme3GKMnbsMFpLPtgeV/l5Z1P1NqIHAursgoSxGgAC9BB7HnxmLdTMJZmZf6z
         rRPXzy6NqxZirO762wdTwcV71OgSTpCmL5WL6O0ZbsaGHqx0Jum34gz1bIFOdKrWGR
         L9wegQoVakCMNn71+E4SsiDNW9z9Eb2eTE1sXKKtL8ZrzIUeeYFKqZvn3JjdKMU8z0
         YX74gTTxyMJQ/xeos3KmWGGMcm7kh4bYomufik2QKma2HaKoTcFH2FTUPFkOB4uA6B
         tvprKWc61ON8sI74OCUqPz0oWb9CTyNfY1RTBBR1CKhmPkahQPXwcsEbF/mrllRfl6
         TNA82NAlJtTIQ==
Date:   Wed, 3 Feb 2021 15:19:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     bjorn@mork.no, dcbw@redhat.com, netdev@vger.kernel.org,
        carl.yin@quectel.com
Subject: Re: [PATCH net-next v2 3/3] net: mhi: Add mbim proto
Message-ID: <20210203151927.6eae17a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612213542-17257-3-git-send-email-loic.poulain@linaro.org>
References: <1612213542-17257-1-git-send-email-loic.poulain@linaro.org>
        <1612213542-17257-3-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Feb 2021 22:05:42 +0100 Loic Poulain wrote:
> MBIM has initially been specified by USB-IF for transporting data (IP)
> between a modem and a host over USB. However some modern modems also
> support MBIM over PCIe (via MHI). In the same way as QMAP(rmnet), it
> allows to aggregate IP packets and to perform context multiplexing.
> 
> This change adds minimal MBIM data transport support to MHI, allowing
> to support MBIM only modems. MBIM being based on USB NCM, it reuses
> and copy some helpers/functions from the USB stack (cdc-ncm, cdc-mbim).
> 
> Note that is a subset of the CDC-MBIM specification, supporting only
> transport of network data (IP), there is no support for DSS. Moreover
> the multi-session (for multi-pdn) is not supported in this initial
> version, but will be added latter, and aligned with the cdc-mbim
> solution (VLAN tags).
> 
> This code has been inspired from the mhi_mbim downstream implementation
> (Carl Yin <carl.yin@quectel.com>).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/* MHI Network driver - Network over MHI bus
> + *
> + * Copyright (C) 2021 Linaro Ltd <loic.poulain@linaro.org>
> + */
> +
> +struct mhi_net_stats {
> +	u64_stats_t rx_packets;
> +	u64_stats_t rx_bytes;
> +	u64_stats_t rx_errors;

> -struct mhi_net_stats {
> -	u64_stats_t rx_packets;
> -	u64_stats_t rx_bytes;
> -	u64_stats_t rx_errors;

Could the move to the header be a separate patch or part to the previous
patch?

> +#include <linux/ethtool.h>
> +#include <linux/if_vlan.h>
> +#include <linux/ip.h>
> +#include <linux/mii.h>
> +#include <linux/netdevice.h>
> +#include <linux/skbuff.h>
> +#include <linux/usb.h>
> +#include <linux/usb/cdc.h>
> +#include <linux/usb/usbnet.h>
> +#include <linux/usb/cdc_ncm.h>
> +
> +#include "mhi.h"
> +
> +#define MHI_MBIM_MAX_BLOCK_SZ (31 * 1024)
> +
> +struct mbim_context {
> +	u16 rx_seq;
> +	u16 tx_seq;
> +};
> +
> +static int mbim_rx_verify_nth16(struct sk_buff *skb)
> +{
> +	struct mhi_net_dev *dev = netdev_priv(skb->dev);
> +	struct mbim_context *ctx = dev->proto_data;
> +	struct usb_cdc_ncm_nth16 *nth16;
> +	int ret = -EINVAL;
> +	int len;
> +
> +	if (skb->len < (sizeof(struct usb_cdc_ncm_nth16) +
> +			sizeof(struct usb_cdc_ncm_ndp16))) {

parenthesis unnecessary

> +		netif_dbg(dev, rx_err, dev->ndev, "frame too short\n");

Looks like we could use some more specific counters here, like 
rx_length_errors?

> +		goto error;
> +	}
> +
> +	nth16 = (struct usb_cdc_ncm_nth16 *)skb->data;
> +
> +	if (nth16->dwSignature != cpu_to_le32(USB_CDC_NCM_NTH16_SIGN)) {
> +		netif_dbg(dev, rx_err, dev->ndev,
> +			  "invalid NTH16 signature <%#010x>\n",
> +			  le32_to_cpu(nth16->dwSignature));
> +		goto error;
> +	}
> +
> +	/* No limit on the block length, except the size of the data pkt */
> +	len = le16_to_cpu(nth16->wBlockLength);
> +	if (len > skb->len) {

Also rx_length_errors?

> +		netif_dbg(dev, rx_err, dev->ndev,
> +			  "NTB does not fit into the skb %u/%u\n", len,
> +			  skb->len);
> +		goto error;
> +	}
> +
> +	if ((ctx->rx_seq + 1) != le16_to_cpu(nth16->wSequence) &&
> +	    (ctx->rx_seq || le16_to_cpu(nth16->wSequence)) &&
> +	    !((ctx->rx_seq == 0xffff) && !le16_to_cpu(nth16->wSequence))) {

Multiple unnecessary parens here. They make the grouping harder to
follow.

> +		netif_dbg(dev, rx_err, dev->ndev,
> +			  "sequence number glitch prev=%d curr=%d\n",
> +			  ctx->rx_seq, le16_to_cpu(nth16->wSequence));
> +	}
> +	ctx->rx_seq = le16_to_cpu(nth16->wSequence);
> +
> +	ret = le16_to_cpu(nth16->wNdpIndex);
> +error:
> +	return ret;
> +}
> +
> +static int mbim_rx_verify_ndp16(struct sk_buff *skb, int ndpoffset)
> +{
> +	struct mhi_net_dev *dev = netdev_priv(skb->dev);
> +	struct usb_cdc_ncm_ndp16 *ndp16;
> +	int ret = -EINVAL;
> +
> +	if ((ndpoffset + sizeof(struct usb_cdc_ncm_ndp16)) > skb->len) {

comments from previous function apply here, too.

> +		netif_dbg(dev, rx_err, dev->ndev, "invalid NDP offset  <%u>\n",
> +			  ndpoffset);
> +		goto error;
> +	}
> +
> +	ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
> +
> +	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN) {
> +		netif_dbg(dev, rx_err, dev->ndev, "invalid DPT16 length <%u>\n",
> +			  le16_to_cpu(ndp16->wLength));
> +		goto error;
> +	}
> +
> +	ret = ((le16_to_cpu(ndp16->wLength) -
> +					sizeof(struct usb_cdc_ncm_ndp16)) /
> +					sizeof(struct usb_cdc_ncm_dpe16));
> +	ret--; /* Last entry is always a NULL terminator */
> +
> +	if ((sizeof(struct usb_cdc_ncm_ndp16) +
> +	     ret * (sizeof(struct usb_cdc_ncm_dpe16))) > skb->len) {
> +		netif_dbg(dev, rx_err, dev->ndev,
> +			  "Invalid nframes = %d\n", ret);
> +		ret = -EINVAL;
> +	}
> +
> +error:
> +	return ret;
> +}
> +
> +static int mbim_rx_fixup(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
> +{
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	int ndpoffset;
> +
> +	/* Check NTB header and retrieve first NDP offset */
> +	ndpoffset = mbim_rx_verify_nth16(skb);
> +	if (ndpoffset < 0) {
> +		netdev_err(ndev, "MBIM: Incorrect NTB header\n");

this needs to be rate limitted

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
> +		nframes = mbim_rx_verify_ndp16(skb, ndpoffset);
> +		if (nframes < 0) {
> +			netdev_err(ndev, "MBIM: Incorrect NDP16\n");

ditto

> +			goto error;
> +		}
> +
> +		/* Only support the IPS session 0 for now (only one PDN context)
> +		 * There is no Data Service Stream (DSS) in MHI context.
> +		 */
> +		ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
> +		switch (ndp16->dwSignature & cpu_to_le32(0x00ffffff)) {

Add a define for the mask?

> +		case cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN):
> +			break;

Are you going to add more cases here?

> +		default:
> +			netdev_err(ndev, "MBIM: Unsupported NDP type\n");
> +			goto next_ndp;
> +		}
> +
> +		/* de-aggregate and deliver IP packets */
> +		dpe16 = ndp16->dpe16;
> +		for (n = 0; n < nframes; n++, dpe16++) {
> +			u16 dgram_offset = le16_to_cpu(dpe16->wDatagramIndex);
> +			u16 dgram_len = le16_to_cpu(dpe16->wDatagramLength);
> +			struct sk_buff *skbn;
> +
> +			if (!dgram_offset || !dgram_len)
> +				break; /* null terminator */
> +
> +			skbn = netdev_alloc_skb(ndev, dgram_len);
> +			if (!skbn)
> +				continue;
> +
> +			skb_put(skbn, dgram_len);
> +			memcpy(skbn->data, skb->data + dgram_offset, dgram_len);
> +
> +			switch (skbn->data[0] & 0xf0) {
> +			case 0x40:
> +				skbn->protocol = htons(ETH_P_IP);
> +				break;
> +			case 0x60:
> +				skbn->protocol = htons(ETH_P_IPV6);
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
> +		ndpoffset = le16_to_cpu(ndp16->wNextNdpIndex);
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

Caller ignores the return value IIRC from the previous patch, no?
In that case just make the return value void.

> +}
> +
> +struct mbim_tx_hdr {
> +	struct usb_cdc_ncm_nth16 nth16;
> +	struct usb_cdc_ncm_ndp16 ndp16;
> +	struct usb_cdc_ncm_dpe16 dpe16[2];
> +} __packed;
> +
> +static struct sk_buff *mbim_tx_fixup(struct mhi_net_dev *mhi_netdev,
> +				     struct sk_buff *skb)
> +{
> +	struct mbim_context *ctx = mhi_netdev->proto_data;
> +	unsigned int dgram_size = skb->len;
> +	struct usb_cdc_ncm_nth16 *nth16;
> +	struct usb_cdc_ncm_ndp16 *ndp16;
> +	struct mbim_tx_hdr *mbim_hdr;
> +
> +	/* For now, this is a partial implementation of CDC MBIM, only one NDP
> +	 * is sent, containing the IP packet (no aggregation).
> +	 */
> +
> +	if (skb_headroom(skb) < sizeof(struct mbim_tx_hdr)) {

skb_cow_head()

> +		dev_kfree_skb_any(skb);
> +		return NULL;
> +	}
> +
> +	mbim_hdr = skb_push(skb, sizeof(struct mbim_tx_hdr));
> +
> +	/* Fill NTB header */
> +	nth16 = &mbim_hdr->nth16;
> +	nth16->dwSignature = cpu_to_le32(USB_CDC_NCM_NTH16_SIGN);
> +	nth16->wHeaderLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16));
> +	nth16->wSequence = cpu_to_le16(ctx->tx_seq++);
> +	nth16->wBlockLength = cpu_to_le16(skb->len);
> +	nth16->wNdpIndex = cpu_to_le16(sizeof(struct usb_cdc_ncm_nth16));
> +
> +	/* Fill the unique NDP */
> +	ndp16 = &mbim_hdr->ndp16;
> +	ndp16->dwSignature = cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN);
> +	ndp16->wLength = cpu_to_le16(sizeof(struct usb_cdc_ncm_ndp16)
> +					+ sizeof(struct usb_cdc_ncm_dpe16) * 2);
> +	ndp16->wNextNdpIndex = 0;
> +
> +	/* Datagram follows the mbim header */
> +	ndp16->dpe16[0].wDatagramIndex = cpu_to_le16(sizeof(struct mbim_tx_hdr));
> +	ndp16->dpe16[0].wDatagramLength = cpu_to_le16(dgram_size);
> +
> +	/* null termination */
> +	ndp16->dpe16[1].wDatagramIndex = 0;
> +	ndp16->dpe16[1].wDatagramLength = 0;
> +
> +	return skb;
> +}
