Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1916187818
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 04:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgCQDW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 23:22:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42644 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgCQDW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 23:22:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id h8so10920662pgs.9
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 20:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YFwdwokeovEZ2zjrRaZ7T7a+UD0PdDiAfN6gx/7xgTo=;
        b=vhq4b8OXlWHUbTNJcH2myra+q6eHOFAXeuKu+cXV0bCD3035Q2XvH3mw8BEw2FXzLT
         hmqhX8E4qwbq/FffMI16Oj/mWBH2HH9Orml0KEjGiQpd0E4nW4kGeXdrLOpwqtM8KQY0
         oHgedhWty4uHc0J0aSVjPYwkzyXVZVx0bjWZduhzxR1+xBvYIm9CK3rITebw++gsdlPs
         40pdpf/aIYub+TmipSjh1AQjYa9XYSPa+7G6c1W0wvLBFq2euTnq+Nnxzlw2GPBvAyrY
         8LziuLXKscw7Le65Nzk7Be2xHFdLlzBMF7cCxZo6OrgcExWL4ZwKnT9yovyTqh8bOTzi
         MF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YFwdwokeovEZ2zjrRaZ7T7a+UD0PdDiAfN6gx/7xgTo=;
        b=q3KIWsIlmWhzJNnaX1yUxhpSLZHN5lQV9TlpQNQ/P9QfM0VmKJbRf3a+4lIfwk5nDN
         po7e3PYwuitPBki/682JRms1XKw7BgYYosRlKBBaIvOsURlbu/V607VSFG9vJ1LtrVFF
         VHBWIg5+2xZMavgxtz4X6v+2cmVeHj9GxfANu4F3ljzEp6gp58HsCCfs+aWSqeQCo6mx
         xw/5gp6x3hOJPcK1YVylKcLMF2BV8j8mPfb3ZL6mULs1TJvSyG/o/KRTZX6cx8eRu7R0
         x1MJxZJy6pb7MKuxsLXyGIoUrvMSI8tsTiLQ1Ivee/DpWl0SKyvN61hHucINFyPi5YKg
         Ns7g==
X-Gm-Message-State: ANhLgQ0CGKnVptJR0kURVD+PToTOnXBrinhr3ddtoLebXFEvig7XnncS
        4V2XC6O1zl/D8e8sS9TCnKE6YH9mJD4=
X-Google-Smtp-Source: ADFU+vssCMeycBk6NBVw3OHpPMhOnAhyoWOF3RBvC2xedMEHSgMXRuESAO3QtAM7Mkzq/CEBpZ/cog==
X-Received: by 2002:a63:f74a:: with SMTP id f10mr2912864pgk.360.1584415344467;
        Mon, 16 Mar 2020 20:22:24 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f8sm1185639pfq.178.2020.03.16.20.22.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 20:22:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/5] ionic: stop devlink warn on mgmt device
Date:   Mon, 16 Mar 2020 20:22:06 -0700
Message-Id: <20200317032210.7996-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317032210.7996-1-snelson@pensando.io>
References: <20200317032210.7996-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we don't set a port type, the devlink code will eventually
print a WARN in the kernel log.  Because the mgmt device is
not really a useful port, don't register it as a devlink port.

Fixes: b3f064e9746d ("ionic: add support for device id 0x1004")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index ed14164468a1..273c889faaad 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -77,12 +77,16 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
+	/* don't register the mgmt_nic as a port */
+	if (ionic->is_mgmt_nic)
+		return 0;
+
 	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
 			       0, false, 0, NULL, 0);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err)
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-	else if (!ionic->is_mgmt_nic)
+	else
 		devlink_port_type_eth_set(&ionic->dl_port,
 					  ionic->master_lif->netdev);
 
@@ -93,6 +97,7 @@ void ionic_devlink_unregister(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 
-	devlink_port_unregister(&ionic->dl_port);
+	if (ionic->dl_port.registered)
+		devlink_port_unregister(&ionic->dl_port);
 	devlink_unregister(dl);
 }
-- 
2.17.1

