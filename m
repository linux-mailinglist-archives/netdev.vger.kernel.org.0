Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC38D35DA1E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhDMIcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhDMIcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:32:06 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C0AC061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 01:31:46 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id i3so16261734oik.7
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 01:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TA8jKTero41YIyn3HR4g7Qbpav1f1QypbbRcWGyGxZk=;
        b=rkWgq2OoKHzX2uLjgI+C2nyyyc+AZOM741rowHj8cwutQnezdF7+p86kQTt0CQrJGS
         ySkzMSlbZnTkewUCHtqM2PHmde93qXfNJZYuOks6IGDKYD4K7uH9ieU9lY9P+6epXFvg
         utBH7CJ56Ba0dwf4jQw0guKXJOTG1B6HCAplfWXNMMVYBocajok6/BphYQnvLXX/hzzI
         OFT0GhAuFEbXm7I8+P7qW9yly5talk30zBREeaw1D8rKivp60zfF7i5RpLMckh9rKoSi
         mCvBZKNh9aTkKTYuOMV5k74IXwL0eV9UkH3ZA61e4XAqmT6lq5VeJlTaYrW3fuuL1Fc0
         z0wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TA8jKTero41YIyn3HR4g7Qbpav1f1QypbbRcWGyGxZk=;
        b=Z4/BYq3Kr0ocoyegJY93qno0PYfbcDC7PBaES0obfSvSNo9YZIbdQbFZowlAS8h4S2
         mqzNTGWIpEe4aZcWuqW4hd45guth8/Z0C3wK5CUCZwkkFNhNXWoy7panLTnyvSe0A+e7
         vaXdwyfiCZ3XeIUW/MoFpueOhuYpUyHE51HdC/j+o1AP54B5kOHKwt+qfmPI6B7wfwuY
         zwfuskFVL/UtcRp20UiJtJ4ygsRcqYA4qqTinQAShi+yh33IbrntBvLGQ3dDiLEIgS28
         5Oj+k1FZGHZQ134Lcfv0xy711P5h53YSF/MIndwe8le4lW72/zWjQ3oX48Is0tZZY69o
         OFIA==
X-Gm-Message-State: AOAM5302Gx0FZOvgQHfTCM9AWVfUuLHjnV49G1iVhbERXN9k4DZUXE5+
        KFIXg+vLTa//9KWY4MRb6uOX/rtOO+kkpA==
X-Google-Smtp-Source: ABdhPJyO/TA7tPal+h8/Dl8uIfrU0nPgrQdPPJgNnNeJyeOdOspn4mF12ogTR0lzrGVxpMXqfoyxng==
X-Received: by 2002:aca:486:: with SMTP id 128mr2483482oie.117.1618302706062;
        Tue, 13 Apr 2021 01:31:46 -0700 (PDT)
Received: from pear.attlocal.net ([2600:1700:271:1a80:f46a:46e6:5a15:5a2c])
        by smtp.gmail.com with ESMTPSA id 103sm2920540otj.41.2021.04.13.01.31.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 01:31:45 -0700 (PDT)
From:   Lijun Pan <lijunp213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <lijunp213@gmail.com>
Subject: [PATCH net-next v2] ibmvnic: improve failover sysfs entry
Date:   Tue, 13 Apr 2021 03:31:44 -0500
Message-Id: <20210413083144.10423-1-lijunp213@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation relies on H_IOCTL call to issue a
H_SESSION_ERR_DETECTED command to let the hypervisor to send a failover
signal. However, it may not work if there is no backup device or if
the vnic is already in error state,
e.g., "ibmvnic 30000003 env3: rx buffer returned with rc 6".
Add a last resort, that is to schedule a failover reset via CRQ command.

Signed-off-by: Lijun Pan <lijunp213@gmail.com>
---
v2: reword commit message
    drop v1 series' patch 2 and send this patch alone.

 drivers/net/ethernet/ibm/ibmvnic.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9c6438d3b3a5..3773dc97e63d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5452,7 +5452,7 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 	if (rc) {
 		netdev_err(netdev, "Couldn't retrieve session token, rc %ld\n",
 			   rc);
-		return -EINVAL;
+		goto last_resort;
 	}
 
 	session_token = (__be64)retbuf[0];
@@ -5460,15 +5460,17 @@ static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
 		   be64_to_cpu(session_token));
 	rc = plpar_hcall_norets(H_VIOCTL, adapter->vdev->unit_address,
 				H_SESSION_ERR_DETECTED, session_token, 0, 0);
-	if (rc) {
-		netdev_err(netdev, "Client initiated failover failed, rc %ld\n",
+	if (rc)
+		netdev_err(netdev,
+			   "H_VIOCTL initiated failover failed, rc %ld\n",
 			   rc);
-		return -EINVAL;
-	}
+
+last_resort:
+	netdev_dbg(netdev, "Trying to send CRQ_CMD, the last resort\n");
+	ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
 
 	return count;
 }
-
 static DEVICE_ATTR_WO(failover);
 
 static unsigned long ibmvnic_get_desired_dma(struct vio_dev *vdev)
-- 
2.23.0

