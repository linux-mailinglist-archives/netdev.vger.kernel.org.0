Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF937FFE9
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 23:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhEMVvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 17:51:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233485AbhEMVvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 17:51:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78AF1613F7;
        Thu, 13 May 2021 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620942613;
        bh=jylMkVVffJcfLoicOnx1jFxnRZpA8OtO3GY3fkMHtGc=;
        h=Date:From:To:Cc:Subject:From;
        b=U8qdmD7iZmqF7v+/Q04eb+HdSftHkOzszJsUncPUUej934a8o41tC9LCyfF/06eP4
         gF+vWMiKdeAwIctsNBfezYXRYDHdXGcWq+oYc4k2YiI6tHD8KLJymQ80Eq/01b1u1u
         IKgQBooUyB/xIEQzoSUfhsu+Pr2SduOoWnGR+IooJdt5h7h/rul/R4cjU2/TcdCr4H
         Q7pOrhq+fHGHSsVGSKGVQsnZSTNcVrkGHSGVyubE0qQksrIRzpFOWnGyOa/O/82I/A
         S+tAIEkEfvux2FOPsO2SA0OfjgELA4HvL7pKEL/pdimSo2Be2lptQiPBT13/WV4CRA
         9mc5kiJyDxkzQ==
Date:   Thu, 13 May 2021 16:50:49 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] bpf: Use struct_size() in kzalloc()
Message-ID: <20210513215049.GA215271@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows
that, in the worst scenario, could lead to heap overflows.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/core/bpf_sk_storage.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index cc3712ad8716..f564f82e91d9 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -524,8 +524,7 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs)
 			nr_maps++;
 	}
 
-	diag = kzalloc(sizeof(*diag) + sizeof(diag->maps[0]) * nr_maps,
-		       GFP_KERNEL);
+	diag = kzalloc(struct_size(diag, maps, nr_maps), GFP_KERNEL);
 	if (!diag)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.27.0

