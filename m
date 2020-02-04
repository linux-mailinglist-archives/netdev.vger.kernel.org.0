Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885B5151EFD
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgBDRLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:11:18 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:26127 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgBDRLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:11:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580836273;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=97kFKdtjqzM1fuVk+6yX5/4JtYqIyrLVpwZ5MbyNC38=;
        b=H1l+etZy9wheFJiMvEHfocFYBKHlmcJePG4g2yEHZKwJfkQ9t3rYv6SSQUFeOYI5fP
        qyUkOkbjGX26yR3hQWp1rk085Rg4ev+Mz0bh9izUuqBdGsG6VJc7UPUWdjhu6EREoGo5
        zvlJYhWFe2eAkvBaleQHm2SmkH+nvLDSCHbQnRJL1PB9YfkGB0wBfn+xi2/4S1WBE9Mp
        3SoG2RULYx1j320NUL2gFxZiKw2DhvzIvBWjIwbfKMp6Avay1efa7hQgq1sfTr0ambKw
        D1X/dhIazXKa2JK2DYKvEWcIRmCarQYCl9Ov7W4DCKNeDCTHkXg+f3TxK0RNpC/W/jIP
        OV/Q==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJUsh6k0go"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id g084e8w14HB4DHS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 4 Feb 2020 18:11:04 +0100 (CET)
Subject: Re: [PATCH] bonding: do not enslave CAN devices
To:     linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, mkl@pengutronix.de, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        linux-stable <stable@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
References: <20200130133046.2047-1-socketcan@hartkopp.net>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <3315b977-8b62-ca07-7117-d87ad476a548@hartkopp.net>
Date:   Tue, 4 Feb 2020 18:11:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200130133046.2047-1-socketcan@hartkopp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any updates, reviews, acks on this?

As pointed out by Sabrina here 
https://marc.info/?l=linux-netdev&m=158039302905460&w=2
the issue is also relevant for the TEAM driver.

Best,
Oliver

On 30/01/2020 14.30, Oliver Hartkopp wrote:
> Since commit 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
> device struct can_dev_rcv_lists") the device specific CAN receive filter lists
> are stored in netdev_priv() and dev->ml_priv points to these filters.
> 
> In the bug report Syzkaller enslaved a vxcan1 CAN device and accessed the
> bonding device with a PF_CAN socket which lead to a crash due to an access of
> an unhandled bond_dev->ml_priv pointer.
> 
> Deny to enslave CAN devices by the bonding driver as the resulting bond_dev
> pretends to be a CAN device by copying dev->type without really being one.
> 
> Reported-by: syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com
> Fixes: 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
> device struct can_dev_rcv_lists")
> Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> ---
>   drivers/net/bonding/bond_main.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 48d5ec770b94..4b781a7dfd96 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1475,6 +1475,18 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
>   		return -EPERM;
>   	}
>   
> +	/* CAN network devices hold device specific filter lists in
> +	 * netdev_priv() where dev->ml_priv sets a reference to.
> +	 * As bonding assumes to have some ethernet-like device it doesn't
> +	 * take care about these CAN specific filter lists today.
> +	 * So we deny the enslaving of CAN interfaces here.
> +	 */
> +	if (slave_dev->type == ARPHRD_CAN) {
> +		NL_SET_ERR_MSG(extack, "CAN devices can not be enslaved");
> +		slave_err(bond_dev, slave_dev, "no bonding on CAN devices\n");
> +		return -EINVAL;
> +	}
> +
>   	/* set bonding device ether type by slave - bonding netdevices are
>   	 * created with ether_setup, so when the slave type is not ARPHRD_ETHER
>   	 * there is a need to override some of the type dependent attribs/funcs.
> 
