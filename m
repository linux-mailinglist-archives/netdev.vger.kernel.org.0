Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24ADB187358
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 20:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732448AbgCPTbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 15:31:45 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37892 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732429AbgCPTbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 15:31:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id x7so10296857pgh.5
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 12:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YFwdwokeovEZ2zjrRaZ7T7a+UD0PdDiAfN6gx/7xgTo=;
        b=oyUAyALlXn7nqeQtperRXOrqmsCStal1U8XZFW+Hra1ipX5bc2zlePjiRP3/2Gn2QB
         LQZ3sE9y88M4BF6eXdHlW6K5LjkogqLJjfAC3+J/JfIW/sVPVm3wYRSaBaQxktCOD3ty
         CIDbVmmJ4nSOaZs2suFFyVqvC4kzlbxJpNuSQkoShMiTUs/hN53qFtab47NqdSFeiFuf
         rJZcDJU/1/htbdRQi3CFoZZbmpe2q2RRommhRD4rFbKaIEpnyBbIIZA22YbR9SNPvmdr
         b4i2OcpMgx7fkg+S35XkDt5ZWiNPaSITfXRXQQzHqzj9Sj4bHtjfi7n6PwL+AeJoEcnI
         9xBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YFwdwokeovEZ2zjrRaZ7T7a+UD0PdDiAfN6gx/7xgTo=;
        b=p6pfzawgO98lbnZGm6NSm/wf0R7f++eIaavbrTDCkk8aRkqa6wlJA0ldbEarupYQKD
         otZkiNqllgxlnTONLyhuwm9jgGu5Z9MBm/RIsugGANgjmSOys0AwgkZYab3XXh1blC96
         GpXfdxBKEShk82RfpY+FuSFGMg2EH0g1EiFec5ENwEXxH+TjNIT+CPBdyKYch2WydQgS
         3awtAq742MPwU693d+NPoEdePpXA6G2G3F7zZ4Asa1BZF6zysQnafVNTrauvpyenSPQ4
         pnfYAjJXWyb2llQVCjHxuzD6xKxeB9OUL/Sv/grnQfdaxYiDKRkfrh5N7wEAPQyjI177
         CWbA==
X-Gm-Message-State: ANhLgQ2ezAefrlyCTZiLUflYLjAcxADTe1deTUsELuxVEbQigft70K6r
        R82b9+b8GkMtV14PrpFDSRI8MwuveI0=
X-Google-Smtp-Source: ADFU+vvIabp4ZAGjhR6+TSGY2pdBQgmfwHCz2H0wWtlSTj+m5XuVrvCju5PJJAImQaJNvemrQFiC8Q==
X-Received: by 2002:a63:7a02:: with SMTP id v2mr1289044pgc.13.1584387102575;
        Mon, 16 Mar 2020 12:31:42 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w17sm656413pfi.59.2020.03.16.12.31.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:31:42 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/5] ionic: stop devlink warn on mgmt device
Date:   Mon, 16 Mar 2020 12:31:30 -0700
Message-Id: <20200316193134.56820-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316193134.56820-1-snelson@pensando.io>
References: <20200316193134.56820-1-snelson@pensando.io>
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

