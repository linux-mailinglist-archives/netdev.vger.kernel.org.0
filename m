Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8422210069
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgF3X2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgF3X2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:28:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D843C061755;
        Tue, 30 Jun 2020 16:28:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7D34127D3F63;
        Tue, 30 Jun 2020 16:28:15 -0700 (PDT)
Date:   Tue, 30 Jun 2020 16:28:13 -0700 (PDT)
Message-Id: <20200630.162813.775042630673995756.davem@davemloft.net>
To:     cjhuang@codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v2] net: qrtr: free flow in __qrtr_node_release
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593499971-9212-1-git-send-email-cjhuang@codeaurora.org>
References: <1593499971-9212-1-git-send-email-cjhuang@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 16:28:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>
Date: Tue, 30 Jun 2020 14:52:51 +0800

> The flow is allocated in qrtr_tx_wait, but not freed when qrtr node
> is released. (*slot) becomes NULL after radix_tree_iter_delete is
> called in __qrtr_node_release. The fix is to save (*slot) to a
> vairable and then free it.
> 
> This memory leak is catched when kmemleak is enabled in kernel,
> the report looks like below:
> 
> unreferenced object 0xffffa0de69e08420 (size 32):
>   comm "kworker/u16:3", pid 176, jiffies 4294918275 (age 82858.876s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 28 84 e0 69 de a0 ff ff  ........(..i....
>     28 84 e0 69 de a0 ff ff 03 00 00 00 00 00 00 00  (..i............
>   backtrace:
>     [<00000000e252af0a>] qrtr_node_enqueue+0x38e/0x400 [qrtr]
>     [<000000009cea437f>] qrtr_sendmsg+0x1e0/0x2a0 [qrtr]
>     [<000000008bddbba4>] sock_sendmsg+0x5b/0x60
>     [<0000000003beb43a>] qmi_send_message.isra.3+0xbe/0x110 [qmi_helpers]
>     [<000000009c9ae7de>] qmi_send_request+0x1c/0x20 [qmi_helpers]
> 
> Signed-off-by: Carl Huang <cjhuang@codeaurora.org>

Applied and queued up for -stable, thanks.
