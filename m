Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A78C123F65
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfLRGH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:07:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRGH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:07:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CE9E15003987;
        Tue, 17 Dec 2019 22:07:27 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:07:26 -0800 (PST)
Message-Id: <20191217.220726.297850189715758528.davem@davemloft.net>
To:     ben@decadent.org.uk
Cc:     netdev@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
        navid.emamdoost@gmail.com
Subject: Re: [PATCH net] net: qlogic: Fix error paths in
 ql_alloc_large_buffers()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217015740.GA31381@decadent.org.uk>
References: <20191217015740.GA31381@decadent.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:07:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 17 Dec 2019 01:57:40 +0000

> ql_alloc_large_buffers() has the usual RX buffer allocation
> loop where it allocates skbs and maps them for DMA.  It also
> treats failure as a fatal error.
> 
> There are (at least) three bugs in the error paths:
> 
> 1. ql_free_large_buffers() assumes that the lrg_buf[] entry for the
> first buffer that couldn't be allocated will have .skb == NULL.
> But the qla_buf[] array is not zero-initialised.
> 
> 2. ql_free_large_buffers() DMA-unmaps all skbs in lrg_buf[].  This is
> incorrect for the last allocated skb, if DMA mapping failed.
> 
> 3. Commit 1acb8f2a7a9f ("net: qlogic: Fix memory leak in
> ql_alloc_large_buffers") added a direct call to dev_kfree_skb_any()
> after the skb is recorded in lrg_buf[], so ql_free_large_buffers()
> will double-free it.
> 
> The bugs are somewhat inter-twined, so fix them all at once:
> 
> * Clear each entry in qla_buf[] before attempting to allocate
>   an skb for it.  This goes half-way to fixing bug 1.
> * Set the .skb field only after the skb is DMA-mapped.  This
>   fixes the rest.
> 
> Fixes: 1357bfcf7106 ("qla3xxx: Dynamically size the rx buffer queue ...")
> Fixes: 0f8ab89e825f ("qla3xxx: Check return code from pci_map_single() ...")
> Fixes: 1acb8f2a7a9f ("net: qlogic: Fix memory leak in ql_alloc_large_buffers")
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

I've been over this a few times, applied and queued up for -stable.

Thanks.
