Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3D0173810
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgB1NQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:16:15 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.38]:49380 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgB1NQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:16:15 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 0940E400D1BD5
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 07:16:14 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7fUzjI0doRP4z7fV0jgPu9; Fri, 28 Feb 2020 07:16:14 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RE0pda+OoJ4cL4RKWAP8k9023lNF5IK92xD1bJo2GXE=; b=EZGpzrAjcSTU9tz+KfZHqu3MaD
        Szx/qQVD/GAzX0ei1A5yn3SEFGEFtfveb/Djj8PebHtnx8f6bMcK4yM01h62XDJuo3pez1f1ujXRC
        hYME70p+aB3CqunyFFknk14DeKJ2TkgG+cQVdCGIpOs10T40Rqd1nw4hcusDP9PsD/HKIB8nKC/If
        7omwKqGkNQMvQ6128OO9V1dH3kviLjV6frN5K2qD1HUmucRqDywSKZMdJUt3bhM+EhXwFBYMKO9KP
        TSeepnIY8xV2HWjOasENBL0Ybv8pI057b22QVKUQha1ySpHOVT4Q/sxztyDBr6y+cJ3fF4S2ZmfL/
        VAEeWIoA==;
Received: from [201.162.240.44] (port=6535 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7fUx-001EPI-Hz; Fri, 28 Feb 2020 07:16:12 -0600
Date:   Fri, 28 Feb 2020 07:19:07 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] xdp: Replace zero-length array with flexible-array
 member
Message-ID: <20200228131907.GA17911@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.240.44
X-Source-L: No
X-Exim-ID: 1j7fUx-001EPI-Hz
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:6535
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 10
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
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

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/xdp/xsk_queue.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 89a01ac4e079..b50bb5c76da5 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -19,13 +19,13 @@ struct xdp_ring {
 /* Used for the RX and TX queues for packets */
 struct xdp_rxtx_ring {
 	struct xdp_ring ptrs;
-	struct xdp_desc desc[0] ____cacheline_aligned_in_smp;
+	struct xdp_desc desc[] ____cacheline_aligned_in_smp;
 };
 
 /* Used for the fill and completion queues for buffers */
 struct xdp_umem_ring {
 	struct xdp_ring ptrs;
-	u64 desc[0] ____cacheline_aligned_in_smp;
+	u64 desc[] ____cacheline_aligned_in_smp;
 };
 
 struct xsk_queue {
-- 
2.25.0

