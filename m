Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4161D346E6B
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhCXBA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:00:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233838AbhCXBAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616547634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mXD4jkd7wlqRcumQPssXGkKrnP2LYdiCNnEzRMWZEdA=;
        b=E2LNglMWCLm0aT4NfhN9mgQr/h2IBiCE+7Cq5hZhK4uKguFVGm9c//yq+hmxCIDdEvvohe
        VKgIb0Zvuclkhj+a8ERWemrQZZBAoty697fZgy+yd6ShwWAXdxC/M+Jw51XvOPE0wJ+TlY
        Xig4SV8+a7amI3pDQos/gzGzInpkBtI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-j1atdiDEPDel3eWBbBYFlg-1; Tue, 23 Mar 2021 21:00:30 -0400
X-MC-Unique: j1atdiDEPDel3eWBbBYFlg-1
Received: by mail-pl1-f200.google.com with SMTP id f13so40247plj.5
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mXD4jkd7wlqRcumQPssXGkKrnP2LYdiCNnEzRMWZEdA=;
        b=l58vw1s8y9b9qI5qkVSPcREiwz7dfJFVGmRFXGQgnN4uUkm9DNeiWqR/3tWHk/mUnl
         mJfxUYSoTE8BnzALX683fWDl4M+dutMqkmOoME0oSE4WnT5wTp7NoDwAbsGcBYrUVKOA
         zxJYoS8A7cm2j19eDxiBpHv70lcgHoC/Qc4yu3UocDALshcVQ9Ao9WeO+KDH2lAyRRcq
         oOd6+G2WeIt5QWvTllI9dzCyUpzpYOA6TCG5qhClrSpGVp3d+sJj2N9qEPlUHYfJK8N7
         FLkARAWd/ATS9jcdGJ/CQHyVUfga9F0Yd0sZ/f0vh4FDIEFUTbmqE1IFLISaQ8tEQMsh
         lPxQ==
X-Gm-Message-State: AOAM532i2+opkT6EWnVTlnOyClEbEtaxLONNpjxLO/K8SIe7zjZob5tx
        KWfjwbu7r1oOfyTHNaRZxvyrX85afgklm+9rr4O+qcgnUZF+a8JrPF/Una9uFXLkqMLQbbKT8e/
        hhF+GYef/ZhVAXjqA
X-Received: by 2002:a65:4288:: with SMTP id j8mr777132pgp.231.1616547629237;
        Tue, 23 Mar 2021 18:00:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWirEo8pQH7hqV/baJawI7VwpC/dAAShVAbbWa8tVTu1Ema0frBwQddALOqOwrEz0+SFjcig==
X-Received: by 2002:a65:4288:: with SMTP id j8mr777116pgp.231.1616547628926;
        Tue, 23 Mar 2021 18:00:28 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x1sm321456pje.40.2021.03.23.18.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 18:00:28 -0700 (PDT)
From:   Coiby Xu <coxu@redhat.com>
To:     linux-staging@lists.linux.dev
Cc:     Coiby Xu <coiby.xu@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] staging: qlge: deal with the case that devlink_health_reporter_create fails
Date:   Wed, 24 Mar 2021 09:00:01 +0800
Message-Id: <20210324010002.109846-1-coxu@redhat.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coiby Xu <coiby.xu@gmail.com>

devlink_health_reporter_create may fail. In that case, do the cleanup
work.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
---
 drivers/staging/qlge/qlge_devlink.c | 10 +++++++---
 drivers/staging/qlge/qlge_devlink.h |  2 +-
 drivers/staging/qlge/qlge_main.c    |  8 +++++++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
index 86834d96cebf..0ab02d6d3817 100644
--- a/drivers/staging/qlge/qlge_devlink.c
+++ b/drivers/staging/qlge/qlge_devlink.c
@@ -148,16 +148,20 @@ static const struct devlink_health_reporter_ops qlge_reporter_ops = {
 	.dump = qlge_reporter_coredump,
 };
 
-void qlge_health_create_reporters(struct qlge_adapter *priv)
+long qlge_health_create_reporters(struct qlge_adapter *priv)
 {
 	struct devlink *devlink;
+	long err = 0;
 
 	devlink = priv_to_devlink(priv);
 	priv->reporter =
 		devlink_health_reporter_create(devlink, &qlge_reporter_ops,
 					       0, priv);
-	if (IS_ERR(priv->reporter))
+	if (IS_ERR(priv->reporter)) {
+		err = PTR_ERR(priv->reporter);
 		netdev_warn(priv->ndev,
 			    "Failed to create reporter, err = %ld\n",
-			    PTR_ERR(priv->reporter));
+			    err);
+	}
+	return err;
 }
diff --git a/drivers/staging/qlge/qlge_devlink.h b/drivers/staging/qlge/qlge_devlink.h
index 19078e1ac694..94538e923f2f 100644
--- a/drivers/staging/qlge/qlge_devlink.h
+++ b/drivers/staging/qlge/qlge_devlink.h
@@ -4,6 +4,6 @@
 
 #include <net/devlink.h>
 
-void qlge_health_create_reporters(struct qlge_adapter *priv);
+long qlge_health_create_reporters(struct qlge_adapter *priv);
 
 #endif /* QLGE_DEVLINK_H */
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3af898..59d1ec580696 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4620,7 +4620,11 @@ static int qlge_probe(struct pci_dev *pdev,
 	if (err)
 		goto netdev_free;
 
-	qlge_health_create_reporters(qdev);
+	err = qlge_health_create_reporters(qdev);
+
+	if (err)
+		goto devlink_unregister;
+
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
 	 */
@@ -4632,6 +4636,8 @@ static int qlge_probe(struct pci_dev *pdev,
 	cards_found++;
 	return 0;
 
+devlink_unregister:
+	devlink_unregister(devlink);
 netdev_free:
 	free_netdev(ndev);
 devlink_free:
-- 
2.31.0

