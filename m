Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F7931969C
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhBKX2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:28:48 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:43731 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhBKX2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 18:28:34 -0500
Received: by mail-oi1-f176.google.com with SMTP id d20so8100336oiw.10;
        Thu, 11 Feb 2021 15:28:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ADz3YBOZKFLK6zF24DOxVVKS+J+CretpaVJj7vT++ec=;
        b=HfV5kgb15+3qf3V3a1xJtbEK6Bjg2UIFHJliEgR7a3u0jwCGNrJ30X9vErIubndP8h
         3u1XK8miCaBaHE3yuHCo+2LXEtBD8O45CxZuSQS2YH84P0esP97i0pUHIy7bnyd8ULS7
         l9lpJ9oKBHbZ+zzhjehc4VHUqgZwSK/iMMcaQXtdhzN0FokJyG3zW5oj7vtTzk9+bmzA
         SzA47YPExB4nzzPEeWmDMi0psryrkN7KQ4u6KuN/kRn9vgB/wMcAFFCF+O0RWFd008mm
         hQoQ/IZdv6/vcUXk1F/2eIkV5dDDPP0caBazKjCFFCvOQRQ8MMYjYvwcG/J32boQaDyM
         24OQ==
X-Gm-Message-State: AOAM533VU2kwLAFfOZRLYVG4DUS/SpCtUrKOkXe86olxqHqTfaJPiLJE
        t8dIE8UzQwfyYZARLBLCmw==
X-Google-Smtp-Source: ABdhPJy+twQqGpwKSav6zIZvsh713BBmGhpUj6WaxgTGWBdNTF041IP+ZozxodSFlnoZb6Znde+AKQ==
X-Received: by 2002:aca:eb13:: with SMTP id j19mr185629oih.10.1613086073175;
        Thu, 11 Feb 2021 15:27:53 -0800 (PST)
Received: from xps15.herring.priv (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.googlemail.com with ESMTPSA id s18sm1283922oih.53.2021.02.11.15.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:27:51 -0800 (PST)
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
Subject: [PATCH v2 2/2] driver core: platform: Drop of_device_node_put() wrapper
Date:   Thu, 11 Feb 2021 17:27:45 -0600
Message-Id: <20210211232745.1498137-3-robh@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210211232745.1498137-1-robh@kernel.org>
References: <20210211232745.1498137-1-robh@kernel.org>
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
v2:
 - Fix build
---
 drivers/base/platform.c   | 2 +-
 include/linux/of_device.h | 7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 95fd1549f87d..9d5171e5f967 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -571,7 +571,7 @@ static void platform_device_release(struct device *dev)
 	struct platform_object *pa = container_of(dev, struct platform_object,
 						  pdev.dev);
 
-	of_device_node_put(&pa->pdev.dev);
+	of_node_put(pa->pdev.dev.of_node);
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

