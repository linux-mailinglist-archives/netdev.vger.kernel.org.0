Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D175C33E0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 14:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbfJAMIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 08:08:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33088 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfJAMIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 08:08:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so15220403wrs.0;
        Tue, 01 Oct 2019 05:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vDFY4l7ObdzMDLTWvSUTkZyMTjDs2NyWYY8Kts57jhs=;
        b=LQWkubhsu5JfOHnNRgZxHIVVqCwzlzmLuZ9RHk9QImzDX+0MV/CkXvsOatJ8tZrmXe
         piAW/kJ612Zz75+s/zPNZ3jGgdtNmrHKAM1JfokLdSUAtFQAhU32AoKvMfarbTjWdPzT
         SQEMxn+a2+nL4iNSRZbq09+EhJfByQ6UrXxaZnqSMks+OEgjXFSfc6OBquesTes2NQ07
         XXtnlwoC9mcSE7WTBZ0Wc4mCa8Tl7iMcFslMY65KqGDhNWT055fwAULryP9LZae5dd3I
         mat6PHk4RoNhs1du92YxKWZnnunloWSOpEJ2+V26Jqr0NWc1ao+HMTW1Z+Evw7XFEXCd
         kCuQ==
X-Gm-Message-State: APjAAAXRGfOqKC1GUjsfAFk1rBo27bvu7FrqiRlgpNcgHKyCXKXKHzSU
        HbztSGXtCP1h6vE50Pxg9cdagF++
X-Google-Smtp-Source: APXvYqyujIGI2hIGh/lUB8MFy3vCutJPJw+lMg4NWy6Jo7f9gI9ynwIJ+NcNgdPUNqFXXaJHDo5zCQ==
X-Received: by 2002:a5d:540c:: with SMTP id g12mr17579546wrv.207.1569931718832;
        Tue, 01 Oct 2019 05:08:38 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id f18sm2600683wmh.43.2019.10.01.05.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 05:08:38 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-wireless@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: [PATCH] wil6210: check len before memcpy() calls
Date:   Tue,  1 Oct 2019 15:08:23 +0300
Message-Id: <20191001120823.29853-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcpy() in wmi_set_ie() and wmi_update_ft_ies() is called with
src == NULL and len == 0. This is an undefined behavior. Fix it
by checking "ie_len > 0" before the memcpy() calls.

As suggested by GCC documentation:
"The pointers passed to memmove (and similar functions in <string.h>)
must be non-null even when nbytes==0, so GCC can use that information
to remove the check after the memmove call." [1]

[1] https://gcc.gnu.org/gcc-4.9/porting_to.html

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 153b84447e40..41389c1eb252 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2505,7 +2505,8 @@ int wmi_set_ie(struct wil6210_vif *vif, u8 type, u16 ie_len, const void *ie)
 	cmd->mgmt_frm_type = type;
 	/* BUG: FW API define ieLen as u8. Will fix FW */
 	cmd->ie_len = cpu_to_le16(ie_len);
-	memcpy(cmd->ie_info, ie, ie_len);
+	if (ie_len)
+		memcpy(cmd->ie_info, ie, ie_len);
 	rc = wmi_send(wil, WMI_SET_APPIE_CMDID, vif->mid, cmd, len);
 	kfree(cmd);
 out:
@@ -2541,7 +2542,8 @@ int wmi_update_ft_ies(struct wil6210_vif *vif, u16 ie_len, const void *ie)
 	}
 
 	cmd->ie_len = cpu_to_le16(ie_len);
-	memcpy(cmd->ie_info, ie, ie_len);
+	if (ie_len)
+		memcpy(cmd->ie_info, ie, ie_len);
 	rc = wmi_send(wil, WMI_UPDATE_FT_IES_CMDID, vif->mid, cmd, len);
 	kfree(cmd);
 
-- 
2.21.0

