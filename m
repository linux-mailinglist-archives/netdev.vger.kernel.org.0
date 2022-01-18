Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C314F4919BA
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344012AbiARCzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:55:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34048 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347788AbiARCm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:42:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5EDF612E2;
        Tue, 18 Jan 2022 02:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B978EC36AF5;
        Tue, 18 Jan 2022 02:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473777;
        bh=yAqAZHiaUVsSKWYcyJbT5Pw4juaXoBzS3wlC3RLGxvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmJ81s1bEOXyyWiWPLlv21RvlP0/aiBn8nmanfTHsKbpLOG9cK5Xv9z6F08VNEM1c
         CHCANjR0KHj2shQqsoUGoZpVoIASL8hpAskdwfXSVff+LwSEZOw/GjZU+aKQd8DD3u
         uIh0R9QbHr7r1rVQyROP+l4TiIBcm6a6X6fe90GMiyiKfTAVMKQt6+r0E3pog0YDes
         NBVDDqdVcAXi8GFMN6tJKlQ8XsXN98fpoCLzBezxUzymr26eo+JnTWQpvrVaFfXfS9
         6vG8Uof4pvb886yMBtl9FDzX0HJVdnnG2AJ/EqBz88ZRecBGERulXjdvI81ZC/0Rbz
         0mJMnKNipfL/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>, ast@kernel.org,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 066/116] bpf: Do not WARN in bpf_warn_invalid_xdp_action()
Date:   Mon, 17 Jan 2022 21:39:17 -0500
Message-Id: <20220118024007.1950576-66-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index abd58dce49bbc..578b0bc78ac10 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7919,9 +7919,9 @@ void bpf_warn_invalid_xdp_action(u32 act)
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

