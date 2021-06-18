Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037103AD152
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 19:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbhFRRj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 13:39:57 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:30141 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbhFRRjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 13:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624037859;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=eLdthvV94UiwPTKF77x53HdqKFSGDribbxdMJF1IWks=;
    b=JV+ikJXOPGJBRQAhnbtSd61lnhJmmNhBvV1yNxYeABATpbInkEAPHe1pirhETbPqdf
    /K6Y1IAzIKnJsZNqnLufdhVltzNDjFh7pbVUIznn48AAoPkFHxFQ1yvLu1txqRI4okad
    4hZZJAL4qhli+YqVl7WkZz+OXYsslX5oflksWdSKlmYGjGnXHxnTJwBkVg6ZgOkVmEbv
    OatPDH3j4v+DkQS86oWlW5eGG4rXTwm2ywLHYCbFp/JRQu6FHVIKAKTvHqjKwhZjGM97
    K4GmRc+7F8kVn2SCTleaJNIFOAL39Lm1abO+OmsifJhro7XQcX8/IptsR+9lf2u5Jm2T
    2wJQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxO426OllE="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.27.3 DYNA|AUTH)
    with ESMTPSA id 000885x5IHbd6bc
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 18 Jun 2021 19:37:39 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v3 1/3] rpmsg: core: Add driver_data for rpmsg_device_id
Date:   Fri, 18 Jun 2021 19:36:09 +0200
Message-Id: <20210618173611.134685-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618173611.134685-1-stephan@gerhold.net>
References: <20210618173611.134685-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most device_id structs provide a driver_data field that can be used
by drivers to associate data more easily for a particular device ID.
Add the same for the rpmsg_device_id.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
Changes in v2/v3: None
---
 drivers/rpmsg/rpmsg_core.c      | 4 +++-
 include/linux/mod_devicetable.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index e5daee4f9373..c1404d3dae2c 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -459,8 +459,10 @@ static int rpmsg_dev_match(struct device *dev, struct device_driver *drv)
 
 	if (ids)
 		for (i = 0; ids[i].name[0]; i++)
-			if (rpmsg_id_match(rpdev, &ids[i]))
+			if (rpmsg_id_match(rpdev, &ids[i])) {
+				rpdev->id.driver_data = ids[i].driver_data;
 				return 1;
+			}
 
 	return of_driver_match_device(dev, drv);
 }
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 7d45b5f989b0..8e291cfdaf06 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -447,6 +447,7 @@ struct hv_vmbus_device_id {
 
 struct rpmsg_device_id {
 	char name[RPMSG_NAME_SIZE];
+	kernel_ulong_t driver_data;
 };
 
 /* i2c */
-- 
2.32.0

