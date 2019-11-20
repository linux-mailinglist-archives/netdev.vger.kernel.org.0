Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CBB104468
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfKTTlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:41:07 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32875 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKTTlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:41:06 -0500
Received: by mail-pf1-f193.google.com with SMTP id c184so268628pfb.0
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 11:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kq6dpLrq0O0MqtSUxpM+rTesxFgi0MGsYZuOTAbdT3I=;
        b=fv4qxxeyp0zwBOCerkQNSMvc2TZ3PYiYqlU0WqzcuHLqE9acCU9Smf0jNu8z/teqTr
         PqmSNitw0Dj4nV+nrfKykYMLpZiRdcv52mdmLpH/SOSRm4ypldAbf0FmrsCJaxmP6qpc
         iIaRFRwWIxzE+7gtsISn9xKJxynkksk2kqEQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kq6dpLrq0O0MqtSUxpM+rTesxFgi0MGsYZuOTAbdT3I=;
        b=cZzaHboajsILW4O5GFAGdIoaetR4mQhRbyIPQouF/0QrzRr7xIdr2CWD/0MokXUSeo
         aucA6mU5eibfWyAwq4SQxRn0tAJWLi7M8UvYCE5uq/UqDv/hAva/FpoZK2CJeWi4qo/P
         7nsfqLq9Ntn1KepN2+hMtRdhNXkCVeqi5jJApg47ngsY8FziXcQn8Pn5mbkFBPIHIHM5
         JHgONFs322CPsyq9Uv16anxlucxSK7dUQqnmLG+i+nPqUK6FYNExiX5Kdo41BvGXA4y7
         RV2uAd4pwCtubGPGE3VvLnwSyUBXgXPsGaPnO21KNiN8XMWZ7+ybyLkTuApsOb/ZqzoA
         0uOA==
X-Gm-Message-State: APjAAAWlfJ0EUrkzvgFvRdPww7oM7WloMYoEx4l9NqOXO7eWlWKdc+Yb
        C3nh5g6FlYr3Rin1W1T+YDSwFQ==
X-Google-Smtp-Source: APXvYqzAjjMaLcaWF+EQLkcDuvG00Z8nDWDSWaTFjHCL2JpY6hv8F5/HflqAJPOmqe3GQM6pgviJbQ==
X-Received: by 2002:a62:1d90:: with SMTP id d138mr6111664pfd.223.1574278865959;
        Wed, 20 Nov 2019 11:41:05 -0800 (PST)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id 68sm23632pgj.79.2019.11.20.11.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 11:41:05 -0800 (PST)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Prashant Malani <pmalani@chromium.org>
Subject: [PATCH net] r8152: Re-order napi_disable in rtl8152_close
Date:   Wed, 20 Nov 2019 11:40:21 -0800
Message-Id: <20191120194020.8796-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both rtl_work_func_t() and rtl8152_close() call napi_disable().
Since the two calls aren't protected by a lock, if the close
function starts executing before the work function, we can get into a
situation where the napi_disable() function is called twice in
succession (first by rtl8152_close(), then by set_carrier()).

In such a situation, the second call would loop indefinitely, since
rtl8152_close() doesn't call napi_enable() to clear the NAPI_STATE_SCHED
bit.

The rtl8152_close() function in turn issues a
cancel_delayed_work_sync(), and so it would wait indefinitely for the
rtl_work_func_t() to complete. Since rtl8152_close() is called by a
process holding rtnl_lock() which is requested by other processes, this
eventually leads to a system deadlock and crash.

Re-order the napi_disable() call to occur after the work function
disabling and urb cancellation calls are issued.

Change-Id: I6ef0b703fc214998a037a68f722f784e1d07815e
Reported-by: http://crbug.com/1017928
Signed-off-by: Prashant Malani <pmalani@chromium.org>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d4a95b50bda6b..4d34c01826f30 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4283,10 +4283,10 @@ static int rtl8152_close(struct net_device *netdev)
 	unregister_pm_notifier(&tp->pm_notifier);
 #endif
 	tasklet_disable(&tp->tx_tl);
-	napi_disable(&tp->napi);
 	clear_bit(WORK_ENABLE, &tp->flags);
 	usb_kill_urb(tp->intr_urb);
 	cancel_delayed_work_sync(&tp->schedule);
+	napi_disable(&tp->napi);
 	netif_stop_queue(netdev);
 
 	res = usb_autopm_get_interface(tp->intf);
-- 
2.24.0.432.g9d3f5f5b63-goog

