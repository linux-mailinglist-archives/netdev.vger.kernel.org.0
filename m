Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139C021402B
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 21:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgGCT7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 15:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgGCT7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 15:59:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED67C061794;
        Fri,  3 Jul 2020 12:59:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1897B15503C5B;
        Fri,  3 Jul 2020 12:59:34 -0700 (PDT)
Date:   Fri, 03 Jul 2020 12:59:33 -0700 (PDT)
Message-Id: <20200703.125933.1255981278532631718.davem@davemloft.net>
To:     alobakin@marvell.com
Cc:     kuba@kernel.org, irusskikh@marvell.com,
        michal.kalderon@marvell.com, aelior@marvell.com,
        denis.bolotin@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: qed: prevent buffer overflow when collecting
 debug data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703090258.2076-1-alobakin@marvell.com>
References: <20200703090258.2076-1-alobakin@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jul 2020 12:59:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>
Date: Fri, 3 Jul 2020 12:02:58 +0300

> When generating debug dump, driver firstly collects all data in binary
> form, and then performs per-feature formatting to human-readable if it
> is supported.
> The size of the new formatted data is often larger than the raw's. This
> becomes critical when user requests dump via ethtool (-d/-w), as output
> buffer size is strictly determined (by ethtool_ops::get_regs_len() etc),
> as it may lead to out-of-bounds writes and memory corruption.
> 
> To not go past initial lengths, add a flag to return original,
> non-formatted debug data, and set it in such cases. Also set data type
> in regdump headers, so userland parsers could handle it.
> 
> Fixes: c965db444629 ("qed: Add support for debug data collection")
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

This is now how ethtool register dumps work.

It does not provide "human readable" versions of register data.  Instead
it is supposed to be purely raw data and then userland utilities interpret
that data and can make it human readable based upon the driver name and
reg dump version.

Please fix your ethtool -d implementation to comply with this.

Thank you.
