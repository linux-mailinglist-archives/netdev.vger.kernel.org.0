Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8F1145C8B
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgAVTiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:38:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVTiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:38:13 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C4BD15A14DD8;
        Wed, 22 Jan 2020 11:38:06 -0800 (PST)
Date:   Wed, 22 Jan 2020 20:38:04 +0100 (CET)
Message-Id: <20200122.203804.923537127367735988.davem@davemloft.net>
To:     maximmi@mellanox.com
Cc:     alobakin@dlink.ru, ecree@solarflare.com, saeedm@mellanox.com,
        netdev@vger.kernel.org, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        tariqt@mellanox.com, jiri@mellanox.com, edumazet@google.com
Subject: Re: [PATCH net v2] net: Fix packet reordering caused by GRO and
 listified RX cooperation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121150917.6279-1-maximmi@mellanox.com>
References: <20200121150917.6279-1-maximmi@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jan 2020 11:38:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>
Date: Tue, 21 Jan 2020 15:09:40 +0000

> Commit 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL
> skbs") introduces batching of GRO_NORMAL packets in napi_frags_finish,
> and commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()") adds the same to napi_skb_finish. However,
> dev_gro_receive (that is called just before napi_{frags,skb}_finish) can
> also pass skbs to the networking stack: e.g., when the GRO session is
> flushed, napi_gro_complete is called, which passes pp directly to
> netif_receive_skb_internal, skipping napi->rx_list. It means that the
> packet stored in pp will be handled by the stack earlier than the
> packets that arrived before, but are still waiting in napi->rx_list. It
> leads to TCP reorderings that can be observed in the TCPOFOQueue counter
> in netstat.
> 
> This commit fixes the reordering issue by making napi_gro_complete also
> use napi->rx_list, so that all packets going through GRO will keep their
> order. In order to keep napi_gro_flush working properly, gro_normal_list
> calls are moved after the flush to clear napi->rx_list.
> 
> iwlwifi calls napi_gro_flush directly and does the same thing that is
> done by gro_normal_list, so the same change is applied there:
> napi_gro_flush is moved to be before the flush of napi->rx_list.
> 
> A few other drivers also use napi_gro_flush (brocade/bna/bnad.c,
> cortina/gemini.c, hisilicon/hns3/hns3_enet.c). The first two also use
> napi_complete_done afterwards, which performs the gro_normal_list flush,
> so they are fine. The latter calls napi_gro_receive right after
> napi_gro_flush, so it can end up with non-empty napi->rx_list anyway.
> 
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Applied and queued up for v5.4 -stable, thank you.
