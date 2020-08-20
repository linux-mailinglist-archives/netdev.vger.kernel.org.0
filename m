Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989B024B9B6
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgHTLxw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Aug 2020 07:53:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43120 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728915AbgHTLxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 07:53:42 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-FJQcYFnfNTWoKtq-Q64ILg-1; Thu, 20 Aug 2020 07:53:36 -0400
X-MC-Unique: FJQcYFnfNTWoKtq-Q64ILg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BF3A81F024;
        Thu, 20 Aug 2020 11:53:34 +0000 (UTC)
Received: from p50.redhat.com (ovpn-112-108.ams2.redhat.com [10.36.112.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9550716D40;
        Thu, 20 Aug 2020 11:53:32 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, lihong.yang@intel.com,
        aleksandr.loktionov@intel.com, sassmann@kpanic.de
Subject: [PATCH] i40e: always propagate error value in i40e_set_vsi_promisc()
Date:   Thu, 20 Aug 2020 13:53:12 +0200
Message-Id: <20200820115312.28099-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sassmann@kpanic.de
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kpanic.de
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The for loop in i40e_set_vsi_promisc() reports errors via dev_err() but
does not propage the error up the call chain. Instead it continues the
loop and potentially overwrites the reported error value.
This results in the error being recorded in the log buffer, but the
caller might never know anything went the wrong way.

To avoid this situation i40e_set_vsi_promisc() needs to temporary store
the error after reporting it. This is still not optimal as multiple
different errors may occur, so store the first error and hope that's
the main issue.

Fixes: 37d318d7805f (i40e: Remove scheduling while atomic possibility)
Reported-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 8e133d6545bd..526ce89b0ba5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1173,7 +1173,7 @@ i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_hw *hw = &pf->hw;
-	i40e_status aq_ret;
+	i40e_status aq_ret, aq_tmp = 0;
 	int i;
 
 	/* No VLAN to set promisc on, set on VSI */
@@ -1222,6 +1222,9 @@ i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
 				vf->vf_id,
 				i40e_stat_str(&pf->hw, aq_ret),
 				i40e_aq_str(&pf->hw, aq_err));
+
+			if (!aq_tmp)
+				aq_tmp = aq_ret;
 		}
 
 		aq_ret = i40e_aq_set_vsi_uc_promisc_on_vlan(hw, seid,
@@ -1235,8 +1238,15 @@ i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
 				vf->vf_id,
 				i40e_stat_str(&pf->hw, aq_ret),
 				i40e_aq_str(&pf->hw, aq_err));
+
+			if (!aq_tmp)
+				aq_tmp = aq_ret;
 		}
 	}
+
+	if (aq_tmp)
+		aq_ret = aq_tmp;
+
 	return aq_ret;
 }
 
-- 
2.26.2

