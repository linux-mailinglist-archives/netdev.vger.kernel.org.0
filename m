Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8A343FCB3
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhJ2Mzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:55:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhJ2Mzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Tf+eFvst+sDmVDewSuH83kOgYhym8Pp3p42wSXNJ1CE=; b=gN+DweX/VDoKVlzDFmerEQN38s
        T9J7syOeh7Mb+rjLyaSJz6Y3z6Gk9D3MWIeHeFD1+X6Ww1FsKjTMSoz99OH5AqEAYs3MQoGD3fewu
        uCxIZssVvZ8mBZ7TMBgkvXilHxmufngiIOabTcQLaqXYXukPDczN8OVZYKsxuYSH5WU8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mgRNU-00C65b-G9; Fri, 29 Oct 2021 14:53:00 +0200
Date:   Fri, 29 Oct 2021 14:53:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     kuba@kernel.org, mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: marvell: prestera: add firmware v4.0
 support
Message-ID: <YXvurO1ssFPL15Qu@lunn.ch>
References: <1635485889-27504-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635485889-27504-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct prestera_msg_event_port_param {
> +	union {
> +		struct {
> +			u8 oper;
> +			__le32 mode;
> +			__le32 speed;
> +			u8 duplex;
> +			u8 fc;
> +			u8 fec;

Makes more sense to put the 2 le32 first and then the 4 u8s. At the
moment, the le32 are not word aligned, so the compiler has to issue
more instructions.


> +		} __packed mac;
> +		struct {
> +			u8 mdix;
> +			__le64 lmode_bmap;
> +			u8 fc;

Same here, le64 first, then to two u8.

>  union prestera_msg_port_param {
> -	u8  admin_state;
> -	u8  oper_state;
> -	u32 mtu;
> -	u8  mac[ETH_ALEN];
> -	u8  accept_frm_type;
> -	u32 speed;
> +	u8 admin_state;
> +	u8 oper_state;
> +	__le32 mtu;

2 u8 followed by a le32? Swap them.

> +	u8 mac[ETH_ALEN];

You then get the 6 byte MAC and the 2 u8 giving you word alignment.

> +	u8 accept_frm_type;
> +	__le32 speed;

Swap these two, keeping speed word aligned.

>  	u8 learning;
>  	u8 flood;

You have 3 u8 in a row, so move another u8 up to keep word alignment, say type.

> -	u32 link_mode;
> -	u8  type;
> -	u8  duplex;
> -	u8  fec;
> -	u8  fc;
> -	struct prestera_msg_port_mdix_param mdix;
> -	struct prestera_msg_port_autoneg_param autoneg;
> +	__le32 link_mode;
> +	u8 type;
> +	u8 duplex;
> +	u8 fec;
> +	u8 fc;
> +	union {

With type moved up, this whole union becomes unaligned. So you might
want to explicitly add a reserved byte here. Make sure it is set to
zero when sent to the firmware, and ignored on receive.

> +		struct {
> +			u8 admin:1;
> +			u8 fc;
> +			u8 ap_enable;

Move these three after the next union, to keep the union aligned.

> +			union {
> +				struct {
> +					__le32 mode;
> +					u8  inband:1;
> +					__le32 speed;

speed should be second, so it is aligned.

> +					u8  duplex;
> +					u8  fec;
> +					u8  fec_supp;
> +				} __packed reg_mode;
> +				struct {
> +					__le32 mode;
> +					__le32 speed;
> +					u8  fec;
> +					u8  fec_supp;
> +				} __packed ap_modes[PRESTERA_AP_PORT_MAX];
> +			} __packed;
> +		} __packed mac;
> +		struct {
> +			u8 admin:1;
> +			u8 adv_enable;
> +			__le64 modes;
> +			__le32 mode;

These two le64 come first to keep them aligned.

> +			u8 mdix;
> +		} __packed phy;
> +	} __packed link;


Hopefully you get the idea. Getting alignment correct will produce
smaller faster code, especially on architectures where none aligned
accesses are expensive.

> @@ -475,15 +543,15 @@ static int __prestera_cmd_ret(struct prestera_switch *sw,
>  	struct prestera_device *dev = sw->dev;
>  	int err;
>  
> -	cmd->type = type;
> +	cmd->type = __cpu_to_le32(type);
>  
> -	err = dev->send_req(dev, cmd, clen, ret, rlen, waitms);
> +	err = dev->send_req(dev, 0, cmd, clen, ret, rlen, waitms);
>  	if (err)
>  		return err;
>  
> -	if (ret->cmd.type != PRESTERA_CMD_TYPE_ACK)
> +	if (__le32_to_cpu(ret->cmd.type) != PRESTERA_CMD_TYPE_ACK)
>  		return -EBADE;

Makes more sense to apply the endianness swap to
PRESTERA_CMD_TYPE_ACK. That can be done at compile time, where as
swapping ret->cmd.type has to be done a runtime.


> -	if (ret->status != PRESTERA_CMD_ACK_OK)
> +	if (__le32_to_cpu(ret->status) != PRESTERA_CMD_ACK_OK)
>  		return -EINVAL;

So this patch is now doing two different things at once. It is fixing
your broken endianness support, and it is changing the ABI. Please
separate these into different patches. Fix the endianness first, then
change the ABI. That will make it much easier to review.

       Andrew
