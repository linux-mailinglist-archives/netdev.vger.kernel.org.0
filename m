Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C4B2AE953
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 08:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKKHCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 02:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgKKHCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 02:02:49 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D8FC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:02:49 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y11so1405569ybm.22
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 23:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=C95huzuAXxK/Q/ur78yeB7NRb6+ErTiDkKW1OinYBEM=;
        b=YgqMMzV72cotIeIOR4rQM3a+Hm8zGJWbl4+4bPGgH87ABhfuYrLJ3ZPmKeUx6+o+jV
         VGrXiP7WDqOqrCQbFayHT9i89gXNvsoxhTn+6gQG8BiQrZTBiwgD4rEP8+JGUvIpwgCI
         SpQNnic1DuDL1Er/u+KIMZaNtF7j8GSx+Bt4A8CWLwtnHtuoD3vNbqwyc7OCw147YRmG
         8rLlMgthgFSKaJ+bYtdfqFJcjIS1N2YB+uTGj/tGgTYHZB65geRiGrPtMqS4phI/xSN3
         P4fhRI89t0CHPkwJXjrk/NUPX83oPVhK3R+QWf4sWKEs+LOkj8vFQDBcJQeYHw+x4blG
         k1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C95huzuAXxK/Q/ur78yeB7NRb6+ErTiDkKW1OinYBEM=;
        b=Ng3ots8QobwRX0JfqlLLvxHLbO3DX/T8lJm8IRQmGM+7GRPDszYy+LjyUdHoUF3hYd
         K6zfgUlX934TkBV6QS6Pzb1PGLqQxGcDMWip2vbQydREui+uXIzJkyNYFNE4wVy6RuUz
         K5wckStR3VbjGUoEmyJk+VCOdgv/AHtzCRvujgUEfI6FkyoVvQ9a09WiguLDmXVqbeuB
         lrf24og0QKcevC4jgjCZOhASRZORoDyFCLcYfqaNCnDRV9oBR+z2aXeN/DCDxHcpRtpS
         gup31gngV4xjD4zbsrJdj9JypAUdZVt9jrn/56lVU28+lgKogR30pkAPfcQByhm+TrQH
         n7+A==
X-Gm-Message-State: AOAM533nDj5RZVZSjS5slha57tIVth1iWL4xI+sq/wPbghDOwxnUCcX/
        uUTuPKCiIlN5kr7HRhaEF0bAc64jGDKtiNJgjw==
X-Google-Smtp-Source: ABdhPJz6FsnPgsGWaQzSUMDb9ruAALlS+KuNe//2KbbYnUGDYkLX+oRQU2x83NNjr8G83RnsyxnVKfvoQH/7laY9RQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a25:d30a:: with SMTP id
 e10mr74900ybf.196.1605078169043; Tue, 10 Nov 2020 23:02:49 -0800 (PST)
Date:   Wed, 11 Nov 2020 15:02:22 +0800
In-Reply-To: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
Message-Id: <20201111150115.v9.4.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20201111150115.v9.1.I55fa38874edc240d726c1de6e82b2ce57b64f5eb@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v9 4/6] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mmandlik@chromium.org, mcchou@chromium.org,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds code to handle the active scan during interleave
scan. The interleave scan will be canceled when users start active scan,
and it will be restarted after active scan stopped.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
---

(no changes since v1)

 net/bluetooth/hci_request.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index d943ad2885aa0..172ccbf4f0cd2 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -3099,8 +3099,10 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	 * running. Thus, we should temporarily stop it in order to set the
 	 * discovery scanning parameters.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
+	if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
 		hci_req_add_le_scan_disable(req, false);
+		cancel_interleave_scan(hdev);
+	}
 
 	/* All active scans will be done with either a resolvable private
 	 * address (when privacy feature has been enabled) or non-resolvable
-- 
2.29.2.222.g5d2a92d10f8-goog

