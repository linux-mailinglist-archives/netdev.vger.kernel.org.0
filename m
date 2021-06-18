Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EED73AC569
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhFRH4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:56:34 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:20285 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbhFRH4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:56:24 -0400
X-Greylist: delayed 139224 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2021 03:56:23 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624002848;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=pV6Ft6oOUmVeMb8nCyE2JYFkklCXcfcgJq0yra9LYEY=;
    b=DxfQpkjdcTIzj87SuWLOgl5gGJmfxZyANWKOGGw0b+MqcLrduwzz/B8d2GPLqBLAMm
    MHhnbg/i+BdzAgR+UlXFT/mh5m69xjX7jOBobF3UJqFw8DtDX1n54ua6bS7pc/1XgcUr
    dykazttpxmILq1fsZgBzttTdXbP/tv41sK5w+dznt2TmGwMneISTltH4Yo79ecEg5hbt
    pKJW3nNUXwM9yAiBSnJLk1iu2lckjMl3uGGiN+TjbdOAH3iT7k8P3PCn2LuKQZaJi1fL
    GxcNUf5r7z2+JDcGvHVroKP7YYXTpo42/ISmT/nQERqlTZ79hSqTAnA+MvkoDd806PEF
    +97Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxA626EOg=="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.27.3 DYNA|AUTH)
    with ESMTPSA id 000885x5I7s84DC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 18 Jun 2021 09:54:08 +0200 (CEST)
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
        linuxwwan@intel.com, Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v2 1/3] rpmsg: core: Add driver_data for rpmsg_device_id
Date:   Fri, 18 Jun 2021 09:52:41 +0200
Message-Id: <20210618075243.42046-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618075243.42046-1-stephan@gerhold.net>
References: <20210618075243.42046-1-stephan@gerhold.net>
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
Changes in v2: None
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

