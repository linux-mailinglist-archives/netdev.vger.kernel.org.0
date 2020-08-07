Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D7D23E4EC
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 02:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgHGACL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 20:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHGACL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 20:02:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EEEC061574;
        Thu,  6 Aug 2020 17:02:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 836BE11D69C3E;
        Thu,  6 Aug 2020 16:45:23 -0700 (PDT)
Date:   Thu, 06 Aug 2020 17:02:05 -0700 (PDT)
Message-Id: <20200806.170205.1316893051509388641.davem@davemloft.net>
To:     xie.he.0141@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        willemdebruijn.kernel@gmail.com, ms@dev.tdt.de,
        briannorris@chromium.org
Subject: Re: [PATCH] drivers/net/wan/lapbether: Added needed_headroom and a
 skb->len check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806015040.98379-1-xie.he.0141@gmail.com>
References: <20200806015040.98379-1-xie.he.0141@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Aug 2020 16:45:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>
Date: Wed,  5 Aug 2020 18:50:40 -0700

> 1. Added a skb->len check
> 
> This driver expects upper layers to include a pseudo header of 1 byte
> when passing down a skb for transmission. This driver will read this
> 1-byte header. This patch added a skb->len check before reading the
> header to make sure the header exists.
> 
> 2. Changed to use needed_headroom instead of hard_header_len to request
> necessary headroom to be allocated
> 
> In net/packet/af_packet.c, the function packet_snd first reserves a
> headroom of length (dev->hard_header_len + dev->needed_headroom).
> Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> which calls dev->header_ops->create, to create the link layer header.
> If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> length (dev->hard_header_len), and assumes the user to provide the
> appropriate link layer header.
> 
> So according to the logic of af_packet.c, dev->hard_header_len should
> be the length of the header that would be created by
> dev->header_ops->create.
> 
> However, this driver doesn't provide dev->header_ops, so logically
> dev->hard_header_len should be 0.
> 
> So we should use dev->needed_headroom instead of dev->hard_header_len
> to request necessary headroom to be allocated.
> 
> This change fixes kernel panic when this driver is used with AF_PACKET
> SOCK_RAW sockets.
> 
> Call stack when panic:
 ...
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied and queued up for -stable, thanks.
