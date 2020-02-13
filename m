Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964E315C43E
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 16:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgBMPpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:45:16 -0500
Received: from gateway36.websitewelcome.com ([192.185.200.11]:34696 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728169AbgBMPpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:45:15 -0500
X-Greylist: delayed 1408 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 10:45:14 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id A8B784019E742
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 08:35:47 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 2GJBjLTcxvBMd2GJBjJyMD; Thu, 13 Feb 2020 09:21:41 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tlzInWey23Efbti3IVI7QK7bG7x1edOF4vWB/j8UuCg=; b=qUBPc+5fDEGt6M5dgwJulMJp+G
        xcMtSAYOH/X0jV8IyUUPvs80Ttm+MXBgQ8qc27gOJWz05nEnxh4pFjiFklBTyOZgBCxQ0gkv0qNVU
        oKGPrxltSRC+XnaTwGk/xuX5mhgyFpgQdq+I4gqPpsSIi2DpRDoQCe55ho30GyrzWIqoyuzXhHiwE
        jyiSnpGoggRlGalXfSmMNqIutwrK5Wee4Z77OuIp/CvM13nU/t/nBmkfntKDkFRCSdgrqjor/APB0
        5QE3/CkAoKBfUgQV9K5AT+4GfPe1H4rDZTWmD742+C+7oRRpkbCKEhX4WDPXJMHEDFtddVW2fo3hk
        OXEc0N7Q==;
Received: from [200.68.140.15] (port=29529 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j2GJA-003BYr-8t; Thu, 13 Feb 2020 09:21:40 -0600
Date:   Thu, 13 Feb 2020 09:24:16 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] bpf: queue_stack_maps: Replace zero-length array with
 flexible-array member
Message-ID: <20200213152416.GA1873@embeddedor>
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
X-Source-IP: 200.68.140.15
X-Source-L: No
X-Exim-ID: 1j2GJA-003BYr-8t
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.15]:29529
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 28
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
 kernel/bpf/queue_stack_maps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f697647ceb54..30e1373fd437 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -19,7 +19,7 @@ struct bpf_queue_stack {
 	u32 head, tail;
 	u32 size; /* max_entries + 1 */
 
-	char elements[0] __aligned(8);
+	char elements[] __aligned(8);
 };
 
 static struct bpf_queue_stack *bpf_queue_stack(struct bpf_map *map)
-- 
2.25.0

