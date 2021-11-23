Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E38459DC6
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhKWIYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:24:32 -0500
Received: from mail-ed1-f53.google.com ([209.85.208.53]:35831 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhKWIYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:24:32 -0500
Received: by mail-ed1-f53.google.com with SMTP id v1so54851318edx.2
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 00:21:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oacqMetQN1OuQwh/Z55yfok85SP5ogETF+7eNboexQo=;
        b=dfPKVlzMkV+NcGj9TyY4lTcFJkJTa61P7aWNRRnavdzLgJEVXgLkcPYENQUYwXXeT5
         oytEFIs344gBDaAl3pjihUFojaX2ZppM8U6oL5xPUktVNSM2nIp+NZZTdENmW3/o7qHq
         T/YkdJxUPm1aviUtyXPWxgncX2ZYbusRG3svjv5HG154b2MUlg0Y0cuPmUFSRznvhdN8
         cV0vVzpvJwMEEs5wX8+xh/vith2/AvU39RxB0TPGoQYy70pyRfl2/AxvLxbVICnJkyQK
         bZUlcp+26uGXannAkYvTwOWz7ftnNzcBr03Zx9hWmh107sWvvXpk542ijlX/8wMbFXRq
         V1tg==
X-Gm-Message-State: AOAM531L9U6frEXUWpgJTXLOyjguG4cg0IxzXHc+JLvOd/5AyeusYdCf
        y0v39yS/m4Wjl82vLGDRKLo=
X-Google-Smtp-Source: ABdhPJwri7vw5LpvCaU7WAYLjKXeP7DKuAb53GQhT9vcvtn6ISPgMfR6jqeGo2WfYh595CoQkHuvaA==
X-Received: by 2002:a17:907:9196:: with SMTP id bp22mr5043185ejb.69.1637655683555;
        Tue, 23 Nov 2021 00:21:23 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id sh33sm5044552ejc.56.2021.11.23.00.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:21:23 -0800 (PST)
Message-ID: <e6c37dee-89a5-d56d-bf53-55ac4bec9083@kernel.org>
Date:   Tue, 23 Nov 2021 09:21:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next v2] mctp: Add MCTP-over-serial transport binding
Content-Language: en-US
To:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20211123015952.2998176-1-jk@codeconstruct.com.au>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20211123015952.2998176-1-jk@codeconstruct.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23. 11. 21, 2:59, Jeremy Kerr wrote:
> This change adds a MCTP Serial transport binding, as defined by DMTF
> specificiation DSP0253 - "MCTP Serial Transport Binding". This is
> implemented as a new serial line discipline, and can be attached to
> arbitrary tty devices.
…
> --- /dev/null
> +++ b/drivers/net/mctp/mctp-serial.c
> @@ -0,0 +1,510 @@
…
> +static int next_chunk_len(struct mctp_serial *dev)
> +{
> +	int i;
> +
> +	/* either we have no bytes to send ... */
> +	if (dev->txpos == dev->txlen)
> +		return 0;
> +
> +	/* ... or the next byte to send is an escaped byte; requiring a
> +	 * single-byte chunk...

This is not a correct multi-line comment. Or does net/ differ in this?

> +	 */
> +	if (needs_escape(dev->txbuf[dev->txpos]))
> +		return 1;
> +
> +	/* ... or we have one or more bytes up to the next escape - this chunk
> +	 * will be those non-escaped bytes, and does not include the escaped
> +	 * byte.
> +	 */
> +	for (i = 1; i + dev->txpos + 1 < dev->txlen; i++) {
> +		if (needs_escape(dev->txbuf[dev->txpos + i + 1]))
> +			break;
> +	}
> +
> +	return i;
> +}
> +
> +static int write_chunk(struct mctp_serial *dev, unsigned char *buf, int len)
> +{
> +	return dev->tty->ops->write(dev->tty, buf, len);
> +}


