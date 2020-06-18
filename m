Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2145A1FDBE0
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgFRBP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728727AbgFRBPR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C4532088E;
        Thu, 18 Jun 2020 01:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442917;
        bh=hWvsQYDqO6ODPc2VivaR0tA2XykBahjovGY7dkG8Gk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSJ4YnZkQFbsdQVpkI1DtK5v+O+YLp70YFL66+jJiny4i3Yq2E5soGiJ3CLYX0qi5
         4jmSNY+pypFlSZN0DpdyDLSX+DllGr91Tw0qxGzGytL19zzl2O1w2yf1DcOBWrT0du
         WlEgsee6uEitn78U21ObRzbWTcIGI02t6f0M5i08=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 334/388] bpf: Fix an error code in check_btf_func()
Date:   Wed, 17 Jun 2020 21:07:11 -0400
Message-Id: <20200618010805.600873-334-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e7ed83d6fa1a00d0f2ad0327e73d3ea9e7ea8de1 ]

This code returns success if the "info_aux" allocation fails but it
should return -ENOMEM.

Fixes: 8c1b6e69dcc1 ("bpf: Compare BTF types of functions arguments with actual types")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20200604085436.GA943001@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index efe14cf24bc6..739d9ba3ba6b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7366,7 +7366,7 @@ static int check_btf_func(struct bpf_verifier_env *env,
 	const struct btf *btf;
 	void __user *urecord;
 	u32 prev_offset = 0;
-	int ret = 0;
+	int ret = -ENOMEM;
 
 	nfuncs = attr->func_info_cnt;
 	if (!nfuncs)
-- 
2.25.1

