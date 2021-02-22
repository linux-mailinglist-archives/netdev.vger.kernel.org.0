Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F3A3220EE
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 21:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhBVUtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 15:49:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231314AbhBVUtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 15:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614026867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xccBIINI7WlO1Egl64efVPOOap7kKG1IztmBUWvIQS0=;
        b=I6EeThDGBdivGdASCeb3OepOCu7lGxwnvSUcBZXyDu/ObTNi3nPVvnOcQuyPDD2e7ztUZ5
        oiYzeyee7unUdfPU/fPJkcKBqNZHbM41CnkWm2X24uEoHNAxIjC4iY88F15s9Z/5XKRZ97
        1Hpd5P+0Ec1tAzaVBj7N10BIv40Woh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-LsLF8dk1Otq70bmUc9Y83Q-1; Mon, 22 Feb 2021 15:27:34 -0500
X-MC-Unique: LsLF8dk1Otq70bmUc9Y83Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C92F801983;
        Mon, 22 Feb 2021 20:27:33 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-141.ams2.redhat.com [10.36.115.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BAF819C78;
        Mon, 22 Feb 2021 20:27:32 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] tc: m_gate: use SPRINT_BUF when needed
Date:   Mon, 22 Feb 2021 21:22:47 +0100
Message-Id: <7839781ddd51ffdeed528a50ecd6c5312d876036.1614022203.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sprint_time64() uses SPRINT_BSIZE-1 as a constant buffer lenght in its
implementation, however m_gate uses shorter buffers when calling it.

Fix this using SPRINT_BUF macro to get the buffer, thus getting a
SPRINT_BSIZE-long buffer.

Fixes: 07d5ee70b5b3 ("iproute2-next:tc:action: add a gate control action")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/m_gate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/m_gate.c b/tc/m_gate.c
index 892775a3..c091ae19 100644
--- a/tc/m_gate.c
+++ b/tc/m_gate.c
@@ -427,7 +427,7 @@ static int print_gate_list(struct rtattr *list)
 		__u32 index = 0, interval = 0;
 		__u8 gate_state = 0;
 		__s32 ipv = -1, maxoctets = -1;
-		char buf[22];
+		SPRINT_BUF(buf);
 
 		parse_rtattr_nested(tb, TCA_GATE_ENTRY_MAX, item);
 
@@ -490,7 +490,7 @@ static int print_gate(struct action_util *au, FILE *f, struct rtattr *arg)
 	__s64 base_time = 0;
 	__s64 cycle_time = 0;
 	__s64 cycle_time_ext = 0;
-	char buf[22];
+	SPRINT_BUF(buf);
 	int prio = -1;
 
 	if (arg == NULL)
-- 
2.29.2

