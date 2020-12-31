Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404402E7DE1
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 04:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgLaDiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 22:38:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgLaDiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 22:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 035A620773;
        Thu, 31 Dec 2020 03:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609385886;
        bh=QfIZ8JnGTyGSR+hlQdQBq7pVP1OwhGOQE1IqT93K/qc=;
        h=From:To:Cc:Subject:Date:From;
        b=YyLgk2Wdr2InR8mEPMZ5Bg4oIGFEsPtlaN6y/NZ74n/lL4KJdox93fY/vvsIAAE7x
         A8AD6dJ0+mJ4opu1W6COgVYTqkcpSXk0Wyjn3GFm0B9kcEcoZOgbVBsGajCZH4weGF
         MOzHWjNfMhoQthrrMWdTrobugPecNd/fpkp+qPTW8fznHNm29c0skXFK2XsQHh5Z4n
         NdqfSy/0gL8dCzsnD7PaxkDyo+D87VTuhFQM1j9bYESc8cQtaGn+sUwvHi7dsbj0Ln
         hhEIfqIlt+pSN+H7jaoPvzMWjVCtGRNrRLxIw56TUcFG3DOEDri3hwZBhu+8QMzend
         +5JJ52Qmh/6SA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: suggest L2 discards be counted towards rx_dropped
Date:   Wed, 30 Dec 2020 19:37:53 -0800
Message-Id: <20201231033753.1568393-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From the existing definitions it's unclear which stat to
use to report filtering based on L2 dst addr in old
broadcast-medium Ethernet.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/if_link.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 874cc12a34d9..82708c6db432 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -75,8 +75,9 @@ struct rtnl_link_stats {
  *
  * @rx_dropped: Number of packets received but not processed,
  *   e.g. due to lack of resources or unsupported protocol.
- *   For hardware interfaces this counter should not include packets
- *   dropped by the device which are counted separately in
+ *   For hardware interfaces this counter may include packets discarded
+ *   due to L2 address filtering but should not include packets dropped
+ *   by the device due to buffer exhaustion which are counted separately in
  *   @rx_missed_errors (since procfs folds those two counters together).
  *
  * @tx_dropped: Number of packets dropped on their way to transmission,
-- 
2.26.2

