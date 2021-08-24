Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43393F5BB3
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbhHXKHj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Aug 2021 06:07:39 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:27656 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235971AbhHXKHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 06:07:37 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-3oBWNdzdMaOgtug7uCYZbQ-1; Tue, 24 Aug 2021 06:06:47 -0400
X-MC-Unique: 3oBWNdzdMaOgtug7uCYZbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C333800493;
        Tue, 24 Aug 2021 10:06:46 +0000 (UTC)
Received: from x230.redhat.com (unknown [10.39.194.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 603CB5C1A3;
        Tue, 24 Aug 2021 10:06:44 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com,
        anthony.l.nguyen@intel.com, lihong.yang@intel.com,
        sassmann@kpanic.de
Subject: [PATCH] iavf: fix double unlock of crit_lock
Date:   Tue, 24 Aug 2021 12:06:39 +0200
Message-Id: <20210824100639.60076-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sassmann@kpanic.de
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kpanic.de
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crit_lock mutex could be unlocked twice as reported here
https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20210823/025525.html

Remove the superfluous unlock. Technically the problem was already
present before 5ac49f3c2702 as that commit only replaced the locking
primitive, but no functional change.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Fixes: bac8486116b0 ("iavf: Refactor the watchdog state machine")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 23762a7ef740..cada4e0e40b4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1965,7 +1965,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
-- 
2.31.1

