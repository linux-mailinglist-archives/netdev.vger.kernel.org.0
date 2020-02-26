Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0629016F981
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgBZIWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:22:01 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54906 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgBZIWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 03:22:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id z12so1902165wmi.4
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 00:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7J2DxLz3GhI1hWVnw+0yYK2sI2jWzW1CghgsSy4TD8c=;
        b=TYjJVloRTB37BUUWWYMi4K/5ikHB2wRoSwfNDpjkufa/DcK0Uc40hrHt0myoqC1/lR
         QLlGhoRGzBYUVka9+ul1no8qSIoPR9ttR/BaVUBYsf5FICo+wH8CLN1RZtk/4jfHPa4l
         Q5yNeXMJCnIjcTwH+jM/bkpEkA8KiCwSO3M0agL97zRUXBHKX7X67lWRyAUpcu3KafnK
         SDkHXyQ10KO2Y2mj2IOEa4otlglp+VNcKfP5theg8GQD6sfG4lj/EYRXc0JEhb4ARYVj
         +0wLTBlc5Rfmt3dg7xf1ixOpRexPbXUbEeXBw24IVFK9FEr0Rm9HtnjksPQqjr76qZsj
         EkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7J2DxLz3GhI1hWVnw+0yYK2sI2jWzW1CghgsSy4TD8c=;
        b=pBU5T39Ok/4e1mb3qJdBKn4PmrTqLCblZYeEgnPEMOG8KY3XF8dNZsSPQLVHqx0K8k
         56b4FO4V3mt9Bq2h7lFIVzNLZ5X9jhC5WPOuQi0QhM+oKokVTyM7g+wpHgPgP80Kq9a4
         v6OJkQaZVgS+Cr3sMUjxENMWg0CpiWHGXQxqKQspOUWx8//MhWzvMuR10JfQ3Bue659N
         zxwK0PHEfUpfzgKINDhq0l6sNwnA1wHI4pWVajWGPgJ9CXbDDYNsssebgR2FheLsmN35
         18yOWRgn1AZuSweo18X6QlYEo7hxJC+lz3zTEJiHrV3KpajQLk8c3KTP9WtN2bngURHn
         jnRw==
X-Gm-Message-State: APjAAAUVseJgKJVRAA2k0GchJFZQxoAyObS1aU+/OOO0Z08X2Wdsx/oP
        5XgjXbPWNHTnq8HZjb9pDI9R+sMOs9g=
X-Google-Smtp-Source: APXvYqyfaHknJk4HePaBtgPvbtJrHN46kb8Fl1UBaJ/tkAIswMn1tNC5jh+IF++eu6QBCvWfAV5iaA==
X-Received: by 2002:a05:600c:251:: with SMTP id 17mr4017094wmj.59.1582705319138;
        Wed, 26 Feb 2020 00:21:59 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c9sm2258194wrq.44.2020.02.26.00.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 00:21:58 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jeffrey.t.kirsher@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [patch net-next v2] iavf: use tc_cls_can_offload_and_chain0() instead of chain check
Date:   Wed, 26 Feb 2020 09:21:57 +0100
Message-Id: <20200226082157.13848-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Looks like the iavf code actually experienced a race condition, when a
developer took code before the check for chain 0 was put to helper.
So use tc_cls_can_offload_and_chain0() helper instead of direct check and
move the check to _cb() so this is similar to i40e code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- rebased on top of net-next (using the correct helper name)
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 62fe56ddcb6e..76361bd468db 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3061,9 +3061,6 @@ static int iavf_delete_clsflower(struct iavf_adapter *adapter,
 static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 				    struct flow_cls_offload *cls_flower)
 {
-	if (cls_flower->common.chain_index)
-		return -EOPNOTSUPP;
-
 	switch (cls_flower->command) {
 	case FLOW_CLS_REPLACE:
 		return iavf_configure_clsflower(adapter, cls_flower);
@@ -3087,6 +3084,11 @@ static int iavf_setup_tc_cls_flower(struct iavf_adapter *adapter,
 static int iavf_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 				  void *cb_priv)
 {
+	struct iavf_adapter *adapter = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(adapter->netdev, type_data))
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return iavf_setup_tc_cls_flower(cb_priv, type_data);
-- 
2.21.1

