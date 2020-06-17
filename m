Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE00F1FD80E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgFQWAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQWAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:00:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0773C06174E;
        Wed, 17 Jun 2020 15:00:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92AAD1297C67F;
        Wed, 17 Jun 2020 15:00:02 -0700 (PDT)
Date:   Wed, 17 Jun 2020 14:59:59 -0700 (PDT)
Message-Id: <20200617.145959.1761016261916982775.davem@davemloft.net>
To:     jk@ozlabs.org
Cc:     netdev@vger.kernel.org, allan@asix.com.tw, freddy@asix.com.tw,
        pfink@christ-es.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: ax88179_178a: fix packet alignment padding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615025456.30219-1-jk@ozlabs.org>
References: <20200615025456.30219-1-jk@ozlabs.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jun 2020 15:00:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Kerr <jk@ozlabs.org>
Date: Mon, 15 Jun 2020 10:54:56 +0800

> Using a AX88179 device (0b95:1790), I see two bytes of appended data on
> every RX packet. For example, this 48-byte ping, using 0xff as a
> payload byte:
> 
>   04:20:22.528472 IP 192.168.1.1 > 192.168.1.2: ICMP echo request, id 2447, seq 1, length 64
> 	0x0000:  000a cd35 ea50 000a cd35 ea4f 0800 4500
> 	0x0010:  0054 c116 4000 4001 f63e c0a8 0101 c0a8
> 	0x0020:  0102 0800 b633 098f 0001 87ea cd5e 0000
> 	0x0030:  0000 dcf2 0600 0000 0000 ffff ffff ffff
> 	0x0040:  ffff ffff ffff ffff ffff ffff ffff ffff
> 	0x0050:  ffff ffff ffff ffff ffff ffff ffff ffff
> 	0x0060:  ffff 961f
> 
> Those last two bytes - 96 1f - aren't part of the original packet.
> 
> In the ax88179 RX path, the usbnet rx_fixup function trims a 2-byte
> 'alignment pseudo header' from the start of the packet, and sets the
> length from a per-packet field populated by hardware. It looks like that
> length field *includes* the 2-byte header; the current driver assumes
> that it's excluded.
> 
> This change trims the 2-byte alignment header after we've set the packet
> length, so the resulting packet length is correct. While we're moving
> the comment around, this also fixes the spelling of 'pseudo'.
> 
> Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

Applied and queued up for -stable.
