Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F0226D31A
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 07:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIQFaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 01:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQFaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 01:30:04 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02EDC06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:30:03 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id u6so881304qte.8
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=XmWCE7age5UnMwS5JxN69B5KWt/qREsunjUKP7hacM0=;
        b=TohQyaKedV/7Ibhkoc0hUwGYUEX+/BNWsSL89N2gO0v+tE9tqhLwpg6tZeaw4GUbZo
         4HhpI/j7aAxBG2p8cW/hQfog/Kmro0dyRPtJQtGNmyH54sBGaXykSOQGiR/ASZmrz8BF
         tB78F/5HihiYxkviq3wgYXKfaYCMIF+MQqfbpXGGxHWVrp06DGKXlmhcBOx929fO4+VY
         fJ449NLpfNWft19izeqkHXiNKFEvYfZa1hQnlrx2VsjAIbgz1MzSDAimpkHRCDpoC6bK
         ePgoYsCEivmmA6gpPsZYqOuNoETRSoKI10bgfJU+B7xe6W6Huuf2ythSEi2yJIlqmoJr
         Zblg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XmWCE7age5UnMwS5JxN69B5KWt/qREsunjUKP7hacM0=;
        b=h4jya0UVy0kzzx8qicfkeKwNb2M8F1qVhEknEjb7Wk6RD854GP/qnGByDtFnILRxIq
         NmdqF2e0tjUpkIjH8xJImYmKFcDgt8rj0kBsChWHgPXJSEZ32AOCG2tIOlo2QqRo36t7
         P/Fgka8KoCzZZGYEiY549d/gaHnHwwkguQBAuRHgZSmNDW+JUExj1z+qUweft0Pkcrqj
         BDNKg0EEivsdEP1jyuoxlJcdNiadd2apKYEJJwUaRcs3cuiTeiqlOGXxvyIpJcSmun6S
         MX5z61QHTDstHDfeffK8Wui8rHL3rDOWMzD+KA/+M5V62Fzh46ahkTTmp7O15KWTlTcI
         6KJA==
X-Gm-Message-State: AOAM532vtGx2pgI+HVdVcsJ//4Hk78GHk955FMysIgDNzQ17VzMvrapK
        WFM5Lwa2ty2yrR65yGpuCelCsx8UVoqGjXMl8w==
X-Google-Smtp-Source: ABdhPJwtM46x5bZUFvh2+P9WwAGt7EnNMSpRF+abYwADScuXGTd4JUZBu0FtOj7Xlb0a4eiqNhvSTg7TGV+oMTOq8A==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:d848:: with SMTP id
 i8mr27007933qvj.31.1600320603105; Wed, 16 Sep 2020 22:30:03 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:29:42 +0800
In-Reply-To: <20200917132836.BlueZ.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200917132836.BlueZ.5.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20200917132836.BlueZ.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [BlueZ PATCH 5/6] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     mcchou@chromium.org, marcel@holtmann.org, mmandlik@chromium.org,
        howardchung@google.com, luiz.dentz@gmail.com, alainm@chromium.org,
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
2.28.0.618.gf4bc123cb7-goog

