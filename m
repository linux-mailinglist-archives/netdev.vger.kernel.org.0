Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B64228BF5
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgGUWe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUWe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:34:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F647C061794;
        Tue, 21 Jul 2020 15:34:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8885D11E45900;
        Tue, 21 Jul 2020 15:17:43 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:34:27 -0700 (PDT)
Message-Id: <20200721.153427.1257555808984580585.davem@davemloft.net>
To:     yoshihiro.shimoda.uh@renesas.com
Cc:     sergei.shtylyov@gmail.com, kuba@kernel.org,
        dirk.behme@de.bosch.com, Shashikant.Suguni@in.bosch.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3] net: ethernet: ravb: exit if re-initialization
 fails in tx timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595312592-28666-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1595312592-28666-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:17:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue, 21 Jul 2020 15:23:12 +0900

> According to the report of [1], this driver is possible to cause
> the following error in ravb_tx_timeout_work().
> 
> ravb e6800000.ethernet ethernet: failed to switch device to config mode
> 
> This error means that the hardware could not change the state
> from "Operation" to "Configuration" while some tx and/or rx queue
> are operating. After that, ravb_config() in ravb_dmac_init() will fail,
> and then any descriptors will be not allocaled anymore so that NULL
> pointer dereference happens after that on ravb_start_xmit().
> 
> To fix the issue, the ravb_tx_timeout_work() should check
> the return values of ravb_stop_dma() and ravb_dmac_init().
> If ravb_stop_dma() fails, ravb_tx_timeout_work() re-enables TX and RX
> and just exits. If ravb_dmac_init() fails, just exits.
> 
> [1]
> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/
> 
> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Applied, thank you.
