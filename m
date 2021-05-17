Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40A23828A4
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 11:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbhEQJp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbhEQJp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:45:56 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B4EC061756
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:44:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u133so3194456wmg.1
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 02:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=czt05gbx9Pid9NCOBx3PHFg0s8pV+iSFG2r3hOEhaGM=;
        b=RciWXfWKrh0FozwZ7DDZ38Qd60PorM47ElaTUrNPNtqdwnTDZerSmNkQ4vP/zZPvU9
         onKCy/ck1ek7MoVnhKzgWhJjCZPLhg6N0F9UqBq3LZcwcqPCXiyKJuPKhdMNEGF+UnYO
         p1SzD4uL7NUFcLwyRSxry5jedZfnez8tDuNOrBXXY/jcijf3YU3+RAav5USqJGVMoF4R
         w5GaRkbvrbxbOywR8sJJXs0bMK9Jiy0pGRS11HW2iqP3/RE/ul4+yn1wAz5sbWK2H/I8
         F3j4TqwLuyECkrTrVbC/PfSkdRDqo5UJ23lZP9L2w6C+jd9QM8K/tXud3K8ZQmFXSfJ9
         twKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=czt05gbx9Pid9NCOBx3PHFg0s8pV+iSFG2r3hOEhaGM=;
        b=RCyICvXGwxt3iMAt4g9uQJBlNjPZnDYIhakSLfEqqPs+fLMHgaipOn6v4wg3Pk8WfB
         I8t67ECFpFpUV5jONK1a8ZMA8+vby4YUxD6vfPwqyhV+uw11PnqnL4/RJzE1HyL3faHg
         G1qX3LIEqvJvRbPeDlyIhhnALUF2zfNS84EbcQq+Nkn4lruDaUzqTa7OzQC6ynLLNRUv
         rmMWyYOqs6H2tcLc6yZRGf6pglAx+OAtL0sOP8AG4qWA/qKn4o8mEKe5kCOLk33S485y
         kU8IIXFR3LWAIPgttPMptu4noKeGS3PvWbFr+0sIQjAyBCwP8b10g1VXrtDfVbGNeqgQ
         FJIQ==
X-Gm-Message-State: AOAM532Pc7yfanhpG/wJppE/9cD/Raj5gX1VnNlRDBqcLm1D1UB+UC/T
        OcecC74m06fl3MMOuYKgCAdbcg==
X-Google-Smtp-Source: ABdhPJziQJAKsZYyabKw4LwbcBRLVn+VeF0cO4fx51WIB2C7ewNqWhiUe8H8nPMnoOryZwq9a0KaoQ==
X-Received: by 2002:a7b:c056:: with SMTP id u22mr22255628wmc.181.1621244678821;
        Mon, 17 May 2021 02:44:38 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:b1c7:5cae:f8d:ca54])
        by smtp.gmail.com with ESMTPSA id c15sm16171732wrr.3.2021.05.17.02.44.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 May 2021 02:44:38 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dcbw@gapps.redhat.com,
        aleksander@aleksander.es, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net] net: wwan: Add WWAN port type attribute
Date:   Mon, 17 May 2021 11:53:34 +0200
Message-Id: <1621245214-19343-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The port type is by default part of the WWAN port device name.
However device name can not be considered as a 'stable' API and
may be subject to change in the future. This change adds a proper
device attribute that can be used to determine the WWAN protocol/
type.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/wwan_core.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index cff04e5..92a8a6f 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -169,6 +169,30 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 
 /* ------- WWAN port management ------- */
 
+/* Keep aligned with wwan_port_type enum */
+static const char * const wwan_port_type_str[] = {
+	"AT",
+	"MBIM",
+	"QMI",
+	"QCDM",
+	"FIREHOSE"
+};
+
+static ssize_t type_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct wwan_port *port = to_wwan_port(dev);
+
+	return sprintf(buf, "%s\n", wwan_port_type_str[port->type]);
+}
+static DEVICE_ATTR_RO(type);
+
+static struct attribute *wwan_port_attrs[] = {
+	&dev_attr_type.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(wwan_port);
+
 static void wwan_port_destroy(struct device *dev)
 {
 	struct wwan_port *port = to_wwan_port(dev);
@@ -182,6 +206,7 @@ static void wwan_port_destroy(struct device *dev)
 static const struct device_type wwan_port_dev_type = {
 	.name = "wwan_port",
 	.release = wwan_port_destroy,
+	.groups = wwan_port_groups,
 };
 
 static int wwan_port_minor_match(struct device *dev, const void *minor)
@@ -201,15 +226,6 @@ static struct wwan_port *wwan_port_get_by_minor(unsigned int minor)
 	return to_wwan_port(dev);
 }
 
-/* Keep aligned with wwan_port_type enum */
-static const char * const wwan_port_type_str[] = {
-	"AT",
-	"MBIM",
-	"QMI",
-	"QCDM",
-	"FIREHOSE"
-};
-
 struct wwan_port *wwan_create_port(struct device *parent,
 				   enum wwan_port_type type,
 				   const struct wwan_port_ops *ops,
-- 
2.7.4

