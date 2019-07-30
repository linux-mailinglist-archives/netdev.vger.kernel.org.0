Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48137A703
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 13:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730297AbfG3Lcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 07:32:52 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42406 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbfG3Lcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 07:32:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id v15so62273308eds.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 04:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=18EqOfhuQClGXcdlOcc4uXQHHm1zyupQdEeCZ4/B10k=;
        b=e6U5apdYP6WlmchPRjkCaAFdQI+AANC+GSwp5IQzzU5cLg1voDWcPdRdqm9kernZnc
         aUJWCjrbxbVU+J8awgDr1fNlASCL7YSKfMTvzbqKaGAeLeBwqBRfSywpm2Gmrk1qVnVj
         fSNYYQ07XxWVwXlrUBpSeNoe+r/iWtDobA1JCQcrZomD8cXsM5PCBdnIgk60wE26JOBM
         dnOsj2pfFX7W9OyRQIc4gI1S43BQOQ3v55vrmq4rvql4LIh1+HN8gBOLvfWPdBKG8OTL
         9YS0BbvZDhS2eEL7qNf3hN4V6BmMZXB/AeUSVIKj9Q7AoiZYsuvVrRUIOAtmSePLL16x
         ZTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=18EqOfhuQClGXcdlOcc4uXQHHm1zyupQdEeCZ4/B10k=;
        b=qf7+BYRb3dgX2CBbYPfPqnsi9iM958bQYyXsHcRj8WwefGlp/A//F8MKjO/ZIgmnGo
         rCGvk9oFcjKzqGtYD6F25YzfjYDfHN81qLIdE1T/YQ7XDdgLC7VshKNIS3uD0aSkAePV
         RwPLSXOyV6ezil/OKJeAUY1Sa8yMk/Yh3MpFd7u7jxFjQVX9LT2e2udTJh7cvn4fO0W2
         2Ve42H+6vnRdBcttjV7/GOaO8PZ6uTHOSC8J2zU4skobxWhHWoWrwofEzzeOnLTI2aK3
         /n3nsVhjYthtq8e5mCkX38AkZ/skliMIPTZfFJlJxzampDJRXQlW0ibqagxDJKN5nN6l
         sbRA==
X-Gm-Message-State: APjAAAWJHocHEVLJnKBu0WbsywPndnvba3hStAdAIA2nHHRixJZyVNND
        dwqHWzgW32RMWp4OzUiF2C4=
X-Google-Smtp-Source: APXvYqxJAT5aN/YmYNaeTd2NUJe0h8uuS4heTSbO0x4zfdV+cAGNAQ+Ecx/bt1XsxSH329dNhtPTSA==
X-Received: by 2002:a17:906:b283:: with SMTP id q3mr34354626ejz.153.1564486370031;
        Tue, 30 Jul 2019 04:32:50 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id x11sm16704358eda.80.2019.07.30.04.32.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 04:32:49 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Cc:     netdev@vger.kernel.org, Denis Kirjanov <kdav@linux-powerpc.org>
Subject: [PATCH net-next] be2net: disable bh with spin_lock in be_process_mcc
Date:   Tue, 30 Jul 2019 13:32:26 +0200
Message-Id: <20190730113226.39845-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Denis Kirjanov <kdav@linux-powerpc.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 4 ++--
 drivers/net/ethernet/emulex/benet/be_main.c | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index ef5d61d57597..9365218f4d3b 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -550,7 +550,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	int num = 0, status = 0;
 	struct be_mcc_obj *mcc_obj = &adapter->mcc_obj;
 
-	spin_lock(&adapter->mcc_cq_lock);
+	spin_lock_bh(&adapter->mcc_cq_lock);
 
 	while ((compl = be_mcc_compl_get(adapter))) {
 		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
@@ -566,7 +566,7 @@ int be_process_mcc(struct be_adapter *adapter)
 	if (num)
 		be_cq_notify(adapter, mcc_obj->cq.id, mcc_obj->rearm_cq, num);
 
-	spin_unlock(&adapter->mcc_cq_lock);
+	spin_unlock_bh(&adapter->mcc_cq_lock);
 	return status;
 }
 
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 2edb86ec9fe9..4d8e40ac66d2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5630,9 +5630,7 @@ static void be_worker(struct work_struct *work)
 	 * mcc completions
 	 */
 	if (!netif_running(adapter->netdev)) {
-		local_bh_disable();
 		be_process_mcc(adapter);
-		local_bh_enable();
 		goto reschedule;
 	}
 
-- 
2.12.3

