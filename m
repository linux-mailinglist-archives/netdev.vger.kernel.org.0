Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B023E4E53B8
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244548AbiCWOAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 10:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241517AbiCWOAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 10:00:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ED7322290
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648043916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NPsFKWBDc285bGf4fkPtm66sH099xvtiav0N2gh4FPU=;
        b=GaL2dwQWRT2fRFMWvcDzObQji9OoNdcP3Q4lAchoT9CoYVn++Ch0l5SuvkTyIN4CbzGoOA
        //kerV4lhnLxQhzz4X/lBHWUXk6RGL4M9zhmKZkvnDudaGZ7lVi697Xn52z1aInh6Ld8bx
        jqT3xuKZFxMnnDwk84pbYy+Aje0PA40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-99w9fyUfPM-3XaVeV6T16Q-1; Wed, 23 Mar 2022 09:58:33 -0400
X-MC-Unique: 99w9fyUfPM-3XaVeV6T16Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A075106655B;
        Wed, 23 Mar 2022 13:58:32 +0000 (UTC)
Received: from ceranb.redhat.com (unknown [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6C2B403D1A3;
        Wed, 23 Mar 2022 13:58:30 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] ice: Fix MAC address setting
Date:   Wed, 23 Mar 2022 14:58:29 +0100
Message-Id: <20220323135829.4015645-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2ccc1c1ccc671b ("ice: Remove excess error variables") merged
the usage of 'status' and 'err' variables into single one in
function ice_set_mac_address(). Unfortunately this causes
a regression when call of ice_fltr_add_mac() returns -EEXIST because
this return value does not indicate an error in this case but
value of 'err' value remains to be -EEXIST till the end of
the function and is returned to caller.

Prior this commit this does not happen because return value of
ice_fltr_add_mac() was stored to 'status' variable first and
if it was -EEXIST then 'err' remains to be zero.

The patch fixes the problem by reset 'err' to zero when
ice_fltr_add_mac() returns -EEXIST.

Fixes: 2ccc1c1ccc671b ("ice: Remove excess error variables")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 168a41ea37b8..420558d1cd21 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5474,14 +5474,15 @@ static int ice_set_mac_address(struct net_device *netdev, void *pi)
 
 	/* Add filter for new MAC. If filter exists, return success */
 	err = ice_fltr_add_mac(vsi, mac, ICE_FWD_TO_VSI);
-	if (err == -EEXIST)
+	if (err == -EEXIST) {
 		/* Although this MAC filter is already present in hardware it's
 		 * possible in some cases (e.g. bonding) that dev_addr was
 		 * modified outside of the driver and needs to be restored back
 		 * to this value.
 		 */
 		netdev_dbg(netdev, "filter for MAC %pM already exists\n", mac);
-	else if (err)
+		err = 0;
+	} else if (err)
 		/* error if the new filter addition failed */
 		err = -EADDRNOTAVAIL;
 
-- 
2.34.1

