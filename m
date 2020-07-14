Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39CE22001C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgGNVhf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Jul 2020 17:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgGNVhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:37:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA10C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:37:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D67B15E366E3;
        Tue, 14 Jul 2020 14:37:32 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:37:31 -0700 (PDT)
Message-Id: <20200714.143731.1428321936444887200.davem@davemloft.net>
To:     george.kennedy@oracle.com
Cc:     dan.carpenter@oracle.com, kuba@kernel.org, dhaval.giani@oracle.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] ax88172a: fix ax88172a_unbind() failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b7423f65-53d5-35d7-a469-509163c85853@oracle.com>
References: <20200714080038.GX2571@kadam>
        <20200714.140323.590389609923321569.davem@davemloft.net>
        <b7423f65-53d5-35d7-a469-509163c85853@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 14:37:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Kennedy <george.kennedy@oracle.com>
Date: Tue, 14 Jul 2020 17:34:33 -0400

> For example, the failing case here has "ret" = 0 (#define ETH_ALEN 6):
> 
>     172 static int ax88172a_bind(struct usbnet *dev, struct
> usb_interface *intf)
>     173 {
> ...
>     186         /* Get the MAC address */
>     187         ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0,
> ETH_ALEN, buf, 0);
>     188         if (ret < ETH_ALEN) {
>     189                 netdev_err(dev->net, "Failed to read MAC
> address: %d\n", ret);
>     190                 goto free;
>     191         }
> "drivers/net/usb/ax88172a.c"

Then this is the spot that should set 'ret' to -EINVAL or similar?
