Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF991EAF67
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgFATCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728037AbgFATCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:02:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAC1C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:02:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74A8611D53F8B;
        Mon,  1 Jun 2020 12:02:33 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:02:32 -0700 (PDT)
Message-Id: <20200601.120232.1629917452255419192.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, willemb@google.com, ppenkov@google.com
Subject: Re: [PATCH net v2] tun: correct header offsets in napi frags mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530194131.80155-1-willemdebruijn.kernel@gmail.com>
References: <20200530194131.80155-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:02:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sat, 30 May 2020 15:41:31 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> Tun in IFF_NAPI_FRAGS mode calls napi_gro_frags. Unlike netif_rx and
> netif_gro_receive, this expects skb->data to point to the mac layer.
> 
> But skb_probe_transport_header, __skb_get_hash_symmetric, and
> xdp_do_generic in tun_get_user need skb->data to point to the network
> header. Flow dissection also needs skb->protocol set, so
> eth_type_trans has to be called.
> 
> Ensure the link layer header lies in linear as eth_type_trans pulls
> ETH_HLEN. Then take the same code paths for frags as for not frags.
> Push the link layer header back just before calling napi_gro_frags.
> 
> By pulling up to ETH_HLEN from frag0 into linear, this disables the
> frag0 optimization in the special case when IFF_NAPI_FRAGS is used
> with zero length iov[0] (and thus empty skb->linear).
> 
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Petar Penkov <ppenkov@google.com>

Applied and queued up for -stable, thank you.
