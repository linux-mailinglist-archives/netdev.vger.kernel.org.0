Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E25116C06C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgBYMKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:10:30 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33202 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgBYMKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:10:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so14477191wrt.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 04:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vf7vFy32leZxkg71Rv8R4R2GOrwOOUiymQNeS6WVSI=;
        b=06PkSJnH2FZx1nCC/x5Ek3romIGn5geHaYIAL2P10gLlY/uzRXVTk/4P7RxmEWHG1G
         NaJu+MMjA0ydvC6EYmyyTjrwXagaCw+8ofMLtvjyTNln/3qwKE1xy65o6W5slaB5MId7
         z0XC3uLBtNXJBv0aRP2avu3LRihZHixIPxdI2Kzkf+6K6osdYoYkmoccWS2hf0zha8dL
         ZYkmMQQzZ/oyrEMVqjg3L64N8ymngGbt3Qaq9XZb2Fn5gTxG1j1IEdlGK9YxFv9c15XD
         4Ael8SXcpL6M8ZfjzcsK7CEsh6+DxeL5nJjJgRGoHFzKoDu6auTRPB/KmqAK40gTHPfg
         DsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vf7vFy32leZxkg71Rv8R4R2GOrwOOUiymQNeS6WVSI=;
        b=Gh5xPohV2hncK1mFle3Osxijf0TICr/8RXLaXa3okVLOl23HM7A/az7WvVuzj09nxk
         5rSUgWtj7/QEIBp0i0RMQHEFYxC3JtzpVdEVNDnj/qmpfy/CJljZ/2FDq/XtowlUp5JR
         wtud9sB+/uZkdI5dRz3tgS4Y9Lal6wag0QRVC7ByBwT6dklXT/34dAVe1vohQcZGk+Tp
         vdyHcCiUQ6FyAay1cSHo+6PZ6wCXhlAaqxx7l/YkL0//c/prdSN9HrB4lgKQbD3vnQhG
         qgrOu+ej8FWc2VnUHNDMYRu5cftn3dzxEViJ5o18vJ8ZGZSx2mWQAjxQleV/GVyCiQyK
         ex/Q==
X-Gm-Message-State: APjAAAUevAbfF+AohHlLCNTAcxVrr3Hh5wqOqyXwEcvmgyr3zZ2xppVW
        i4Hxwd54hUauetWLbHHWQEcZruoZ/v0=
X-Google-Smtp-Source: APXvYqwklqACVlTE19bm6aSF4tHd7IzANxCHuuSNEIWyYYMxnnkqqxqSFwkHESzEGyZyydnRrHmpTA==
X-Received: by 2002:adf:f787:: with SMTP id q7mr72914452wrp.297.1582632627798;
        Tue, 25 Feb 2020 04:10:27 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a7sm16745561wrm.29.2020.02.25.04.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 04:10:24 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jeffrey.t.kirsher@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: [patch net-next] iavf: use tc_cls_can_offload_basic() instead of chain check
Date:   Tue, 25 Feb 2020 13:10:23 +0100
Message-Id: <20200225121023.6011-1-jiri@resnulli.us>
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
So use tc_cls_can_offload_basic() helper instead of direct check and
move the check to _cb() so this is similar to i40e code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
This was originally part of "net: allow user specify TC filter HW stats type"
patchset, but it is no longer related after the requested changes.
Sending separatelly.
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 62fe56ddcb6e..8bc0d287d025 100644
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
+	if (!tc_cls_can_offload_basic(adapter->netdev, type_data))
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return iavf_setup_tc_cls_flower(cb_priv, type_data);
-- 
2.21.1

