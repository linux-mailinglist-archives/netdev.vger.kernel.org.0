Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A173195D6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBKW0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:26:24 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:37775 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhBKW0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 17:26:15 -0500
Received: by mail-ot1-f45.google.com with SMTP id a5so5543912otq.4;
        Thu, 11 Feb 2021 14:25:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=59hf+6O4K21P81t02yR2JJsizjTVRLh6ZVSrQljA/sc=;
        b=PzeLWQRKM5kVo8msW/nlweGOtaCQktFulmgltCVNpy/Ty6+hE70jqhjM7KQ9cCG24W
         OqtQupMTrOnCzUNpu3aoIAT75z9ugth1irgQgkh1HG0Pc+zAsoY4AvRHZIcm9uD3brOc
         qd0z+W7xzpFHLHnSa+dwFreKoR6LIuUoZ+zXNq+ZuLZwtxiBanYFcmWC5B1kgN8X80CQ
         85ZmHNal9LfELmtxUezz6qAGKSS76Zr/jo1KIbsXVeSbdF+rGgXBZHzVcAaOgbCEJHN5
         244x4Egh8bpwwOLcxszeUCJvVDciM26KEeJkW8VA4+3s3WA3UyEQtqWtEnajnYrq3X0Y
         YSZA==
X-Gm-Message-State: AOAM532xjRPyDILmadSj6dkPhmunrHaZ24dO+J+SkH8XSI+6tWFx/9it
        T1cDfFCJ+UmaFADbSkYPAQ==
X-Google-Smtp-Source: ABdhPJyoVcKGRF5I+pIki+Oo8A5jCC9o1Ifs/C5d7kBMPZRLIA+fMwLf/LFw7mtzzAZNV7Q3EHU3YQ==
X-Received: by 2002:a9d:605a:: with SMTP id v26mr136880otj.275.1613082333675;
        Thu, 11 Feb 2021 14:25:33 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id j25sm978030otn.55.2021.02.11.14.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 14:25:32 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Gilles Muller <Gilles.Muller@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, cocci@systeme.lip6.fr,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 2/2] driver core: platform: Drop of_device_node_put() wrapper
Date:   Thu, 11 Feb 2021 16:25:26 -0600
Message-Id: <20210211222526.1318236-3-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210211222526.1318236-1-robh@kernel.org>
References: <20210211222526.1318236-1-robh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_device_node_put() is just a wrapper for of_node_put(). The platform
driver core is already polluted with of_node pointers and the only 'get'
already uses of_node_get() (though typically the get would happen in
of_device_alloc()).

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/base/platform.c   | 2 +-
 include/linux/of_device.h | 7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 95fd1549f87d..c31bc9e92dd1 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -571,7 +571,7 @@ static void platform_device_release(struct device *dev)
 	struct platform_object *pa = container_of(dev, struct platform_object,
 						  pdev.dev);
 
-	of_device_node_put(&pa->pdev.dev);
+	of_node_put(&pa->pdev.dev->of_node);
 	kfree(pa->pdev.dev.platform_data);
 	kfree(pa->pdev.mfd_cell);
 	kfree(pa->pdev.resource);
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index d7a407dfeecb..1d7992a02e36 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -38,11 +38,6 @@ extern int of_device_request_module(struct device *dev);
 extern void of_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 extern int of_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env);
 
-static inline void of_device_node_put(struct device *dev)
-{
-	of_node_put(dev->of_node);
-}
-
 static inline struct device_node *of_cpu_device_node_get(int cpu)
 {
 	struct device *cpu_dev;
@@ -94,8 +89,6 @@ static inline int of_device_uevent_modalias(struct device *dev,
 	return -ENODEV;
 }
 
-static inline void of_device_node_put(struct device *dev) { }
-
 static inline const struct of_device_id *of_match_device(
 		const struct of_device_id *matches, const struct device *dev)
 {
-- 
2.27.0

