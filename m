Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4673123A3B0
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 13:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHCL5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 07:57:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:41866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgHCL50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 07:57:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 21C53AC65
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:57:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CD7C660754; Mon,  3 Aug 2020 13:57:24 +0200 (CEST)
Message-Id: <7158b73b9a8d045a25692b33bee8497d3bd627b7.1596451857.git.mkubecek@suse.cz>
In-Reply-To: <cover.1596451857.git.mkubecek@suse.cz>
References: <cover.1596451857.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 7/7] ioctl: avoid zero length array warning in
 get_stringset()
To:     netdev@vger.kernel.org
Date:   Mon,  3 Aug 2020 13:57:24 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with gcc10, gcc issues a warning about accessing elements of
zero leghth arrays. This is usually fixed by using C99 variable length
arrays but struct ethtool_sset_info is part of kernel UAPI so use an
auxiliary pointer instead.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 0f312bdae2bb..c4ad186cd390 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1632,7 +1632,9 @@ get_stringset(struct cmd_context *ctx, enum ethtool_stringset set_id,
 	sset_info.hdr.reserved = 0;
 	sset_info.hdr.sset_mask = 1ULL << set_id;
 	if (send_ioctl(ctx, &sset_info) == 0) {
-		len = sset_info.hdr.sset_mask ? sset_info.hdr.data[0] : 0;
+		const u32 *sset_lengths = sset_info.hdr.data;
+
+		len = sset_info.hdr.sset_mask ? sset_lengths[0] : 0;
 	} else if (errno == EOPNOTSUPP && drvinfo_offset != 0) {
 		/* Fallback for old kernel versions */
 		drvinfo.cmd = ETHTOOL_GDRVINFO;
-- 
2.28.0

