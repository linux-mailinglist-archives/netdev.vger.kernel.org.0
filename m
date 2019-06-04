Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C534C1F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfFDPYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:24:16 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34808 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbfFDPYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:24:15 -0400
Received: by mail-ed1-f65.google.com with SMTP id c26so1031513edt.1
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 08:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=b4Dhelb9OzCiu060sjxaTHet//BhPuHyI8KqKN1lWd0=;
        b=DhxWPs0eQ4aEB1IO8rMC8llUThS4koTC6aqFTPZsJL0rWnU7Mdb5hbtNZ351jMK6mk
         PBThKT4+V41iCmiuns0Rzd8H87fYqEtmvb3BOFMo5wQ+R8JDtix8hFTu9E8RKI4UUlhS
         +ZsPEvv+QpHcxzr+u65x60QFbZ70TaT+j2o25BKUSTy21Is83uvFdRknrvznKdz5XGa4
         vuuaGW2pyPsoRvW9gUBaUg/U5/yvF1g3NjUt2GE+f/RvzTCkdUsnoegMSzXypUIcgSVl
         0bVP0gUhkRr1bR/5UTsRHAGrgnN1rVdDnpqPtOwSZtbA4/NlrnKXb1qx2zBT2dIiQ8ik
         pdNQ==
X-Gm-Message-State: APjAAAVvrRfM+SoDxueoIux3p7vfpIOPMaaZJZy84pHGCzCajb7bqefQ
        JEwV6emcVN5AEK08d229mtVmXA==
X-Google-Smtp-Source: APXvYqz0MpabqTGK/+SsRqCpDPtMtz01dntChH2Wu1yQACMTvVK9fwg6t1zqzLn7h+ipakUlkecJSw==
X-Received: by 2002:a17:906:6091:: with SMTP id t17mr6281558ejj.74.1559661853165;
        Tue, 04 Jun 2019 08:24:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c7sm3206006ejz.71.2019.06.04.08.24.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:24:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BEBED1802E6; Tue,  4 Jun 2019 17:24:10 +0200 (CEST)
Subject: [PATCH net-next 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Date:   Tue, 04 Jun 2019 17:24:10 +0200
Message-ID: <155966185069.9084.1926498690478259792.stgit@alrua-x1>
In-Reply-To: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_redirect_map() helper used by XDP programs doesn't return any
indication of whether it can successfully redirect to the map index it was
given. Instead, BPF programs have to track this themselves, leading to
programs using duplicate maps to track which entries are populated in the
devmap.

This adds a flag to the XDP version of the bpf_redirect_map() helper, which
makes the helper do a lookup in the map when called, and return XDP_PASS if
there is no value at the provided index. This enables two use cases:

- A BPF program can check the return code from the helper call and react if
  it is XDP_PASS (by, for instance, redirecting out a different interface).

- Programs that just return the value of the bpf_redirect() call will
  automatically fall back to the regular networking stack, simplifying
  programs that (for instance) build a router with the fib_lookup() helper.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h |    8 ++++++++
 net/core/filter.c        |   10 +++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7c6aef253173..4c41482b7604 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3098,6 +3098,14 @@ enum xdp_action {
 	XDP_REDIRECT,
 };
 
+/* Flags for bpf_xdp_redirect_map helper */
+
+/* If set, the help will check if the entry exists in the map and return
+ * XDP_PASS if it doesn't.
+ */
+#define XDP_REDIRECT_PASS_ON_INVALID BIT(0)
+#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_PASS_ON_INVALID
+
 /* user accessible metadata for XDP packet hook
  * new fields must be added to the end of this structure
  */
diff --git a/net/core/filter.c b/net/core/filter.c
index 55bfc941d17a..dfab8478f66c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
 {
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
 		return XDP_ABORTED;
 
+	if (flags & XDP_REDIRECT_PASS_ON_INVALID) {
+		struct net_device *fwd;
+
+		fwd = __xdp_map_lookup_elem(map, ifindex);
+		if (unlikely(!fwd))
+			return XDP_PASS;
+	}
+
 	ri->ifindex = ifindex;
 	ri->flags = flags;
 	WRITE_ONCE(ri->map, map);

