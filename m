Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43EE5A3622
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 11:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiH0JDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 05:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbiH0JC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 05:02:56 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9845A286E5;
        Sat, 27 Aug 2022 02:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1661590954;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=xsJJDT05zwrS62WUvKCZ4ErvGOIqvTn3kjzwl1anUsA=;
    b=C2GcM/yBwMX/Yw6MzOYk8Ba9Yo5pBBEKV4aXpBzAw7CvsZxAv4JiOznr0RbmdwXPCZ
    SxjgjTrHzG+PiwM8exoFP2I/O/W8rr2JtJTUrs7LRWAewq1x1Be8GdsdS8ZkZb1050ZU
    1EqeyIY5DCW9NbxVKFPq/k5OEZRvcwWvlY11Y8wwpT5zr9wPUwHk2PDvq06Bq6dRgmQf
    F+rEIozvT8h+WYFY7/abMM22AzChHyeb+CjeCEQ1Bbn84D8ZyQArrfCovs8g2bR48e5R
    YUkMtp5UrqiVVqIKGq+yU+12n/kN7n/EIAyO1l801WamigertEcIqOrmyDrnYPrkab8x
    5rIQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6jamATg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::1e4]
    by smtp.strato.de (RZmta 47.47.0 AUTH)
    with ESMTPSA id Icb1b0y7R92XIVi
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 27 Aug 2022 11:02:33 +0200 (CEST)
Message-ID: <b19f3d7e-9439-5c2b-c731-e5eaef37442d@hartkopp.net>
Date:   Sat, 27 Aug 2022 11:02:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
To:     Harald Mommer <harald.mommer@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Harald Mommer <hmo@opensynergy.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220825134449.18803-1-harald.mommer@opensynergy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

On 8/25/22 15:44, Harald Mommer wrote:

> +/*
> + * This function is the NAPI RX poll function and NAPI guarantees that this
> + * function is not invoked simulataneously on multiply processors.
> + * Read a RX message from the used queue and sends it to the upper layer.
> + * (See also m_can.c / m_can_read_fifo()).
> + */
> +static int virtio_can_read_rx_queue(struct virtqueue *vq)
> +{
> +	struct virtio_can_priv *priv = vq->vdev->priv;
> +	struct net_device *dev = priv->dev;
> +	struct net_device_stats *stats = &dev->stats;
> +	struct virtio_can_rx *can_rx;
> +	struct canfd_frame *cf;
> +	struct sk_buff *skb;
> +	unsigned int len;
> +	const unsigned int header_size = offsetof(struct virtio_can_rx, sdu);
> +	u16 msg_type;
> +	u32 can_flags;
> +	u32 can_id;
> +
> +	can_rx = virtqueue_get_buf(vq, &len);
> +	if (!can_rx)
> +		return 0; /* No more data */
> +
> +	BUG_ON(len < header_size);
> +
> +	/* virtio_can_hexdump(can_rx, len, 0u); */
> +
> +	if (priv->can.state >= CAN_STATE_ERROR_PASSIVE) {
> +		netdev_dbg(dev, "%s(): Controller not active\n", __func__);
> +		goto putback;
> +	}
> +
> +	msg_type = le16_to_cpu(can_rx->msg_type);
> +	if (msg_type != VIRTIO_CAN_RX) {
> +		netdev_warn(dev, "RX: Got unknown msg_type %04x\n", msg_type);
> +		goto putback;
> +	}
> +
> +	len -= header_size; /* Payload only now */
> +	can_flags = le32_to_cpu(can_rx->flags);
> +	can_id = le32_to_cpu(can_rx->can_id);
> +
> +	if ((can_flags & ~CAN_KNOWN_FLAGS) != 0u) {

For your entire patch:

Please remove this pointless " != 0u)" stuff.

	if (can_flags & ~CAN_KNOWN_FLAGS) {

is just ok.

> +		stats->rx_dropped++;
> +		netdev_warn(dev, "RX: CAN Id 0x%08x: Invalid flags 0x%x\n",
> +			    can_id, can_flags);
> +		goto putback;
> +	}
> +
> +	if ((can_flags & VIRTIO_CAN_FLAGS_EXTENDED) != 0u) {

e.g. here too ...

> +		if (can_id > CAN_EFF_MASK) {

The MASK is not a number value.

The check should be

if (can_id & ~CAN_EFF_MASK) {

or you simply mask the can_id value to be really sure without the 
netdev_warn() stuff.

Are you sure that you could get undefined CAN ID values here?

> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Ext Id 0x%08x too big\n",

As it is no value 'too big' is not the right comment here.

> +				    can_id);
> +			goto putback;
> +		}
> +		can_id |= CAN_EFF_FLAG;
> +	} else {
> +		if (can_id > CAN_SFF_MASK) {

same here

> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Std Id 0x%08x too big\n",

and here

> +				    can_id);
> +			goto putback;
> +		}
> +	}
> +
> +	if ((can_flags & VIRTIO_CAN_FLAGS_RTR) != 0u) {
> +		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_RTR_FRAMES)) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR not negotiated\n",
> +				    can_id);
> +			goto putback;
> +		}
> +		if ((can_flags & VIRTIO_CAN_FLAGS_FD) != 0u) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with FD not possible\n",
> +				    can_id);
> +			goto putback;
> +		}
> +		if (len != 0u) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: RTR with len != 0\n",
> +				    can_id);

