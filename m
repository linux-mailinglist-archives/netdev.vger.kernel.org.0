Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB0524165A
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 08:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHKGdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 02:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgHKGdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 02:33:22 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC24820774;
        Tue, 11 Aug 2020 06:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597127601;
        bh=z1Ojr/Zecm9QJSnsyUBeo7c3xuI6Rz0wIo8MpL1zQpE=;
        h=From:To:Cc:Subject:Date:From;
        b=zacbTdQjglT5kZNK/z9TF61YaPMayl504iWBjN/qZUDUshmEKohhQ0osvV7AXeC2h
         M2C5jx6rTLp73+0m4jD2QXwg/qUxpKzIjn9mfyiTeFiIF3SFKaLK/XfUrAIocUxcBl
         exo3f4TlCt9HkyvldSRaUvhBSmjhP90GwUhc8Qus=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc] rdma: Fix owner name for the kernel resources
Date:   Tue, 11 Aug 2020 09:33:04 +0300
Message-Id: <20200811063304.581395-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Owner of kernel resources is printed in different format than user
resources to easy with the reader by simply looking on the name.
The kernel owner will have "[ ]" around the name.

Before this change:
[leonro@vm ~]$ rdma res show qp
link rocep0s9/1 lqpn 1 type GSI state RTS sq-psn 58 comm ib_core

After this change:
[leonro@vm ~]$ rdma res show qp
link rocep0s9/1 lqpn 1 type GSI state RTS sq-psn 58 comm [ib_core]

Fixes: b0a688a542cd ("rdma: Rewrite custom JSON and prints logic to use common API")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/res.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/res.c b/rdma/res.c
index c99a1fcb..6eca87e5 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -161,7 +161,7 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 		snprintf(tmp, sizeof(tmp), "%s", str);
 	else
 		snprintf(tmp, sizeof(tmp), "[%s]", str);
-	print_color_string(PRINT_ANY, COLOR_NONE, "comm", "comm %s ", str);
+	print_color_string(PRINT_ANY, COLOR_NONE, "comm", "comm %s ", tmp);
 }

 void print_dev(struct rd *rd, uint32_t idx, const char *name)
--
2.26.2

