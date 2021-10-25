Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9252A43964C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhJYM3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:29:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhJYM33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GEJMIp1Co7EQbihLV9HM0uM2vYDqN3IJKvgEFJVwY50=; b=uzIzKIarGL49x+1Kr6N08KTUp6
        TNbdDakDIhgFq4EMg40r3tdrn8rgDHZEOlkxzduQExNgepNuOdmw1m92PU3mKv5H9ov5e5qiyhscA
        bDhXUCegbWldcGzzTlpCNvTSBu6HrE/i6Sew7hTJ5FkvM+LSXmpIGOKaLR9R2HuldrkU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mez4E-00BeA6-BB; Mon, 25 Oct 2021 14:27:06 +0200
Date:   Mon, 25 Oct 2021 14:27:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can <linux-can@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: ethtool: ring configuration for CAN devices
Message-ID: <YXaimhlXkpBKRQin@lunn.ch>
References: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024213759.hwhlb4e3repkvo6y@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 11:37:59PM +0200, Marc Kleine-Budde wrote:
> Hello,
> 
> I'm currently working on runtime configurable RX/TX ring sizes for a the
> mcp251xfd CAN driver.
> 
> Unlike modern Ethernet cards with DMA support, most CAN IP cores come
> with a fixed size on chip RAM that's used to store received CAN frames
> and frames that should be sent.
> 
> For CAN-2.0 only devices that can be directly supported via ethtools's
> set/get_ringparam. A minor unaesthetic is, as the on chip RAM is usually
> shared between RX and TX, the maximum values for RX and TX cannot be set
> at the same time.
> 
> The mcp251xfd chip I'm enhancing supports CAN-2.0 and CAN-FD mode. The
> relevant difference of these modes is the size of the CAN frame. 8 vs 64
> bytes of payload + 12 bytes of header. This means we have different
> maximum values for both RX and TX for those modes.
> 
> How do we want to deal with the configuration of the two different
> modes? As the current set/get_ringparam interface can configure the
> mini- and jumbo frames for RX, but has only a single TX value.

Hi Marc

I would not consider it as two different modes, but as N modes. That
way, we are prepared for CAN-3.0 which might need other ring
parameters.

The netlink API is extensible, unlike the IOCTL interface. I would add
an additional optional attribute, ETHTOOL_A_RINGS_MODE, with values like:

ETHTOOL_A_RINGS_MODE_DEFAULT
ETHTOOL_A_RINGS_MODE_CAN_2
ETHTOOL_A_RINGS_MODE_CAN_FD

The IOCTL would always be for mode _DEFAULT, and it would get/set the
current used setting. If the optionally attribute is missing, then the
calling into the driver would also use _DEFAULT. However, if it is
present, the driver can store away the ring parameters for a
particular mode, and maybe actually put them into use if the mode is
currently active.

You cannot change

struct ethtool_ringparam {
	__u32	cmd;
	__u32	rx_max_pending;
	__u32	rx_mini_max_pending;
	__u32	rx_jumbo_max_pending;
	__u32	tx_max_pending;
	__u32	rx_pending;
	__u32	rx_mini_pending;
	__u32	rx_jumbo_pending;
	__u32	tx_pending;
};

Since that is ABI. But you can add an

struct ethtool_kringparam {
	__u32	cmd;
	__u32   mode;
	__u32	rx_max_pending;
	__u32	rx_mini_max_pending;
	__u32	rx_jumbo_max_pending;
	__u32	tx_max_pending;
	__u32	rx_pending;
	__u32	rx_mini_pending;
	__u32	rx_jumbo_pending;
	__u32	tx_pending;
};

and use this structure between the ethtool core and the drivers. This
has already been done at least once to allow extending the
API. Semantic patches are good for making the needed changes to all
the drivers.

     Andrew
