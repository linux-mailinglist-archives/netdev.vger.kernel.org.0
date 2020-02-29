Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71D51743A9
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgB2AKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:10:14 -0500
Received: from gateway34.websitewelcome.com ([192.185.148.212]:22494 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbgB2AKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:10:14 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id CEE692793D0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 18:10:12 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7phsj8jQ5Sl8q7phsjmcT0; Fri, 28 Feb 2020 18:10:12 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xNOoVJXsQbHnYoAPlqTzBSpU3sayaB7un57WUVRF4FU=; b=LBGYo6LshgUkcdiSBa0nmaAXXe
        OcV/VoGtUETVQ+4F4FxUjBDEvsIrXEGAjJ+NugNxt28ekCSY7AnG6zELbrsdQuswt8/XF+3kbxACm
        l52EovVYi3wjqHX4LYaI4AmmJJ6jyhyC9dzVb7m7x9GupsX989cS1ffPIPPmzm4KGUMWUWqRgLImk
        gW++/eNhnnqLTt51nBqAMGLdZRnhCT22/52nEWWcKRuMNs5dCBeyJ06di3bLRE6YXINxM/FK4qnCD
        ZKB68xtYJcGxiaKHckJAEDhDqU44Bgq3iUNbml+ZTl1cAnO3RuXjwiQziRwClF2kFFhgL2ufXgY8C
        tIteve2Q==;
Received: from [200.39.15.57] (port=31903 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7php-002dlM-48; Fri, 28 Feb 2020 18:10:10 -0600
Date:   Fri, 28 Feb 2020 18:13:05 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: sctp: Replace zero-length array with
 flexible-array member
Message-ID: <20200229001305.GA7465@embeddedor>
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
X-Source-IP: 200.39.15.57
X-Source-L: No
X-Exim-ID: 1j7php-002dlM-48
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:31903
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
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
 include/net/sctp/structs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 314a2fa21d6b..fb42c90348d3 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -326,7 +326,7 @@ struct sctp_cookie {
 	 * the association TCB is re-constructed from the cookie.
 	 */
 	__u32 raw_addr_list_len;
-	struct sctp_init_chunk peer_init[0];
+	struct sctp_init_chunk peer_init[];
 };
 
 
-- 
2.25.0

