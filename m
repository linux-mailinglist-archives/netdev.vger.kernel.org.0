Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE38437450
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 11:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhJVJHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 05:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbhJVJHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 05:07:04 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F69C061764;
        Fri, 22 Oct 2021 02:04:47 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r2so2719183pgl.10;
        Fri, 22 Oct 2021 02:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=90l1KbBHTcmRnRylUtTYdm/TLWGEifv+19uJGmj6Z0Y=;
        b=YTfZCAG1qakiomElETlJBHfRaI3wlsyPGS9XKy1leAcAhbOnPp+a5UIrjGmmAUilSN
         9XUKFhwpIFgUGq/CIBFcCuBni9+Qcv88Untvdrw4flS+uPzGVxgDiftP0/miC08dvpHN
         8yfEef6ELrwBAcdX+ICS5yI6LhHUPCbg52wx+TtAZubCGnHGboJGVmKMkTg3z2/akMTZ
         D1tirqUUPx/MGqquFAiD41Eo7Fy2g3dABB+r83rGFn4wWOPmx+TDOqTPa091OoRjQm8l
         RYky6M6cRtH+loCGoBygm5iiXqAfxdToHY3Cz+uYc3rEfOB3KSLcvL+AHbwAHAJrqs2p
         NOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=90l1KbBHTcmRnRylUtTYdm/TLWGEifv+19uJGmj6Z0Y=;
        b=BcXn2x2OhAS3L+pRm4Eyb9bqy7L8oGogeNl9t3i46pl0QJFMJRmdI4a+xkMQx85y3Z
         SyvzL11WtOWSGh1fYMdltO+3KylNGs9nr++JUUOgAxTUxNddz6kE8s1Pe2s7eWLBWrcu
         GdoUjWLCk1G+B5mzb8xOOkHfKB4OuYkoimn5bWnrTU3QU8ZfShe+xUO8uJPvDoOiU/9W
         dkm1tEGEiWSiK64riuCd4i+kSg5dIAFOumM1vG+PsFL8yJWwE1Ys3impBQYqyjObvdQG
         CrjrxRu8YV7z9OZFI9J7Jgmwe86kWu8LPwFi4zCSR6Q01XAM2n4u3EPlgoOEbkImJXAp
         E7QA==
X-Gm-Message-State: AOAM533nTwHNpYvCkeZftM0UBATQIoXf4LIFAUcxu5N2HHHV/jAO61cq
        WcDNSj9R9lAuVjKOHSG95SU=
X-Google-Smtp-Source: ABdhPJxNNCBfV2oe7XKkcMzc8ZyOSfNlbt7B8Uqf6qQE1jLobTeKReN28jxzF+fVHDXoBl/lMueOJg==
X-Received: by 2002:aa7:8609:0:b0:44b:346a:7404 with SMTP id p9-20020aa78609000000b0044b346a7404mr11106718pfn.86.1634893487031;
        Fri, 22 Oct 2021 02:04:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c24sm8759072pgj.63.2021.10.22.02.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 02:04:46 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.guojin@zte.com.cn
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        ye.guojin@zte.com.cn, yuehaibing@huawei.com,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] libertas: replace snprintf in show functions with sysfs_emit
Date:   Fri, 22 Oct 2021 09:04:38 +0000
Message-Id: <20211022090438.1065286-1-ye.guojin@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING  use scnprintf or sprintf

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index 6cbba84989b8..a58c1e141f2c 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -169,7 +169,7 @@ static ssize_t anycast_mask_show(struct device *dev,
 	if (ret)
 		return ret;
 
-	return snprintf(buf, 12, "0x%X\n", le32_to_cpu(mesh_access.data[0]));
+	return sysfs_emit(buf, "0x%X\n", le32_to_cpu(mesh_access.data[0]));
 }
 
 /**
@@ -222,7 +222,7 @@ static ssize_t prb_rsp_limit_show(struct device *dev,
 		return ret;
 
 	retry_limit = le32_to_cpu(mesh_access.data[1]);
-	return snprintf(buf, 10, "%d\n", retry_limit);
+	return sysfs_emit(buf, "%d\n", retry_limit);
 }
 
 /**
@@ -270,7 +270,7 @@ static ssize_t lbs_mesh_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct lbs_private *priv = to_net_dev(dev)->ml_priv;
-	return snprintf(buf, 5, "0x%X\n", !!priv->mesh_dev);
+	return sysfs_emit(buf, "0x%X\n", !!priv->mesh_dev);
 }
 
 /**
@@ -369,7 +369,7 @@ static ssize_t bootflag_show(struct device *dev,
 	if (ret)
 		return ret;
 
-	return snprintf(buf, 12, "%d\n", le32_to_cpu(defs.bootflag));
+	return sysfs_emit(buf, "%d\n", le32_to_cpu(defs.bootflag));
 }
 
 /**
@@ -419,7 +419,7 @@ static ssize_t boottime_show(struct device *dev,
 	if (ret)
 		return ret;
 
-	return snprintf(buf, 12, "%d\n", defs.boottime);
+	return sysfs_emit(buf, "%d\n", defs.boottime);
 }
 
 /**
@@ -479,7 +479,7 @@ static ssize_t channel_show(struct device *dev,
 	if (ret)
 		return ret;
 
-	return snprintf(buf, 12, "%d\n", le16_to_cpu(defs.channel));
+	return sysfs_emit(buf, "%d\n", le16_to_cpu(defs.channel));
 }
 
 /**
@@ -605,7 +605,7 @@ static ssize_t protocol_id_show(struct device *dev,
 	if (ret)
 		return ret;
 
-	return snprintf(buf, 5, "%d\n", defs.meshie.val.active_protocol_id);
+	return sysfs_emit(buf, "%d\n", defs.meshie.val.active_protocol_id);
 }
 
 /**
@@ -667,7 +667,7 @@ static ssize_t metric_id_show(struct device *dev,
 	if (ret)
 		return ret;
 
-	return snprintf(buf, 5, "%d\n", defs.meshie.val.active_metric_id);
+	return sysfs_emit(buf, "%d\n", defs.meshie.val.active_metric_id);
 }
 
 /**
@@ -729,7 +729,7 @@ static ssize_t capability_show(struct device *dev,
 	if (ret)
 		return ret;
 
-	return snprintf(buf, 5, "%d\n", defs.meshie.val.mesh_capability);
+	return sysfs_emit(buf, "%d\n", defs.meshie.val.mesh_capability);
 }
 
 /**
-- 
2.25.1

