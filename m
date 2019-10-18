Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CB2DD1D6
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbfJRWGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731176AbfJRWGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDF942245D;
        Fri, 18 Oct 2019 22:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436376;
        bh=LNNQLMxHuH//SF79byo4zmELq1YgTbZqrKBWxPS1E2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRGMIYdtROGSkjtkyx3ePTTyBds6rcYNfq4ZzvDykyIlDkC7JKFLKP1i65ZKNuYIA
         HbWJT+5Jr1KBlc/GRPoYDFgnYMXbA/FdpShX2+fGZ6l5bNmj3KXiD2lMWZdwToLy4Z
         +39iXdhLffdtDLkrMfORe6VRvj7N0KeD36l2ZizI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/100] samples: bpf: fix: seg fault with NULL pointer arg
Date:   Fri, 18 Oct 2019 18:04:15 -0400
Message-Id: <20191018220525.9042-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>

[ Upstream commit d59dd69d5576d699d7d3f5da0b4738c3a36d0133 ]

When NULL pointer accidentally passed to write_kprobe_events,
due to strlen(NULL), segmentation fault happens.
Changed code returns -1 to deal with this situation.

Bug issued with Smatch, static analysis.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/bpf_load.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index 5061a2ec45646..176c04a454dc9 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -59,7 +59,9 @@ static int write_kprobe_events(const char *val)
 {
 	int fd, ret, flags;
 
-	if ((val != NULL) && (val[0] == '\0'))
+	if (val == NULL)
+		return -1;
+	else if (val[0] == '\0')
 		flags = O_WRONLY | O_TRUNC;
 	else
 		flags = O_WRONLY | O_APPEND;
-- 
2.20.1

