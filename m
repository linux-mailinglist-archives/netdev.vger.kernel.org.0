Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E6C488023
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiAHAz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiAHAzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267B2C061401;
        Fri,  7 Jan 2022 16:55:53 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id q8so14046309wra.12;
        Fri, 07 Jan 2022 16:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eir22dEvm+/a+IM/fF5TOGAC5dG+fiQ9p937xH/yeHg=;
        b=jaq8Ce81XrHehf9bvgDMNQbeJ+Q3bBqMDnmqBCKjyzIu07/b7VMmsJBZ7Zwcw4R6Z6
         bj7UGys1X0msRrLwjvMvfKiXoi+LOeimendhltX6xe3nDvcmL64dJ2FMSZP3DPp8R2EU
         MO5C1DDNqlWHsTgXthnd9uY+W86Tb0hsyPCGGVVX/Wl5VYBOvaImB4A2BY24z/jduxNU
         fBXpKqzxhzmQ+VP7okHHLrf0kEpo0Xz4ZprElqiHwnq1r3jOiS02uFb5hhRUSLxOUZqS
         zOs+tJ6tnub0D3PpRnWo+kVM1/oE1bbDvUHcxRBvhVde/wFfua8WCdDvdlX3kC1Iinau
         Jvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eir22dEvm+/a+IM/fF5TOGAC5dG+fiQ9p937xH/yeHg=;
        b=VII8NEtMNuIziHJ6Ckn2AhGYjdABXORxsjZvHnoZrYoR0oOUZuFf9bwbRvEMO7akEm
         yF1e49g4BB1BRx1DnbxxcS52c55lAJtENroEu8cNS4TtkqoPnqOT/Z+kQwYYIQnTnksi
         n4xX1S2r6gOBBsS6hnAjsLkge+DGYcNmKfIvPcmf07WlQ7KeL4ej5rvY4FyvC40EMlnd
         8NDlOdbBipUbEId+bXkpOfNjEJvcvWdRrAf58PeIPhSO/hukOUMIEcm/CYozCYycKQLs
         nRW2ozj8HXQzpkoWyN/ngXaE7Ibr8Hln6xCQs78taXJh4XNJtbxpacB/dbIlqVKGpWOk
         Wfxw==
X-Gm-Message-State: AOAM530CL26Kv8na6v4jEUJg85x0UVUMifSi+lvQnikteS4gho/QKIJm
        hFYOhVvcjs+fafR6N3uAEnnAvDiP9Kk=
X-Google-Smtp-Source: ABdhPJwGjZGDQcwPGSFd4LtZkYzetjPJDRMfI5mEAcplG/EsdI771a/pL/Ps0p//ww0i/4QT6zJknQ==
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr56985565wrs.64.1641603351512;
        Fri, 07 Jan 2022 16:55:51 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:51 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 3/8] rtw88: Use rtw_iterate_vifs where the iterator reads or writes registers
Date:   Sat,  8 Jan 2022 01:55:28 +0100
Message-Id: <20220108005533.947787-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Switch
all users of rtw_iterate_vifs_atomic() which are either reading or
writing a register to rtw_iterate_vifs().

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 2 +-
 drivers/net/wireless/realtek/rtw88/ps.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index fd02c0b0025a..b0e2ca8ddbe9 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -585,7 +585,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 	rtw_iterate_keys_rcu(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
 	rcu_read_unlock();
 	rtw_iterate_stas_atomic(rtwdev, rtw_reset_sta_iter, rtwdev);
-	rtw_iterate_vifs_atomic(rtwdev, rtw_reset_vif_iter, rtwdev);
+	rtw_iterate_vifs(rtwdev, rtw_reset_vif_iter, rtwdev);
 	rtw_enter_ips(rtwdev);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index bfa64c038f5f..a7213ff2c224 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -58,7 +58,7 @@ int rtw_leave_ips(struct rtw_dev *rtwdev)
 		return ret;
 	}
 
-	rtw_iterate_vifs_atomic(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
+	rtw_iterate_vifs(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
 
 	rtw_coex_ips_notify(rtwdev, COEX_IPS_LEAVE);
 
-- 
2.34.1

