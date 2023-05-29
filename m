Return-Path: <netdev+bounces-6083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40969714C56
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAB4F1C209CF
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C73D8463;
	Mon, 29 May 2023 14:48:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6017B8BF7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:48:56 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC5DCF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=sh14opWKem7tbvdArM4A+cYouCeo0TIF2iNqelXCu6Y=; b=y6yKRmlj8VDBJSxAmvTfE6U89E
	8kdu+K3ZLnPz404+yn50FYaGrvpHrwgJ3VwkyhyrW10lHhykj4tHEJEAhSrC8+gzsEmNn5vN4qVmx
	B97FRwfGOSrD+r6lxuy4hTJMWpdNLdHaK75G8TK1sLJ3phEbu3rx0TJDIqxobOawhl/0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3eB1-00EEe4-3m; Mon, 29 May 2023 16:48:51 +0200
Date: Mon, 29 May 2023 16:48:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Tristram.Ha@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>,
	Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Message-ID: <cd313489-603e-4d8e-a09d-22a0c492a3cd@lunn.ch>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +	if (wol->wolopts & WAKE_ARP) {
> +		const u8 *ip_addr =
> +			((const u8 *)&((ndev->ip_ptr)->ifa_list)->ifa_address);

I'm not sure this is safe. What happens when the interface only has an
IPv6 address? Is ifa_list a NULL pointer? I really think you need to
be using a core helper to get the IPv4 address.

> +		const u16 mask[3] = { 0xF03F, 0x003F, 0x03C0 };

Are there any endianness issues here? I've not looked at how mask is
used, but if it is indicating which bytes in the pattern should be
matched on, i guess endian does matter.

> +		u8 pattern[42] = {
> +			0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x08, 0x06,
> +			0x00, 0x01, 0x08, 0x00, 0x06, 0x04, 0x00, 0x01,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +			0x00, 0x00, 0x00, 0x00 };


> +	if (wol->wolopts & WAKE_MCAST) {
> +		u8 pattern[6] = { 0x33, 0x33, 0xFF, 0x00, 0x00, 0x00 };
> +		u16 mask[1] = { 0x0007 };
> +		u8 len = 3;
> +
> +		/* Try to match IPv6 Neighbor Solicitation. */
> +		if (ndev->ip6_ptr) {
> +			struct list_head *addr_list =
> +				&ndev->ip6_ptr->addr_list;
> +			struct inet6_ifaddr *ifa;
> +
> +			list_for_each_entry(ifa, addr_list, if_list) {
> +				if (ifa->scope == IFA_LINK) {
> +					memcpy(&pattern[3],
> +					       &ifa->addr.in6_u.u6_addr8[13],
> +					       3);
> +					mask[0] = 0x003F;
> +					len = 6;
> +					break;
> +				}
> +			}
> +		}

From an architecture point of view, i don't think a PHY driver should
be access these data structure directly. See if ipv6_get_lladdr() does
what you need?

> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_UCAST)) {
> +		const u8 *mac = (const u8 *)ndev->dev_addr;
> +
> +		if (!is_valid_ether_addr(mac))
> +			return -EINVAL;

Is that possible? Does the hardware care?

   Andrew

---
pw-bot: cr

