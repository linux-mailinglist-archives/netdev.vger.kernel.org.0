Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2A42EEF21
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbhAHJIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbhAHJIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:08:20 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F84C0612F8
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:07:39 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw4so13489012ejb.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=foCgk8zcUSolWnGxsnJiriBVrT56FQaSbBo6WHS7LCw=;
        b=HroOrmY3Acwa5HIFn61YCfsrNcpM7hj1RMck/n1wZC5u9n/EVSv1Gy/45iWWemfSrQ
         yl36txrj76vJcaRjLyVQw8TRK6xqFp5QIrkMcdNCttNIfqICsD1Jk2k271mCekWABoIX
         Jro7DtOnNJxbY3jt0earQZZh64ATjVCqawheoDC0/dn+PPto/g4U5H4YaifknTYua8fh
         lGDEi6Z8qrp8P5UH7LmL91gbdjoVI+f1hcTIo1UzJea+59djUbnx+0hUmPCZsJg72fNM
         3l/eBwLTpJW7ng6D9LdFC/1IRwhTUJ21MLMwNyici6Qp9stlJ3clc0qqyei8+xZAJhWm
         xmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foCgk8zcUSolWnGxsnJiriBVrT56FQaSbBo6WHS7LCw=;
        b=OAjXLQozv2IlH5CeseYkZJo3GRmMqvhL2meR9nFLSYSrxMNBe95V6DTLB+SPzlYk6T
         oEG85uOQU0iEO7AaBXjyB3UYIZBG5axO3zVCscYE/zIJiO34l1hy0l4IcCxGGSiD3DNS
         458HHSY5fgCjU4MfsFmKgJ+PAD3QP/HwBo84o7lQx7X5aDNVJbxhPm4heaZvUb+GEoUP
         fqc5mKUDpukYbebEkHzmAuEEBaH6ZyPnIYXAo8dvBFa+Q5hf6QTN3W1aRpgNduYPqGLP
         I/tY6qzdgqSse+bbwfaD/Qsxt/S4xcJPiSGrCt1oz3DzET8ep2rZ8feTsjp14rtZeaUN
         wf8A==
X-Gm-Message-State: AOAM530knSmlTN8zTuYYkgp3PbGjJVjiNqaj1UTBrPnNxa/KkIv7+tDc
        CsYwPmqzQHfQ4j30HAKooOQ=
X-Google-Smtp-Source: ABdhPJyoQyazh5u50dbULCea8yZ9GZQ4WzO4ZuUUhJwKJlPRmYxcQeJSYi2+JssXdfAmlqN3v+zvMw==
X-Received: by 2002:a17:906:8051:: with SMTP id x17mr1941552ejw.430.1610096858574;
        Fri, 08 Jan 2021 01:07:38 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k16sm3307132ejd.78.2021.01.08.01.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:07:38 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 3/6] bus: fsl-mc: return -EPROBE_DEFER when a device is not yet discovered
Date:   Fri,  8 Jan 2021 11:07:24 +0200
Message-Id: <20210108090727.866283-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108090727.866283-1-ciorneiioana@gmail.com>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The fsl_mc_get_endpoint() should return a pointer to the connected
fsl_mc device, if there is one. By interrogating the MC firmware, we
know if there is an endpoint or not so when the endpoint device is
actually searched on the fsl-mc bus and not found we are hitting the
case in which the device has not been yet discovered by the bus.

Return -EPROBE_DEFER so that callers can differentiate this case.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
Changes in v2:
 - none

 drivers/bus/fsl-mc/fsl-mc-bus.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index 34811db074b7..28d5da1c011c 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -936,6 +936,15 @@ struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
 	endpoint_desc.id = endpoint2.id;
 	endpoint = fsl_mc_device_lookup(&endpoint_desc, mc_bus_dev);
 
+	/*
+	 * We know that the device has an endpoint because we verified by
+	 * interrogating the firmware. This is the case when the device was not
+	 * yet discovered by the fsl-mc bus, thus the lookup returned NULL.
+	 * Differentiate this case by returning EPROBE_DEFER.
+	 */
+	if (!endpoint)
+		return ERR_PTR(-EPROBE_DEFER);
+
 	return endpoint;
 }
 EXPORT_SYMBOL_GPL(fsl_mc_get_endpoint);
-- 
2.29.2

