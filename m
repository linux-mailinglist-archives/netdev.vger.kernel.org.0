Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442DFFF327
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfKPQYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:24:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbfKPPmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:45 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EBD82073B;
        Sat, 16 Nov 2019 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918964;
        bh=SqMAJqA3YHvVV9J5WhrstskH1pJ06XfwMtA3zAsaE7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xrtA7PNRaCa05URnBlRGCWEb/Xqkk4Hb8qFj6mTj4hvvTYhwwlZyUVBdMOOFxuQrq
         513E7LYAAPCWjdvKhvAU2mjgSa40sBau7t3oOmMD6fxVJSfJzYqfZq9HOWgKl/3TMK
         aaj4QazclojQsIbXfa6tDrWBtNEDenop3ONAP1EY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Hao <peng.hao2@zte.com.cn>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 081/237] selftests/bpf: fix file resource leak in load_kallsyms
Date:   Sat, 16 Nov 2019 10:38:36 -0500
Message-Id: <20191116154113.7417-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Hao <peng.hao2@zte.com.cn>

[ Upstream commit 1bd70d2eba9d90eb787634361f0f6fa2c86b3f6d ]

FILE pointer variable f is opened but never closed.

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index cf156b3536798..82922f13dcd3a 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -41,6 +41,7 @@ int load_kallsyms(void)
 		syms[i].name = strdup(func);
 		i++;
 	}
+	fclose(f);
 	sym_cnt = i;
 	qsort(syms, sym_cnt, sizeof(struct ksym), ksym_cmp);
 	return 0;
-- 
2.20.1

