Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1511C9A04
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgEGSyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgEGSyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 14:54:55 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F5E20575;
        Thu,  7 May 2020 18:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588877694;
        bh=HAF/oRojkDljr1eFLRHqTl9dtHCZGeFR/+2LDxzGKKY=;
        h=Date:From:To:Cc:Subject:From;
        b=2EhmErFn2LX85sjp/FeeJMucTQta5AEMMF5VhGW2+khwX+hDXK9DvM3PDerwrWSzc
         pP5EnH/kZRTLqEtfwNo4xlmAlbu4Sd94+WTd0le1kMUyyxaNSlC2g6UGRgAZnzn5bf
         6lupoaMB2lCCK0sSNkkAToITfMdc1WT+GN3MQbfA=
Date:   Thu, 7 May 2020 13:59:21 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] IB/mlx4: Replace zero-length array with flexible-array
Message-ID: <20200507185921.GA15146@embeddedor>
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
 include/linux/mlx4/qp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 8e2828d48d7f..9db93e487496 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -362,7 +362,7 @@ struct mlx4_wqe_datagram_seg {
 
 struct mlx4_wqe_lso_seg {
 	__be32			mss_hdr_size;
-	__be32			header[0];
+	__be32			header[];
 };
 
 enum mlx4_wqe_bind_seg_flags2 {

