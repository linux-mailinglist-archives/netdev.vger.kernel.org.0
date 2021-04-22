Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A0B367DC4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhDVJfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbhDVJez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:34:55 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D160C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 02:34:21 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c15so35135623wro.13
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KbK/rt/VL2w8jSHm46KzCJTJMHDRS8TBwcrZdxvlZQk=;
        b=LJzsD8rrIQwYziKgRjIh2WPNfwfnaR9vtuJJZLFoc4+EikTpRSLEZjr1KCaeFj8Mcf
         VMgyAXFEYkA8Bt9PuE9v1XLzbpz7odFa/mNLaW5ZSUn/BRqyrgZG7b4yQI2x+k6qgMeO
         ZMqIkYpnN2UT7rfjJOxRAH158x4Wn7WkSFRsu8FF8T/qZ9sGKmEhrelaAb1tuuA4omnH
         v5neocraSTjTEaY1J4niMLgPEJX0YJhuMYF18PjBrspF8i9N2Zi7OSgxxSJduZjxMODi
         nSUvtCwVl5bT+g3hZpwABG63eAP7qpxDRtufw8gdLRf/DpaXBIzomEg7337phB+JHPHe
         ++6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KbK/rt/VL2w8jSHm46KzCJTJMHDRS8TBwcrZdxvlZQk=;
        b=PlHSoxn4PHRQI/PzP8E8ZRU5YXePANJUJSVMZcb+gPfjcOK5HbkFn6CpuL/MiRjUIk
         M5oveiwqxzIChkuKrufoQScN0f5cROa5+Swphrw3/7p50m5nUExpc/zXyjQegdQl6Iks
         k8B/L4IBoXojpM15JlRDWAesfwlrhpCZqTPA/o4oDJFI2BAXL6QMoy30UbYexNYvQL6L
         IcIS9QOH/jfbkGLIsrcIaeaHAW/UwPr4LZ2JAXwhMUD2N3i0Dv8YU3wfCDatt4vzqSDv
         ojmKzV9K0hzOvv3tthb4YMuB8Qd8UNn7uImFS7ABkr84g2G+8jm00Jvc39bsibEQycH9
         0SrQ==
X-Gm-Message-State: AOAM532GyuCOAjZwDpSO96aOPq/BtjKs1dfuUqI5hnJGt93/9fpj2syP
        NCzyOXSCv6dFMy07NYghSVa+lt69BcJJ2Tqt
X-Google-Smtp-Source: ABdhPJyfbsEso+9Iz1YNOoClIl8dkBycPZaXZYnLqvrnA2tzSgOZVO1i4BeXO7GAOYaLU/9/v+FyKg==
X-Received: by 2002:a5d:43c1:: with SMTP id v1mr2932089wrr.419.1619084059857;
        Thu, 22 Apr 2021 02:34:19 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:d197:cfbe:5a91:301])
        by smtp.gmail.com with ESMTPSA id h81sm2717519wmf.41.2021.04.22.02.34.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 02:34:19 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next] net: wwan: core: Return poll error in case of port removal
Date:   Thu, 22 Apr 2021 11:43:34 +0200
Message-Id: <1619084614-24925-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that the poll system call returns error flags when port is
removed, allowing user side to properly fail, without trying read
or write. Port removal leads to nullified port operations, add a
is_port_connected() helper to safely check the status.

Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/wwan_core.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 5be5e1e..c965b21 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -369,14 +369,25 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
 	return ret;
 }
 
+static bool is_port_connected(struct wwan_port *port)
+{
+	bool connected;
+
+	mutex_lock(&port->ops_lock);
+	connected = !!port->ops;
+	mutex_unlock(&port->ops_lock);
+
+	return connected;
+}
+
 static bool is_read_blocked(struct wwan_port *port)
 {
-	return skb_queue_empty(&port->rxq) && port->ops;
+	return skb_queue_empty(&port->rxq) && is_port_connected(port);
 }
 
 static bool is_write_blocked(struct wwan_port *port)
 {
-	return test_bit(WWAN_PORT_TX_OFF, &port->flags) && port->ops;
+	return test_bit(WWAN_PORT_TX_OFF, &port->flags) && is_port_connected(port);
 }
 
 static int wwan_wait_rx(struct wwan_port *port, bool nonblock)
@@ -508,6 +519,8 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	if (!is_read_blocked(port))
 		mask |= EPOLLIN | EPOLLRDNORM;
+	if (!is_port_connected(port))
+		mask |= EPOLLHUP | EPOLLERR;
 
 	return mask;
 }
-- 
2.7.4

