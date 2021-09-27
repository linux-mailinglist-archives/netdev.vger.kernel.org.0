Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8D64193BD
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhI0MAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 08:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbhI0MAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 08:00:05 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D86C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 04:58:27 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id e2-20020ad45582000000b0037e7bdc88d4so73850228qvx.2
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 04:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FHQuGPAsx7HYP87vGVnx/78AZl3+QiedtSpkbOjt7EQ=;
        b=PQ4wLEoHwibbQljKZZiGlG0QC+UQZ0CprAOKwd9fPGtN4DGicTZ+rV6TcK1FpX3B0r
         dSW4x/IRQBcxSHKTlFm0edXdUh4XHcwxEu2l/+vzYtdaeQeQp18tGGGNjmG/drcRaq1L
         lCU2NPYODwZkL/wtwQEPKbOhaL1rh0dwPIdophSYaLznP/0CNNXF+DFLffslQPwPWeD0
         Y4uFtw5VeD2YFPiLADaxQjd1Ox8uhjgj9crlLO5aul80Y9FdHATm41JEzAarFEpg7akL
         o6NAZtj+eD4CXXAB0CIf5BtovcNHAVjNhoeGlKR5yXibVTWx01pjTwALi/B4btMuJA65
         3SCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FHQuGPAsx7HYP87vGVnx/78AZl3+QiedtSpkbOjt7EQ=;
        b=dDJKsriLJlbnwQuy/Vg8Yi9mhEIIYbUI7JNCRNv4J49EPgy+zNP/vBoxu5itiLemXG
         ehH+qUxUYmGbJEQbC1ThyjPUkj2N7qFLEZoONOAYQS+n5PDaj7Gu8VnDfz+vF006dCbT
         cGPctftAbyr57Actou/vLDTdOZW5+fvobyZBh6+JKReDyakWnVV427mKqVSNV5ond/qP
         GiR41mAy3V1xt93u9N8ngVIjCYhAjJCfNmHJsKEadTZrG59UZV49Ud9mjsjly2vs1nAr
         5aytqyk1Nbo03ZZlG6Zo02NVNuysOyN/R5RhbDnCFQVXoOYYRg27pQxFFP/VhjhrIvem
         Fwhw==
X-Gm-Message-State: AOAM530dSrE60fV7xRUZ+91XRdUN3uDCtBPUzLjVgLHsWoxSNNRnOypA
        WAuE0YyQ2995ntsb7NaLAV3KnmhE6S7Fpb/nbA==
X-Google-Smtp-Source: ABdhPJwxxL0oGSpJvwRblD9qlcbwwPQ+tDtlTTHiKbr8IQ3TpLAjYHO/AVzFhLwGY9EBaegrTxetCJayRzvfWAQQsA==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:9751:55fe:4e2:1c04])
 (user=howardchung job=sendgmr) by 2002:ad4:4989:: with SMTP id
 t9mr22237qvx.29.1632743906497; Mon, 27 Sep 2021 04:58:26 -0700 (PDT)
Date:   Mon, 27 Sep 2021 19:58:01 +0800
Message-Id: <20210927195737.v1.1.Id56e280fc8cac32561e3ea49df34308d26d559c9@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v1] Bluetooth: Fix wrong opcode when LL privacy enabled
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     Yun-Hao Chung <howardchung@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yun-Hao Chung <howardchung@chromium.org>

The returned opcode of command status of remove_adv is
wrong when LL privacy is enabled.

Signed-off-by: Yun-Hao Chung <howardchung@chromium.org>
---
Test with following steps:
1. btmgmt --index 0
2. [btmgmt] power off; [btmgmt] exp-privacy on; [btmgmt] power on
3. [btmgmt] rm-adv 1
4. Check if the 'Not supported' message is present in terminal

 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index cea01e275f1ea..87acf0d783a07 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8222,7 +8222,7 @@ static int remove_advertising(struct sock *sk, struct hci_dev *hdev,
 	 * advertising.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY))
-		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_REMOVE_ADVERTISING,
 				       MGMT_STATUS_NOT_SUPPORTED);
 
 	hci_dev_lock(hdev);
-- 
2.33.0.685.g46640cef36-goog