This is not the right handling.

Classical CAN frames with RTR bit set can have a DLC value from 0 .. F 
which is represented in

can_frame.len (for values 0 .. 8)
can_frame.len8_dlc (values 9 .. F; len must be 8)

With the RTR bit set, the CAN controller does not send CAN data, but the 
DLC value is set from 0 .. F.

> +			goto putback;
> +		}
> +		can_id |= CAN_RTR_FLAG;
> +	}
> +
> +	if ((can_flags & VIRTIO_CAN_FLAGS_FD) != 0u) {
> +		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_FD)) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: FD not negotiated\n",
> +				    can_id);
> +			goto putback;
> +		}
> +
> +		skb = alloc_canfd_skb(priv->dev, &cf);
> +		if (len > CANFD_MAX_DLEN)
> +			len = CANFD_MAX_DLEN;

No netdev_warn() here? ;-)

When you silently sanitize the length value here, you should do the same 
with the can_id checks above and simply do a masking like

can_id &= CAN_SFF_MASK or can_id &= CAN_EFF_MASK


> +	} else {
> +		if (!virtio_has_feature(vq->vdev, VIRTIO_CAN_F_CAN_CLASSIC)) {
> +			stats->rx_dropped++;
> +			netdev_warn(dev, "RX: CAN Id 0x%08x: classic not negotiated\n",
> +				    can_id);
> +			goto putback;
> +		}
> +
> +		skb = alloc_can_skb(priv->dev, (struct can_frame **)&cf);
> +		if (len > CAN_MAX_DLEN)
> +			len = CAN_MAX_DLEN;
> +	}
> +	if (!skb) {
> +		stats->rx_dropped++;
> +		netdev_warn(dev, "RX: No skb available\n");
> +		goto putback;
> +	}
> +
> +	cf->can_id = can_id;
> +	cf->len = len;
> +	if ((can_flags & VIRTIO_CAN_FLAGS_RTR) == 0u) {
> +		/* Copy if no RTR frame. RTR frames have a DLC but no payload */
> +		memcpy(cf->data, can_rx->sdu, len);

This would need some rework together with the RTR handling too.

> +	}
> +
> +	stats->rx_packets++;
> +	stats->rx_bytes += cf->len;
> +
> +	/* Use netif_rx() for interrupt context */

?? What is this comment about?

> +	(void)netif_receive_skb(skb);

Why this "(void)" here and at other places in the patch? Please remove.

Is there no error handling needed when netif_receive_skb() fails? Or ar 
least some statistics rollback?

> +
> +putback:
> +	/* Put processed RX buffer back into avail queue */
> +	(void)virtio_can_add_inbuf(vq, can_rx, sizeof(struct virtio_can_rx));
> +
> +	return 1; /* Queue was not emtpy so there may be more data */
> +}

Best regards,
Oliver

