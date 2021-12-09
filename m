Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2003146E07D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238307AbhLIB5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbhLIB5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:57:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372B6C061746;
        Wed,  8 Dec 2021 17:53:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7185ACE246D;
        Thu,  9 Dec 2021 01:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284F0C00446;
        Thu,  9 Dec 2021 01:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639014812;
        bh=eoHKcQX1NP6K4IqIO6Yqp2zmup/tdKRc0vyIl/OQ5rQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FW/gO/NSXfvkWote6KMkZFkMzKqEB3ouMK8MIYfZv/l2Xmj6GZZabyjC6oVyVLHlp
         iwjFZvK4hhkl51S3/mGrE1UAA8cWwXyZI9hqQQNQN3QAz9MjBL8rUYfiSMuFo9vCUd
         Q1QJBRQOO5bX6SCRfuvIMST5GTPyUOp1WQWbFPJ0b8Zg4WJx3xB4ZfGr5Zl9x5b5Ns
         X20y5ctg5RQdc+sp3jypE9HpeTO36/tGnd+wAUyGri4KnDX2sHH998Ez8WMl8GCT1b
         yGavDdvqGDJzkqQRXZOM3K2IgUFSjEUELvPX5e7DSjysRVUV1J21aIukHVHjvjg2bl
         m4tzEVs7Dh2QA==
Date:   Wed, 8 Dec 2021 17:53:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <xiayu.zhang@mediatek.com>
Cc:     <loic.poulain@linaro.org>, <ryazanov.s.a@gmail.com>,
        <davem@davemloft.net>, <johannes@sipsolutions.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <haijun.liu@mediatek.com>, <zhaoping.shu@mediatek.com>,
        <hw.he@mediatek.com>, <srv_heupstream@mediatek.com>
Subject: Re: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network
 Device
Message-ID: <20211208175331.35661ccd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 12:04:14 +0800 xiayu.zhang@mediatek.com wrote:
> From: Xiayu Zhang <Xiayu.Zhang@mediatek.com>
> 
> This patch adds 2 callback functions get_num_tx_queues() and
> get_num_rx_queues() to let WWAN network device driver customize its own
> TX and RX queue numbers. It gives WWAN driver a chance to implement its
> own software strategies, such as TX Qos.
> 
> Currently, if WWAN device driver creates default bearer interface when
> calling wwan_register_ops(), there will be only 1 TX queue and 1 RX queue
> for the WWAN network device. In this case, driver is not able to enlarge
> the queue numbers by calling netif_set_real_num_tx_queues() or
> netif_set_real_num_rx_queues() to take advantage of the network device's
> capability of supporting multiple TX/RX queues.
> 
> As for additional interfaces of secondary bearers, if userspace service
> doesn't specify the num_tx_queues or num_rx_queues in netlink message or
> iproute2 command, there also will be only 1 TX queue and 1 RX queue for
> each additional interface. If userspace service specifies the num_tx_queues
> and num_rx_queues, however, these numbers could be not able to match the
> capabilities of network device.
> 
> Besides, userspace service is hard to learn every WWAN network device's
> TX/RX queue numbers.
> 
> In order to let WWAN driver determine the queue numbers, this patch adds
> below callback functions in wwan_ops:
>     struct wwan_ops {
>         unsigned int priv_size;
>         ...
>         unsigned int (*get_num_tx_queues)(unsigned int hint_num);
>         unsigned int (*get_num_rx_queues)(unsigned int hint_num);
>     };
> 
> WWAN subsystem uses the input parameters num_tx_queues and num_rx_queues of
> wwan_rtnl_alloc() as hint values, and passes the 2 values to the two
> callback functions. WWAN device driver should determine the actual numbers
> of network device's TX and RX queues according to the hint value and
> device's capabilities.

I'll mark it as an RFC in patchwork, there needs to be an in-tree user
for this code to be merged.
