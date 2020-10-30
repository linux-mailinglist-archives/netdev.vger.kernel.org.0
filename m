Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF042A00C3
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgJ3JIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgJ3JIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:08:46 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A45FC0613D4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:08:46 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e19so3520781qtq.17
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=d0ULAdnRkpP0tiJ9/bir4TO+qpr79/0IK0rveQZPnt0=;
        b=tyXPfxubkKIRGg/KIZF9G5IRxo7TciRnhlKJPHOrHk1Cp9Y68QDQqneATMSHTq0gyi
         S+QCQc8RTvIudCaw2/UUbd7r/3AntfelNY9TVZr2IWTp5nfAE130BYPLMCmlj/vUV3IV
         Ki/fWMMBnv04KzC/R7VUXYzGtqrsnilkpUNgDLkA+UFnU9t9xL3EJI1TreQGaCDcevIL
         JvNahGyYMCegBP3W99HX8+mVWI405Ion/TuoGLVmULNK+5+ooCXCT4+QgimRdoD9oAcM
         MpdKi5uIDcxTqE4DAHQxc5us2j6Evxz42dS0bpzu8mwaMiY8zEeS3lYJKiYdpHo1ZCQs
         oDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=d0ULAdnRkpP0tiJ9/bir4TO+qpr79/0IK0rveQZPnt0=;
        b=r8I/fv04O7pjctT+aP30T9QG4rJMb/ctBXkxv2lN9SMzQcWG/AoXHKTjwhd4m3yeCO
         rji+/x0WXC8nHHb5cskdCUJL453q76TZbqSlFtYe6TIkaF5RxtgmUuNlR1dco9hfQymn
         TXic9xGw77kCc4on9Y7AWNpNoLeqKI1nYFRfXACSOF0bVEpWWrkVc0LjBI1JnJP69Jvv
         rumGZyO6hqK4/FWhgC/5jrHw8Gp4keSlhVgBdVC/ipM/jyc9DCWfk959fS39b9B/3vOj
         DyXaXaKr9qctdYeowmXyErlI8OQK4bsMNvL6izsKSqj2/hVVPTDdBeN/wn6inGnaT6lB
         qehA==
X-Gm-Message-State: AOAM533dWv4V5fiSx1YLIGPtzBKed/3Qvr131IFO34rQQA0RKlxiyxzl
        h1+t+68aavtJOk3YXgVAJp/PDVugiAZVnRZTuQ==
X-Google-Smtp-Source: ABdhPJwDUShIiCm4ZQ7Be3llx0aPNgpneRGMjPv+gtzuLViB9OtGsiBHu6o1MxIO2GaexnkAgctAPH+ZsNmWAZXjzQ==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:db13:: with SMTP id
 d19mr7898374qvk.23.1604048925295; Fri, 30 Oct 2020 02:08:45 -0700 (PDT)
Date:   Fri, 30 Oct 2020 17:08:25 +0800
In-Reply-To: <20201030163529.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201030163529.v6.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Mime-Version: 1.0
References: <20201030163529.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH v6 3/5] Bluetooth: Handle active scan case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mmandlik@chromium.orgi, mcchou@chromium.org,
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
2.29.1.341.ge80a0c044ae-goog