> +static netdev_tx_t mctp_serial_tx(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct mctp_serial *dev = netdev_priv(ndev);
> +	unsigned long flags;
> +
> +	WARN_ON(dev->txstate != STATE_IDLE);
> +
> +	if (skb->len > MCTP_SERIAL_MTU) {

Shouldn't you implement ndo_change_mtu to forbid larger frames instead?

> +		dev->netdev->stats.tx_dropped++;
> +		goto out;
> +	}
> +
> +	spin_lock_irqsave(&dev->lock, flags);
> +	netif_stop_queue(dev->netdev);
> +	skb_copy_bits(skb, 0, dev->txbuf, skb->len);
> +	dev->txpos = 0;
> +	dev->txlen = skb->len;
> +	dev->txstate = STATE_START;
> +	spin_unlock_irqrestore(&dev->lock, flags);
> +
> +	set_bit(TTY_DO_WRITE_WAKEUP, &dev->tty->flags);
> +	schedule_work(&dev->tx_work);
> +
> +out:
> +	kfree_skb(skb);
> +	return NETDEV_TX_OK;
> +}
…
> +static void mctp_serial_rx(struct mctp_serial *dev)
> +{
> +	struct mctp_skb_cb *cb;
> +	struct sk_buff *skb;
> +
> +	if (dev->rxfcs != dev->rxfcs_rcvd) {
> +		dev->netdev->stats.rx_dropped++;
> +		dev->netdev->stats.rx_crc_errors++;
> +		return;
> +	}
> +
> +	skb = netdev_alloc_skb(dev->netdev, dev->rxlen);

Just thinking… Wouldn't it be easier to have dev->skb instead of 
dev->rxbuf and push data to it directly in all those mctp_serial_push*()?

> +	if (!skb) {
> +		dev->netdev->stats.rx_dropped++;
> +		return;
> +	}
> +
> +	skb->protocol = htons(ETH_P_MCTP);
> +	skb_put_data(skb, dev->rxbuf, dev->rxlen);
> +	skb_reset_network_header(skb);
> +
> +	cb = __mctp_cb(skb);
> +	cb->halen = 0;
> +
> +	netif_rx_ni(skb);
> +	dev->netdev->stats.rx_packets++;
> +	dev->netdev->stats.rx_bytes += dev->rxlen;
> +}


> +static int mctp_serial_open(struct tty_struct *tty)
> +{
> +	struct mctp_serial *dev;
> +	struct net_device *ndev;
> +	char name[32];
> +	int idx, rc;
> +
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	if (!tty->ops->write)
> +		return -EOPNOTSUPP;
> +
> +	if (tty->disc_data)
> +		return -EEXIST;

This should never happen™.

> +
> +	idx = ida_alloc(&mctp_serial_ida, GFP_KERNEL);
> +	if (idx < 0)
> +		return idx;
> +
> +	snprintf(name, sizeof(name), "mctpserial%d", idx);
> +	ndev = alloc_netdev(sizeof(*dev), name, NET_NAME_ENUM,
> +			    mctp_serial_setup);
> +	if (!ndev) {
> +		rc = -ENOMEM;
> +		goto free_ida;
> +	}
> +
> +	dev = netdev_priv(ndev);
> +	dev->idx = idx;
> +	dev->tty = tty;
> +	dev->netdev = ndev;
> +	dev->txstate = STATE_IDLE;
> +	dev->rxstate = STATE_IDLE;
> +	spin_lock_init(&dev->lock);
> +	INIT_WORK(&dev->tx_work, mctp_serial_tx_work);
> +
> +	rc = register_netdev(ndev);
> +	if (rc)
> +		goto free_netdev;
> +
> +	tty->receive_room = 64 * 1024;
> +	tty->disc_data = dev;
> +
> +	return 0;
> +
> +free_netdev:
> +	free_netdev(ndev);
> +
> +free_ida:
> +	ida_free(&mctp_serial_ida, idx);
> +	return rc;
> +}
> +
> +static void mctp_serial_close(struct tty_struct *tty)
> +{
> +	struct mctp_serial *dev = tty->disc_data;
> +	int idx = dev->idx;
> +
> +	unregister_netdev(dev->netdev);
> +	ida_free(&mctp_serial_ida, idx);

No tx_work flushing/cancelling?

> +}

regards,
-- 
js
suse labs
