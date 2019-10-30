Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C8FE9784
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 09:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfJ3IAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 04:00:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45449 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJ3IAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 04:00:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id c7so999547pfo.12
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 01:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6U0DdVBt11P+lPbk4FcyAzrmyMTGkcNoAeqhfEhsYGc=;
        b=AuUnXPD6IqWZ8X6/7Cgo8TkTxjtqFB7sdOhz8fcp4qU+dX0u90k1q4B6O40exCdpGL
         /Ec4sP+8Xz7X+01gdBQarNa36uM9okQLwAZ3m9A6FyzL6u+NaEv0DZ0f7eoPnaA6587t
         sBgVPJa6hCuUVeeT9zgpeMiVKvgWbWP2xsj0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6U0DdVBt11P+lPbk4FcyAzrmyMTGkcNoAeqhfEhsYGc=;
        b=Z5Comf15s56+1tM9mszVv6N2MNgdBIAaT1G8OY+axoMlLZ+BAOFbOI17p1sD8ghLTG
         3rPTF81Iq7qit1wUqFJBAtQBfyS7Sg+I43zZpTKQKfVvPkf8Rb1ZUZoVRaqcfSQeiWgG
         mJOgT7UgpxnqvV1yJX1MAdBwY2y6baXhdWOM4+lVgL1i3bXskjjKmZkaEA5oqCBQ/SLD
         P+Z0k+dFr8IpuxtXDJodVnotlyfJifx7LTtLYlMVIU+pvfOuZgG5DRnmSDLyNmSjx6mf
         9rXieo+MMEYIcLyPbj1MeF+n2MaFQOYSbwn/LGvaIv0ci2PAUWVSap5zV2DTsV2GgFRP
         sWyw==
X-Gm-Message-State: APjAAAUzhs1+JELa0Y/2ASUEQPT3aEvVqfztbuwofF/hAhBk+aUDSugw
        GM+bKLVtQhh6DgDk2tZLY1j9hIVpSMM=
X-Google-Smtp-Source: APXvYqxMtS2QuOdTjPfw38rYJ/PCAjh4AX/imTua2k2PAsQtSc6Gz/aVpidq7Jnf/932bmtJv17KXg==
X-Received: by 2002:a17:90a:bb0b:: with SMTP id u11mr12402395pjr.94.1572422410796;
        Wed, 30 Oct 2019 01:00:10 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r21sm1960649pfc.27.2019.10.30.01.00.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 01:00:10 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next 7/7] bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during suspend/resume.
Date:   Wed, 30 Oct 2019 03:59:35 -0400
Message-Id: <1572422375-7269-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
References: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Inform the RDMA driver to stop/start during suspend/resume.  The
RDMA driver needs to stop and start just like error recovery.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e7524c0..2467b79 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11892,6 +11892,7 @@ static int bnxt_suspend(struct device *device)
 	int rc = 0;
 
 	rtnl_lock();
+	bnxt_ulp_stop(bp);
 	if (netif_running(dev)) {
 		netif_device_detach(dev);
 		rc = bnxt_close(dev);
@@ -11925,6 +11926,7 @@ static int bnxt_resume(struct device *device)
 	}
 
 resume_exit:
+	bnxt_ulp_start(bp, rc);
 	rtnl_unlock();
 	return rc;
 }
-- 
2.5.1

