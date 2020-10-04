Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AF9282DF0
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 00:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgJDWId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 18:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgJDWId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 18:08:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77117C0613CE;
        Sun,  4 Oct 2020 15:08:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2A4D12782289;
        Sun,  4 Oct 2020 14:51:44 -0700 (PDT)
Date:   Sun, 04 Oct 2020 15:08:31 -0700 (PDT)
Message-Id: <20201004.150831.1030602377050100130.davem@davemloft.net>
To:     trix@redhat.com
Cc:     thomas.petazzoni@bootlin.com, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        ezequiel.garcia@free-electrons.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: mvneta: fix double free of txq->buf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201003185121.12370-1-trix@redhat.com>
References: <20201003185121.12370-1-trix@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:51:45 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: trix@redhat.com
Date: Sat,  3 Oct 2020 11:51:21 -0700

> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis reports this problem:
> 
> drivers/net/ethernet/marvell/mvneta.c:3465:2: warning:
>   Attempt to free released memory
>         kfree(txq->buf);
>         ^~~~~~~~~~~~~~~
> 
> When mvneta_txq_sw_init() fails to alloc txq->tso_hdrs,
> it frees without poisoning txq->buf.  The error is caught
> in the mvneta_setup_txqs() caller which handles the error
> by cleaning up all of the txqs with a call to
> mvneta_txq_sw_deinit which also frees txq->buf.
> 
> Since mvneta_txq_sw_deinit is a general cleaner, all of the
> partial cleaning in mvneta_txq_sw_deinit()'s error handling
> is not needed.
> 
> Fixes: 2adb719d74f6 ("net: mvneta: Implement software TSO")
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied and queued up for -stable, thank you.
