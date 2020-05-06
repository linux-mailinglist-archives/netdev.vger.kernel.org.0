Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843E01C7CD7
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgEFVwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:52:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29D1C061A0F;
        Wed,  6 May 2020 14:52:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F66D1273D95E;
        Wed,  6 May 2020 14:52:21 -0700 (PDT)
Date:   Wed, 06 May 2020 14:52:20 -0700 (PDT)
Message-Id: <20200506.145220.1567628861970386108.davem@davemloft.net>
To:     ayush.sawal@chelsio.com
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, manojmalaviya@chelsio.com
Subject: Re: [PATCH net-next] Revert "crypto: chelsio - Inline single pdu
 only"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506144719.3725-1-ayush.sawal@chelsio.com>
References: <20200506144719.3725-1-ayush.sawal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 14:52:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>
Date: Wed,  6 May 2020 20:17:19 +0530

> This reverts commit 27c6feb0fb33a665a746346e76714826a5be5d10.
> 
> For ipsec offload the chelsio's ethernet driver expects a single mtu
> sized packet.
> 
> But when ipsec traffic is running using iperf, most of the packets in
> that traffic are gso packets(large sized skbs) because GSO is enabled by
> default in TCP, due to this commit 0a6b2a1dc2a2 ("tcp: switch to GSO
> being always on"), so chcr_ipsec_offload_ok() receives a gso
> skb(with gso_size non zero).
> 
> Due to the check in chcr_ipsec_offload_ok(), this function returns false
> for most of the packet, then ipsec offload is skipped and the skb goes
> out taking the coprocessor path which reduces the bandwidth for inline
> ipsec.
> 
> If this check is removed then for most of the packets(large sized skbs)
> the chcr_ipsec_offload_ok() returns true and then as GSO is on, the
> segmentation of the packet happens in the kernel and then finally the
> driver_xmit is called, which receives a segmented mtu sized packet which
> is what the driver expects for ipsec offload. So this case becomes
> unnecessary here, therefore removing it.
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Applied.
