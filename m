Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C745426F42D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgIRDMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbgIRDMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 23:12:36 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5A9C061756
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:12:35 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gc24so2335225pjb.4
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KBETbgHJRtwnWH3QRJ6V38Ec73b7Ro5YQIkQRswxAOg=;
        b=sqSOkvYdQz0bLJ85GB4EkovT6jlCCmlYEykWUeBxoQxZA4PlVZLmXwmB9i0onbdqit
         TTcX45XhJsaUfG7wH/eEFLawfOd90wTVbPeRPPTVVsLi6IUD8zOmcKlgEAFV9HkRHewj
         BJtTcn/8/2cfKBeXjQWNw8cj+bAOXpOBIy9UydMmEqeldzNUZpqkWliHFoKUvmtmNnh0
         KNAfjKcpwLMaK/Vcr1+LE+6p7l8Ux6YsrJWs0ZNTI0hWF67rhKkCe4TNFWCphrlTtQ/q
         wmxo9aBYsaxvi2hHYU5RBQS2YYT2WHUoZT63zBrWSsmWKEx+qZFlnm5O3PCQkE7FWYst
         wSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KBETbgHJRtwnWH3QRJ6V38Ec73b7Ro5YQIkQRswxAOg=;
        b=LROuj0bTaeJZMi/1/KyXdlL3BOeDqX9wWJhTylQWes81dw1qpjS1hrz05xR9y1ywLm
         K3/Mdt1TxapFcbyBG1bdxYBDiZpJnaIxRytA+6yw3Ig0SYBPl++98lVd3O+4AUrBe/5q
         q3trUiGECSv2q157Mw2dusPzQPV2HFK3ExQdagJQLgRASMoo+epz5BjoElLv+EyrPXx/
         f6FCTk0ju1tIaORCqVHtC7zPVkchsuk0ZZhwgnTOXP4jioSEG7ObUKlWzW1BglsLfsT6
         ToT6YGTQqmeLOokqeDrL0XcyK4/IGHORi06wuFmvhBtbx18QRgM//37aOD+vOkBJ6kk7
         MqkQ==
X-Gm-Message-State: AOAM5305Uo3hGQ7NWxWiA3B6tHU9Javuv7giwTVflXPI1RTFpiYH00A8
        43t34y+utzHhiZ1Oh+tQu5JsZKSGyTXEXWdYNg==
X-Google-Smtp-Source: ABdhPJz8q7ZaKm9V2VZgpVb0caX5/T86owruSV8FapB6awBhiGaDKFzEi9cDhWtCM33XZJuEpv7O3wO5dzIPRdwnVw==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:902:a712:b029:d1:cbf4:c583 with
 SMTP id w18-20020a170902a712b02900d1cbf4c583mr20479592plq.16.1600398755362;
 Thu, 17 Sep 2020 20:12:35 -0700 (PDT)
Date:   Fri, 18 Sep 2020 11:11:52 +0800
In-Reply-To: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200918111110.v3.5.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 5/6] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     howardchung@google.com, luiz.dentz@gmail.com, marcel@holtmann.org,
        mcchou@chromium.org, mmandlik@chromium.org, alainm@chromium.org,
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
index d9082019b6386..1fcf6736811e4 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -3085,8 +3085,10 @@ static int active_scan(struct hci_request *req, unsigned long opt)
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
2.28.0.681.g6f77f65b4e-goog

