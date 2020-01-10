Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1CB136487
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 02:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgAJBEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 20:04:50 -0500
Received: from mx58.baidu.com ([61.135.168.58]:45144 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730352AbgAJBEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 20:04:50 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id 7CF192040051;
        Fri, 10 Jan 2020 09:04:37 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, songliubraving@fb.com,
        daniel@iogearbox.net, bpf@vger.kernel.org
Subject: [PATCH][bpf-next][v2] bpf: return -EBADRQC for invalid map type in __bpf_tx_xdp_map
Date:   Fri, 10 Jan 2020 09:04:37 +0800
Message-Id: <1578618277-18085-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a negative value should be returned if map->map_type
is invalid although that seems unlikely now, then the
caller will continue to handle buffer, otherwise the
buffer will be leaked

Daniel Borkmann suggested:
-EBADRQC should be returned to keep consistent with
xdp_do_generic_redirect_map() for the tracepoint output
and not to be confused with -EOPNOTSUPP from other
locations like dev_map_enqueue() when ndo_xdp_xmit
is missing or such.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1cbac34a4e11..8769da0f56bf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3512,7 +3512,7 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 	case BPF_MAP_TYPE_XSKMAP:
 		return __xsk_map_redirect(fwd, xdp);
 	default:
-		break;
+		return -EBADRQC;
 	}
 	return 0;
 }
-- 
2.16.2

