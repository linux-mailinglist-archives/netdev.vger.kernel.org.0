Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4C637A95C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 16:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhEKOea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 10:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhEKOe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 10:34:28 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B21C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:33:21 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v12so20359899wrq.6
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=/b8VYNRk0jePTJBarCozJxGSdSmdkQELnsloLn9GeSE=;
        b=psfP3HwftSOIBsYQ46vIPksoAAbK9Myk0jsTygUyGMPodYSEEWoRkMcc5G+KaB+1Dy
         XXEwDWeTkP91szTYmbS7n0wUywAPcQb45Y/8MbqeULzT+roFM+aR2r/YKqb5f5YjBaUP
         WnqgTLa22cSIpRG6loC8DSKfCif8xBz2JpHuuTtqIroEOONX0LbG+ewFOjoG1W+Z9cy+
         xJFCY5jUuuvjgbBqUEUxHjhOxKaLz977mElFxJ+QREzda8G8wYHFXZ1IHwbjqJ/cIuZm
         zpeOLs869SEaNoStI4+DMzZ97jZW8WsRW+XJA+ViyUgmfv0OfwR8svjX3NhzXApYts7i
         c0tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/b8VYNRk0jePTJBarCozJxGSdSmdkQELnsloLn9GeSE=;
        b=I9QS8uAkQkMfQGdGaSefNufWR9nWnDhc1yNt0M50HMfJAAO4WXXKAAFd2d3eH1xITJ
         GHQz/CHa5gI/D1ZseeIKqKpLOUfRxGlC5XX5cHxoL9OVxUmnd+xKjdmVnp3M65VbBvYo
         ySreqXbFZmaOS23jN0fZhgGiNCctjrJqUMhdbZoVoBaQcUttrYJy4Uf9MGd56mYS8/W7
         W39OOVWaSiXMS3ZEEesKwiAA7zUXfKWyjJdp4c7LUUX9iWqdDd7UzoXikT+g81kMw/CB
         pdxXprtL9DTOI6FFJUE5+GFtYgoUlFOOuN5Wgp5Wwb3pc8E7vNzVZVYwvcBXbllGJq+W
         V/Fg==
X-Gm-Message-State: AOAM530gZptwNBHKA79Ktf5pHtOYq6qgVn0S241HjJL8cRTn5EO3NA8r
        byN0YnkjdoJuGj6BUZJsrB+XxA==
X-Google-Smtp-Source: ABdhPJxMWr4Zb+hBNmGosSue+GnNi/W0Lc1NLPgrlDlqe+aOv+zDwX3KtXX+JPfkv6eaUEoMQAsN/Q==
X-Received: by 2002:adf:ef92:: with SMTP id d18mr39377147wro.413.1620743600319;
        Tue, 11 May 2021 07:33:20 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:ddef:1d66:be88:86cc])
        by smtp.gmail.com with ESMTPSA id j13sm27773018wrw.93.2021.05.11.07.33.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 May 2021 07:33:19 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     oliver@neukum.org
Cc:     kuba@kernel.org, davem@davemloft.net, bjorn@mork.no,
        netdev@vger.kernel.org, aleksander@aleksander.es,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 1/2] net: wwan: Add unknown port type
Date:   Tue, 11 May 2021 16:42:22 +0200
Message-Id: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some devices may have ports with unknown type/protocol which need to
be tagged (though not supported by WWAN core). This will be the case
for cdc-wdm based drivers.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: Replace CDC specific port types change with that change

 include/linux/wwan.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index aa05a25..7216c11 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -15,6 +15,7 @@
  * @WWAN_PORT_QMI: Qcom modem/MSM interface for modem control
  * @WWAN_PORT_QCDM: Qcom Modem diagnostic interface
  * @WWAN_PORT_FIREHOSE: XML based command protocol
+ * @WWAN_PORT_UNKNOWN: Unknown port type
  * @WWAN_PORT_MAX: Number of supported port types
  */
 enum wwan_port_type {
@@ -23,7 +24,8 @@ enum wwan_port_type {
 	WWAN_PORT_QMI,
 	WWAN_PORT_QCDM,
 	WWAN_PORT_FIREHOSE,
-	WWAN_PORT_MAX,
+	WWAN_PORT_UNKNOWN,
+	WWAN_PORT_MAX = WWAN_PORT_UNKNOWN,
 };
 
 struct wwan_port;
-- 
2.7.4

