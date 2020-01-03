Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5037612F489
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 07:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgACG0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 01:26:05 -0500
Received: from mx58.baidu.com ([61.135.168.58]:20372 "EHLO
        tc-sys-mailedm01.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725890AbgACG0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 01:26:04 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm01.tc.baidu.com (Postfix) with ESMTP id B9F9A2040041;
        Fri,  3 Jan 2020 14:25:49 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH][bpf-next] bpf: return EOPNOTSUPP when invalid map type in __bpf_tx_xdp_map
Date:   Fri,  3 Jan 2020 14:25:49 +0800
Message-Id: <1578032749-18197-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a negative value -EOPNOTSUPP should be returned if map->map_type
is invalid although that seems unlikely now, then the caller will
continue to handle buffer, or else the buffer will be leaked

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 1cbac34a4e11..40fa5905321c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3512,7 +3512,7 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
 	case BPF_MAP_TYPE_XSKMAP:
 		return __xsk_map_redirect(fwd, xdp);
 	default:
-		break;
+		return -EOPNOTSUPP;
 	}
 	return 0;
 }
-- 
2.16.2

