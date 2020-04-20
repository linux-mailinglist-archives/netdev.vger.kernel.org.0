Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49661B114F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgDTQSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgDTQSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:18:46 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FE99206F6;
        Mon, 20 Apr 2020 16:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587399526;
        bh=Agg8dISQfqOQcYNOk1Myl31GegLNB76S7VjQ3zOjI3w=;
        h=From:To:Cc:Subject:Date:From;
        b=yVt8XAZa97A9EPSvD3AzZnG87xHJ7TmAbFxtgW+SqiAubczhqirsOnvQue5xqMNRR
         9P8ZRniZlr548XwrlNYeYkfNRMHzf4Z6wx51DUUzPtrUtcDPd1adFWAXcoQK7H1aeN
         pdoyuTQJDaTlB/ZYkmPeKzl0fLPdtfT8Ksoq3dSI=
From:   David Ahern <dsahern@kernel.org>
To:     daniel@iogearbox.net, ast@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrey Ignatov <rdna@fb.com>
Subject: [PATCH bpf] libbpf: Only check mode flags in get_xdp_id
Date:   Mon, 20 Apr 2020 10:18:43 -0600
Message-Id: <20200420161843.46606-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The commit in the Fixes tag changed get_xdp_id to only return prog_id
if flags is 0, but there are other XDP flags than the modes - e.g.,
XDP_FLAGS_UPDATE_IF_NOEXIST. Since the intention was only to look at
MODE flags, clear other ones before checking if flags is 0.

Fixes: f07cbad29741 ("libbpf: Fix bpf_get_link_xdp_id flags handling")
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Andrey Ignatov <rdna@fb.com>
---
 tools/lib/bpf/netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 342acacf7cda..692749d87348 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -352,6 +352,8 @@ int bpf_get_link_xdp_egress_info(int ifindex, struct xdp_link_info *info,
 
 static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
 {
+	flags &= XDP_FLAGS_MODES;
+
 	if (info->attach_mode != XDP_ATTACHED_MULTI && !flags)
 		return info->prog_id;
 	if (flags & XDP_FLAGS_DRV_MODE)
-- 
2.20.1

