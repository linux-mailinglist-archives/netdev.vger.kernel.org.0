Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EE61C9A1B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgEGS5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:57:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGS5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 14:57:08 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A9AF20575;
        Thu,  7 May 2020 18:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588877827;
        bh=WOf9xpQ5HsvErqveasmOo+6FbaiSq7EMDBqA6Zuvr9g=;
        h=Date:From:To:Cc:Subject:From;
        b=CZVkXBlqK81ZHEkhF1UydIa0D9wZ9bRa9JmpvmtRjbh0+WYW04qHnCaqXuGcXvY3V
         48pWDiywx9NuKbmQNtITowylWMtvROmmq+p6rcRmo3Ft8wmy0KxuX1q0YWPlwBrKQA
         jiIPE0lWR8D0TZuZJkz/+NzN+Es+QCp1xbf+vtz4=
Date:   Thu, 7 May 2020 14:01:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: atarilance: Replace zero-length array with
 flexible-array
Message-ID: <20200507190133.GA15348@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/amd/atarilance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 4e36122609a3..961796abab35 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -156,7 +156,7 @@ struct lance_memory {
 	struct lance_init_block	init;
 	struct lance_tx_head	tx_head[TX_RING_SIZE];
 	struct lance_rx_head	rx_head[RX_RING_SIZE];
-	char					packet_area[0];	/* packet data follow after the
+	char					packet_area[];	/* packet data follow after the
 											 * init block and the ring
 											 * descriptors and are located
 											 * at runtime */

