Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD8C27A8E7
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgI1Hlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgI1Hlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:41:35 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B0FC0613D4
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:41:35 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b39so95590qta.0
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=OYN0waWCzIpz4ouqNQwOPc0HvVqV4aulKVgXstFC8pM=;
        b=AJ6VRbDPC7e8smY4eGXu9zYa/IX0MLfCd6bcLc93w842F9ZclCRQhVODpSB3qxUaXS
         3q5zTjxBUavZMzrU21HiiY1Rnqxls24W+X2mg2OEZlSLv8jpaUBB6hz/U7bi5xoBMFTb
         vBfBQB97GAT4qoBrwgPsBFBG5WuuxbRrNX746+CZKMXZogMgWWU5FJlV48QFlfQLAvHm
         vBiC0/c6vDW4ATubViknB0rQzgL9JHhk2FQgBKCNcwapfHzfnHG4yFGzV9R1rBKgSbXi
         F6mOKdaNYV+pWJXtQdfADTJXN4eJI1vHC3IlDk4UgXCvP6HN2aB7mWcXfWVejiT7xF1y
         GbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OYN0waWCzIpz4ouqNQwOPc0HvVqV4aulKVgXstFC8pM=;
        b=DfoY44eORd2h/RIHisG0Deafb3zBIvDk+ckQAnhx4uJWw004oQPwc6JWaM9+KzdVNh
         y1aVMVKvZAkwdgRr7JYH4dhoVA75pzUfGrv3Xd6DdvuGpY77dXEN6hnBkvFoSw1OJlyM
         v54rcPkVtwUjSz6wc+QiTIASojf7RsKWK5ie8GZDMcP/gJjY8QSyF71JaXcf8iS1aOb1
         gUaIKw8kj/mlwEtCuZO9vcgfifIj3gYYn6bx5KS9bLxguBocH+dUzqx2zPuN+HFCM3KU
         MeSnjTHMqmKS1FL4v6Dj5lQqSTE33yN+qWkGC74g/uPFkGs+Z4jgFtaYf4tb4OqG4qsD
         bWdA==
X-Gm-Message-State: AOAM531O6sWwCzotYMBqGALRaDJmkUCkHOEKlKo4AUIXxmrkKm39Bf2Q
        5YI5u+RW+ODmMV3BEhdh+j9wkyDb8dPbUzPEsw==
X-Google-Smtp-Source: ABdhPJwYplovwAH/Ggf4KQjk8UPe7L60iiVDgXR97jOVqK4Kkp/p5mkNWmU+paCz80w6qi0LVwevK/2oLluFzxDMcw==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:b343:: with SMTP id
 a3mr10507577qvf.41.1601278894603; Mon, 28 Sep 2020 00:41:34 -0700 (PDT)
Date:   Mon, 28 Sep 2020 15:41:20 +0800
In-Reply-To: <20200928154107.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200928154107.v6.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20200928154107.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v6 3/4] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.orgi,
        Howard Chung <howardchung@google.com>,
        Manish Mandlik <mmandlik@chromium.org>,
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
index db44680fbe9c9..4048c82d4257f 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -3083,8 +3083,10 @@ static int active_scan(struct hci_request *req, unsigned long opt)
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

