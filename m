Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAF4FA492
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbfKMBz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbfKMBz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FB4222CD;
        Wed, 13 Nov 2019 01:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610125;
        bh=2mZNh7vjMLJ8VzjcNt4mAP3gxaWYiCtdp11s1HXRELc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRTa8/gylhOKzUjejuwgTcN3YOeKgOkjp9W50sms7H+u8BrZPcsn8Z/ThgNFxA8wF
         IX4zCSO0TUqw5QvW1V9/ATRpirvgaMidCKZjn80FACgpmQcQbnEB3l9IPmcboOtdYe
         ovkdSzAStTNugXDjm2Kj9qMW9klPAuipFfZawlHg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wang6495@umn.edu>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 177/209] bpf: btf: Fix a missing check bug
Date:   Tue, 12 Nov 2019 20:49:53 -0500
Message-Id: <20191113015025.9685-177-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wang6495@umn.edu>

[ Upstream commit 8af03d1ae2e154a8be3631e8694b87007e1bdbc2 ]

In btf_parse_hdr(), the length of the btf data header is firstly copied
from the user space to 'hdr_len' and checked to see whether it is larger
than 'btf_data_size'. If yes, an error code EINVAL is returned. Otherwise,
the whole header is copied again from the user space to 'btf->hdr'.
However, after the second copy, there is no check between
'btf->hdr->hdr_len' and 'hdr_len' to confirm that the two copies get the
same value. Given that the btf data is in the user space, a malicious user
can race to change the data between the two copies. By doing so, the user
can provide malicious data to the kernel and cause undefined behavior.

This patch adds a necessary check after the second copy, to make sure
'btf->hdr->hdr_len' has the same value as 'hdr_len'. Otherwise, an error
code EINVAL will be returned.

Signed-off-by: Wenwen Wang <wang6495@umn.edu>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 138f0302692ec..378cef70341c4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2114,6 +2114,9 @@ static int btf_parse_hdr(struct btf_verifier_env *env, void __user *btf_data,
 
 	hdr = &btf->hdr;
 
+	if (hdr->hdr_len != hdr_len)
+		return -EINVAL;
+
 	btf_verifier_log_hdr(env, btf_data_size);
 
 	if (hdr->magic != BTF_MAGIC) {
-- 
2.20.1

