Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD69115AF0
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 05:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfLGETw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 23:19:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfLGETw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 23:19:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF6821536B4D8;
        Fri,  6 Dec 2019 20:19:50 -0800 (PST)
Date:   Fri, 06 Dec 2019 20:19:50 -0800 (PST)
Message-Id: <20191206.201950.100960973648804142.davem@davemloft.net>
To:     alobakin@dlink.ru
Cc:     muciri@openmesh.com, shashidhar.lakkavalli@openmesh.com,
        john@phrozen.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, sdf@google.com, daniel@iogearbox.net,
        songliubraving@fb.com, ast@kernel.org, mcroce@redhat.com,
        jakub@cloudflare.com, edumazet@google.com, paulb@mellanox.com,
        komachi.yoshiki@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205100235.14195-1-alobakin@dlink.ru>
References: <20191205100235.14195-1-alobakin@dlink.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 20:19:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>
Date: Thu,  5 Dec 2019 13:02:35 +0300

> Commit 43e665287f93 ("net-next: dsa: fix flow dissection") added an
> ability to override protocol and network offset during flow dissection
> for DSA-enabled devices (i.e. controllers shipped as switch CPU ports)
> in order to fix skb hashing for RPS on Rx path.
> 
> However, skb_hash() and added part of code can be invoked not only on
> Rx, but also on Tx path if we have a multi-queued device and:
>  - kernel is running on UP system or
>  - XPS is not configured.
> 
> The call stack in this two cases will be like: dev_queue_xmit() ->
> __dev_queue_xmit() -> netdev_core_pick_tx() -> netdev_pick_tx() ->
> skb_tx_hash() -> skb_get_hash().
> 
> The problem is that skbs queued for Tx have both network offset and
> correct protocol already set up even after inserting a CPU tag by DSA
> tagger, so calling tag_ops->flow_dissect() on this path actually only
> breaks flow dissection and hashing.
> 
> This can be observed by adding debug prints just before and right after
> tag_ops->flow_dissect() call to the related block of code:
  ...
> In order to fix that we can add the check 'proto == htons(ETH_P_XDSA)'
> to prevent code from calling tag_ops->flow_dissect() on Tx.
> I also decided to initialize 'offset' variable so tagger callbacks can
> now safely leave it untouched without provoking a chaos.
> 
> Fixes: 43e665287f93 ("net-next: dsa: fix flow dissection")
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

Applied and queued up for -stable.

