Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C642B2D7C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 14:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgKNNxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 08:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgKNNxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 08:53:31 -0500
Received: from mx.der-flo.net (mx.der-flo.net [IPv6:2001:67c:26f4:224::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517FDC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 05:53:29 -0800 (PST)
Received: by mx.der-flo.net (Postfix, from userid 110)
        id 6C5C4431B7; Sat, 14 Nov 2020 14:53:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id F4045427E1;
        Sat, 14 Nov 2020 14:52:11 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        john.fastabend@gmail.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, Florian Lehner <dev@der-flo.net>
Subject: [PATCH bpf,perf]] bpf,perf: return EOPNOTSUPP for attaching bpf handler on PERF_COUNT_SW_DUMMY
Date:   Sat, 14 Nov 2020 14:51:26 +0100
Message-Id: <20201114135126.29462-1-dev@der-flo.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment it is not possible to attach a bpf handler to a perf event
of type PERF_TYPE_SOFTWARE with a configuration of PERF_COUNT_SW_DUMMY.

Signed-off-by: Florian Lehner <dev@der-flo.net>
---
 kernel/events/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index da467e1dd49a..4e8846b7ceda 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9668,6 +9668,10 @@ static int perf_event_set_bpf_handler(struct perf_event *event, u32 prog_fd)
 	if (event->prog)
 		return -EEXIST;
 
+	if (event->attr.type == PERF_TYPE_SOFTWARE &&
+	    event->attr.config == PERF_COUNT_SW_DUMMY)
+		return -EOPNOTSUPP;
+
 	prog = bpf_prog_get_type(prog_fd, BPF_PROG_TYPE_PERF_EVENT);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
-- 
2.28.0

