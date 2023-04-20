Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F906E984C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjDTP3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjDTP3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:29:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C0840D2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEFAB6367B
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 15:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F6CC433D2;
        Thu, 20 Apr 2023 15:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682004558;
        bh=KxF0X0e+6QfOHUz9HdUdkwLD6uZ8PUi+DLFovTpJ5KA=;
        h=From:Date:Subject:To:Cc:From;
        b=IXXk49S7dRASllcgODMsq2w5t6kZVausWV2Vo1kR44VlG/bpqPAcEbyFjPSO0R2Ul
         FKflVdVFpCjyGwCTonIqAvcy4xT2QPwKnatXUYuqEJerbn16SrN4Z6PZSStfWOCUdg
         Ruo3pnN0BstP2DC+fhgcPMrhb4S9auxkcH0a9K0j+PaoY51JOiDN84UAc+o+Oa8RSC
         krzUrHeRsD6eFTa5fO02HYXU7C4EnmMUvLQiX/fmN90QMJDB6ycVeM1BUFaaS+ZRtB
         CYkSAu2+PQVZbncvpHOyiBJs8p8wfLt0piEFXDYeT1dzlYQOcHYN03S0NNuUC4nweV
         uGDRRAVgmlBew==
From:   Simon Horman <horms@kernel.org>
Date:   Thu, 20 Apr 2023 17:29:08 +0200
Subject: [PATCH] bonding: Always assign be16 value to vlan_proto
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org>
X-B4-Tracking: v=1; b=H4sIAENaQWQC/x2NSQrDMAwAvxJ0rsBV0oV+pfRgO2oiMHKQ21AI+
 XtEjzMwzAaNTbjBo9vAeJUmVR3Opw7yHHVilNEZKFAfBgqYqo6iEybGtUTFxeqn4qXPTFficOM
 7eJtiY0wWNc9e67cUl4vxW37/2fO17weMZhNEfAAAAA==
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type of the vlan_proto field is __be16.
And most users of the field use it as such.

In the case of setting or testing the field for the
special VLAN_N_VID value, host byte order is used.
Which seems incorrect.

Address this issue by converting VLAN_N_VID to __be16.

I don't believe this is a bug because VLAN_N_VID in
both little-endian (and big-endian) byte order does
not conflict with any valid values (0 through VLAN_N_VID - 1)
in big-endian byte order.

Reported by sparse as:

 .../bond_main.c:2857:26: warning: restricted __be16 degrades to integer
 .../bond_main.c:2863:20: warning: restricted __be16 degrades to integer
 .../bond_main.c:2939:40: warning: incorrect type in assignment (different base types)
 .../bond_main.c:2939:40:    expected restricted __be16 [usertype] vlan_proto
 .../bond_main.c:2939:40:    got int

No functional changes intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/bonding/bond_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index db7e650d9ebb..7f4c75fe58e1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2854,13 +2854,13 @@ static bool bond_handle_vlan(struct slave *slave, struct bond_vlan_tag *tags,
 	struct net_device *slave_dev = slave->dev;
 	struct bond_vlan_tag *outer_tag = tags;
 
-	if (!tags || tags->vlan_proto == VLAN_N_VID)
+	if (!tags || tags->vlan_proto == cpu_to_be16(VLAN_N_VID))
 		return true;
 
 	tags++;
 
 	/* Go through all the tags backwards and add them to the packet */
-	while (tags->vlan_proto != VLAN_N_VID) {
+	while (tags->vlan_proto != cpu_to_be16(VLAN_N_VID)) {
 		if (!tags->vlan_id) {
 			tags++;
 			continue;
@@ -2936,7 +2936,7 @@ struct bond_vlan_tag *bond_verify_device_path(struct net_device *start_dev,
 		tags = kcalloc(level + 1, sizeof(*tags), GFP_ATOMIC);
 		if (!tags)
 			return ERR_PTR(-ENOMEM);
-		tags[level].vlan_proto = VLAN_N_VID;
+		tags[level].vlan_proto = cpu_to_be16(VLAN_N_VID);
 		return tags;
 	}
 

