Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4988F2AA250
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 04:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgKGD2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 22:28:31 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:6707 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbgKGD2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 22:28:31 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id AD9CD666665;
        Sat,  7 Nov 2020 11:28:28 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] pcp_clock: return EOPNOTSUPP if !CONFIG_PTP_1588_CLOCK
Date:   Sat,  7 Nov 2020 11:28:23 +0800
Message-Id: <1604719703-31930-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZH0lOS0NCTENKGkpCVkpNS09MSkJMS0NCTU5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OQg6LRw5Lj8pFRwfCkk*PTkR
        DDMKCRhVSlVKTUtPTEpCTEtCSElOVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKTUlINwY+
X-HM-Tid: 0a75a0bf8aaf9373kuwsad9cd666665
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pcp_clock_register() is checked with IS_ERR(), and will crash if !PTP,
change return value to ERR_PTR(-EOPNOTSUPP) for the !CONFIG_PTP_1588_CLOCK
 and so question resolved.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 include/linux/ptp_clock_kernel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index d3e8ba5..05db40c
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -276,7 +276,7 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp);
 #else
 static inline struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 						   struct device *parent)
-{ return NULL; }
+{ return ERR_PTR(-EOPNOTSUPP); }
 static inline int ptp_clock_unregister(struct ptp_clock *ptp)
 { return 0; }
 static inline void ptp_clock_event(struct ptp_clock *ptp,
-- 
2.7.4

