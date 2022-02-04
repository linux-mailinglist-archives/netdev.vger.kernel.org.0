Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E884AA410
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353924AbiBDXOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:14:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44066 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbiBDXOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:14:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5BD0CE24BA;
        Fri,  4 Feb 2022 23:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F09C004E1;
        Fri,  4 Feb 2022 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644016473;
        bh=fkMwYBKvbFi2f59VTbiYok/TBWSxIk3qx+WKrnPRpZk=;
        h=Date:From:To:Cc:Subject:From;
        b=UW2/QdnhuVJNmOmrza0vFekR0P2u/O2D+OTJMk0rTeGqWMWisuTuILbDkg5I90lIJ
         EwkJ/YQ/YsmetpfI2RW1LiiwpEWciB4AYi5dk4CgRl+r/VUlgn/UXL/GcaVdYRTd6R
         vDkqcGR4AlgUoA2ORSCIODY7Szh8oJEBLNZrOOyyj8HZfcKbu9nwRLBEG2ovfMKDVe
         tLthORsHTb3R50mWKyja9KbQgomrywzgnVMpyZq+w3DSmBSBg4jf1VmI0PrTCJvQiv
         do2scjrg5gYGmhldIUXf8DpxTvGqy3P55jA4BONubFtAFV377v+gJkJSYhdAiV7RcE
         CJk2/3WhXgYPQ==
Date:   Fri, 4 Feb 2022 17:21:44 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] bnx2x: Replace one-element array with flexible-array
 member
Message-ID: <20220204232144.GA442861@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

This issue was found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index a19dd6797070..447a75ea0cc1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -1271,7 +1271,7 @@ struct bnx2x_fw_stats_data {
 	struct per_port_stats		port;
 	struct per_pf_stats		pf;
 	struct fcoe_statistics_params	fcoe;
-	struct per_queue_stats		queue_stats[1];
+	struct per_queue_stats		queue_stats[];
 };
 
 /* Public slow path states */
-- 
2.27.0

