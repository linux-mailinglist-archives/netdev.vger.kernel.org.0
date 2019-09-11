Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41070AF77B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfIKIMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfIKIMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 04:12:49 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADD721479;
        Wed, 11 Sep 2019 08:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568189568;
        bh=TuGFTo4yDgBKVIjgEc0gL99p9EO6rgqJJ/wUOuDpG9M=;
        h=From:To:Cc:Subject:Date:From;
        b=jhSvXh0i97MUQYOtPmukf75XuHBMTkEEI/i01keIXAJ7NIKrwDZyrDL/rijgFqT6p
         PsgsBXIkwipBpf2/NXq2dW88KpsdSMU6KsUDJv2/H+dOCd6QYvDqwAFMWUSPzcEV48
         tPQs9EaQ+aTRV1o3EU+pqS3a2Ecd8ce5uXuMMqdE=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>, netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH iproute2-next] rdma: Check comm string before print in print_comm()
Date:   Wed, 11 Sep 2019 11:12:43 +0300
Message-Id: <20190911081243.28917-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Broken kernels (not-upstream) can provide wrong empty "comm" field.
It causes to segfault while printing in JSON format.

Fixes: 8ecac46a60ff ("rdma: Add QP resource tracking information")
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rdma/res.c b/rdma/res.c
index 97a7b964..6003006e 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -161,6 +161,9 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 {
 	char tmp[18];
 
+	if (!str)
+		return;
+
 	if (rd->json_output) {
 		/* Don't beatify output in JSON format */
 		jsonw_string_field(rd->jw, "comm", str);
-- 
2.20.1

