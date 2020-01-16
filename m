Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC8C13E164
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgAPQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:49:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730106AbgAPQtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:49:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC5220663;
        Thu, 16 Jan 2020 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193351;
        bh=DjE97bheROVZ18CcWQMhWVFxif0qzaer0RVjZd8zi+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbdNXMljdUyEckVrou+6WqFjEdmangx+qMfaMVeDDijaqLDx4Mnf9vX1lbOgZArw7
         YFVWt8ClvQsP+eZbwF6Y5tmXeMb03h5tKZiH2UI5q7yK4yPUuBVnudx+X/uWuo5mNA
         HZAhK0UWtJTYfuwp0j/A/CQtEElgxx38dcfQBgb4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 080/205] libbpf: Don't use kernel-side u32 type in xsk.c
Date:   Thu, 16 Jan 2020 11:40:55 -0500
Message-Id: <20200116164300.6705-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit a566e35f1e8b4b3be1e96a804d1cca38b578167c ]

u32 is a kernel-side typedef. User-space library is supposed to use __u32.
This breaks Github's projection of libbpf. Do u32 -> __u32 fix.

Fixes: 94ff9ebb49a5 ("libbpf: Fix compatibility for kernels without need_wakeup")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20191029055953.2461336-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/xsk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index b29d37fba2b0..0c7386b0e42e 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -161,22 +161,22 @@ static void xsk_mmap_offsets_v1(struct xdp_mmap_offsets *off)
 	off->rx.producer = off_v1.rx.producer;
 	off->rx.consumer = off_v1.rx.consumer;
 	off->rx.desc = off_v1.rx.desc;
-	off->rx.flags = off_v1.rx.consumer + sizeof(u32);
+	off->rx.flags = off_v1.rx.consumer + sizeof(__u32);
 
 	off->tx.producer = off_v1.tx.producer;
 	off->tx.consumer = off_v1.tx.consumer;
 	off->tx.desc = off_v1.tx.desc;
-	off->tx.flags = off_v1.tx.consumer + sizeof(u32);
+	off->tx.flags = off_v1.tx.consumer + sizeof(__u32);
 
 	off->fr.producer = off_v1.fr.producer;
 	off->fr.consumer = off_v1.fr.consumer;
 	off->fr.desc = off_v1.fr.desc;
-	off->fr.flags = off_v1.fr.consumer + sizeof(u32);
+	off->fr.flags = off_v1.fr.consumer + sizeof(__u32);
 
 	off->cr.producer = off_v1.cr.producer;
 	off->cr.consumer = off_v1.cr.consumer;
 	off->cr.desc = off_v1.cr.desc;
-	off->cr.flags = off_v1.cr.consumer + sizeof(u32);
+	off->cr.flags = off_v1.cr.consumer + sizeof(__u32);
 }
 
 static int xsk_get_mmap_offsets(int fd, struct xdp_mmap_offsets *off)
-- 
2.20.1

