Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28BB20513
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfEPLkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfEPLkv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:40:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2FC620833;
        Thu, 16 May 2019 11:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006850;
        bh=5PqpqsePIaUZFwMZ6QtcnVAgVczOlnG/PGID8A8lAE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvYlxS2n01PEKLxtUeoCqVzpX6kjA/REt7O/Pa2CTSjgCkdmE7l/K5s4k/vuoJVg7
         mF5CGWwtCLCmK6YIYh1XxgtefhO2asXKfgzVzPL7vVDdmzhNGiGkrCHpyG2ixTo/uM
         MK5EXqaqwW7BPAUMpXbWp6DWUp64v+1HxXT/XM00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/25] bpf: Fix preempt_enable_no_resched() abuse
Date:   Thu, 16 May 2019 07:40:21 -0400
Message-Id: <20190516114029.8682-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114029.8682-1-sashal@kernel.org>
References: <20190516114029.8682-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 0edd6b64d1939e9e9168ff27947995bb7751db5d ]

Unless the very next line is schedule(), or implies it, one must not use
preempt_enable_no_resched(). It can cause a preemption to go missing and
thereby cause arbitrary delays, breaking the PREEMPT=y invariant.

Cc: Roman Gushchin <guro@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 523481a3471b5..fd95f2efe5f32 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -400,7 +400,7 @@ int bpf_prog_array_copy(struct bpf_prog_array __rcu *old_array,
 		}					\
 _out:							\
 		rcu_read_unlock();			\
-		preempt_enable_no_resched();		\
+		preempt_enable();			\
 		_ret;					\
 	 })
 
-- 
2.20.1

