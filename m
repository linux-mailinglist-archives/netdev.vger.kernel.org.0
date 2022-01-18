Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF604919D9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347482AbiARC4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38444 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348723AbiARCpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:45:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A908612E9;
        Tue, 18 Jan 2022 02:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C0EC36AE3;
        Tue, 18 Jan 2022 02:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473953;
        bh=HOVjiGuJLSrGgAuWUGQwZudQWNHmplGt08zBeWR6DBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hiK/fKfaA58nbx37hW6AZlvw5vENaFC/rOcm7BV/gPM1p1VqrxQWXGEPinY1cHbBQ
         QVhXZM3xDqMUgOYNNchLZJ8wq8PR1Fyp5mveq2FjhVNclT3GGpNYm61Ieaz+ZZZmBV
         a4jcx4N2dmyYimDt10KnhVftC6mRIb3GpzRPo8OXYo4BTSacydlQKxmEIYHABA2fgS
         SDF2qX+ocUqVc/cQDfS5ZAEe2RR6pM4vVIT2T8cGa+Q/9Ik3oHweJPULNiG8lvv35+
         NH71ATt5dkk/Rgt72NgG+5oDIW4WhXg+Ca4lDFEk5o/wVyDj0xwXSu10Swgsz4/PqL
         TIkiFJMeqRrXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 38/73] bpf: Do not WARN in bpf_warn_invalid_xdp_action()
Date:   Mon, 17 Jan 2022 21:43:57 -0500
Message-Id: <20220118024432.1952028-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 2cbad989033bff0256675c38f96f5faab852af4b ]

The WARN_ONCE() in bpf_warn_invalid_xdp_action() can be triggered by
any bugged program, and even attaching a correct program to a NIC
not supporting the given action.

The resulting splat, beyond polluting the logs, fouls automated tools:
e.g. a syzkaller reproducers using an XDP program returning an
unsupported action will never pass validation.

Replace the WARN_ONCE with a less intrusive pr_warn_once().

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/016ceec56e4817ebb2a9e35ce794d5c917df572c.1638189075.git.pabeni@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5ebc973ed4c50..0ef3a8a63afc0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6910,9 +6910,9 @@ void bpf_warn_invalid_xdp_action(u32 act)
 {
 	const u32 act_max = XDP_REDIRECT;
 
-	WARN_ONCE(1, "%s XDP return value %u, expect packet loss!\n",
-		  act > act_max ? "Illegal" : "Driver unsupported",
-		  act);
+	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
+		     act > act_max ? "Illegal" : "Driver unsupported",
+		     act);
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
-- 
2.34.1

