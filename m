Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144E7464960
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347861AbhLAISd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Dec 2021 03:18:33 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:47612 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235464AbhLAISc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:18:32 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-239-pPbNsSXvMJKcWsbR7HVHiQ-1; Wed, 01 Dec 2021 03:15:08 -0500
X-MC-Unique: pPbNsSXvMJKcWsbR7HVHiQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F06A1853026;
        Wed,  1 Dec 2021 08:15:06 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.2.17.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEA93694DF;
        Wed,  1 Dec 2021 08:15:04 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        lihong.yang@intel.com, mateusz.palczewski@intel.com,
        sassmann@kpanic.de
Subject: [PATCH net] iavf: do not override the adapter state in the watchdog task (again)
Date:   Wed,  1 Dec 2021 09:14:34 +0100
Message-Id: <20211201081434.3977672-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kpanic.de
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The watchdog task incorrectly changes the state to __IAVF_RESETTING,
instead of letting the reset task take care of that. This was already
resolved by
22c8fd71d3a5 iavf: do not override the adapter state in the watchdog task
but the problem was reintroduced by the recent code refactoring in
45eebd62999d.

Fixes: 45eebd62999d ("iavf: Refactor iavf state machine tracking")

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 14934a7a13ef..360dfb7594cb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2085,7 +2085,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 	/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		iavf_change_state(adapter, __IAVF_RESETTING);
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-- 
2.31.1

