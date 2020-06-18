Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F6F1FE5E6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387656AbgFRC3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgFRBQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C536821D80;
        Thu, 18 Jun 2020 01:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442972;
        bh=wZAQsidRpruN3wZZ4eFfyqQT1wMLScdt0Bf/+b16xc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gcgeq3upFyJHTbc8PNH8MoMgsD11JyHSgh4nAriS5/bpV9nLl07sFcIWk+rPdF1Qo
         neTmB+KxNv819DU0+2fxbh/yUlrfwGNpXcT7Frpv4r4m46acTk+hcYlBHcAHVqHHHu
         /NkE6WDwj0JWVweu+HsPKmgZ108IzyUUrAEWFVdE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YiFei Zhu <zhuyifei1999@gmail.com>,
        YiFei Zhu <zhuyifei@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 376/388] net/filter: Permit reading NET in load_bytes_relative when MAC not set
Date:   Wed, 17 Jun 2020 21:07:53 -0400
Message-Id: <20200618010805.600873-376-sashal@kernel.org>
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

From: YiFei Zhu <zhuyifei1999@gmail.com>

[ Upstream commit 0f5d82f187e1beda3fe7295dfc500af266a5bd80 ]

Added a check in the switch case on start_header that checks for
the existence of the header, and in the case that MAC is not set
and the caller requests for MAC, -EFAULT. If the caller requests
for NET then MAC's existence is completely ignored.

There is no function to check NET header's existence and as far
as cgroup_skb/egress is concerned it should always be set.

Removed for ptr >= the start of header, considering offset is
bounded unsigned and should always be true. len <= end - mac is
redundant to ptr + len <= end.

Fixes: 3eee1f75f2b9 ("bpf: fix bpf_skb_load_bytes_relative pkt length check")
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/76bb820ddb6a95f59a772ecbd8c8a336f646b362.1591812755.git.zhuyifei@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5cc9276f1023..9080d01d9638 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1766,25 +1766,27 @@ BPF_CALL_5(bpf_skb_load_bytes_relative, const struct sk_buff *, skb,
 	   u32, offset, void *, to, u32, len, u32, start_header)
 {
 	u8 *end = skb_tail_pointer(skb);
-	u8 *net = skb_network_header(skb);
-	u8 *mac = skb_mac_header(skb);
-	u8 *ptr;
+	u8 *start, *ptr;
 
-	if (unlikely(offset > 0xffff || len > (end - mac)))
+	if (unlikely(offset > 0xffff))
 		goto err_clear;
 
 	switch (start_header) {
 	case BPF_HDR_START_MAC:
-		ptr = mac + offset;
+		if (unlikely(!skb_mac_header_was_set(skb)))
+			goto err_clear;
+		start = skb_mac_header(skb);
 		break;
 	case BPF_HDR_START_NET:
-		ptr = net + offset;
+		start = skb_network_header(skb);
 		break;
 	default:
 		goto err_clear;
 	}
 
-	if (likely(ptr >= mac && ptr + len <= end)) {
+	ptr = start + offset;
+
+	if (likely(ptr + len <= end)) {
 		memcpy(to, ptr, len);
 		return 0;
 	}
-- 
2.25.1

