Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDDBCDD42
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 10:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfJGI1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 04:27:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53118 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfJGI1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 04:27:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id r19so11596194wmh.2
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 01:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aFxghCC7lJcVNGs+prYpp4IgWbv1PLO1TgGqm+F6wIU=;
        b=hP9FUCvmuXWzOSb/yhX8Wki8wHXHwgZ/Z31A/3xHYMngFfYa8D9pq5pZdfm7grPd0n
         98UeEniK2TWJYjlngqyYNQdE5y4mm029ccHDO3SzJIdNlfGJOpXlhhLtSVbii1H4MB/q
         Fb2r98xgp0moOcwWEk86hY8gc8ba5Djjzl+4A4gZYWVuQhl8/wEDDW6aIfbuN+76Uf/Y
         NEepeC88pe5bOqnLwPXA3MEIyAn8GiwZUVnFpIODJfwS4QFAhFUcJKBIXpPx0CmRz64t
         Ljx3S0HFmFWhSidamV2WSJyqjAUtnc7//eqAoHcUq5PiYVdpxkUCSx8lROEDuwMFVUwf
         VTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aFxghCC7lJcVNGs+prYpp4IgWbv1PLO1TgGqm+F6wIU=;
        b=VBzfLqbzN9sOCmz9LnnKK2k+eE1/I9g18Pm4nuQC0DjuiHcXcorvNUF5crVeO1hboN
         kWXjk9d+KUFm2wsKjsrswl7V4Wmv6SCPmroo5wDXe53PHLMTWx/Stgib9c3fmKZcJScQ
         TxqCPDfftViIM7c2N8kkqmRjxEMNagfKWrSWeAFcOqdlfcvQ0XYEe+l2N1YoS/HN4Ed1
         D5V2MFjjhElQ4BsPWcBVtOljXgPtR98+aO3PdP3DkMZyniWFVaBdfESYvo4dj5LV9YnT
         gDOBhDYRbuptoK1MoFDyluLhhCCGt8naP7zzn84WD+ojgyrDUoWfG9JIw5CY9Uj0ixpB
         7zcg==
X-Gm-Message-State: APjAAAVL4PkL/euFD9RROcUCvGBl6lgwQ+cMDFPGaFFflHbT4YiqBBFN
        d4Xq9/FRZwU0FrKU+4LsftOsBQQuEnU=
X-Google-Smtp-Source: APXvYqwLx7VdeHq+bj8VyZU9u0cBZt//k/2NfX5iAO/VW+vSs8ImmQfbgQSzx3ADTlchjAAwW4/7nQ==
X-Received: by 2002:a05:600c:2410:: with SMTP id 16mr14570535wmp.125.1570436832179;
        Mon, 07 Oct 2019 01:27:12 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id a204sm23761678wmh.21.2019.10.07.01.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 01:27:11 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 1/2] netdevsim: implement devlink dev_info op
Date:   Mon,  7 Oct 2019 10:27:08 +0200
Message-Id: <20191007082709.13158-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007082709.13158-1-jiri@resnulli.us>
References: <20191007082709.13158-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Do simple dev_info devlink operation implementation which only fills up
the driver name.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 31d1752c703a..a3d7d39f231a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -510,6 +510,13 @@ static int nsim_dev_reload_up(struct devlink *devlink,
 	return nsim_dev_reload_create(nsim_dev, extack);
 }
 
+static int nsim_dev_info_get(struct devlink *devlink,
+			     struct devlink_info_req *req,
+			     struct netlink_ext_ack *extack)
+{
+	return devlink_info_driver_name_put(req, DRV_NAME);
+}
+
 #define NSIM_DEV_FLASH_SIZE 500000
 #define NSIM_DEV_FLASH_CHUNK_SIZE 1000
 #define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
@@ -603,6 +610,7 @@ nsim_dev_devlink_trap_action_set(struct devlink *devlink,
 static const struct devlink_ops nsim_dev_devlink_ops = {
 	.reload_down = nsim_dev_reload_down,
 	.reload_up = nsim_dev_reload_up,
+	.info_get = nsim_dev_info_get,
 	.flash_update = nsim_dev_flash_update,
 	.trap_init = nsim_dev_devlink_trap_init,
 	.trap_action_set = nsim_dev_devlink_trap_action_set,
-- 
2.21.0

