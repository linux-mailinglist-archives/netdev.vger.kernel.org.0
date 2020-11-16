Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33562B4FF4
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgKPSj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:39:26 -0500
Received: from mx.der-flo.net ([193.160.39.236]:53404 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbgKPSjZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 13:39:25 -0500
Received: by mx.der-flo.net (Postfix, from userid 110)
        id 75959440D6; Mon, 16 Nov 2020 19:39:07 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 49374413E7;
        Mon, 16 Nov 2020 19:38:14 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        john.fastabend@gmail.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org, Florian Lehner <dev@der-flo.net>
Subject: [FIX bpf,perf] bpf,perf: return EOPNOTSUPP for bpf handler on PERF_COUNT_SW_DUMMY
Date:   Mon, 16 Nov 2020 19:37:52 +0100
Message-Id: <20201116183752.2716-1-dev@der-flo.net>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf handlers for perf events other than tracepoints, kprobes or uprobes
are attached to the overflow_handler of the perf event.

Perf events of type software/dummy are placeholder events. So when
attaching a bpf handle to an overflow_handler of such an event, the bpf
handler will not be triggered.

This fix returns the error EOPNOTSUPP to indicate that attaching a bpf
handler to a perf event of type software/dummy is not supported.

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

