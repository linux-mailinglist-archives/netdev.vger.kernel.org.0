Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD8D362A95
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236324AbhDPVup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 17:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235422AbhDPVun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 17:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65231610E7;
        Fri, 16 Apr 2021 21:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618609818;
        bh=6L+fBTnmXvjsKWrq+HTLgNRFc6T2FEzJaeGZu54L3xw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jtw4MNhroJlPkFSgpIpEC6vw4e5o1aGJ0y+OTA0fN19gGfPlx1syvCHuxaHwoADS/
         XgZZF01qddyct+5BxoHlsjaGtULVxij8upBpncr4aOPhbPRRXGAPyZAZz8+sOhdAx+
         7LYk2zQlq+iKdsrBiuebvUVUtcRJxaIlTmIhjg9gvB1AM/BTRMbBG5JDbbjfDJjVFC
         msZD+ez7/wJsNX7qMQzo9dihYLx5m6gJX1QawIhIuXk6QAq6V6U+Xj3QxyVi5kbvFr
         gbwzUF8GrGf0Vz96T6/9WPL4pATCGjo0ezhfM/vN44mGrW+xtZfQG7KMkQsios1ckH
         kZSLbPpriOUDQ==
Date:   Fri, 16 Apr 2021 14:50:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 4/6] r8152: support new chips
Message-ID: <20210416145017.1946f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1394712342-15778-354-Taiwan-albertk@realtek.com>
References: <1394712342-15778-350-Taiwan-albertk@realtek.com>
        <1394712342-15778-354-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 16:04:35 +0800 Hayes Wang wrote:
> Support RTL8153C, RTL8153D, RTL8156A, and RTL8156B. The RTL8156A
> and RTL8156B are the 2.5G ethernet.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

> +	switch (tp->version) {
> +	case RTL_VER_10:
> +		data = ocp_reg_read(tp, 0xad40);
> +		data &= ~0x3ff;
> +		data |= BIT(7) | BIT(2);
> +		ocp_reg_write(tp, 0xad40, data);
> +
> +		data = ocp_reg_read(tp, 0xad4e);
> +		data |= BIT(4);
> +		ocp_reg_write(tp, 0xad4e, data);
> +		data = ocp_reg_read(tp, 0xad16);
> +		data &= ~0x3ff;
> +		data |= 0x6;
> +		ocp_reg_write(tp, 0xad16, data);
> +		data = ocp_reg_read(tp, 0xad32);
> +		data &= ~0x3f;
> +		data |= 6;
> +		ocp_reg_write(tp, 0xad32, data);
> +		data = ocp_reg_read(tp, 0xac08);
> +		data &= ~(BIT(12) | BIT(8));
> +		ocp_reg_write(tp, 0xac08, data);
> +		data = ocp_reg_read(tp, 0xac8a);
> +		data |= BIT(12) | BIT(13) | BIT(14);
> +		data &= ~BIT(15);
> +		ocp_reg_write(tp, 0xac8a, data);
> +		data = ocp_reg_read(tp, 0xad18);
> +		data |= BIT(10);
> +		ocp_reg_write(tp, 0xad18, data);
> +		data = ocp_reg_read(tp, 0xad1a);
> +		data |= 0x3ff;
> +		ocp_reg_write(tp, 0xad1a, data);
> +		data = ocp_reg_read(tp, 0xad1c);
> +		data |= 0x3ff;
> +		ocp_reg_write(tp, 0xad1c, data);
> +
> +		data = sram_read(tp, 0x80ea);
> +		data &= ~0xff00;
> +		data |= 0xc400;
> +		sram_write(tp, 0x80ea, data);
> +		data = sram_read(tp, 0x80eb);
> +		data &= ~0x0700;
> +		data |= 0x0300;
> +		sram_write(tp, 0x80eb, data);
> +		data = sram_read(tp, 0x80f8);
> +		data &= ~0xff00;
> +		data |= 0x1c00;
> +		sram_write(tp, 0x80f8, data);
> +		data = sram_read(tp, 0x80f1);
> +		data &= ~0xff00;
> +		data |= 0x3000;
> +		sram_write(tp, 0x80f1, data);

> +	switch (tp->version) {
> +	case RTL_VER_12:
> +		ocp_reg_write(tp, 0xbf86, 0x9000);
> +		data = ocp_reg_read(tp, 0xc402);
> +		data |= BIT(10);
> +		ocp_reg_write(tp, 0xc402, data);
> +		data &= ~BIT(10);
> +		ocp_reg_write(tp, 0xc402, data);
> +		ocp_reg_write(tp, 0xbd86, 0x1010);
> +		ocp_reg_write(tp, 0xbd88, 0x1010);
> +		data = ocp_reg_read(tp, 0xbd4e);
> +		data &= ~(BIT(10) | BIT(11));
> +		data |= BIT(11);
> +		ocp_reg_write(tp, 0xbd4e, data);
> +		data = ocp_reg_read(tp, 0xbf46);
> +		data &= ~0xf00;
> +		data |= 0x700;
> +		ocp_reg_write(tp, 0xbf46, data);

> +	data = r8153_phy_status(tp, 0);
> +	switch (data) {
> +	case PHY_STAT_EXT_INIT:
> +		rtl8152_apply_firmware(tp, true);
> +
> +		data = ocp_reg_read(tp, 0xa466);
> +		data &= ~BIT(0);
> +		ocp_reg_write(tp, 0xa466, data);

What are all these magic constants? :(

> @@ -6878,7 +8942,11 @@ static int rtl8152_probe(struct usb_interface *intf,
>  	set_ethernet_addr(tp);
>  
>  	usb_set_intfdata(intf, tp);
> -	netif_napi_add(netdev, &tp->napi, r8152_poll, RTL8152_NAPI_WEIGHT);
> +
> +	if (tp->support_2500full)
> +		netif_napi_add(netdev, &tp->napi, r8152_poll, 256);

why 256? We have 100G+ drivers all using 64 what's special here?

> +	else
> +		netif_napi_add(netdev, &tp->napi, r8152_poll, 64);

