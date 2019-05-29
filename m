Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67792E602
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfE2UZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:25:19 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41266 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2UZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:25:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB86C149DCFFA;
        Wed, 29 May 2019 13:25:18 -0700 (PDT)
Date:   Wed, 29 May 2019 13:25:18 -0700 (PDT)
Message-Id: <20190529.132518.1102678070487513053.davem@davemloft.net>
To:     yoshihiro.shimoda.uh@renesas.com
Cc:     sergei.shtylyov@cogentembedded.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] net: sh_eth: fix mdio access in sh_eth_close() for
 R-Car Gen2 and RZ/A1 SoCs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559016646-7293-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1559016646-7293-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 13:25:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Tue, 28 May 2019 13:10:46 +0900

> The sh_eth_close() resets the MAC and then calls phy_stop()
> so that mdio read access result is incorrect without any error
> according to kernel trace like below:
> 
> ifconfig-216   [003] .n..   109.133124: mdio_access: ee700000.ethernet-ffffffff read  phy:0x01 reg:0x00 val:0xffff
> 
> According to the hardware manual, the RMII mode should be set to 1
> before operation the Ethernet MAC. However, the previous code was not
> set to 1 after the driver issued the soft_reset in sh_eth_dev_exit()
> so that the mdio read access result seemed incorrect. To fix the issue,
> this patch adds a condition and set the RMII mode register in
> sh_eth_dev_exit() for R-Car Gen2 and RZ/A1 SoCs.
> 
> Note that when I have tried to move the sh_eth_dev_exit() calling
> after phy_stop() on sh_eth_close(), but it gets worse (kernel panic
> happened and it seems that a register is accessed while the clock is
> off).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  Changes from v1 (https://patchwork.kernel.org/patch/10944265/):
>  - Revise the subject, commit log and the comment of the code.
>  - Move the RMII setting to right after soft_reset.

Applied, thank you.
