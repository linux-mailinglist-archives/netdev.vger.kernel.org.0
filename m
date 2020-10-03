Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA244282069
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 04:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJCCJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 22:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJCCJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 22:09:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7035C0613D0;
        Fri,  2 Oct 2020 19:09:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4BCD9126298D1;
        Fri,  2 Oct 2020 18:52:44 -0700 (PDT)
Date:   Fri, 02 Oct 2020 19:09:31 -0700 (PDT)
Message-Id: <20201002.190931.2160541172091214230.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, vigneshr@ti.com,
        nsekhar@ti.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, m-karicheri2@ti.com
Subject: Re: [PATCH net-next 7/8] net: ethernet: ti: am65-cpsw: prepare
 xmit/rx path for multi-port devices in mac-only mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001105258.2139-8-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
        <20201001105258.2139-8-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 18:52:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Thu, 1 Oct 2020 13:52:57 +0300

> This patch adds multi-port support to TI AM65x CPSW driver xmit/rx path in
> preparation for adding support for multi-port devices, like Main CPSW0 on
> K3 J721E SoC or future CPSW3g on K3 AM64x SoC.
> Hence DMA channels are common/shared for all ext Ports and the RX/TX NAPI
> and DMA processing going to be assigned to first netdev this patch:
>  - ensures all RX descriptors fields are initialized;
>  - adds synchronization for TX DMA push/pop operation (locking) as
> Networking core is not enough any more;
>  - updates TX bql processing for every packet in
> am65_cpsw_nuss_tx_compl_packets() as every completed TX skb can have
> different ndev assigned (come from different netdevs).
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

This locking is unnecessary in single-port non-shared DMA situations
and therefore will impose unnecessary performance loss for basically
all existing supported setups.

Please do this another way.

In fact, I would encourage you to find a way to avoid the new atomic
operations even in multi-port configurations.

Thank you.
