Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6823596CEE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHTXJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:09:09 -0400
Received: from lekensteyn.nl ([178.21.112.251]:41075 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfHTXJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 19:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=Q+UDWMYEYIrMXXf99yl5++TT8RhBbJ8ffMGbmG6M8fY=;
        b=Ncim4CHFR1Q5+pd5BNiNHzCvws2Ijii1/CviLZYp5ZSWR4Knp+bFWtUXA4inj+VXxP/LbmslA8R0lI+PQszg7deLDswysKr8qIESiNHsUEg3fpY3T2WheqhouGW6ViDxZKJqPo0FYcuaHnT7A35lEKVss95cKOjpB23BLJ/RIPUimBmtZoZawJtSzRQmdzanEaEHM2WAxLzQof1XsglWFMlQZvZqrMkrWmTvWdHvAtDtrXyPU9HNWjnlIaN0e2oTtV8p4EcWyUUyvn8bMyRKk80RLyX8POgnhIX2G3hIJlaEKIdtmivX62gLQIip1fFKrkMGABkjKA+zKqSVO+AtfQ==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1i0DFR-00055S-D6; Wed, 21 Aug 2019 01:09:05 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 3/4] bpf: clarify when bpf_trace_printk discards lines
Date:   Wed, 21 Aug 2019 00:08:59 +0100
Message-Id: <20190820230900.23445-4-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190820230900.23445-1-peter@lekensteyn.nl>
References: <20190820230900.23445-1-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I opened /sys/kernel/tracing/trace once and kept reading from it.
bpf_trace_printk somehow did not seem to work, no entries were appended
to that trace file. It turns out that tracing is disabled when that file
is open. Save the next person some time and document this.

The trace file is described in Documentation/trace/ftrace.rst, however
the implication "tracing is disabled" did not immediate translate to
"bpf_trace_printk silently discards entries".

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 include/uapi/linux/bpf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 9ca333c3ce91..e4236e357ed9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -575,6 +575,8 @@ union bpf_attr {
  * 		limited to five).
  *
  * 		Each time the helper is called, it appends a line to the trace.
+ * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
+ * 		open, use *\/sys/kernel/debug/tracing/trace_pipe* to avoid this.
  * 		The format of the trace is customizable, and the exact output
  * 		one will get depends on the options set in
  * 		*\/sys/kernel/debug/tracing/trace_options* (see also the
-- 
2.22.0

