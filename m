Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF58B2AB205
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729769AbgKIH5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729759AbgKIH5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:57:45 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5359C0613D4
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 23:57:43 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id s5so1275849qvm.0
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 23:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=cRPN1siIlVsn8AbvknNz+uPGXyjDKCgEUwApuU8hZr8=;
        b=OK4g+7nzOpaCtTolVcT99HmSnfwP6TLRaPt0cHCuU8sfwmR/9p5uBpR4EO/Z+nlqp8
         9zinomiLSSgwcEZQJTCeG/ipM2hzkrRjyvqdchrUX/09voCixiD7AQPX5EtYnBRiNB0Z
         0fBC/Dz6/99WVb0yBx3JvTICfolZjwAs4ii7S2MOySLQGqojuDv2rk355X48DasvZUlO
         DLxacv7u4ll1nK3BHO3oNhAOaI0frY6uqbnbJFilqN9WgD0WxJ6smCypZnRkZX8i43uy
         xCqG5+kkKjZDXShSZXLzU1VfMvtDD6lqjI4GU3f901jKH3FVk0qjSIW/qaEA0I8J46M8
         vtWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cRPN1siIlVsn8AbvknNz+uPGXyjDKCgEUwApuU8hZr8=;
        b=InzDWbrsG2zHUNAdAAfcXXploY+uqiQE+Mq9WFmNCLkJog+jUgbzBZABTDL/1cmj9z
         4ls4KfCfMG2fgT1sriYNiGhJptIfbAYS1viicfZXI6PbLCED6C2k5DrzmpfdVsfqYGdO
         BuBcOYNmLe9KfZExny6JYiOEhrXHlJX8mnkf/IlpT07ac3Zv8gTGb+EwFUmT+HQg9dLe
         VFBdTjZfOjkrRoVWEtNL7g+HS1CAsie5uwvoIqSN0TcuHIBoAU8xif7UQMbkRb5KKuA1
         slbYOprfECFxnfayJOWygLKb7LIQ63AsWdyt6xJ1m84U2CnHGDMMMDzWMzhEn1WBHqkx
         9zrg==
X-Gm-Message-State: AOAM532Qpfq9NsQwoRqI+dioWcIAhgsG5f3lIktc440PHWP1Zn/XprYm
        pPgaQ7AfATbYIj5iC+qUwgCfxPOXmg2G1FpKFw==
X-Google-Smtp-Source: ABdhPJwj/CDkMa8/kwh76WQqi/Pnz2A31JwcTCtQmBViho0ff6iMStNvKHkkDIdz6KTKNIKyH7J2zLPfV3kua/bOaQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a05:6214:174f:: with SMTP id
 dc15mr12603420qvb.26.1604908662713; Sun, 08 Nov 2020 23:57:42 -0800 (PST)
Date:   Mon,  9 Nov 2020 15:57:24 +0800
In-Reply-To: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201109155659.v7.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20201109155659.v7.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH v7 3/5] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     mmandlik@chromium.org, alainm@chromium.org, mcchou@chromium.org,
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
index b615b981be9d6..396960ef54a13 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -3092,8 +3092,10 @@ static int active_scan(struct hci_request *req, unsigned long opt)
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

