Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8741581F3
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgBJSCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:02:53 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36873 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgBJSCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:02:53 -0500
Received: by mail-oi1-f195.google.com with SMTP id q84so10085876oic.4;
        Mon, 10 Feb 2020 10:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQekwqZh4rEhoBj4GEkVjbrCnvdh2ERgwV+8ur0WBBk=;
        b=vUJLSruUL6FxNLr9kXzL/KT0r+L1HzeDE014Umwml3+uSDLb+pm0f50xDGucs8+2It
         zyiMIqtH3p41SbKTO7N9HO6UEv1HZIso5J2FU2Xyxp0sgEr1ot4K1p6HQmlwNUDYxUrV
         rE9Lc9w7wm7UGB3WjzIzza+EQnlGaBWmH4P5M4+i3KOaCLS7WlDfBnfDKfgGYje59aPo
         NPVP6urNpEayFveaNR0i8cf6TSyaooXNcN7/OZh5i+BkHtoATVqJ8lODEpswSMl6ICUD
         SrNt0geBYr2X4wxYYnzzIxNvdomnZs2t8JuExMkcNAc0b2NIEYx9dAz/pLANZnlt8Jm5
         +14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dQekwqZh4rEhoBj4GEkVjbrCnvdh2ERgwV+8ur0WBBk=;
        b=VH9CW4eTKZ7w8c5jM/lQWQjZkPMjRAbXGEOpDkoUl69j2erziclMW+HnzqA7pUwaU6
         6OelD6/IsFKXaq+zKFuKL+WecRz1/xEHLQKN4atEBRWDQePGtMw609vgqihauVXbOJEx
         Z8vp0C7S5+aAfJ0OHQgOak3gnmX+VhvoKD81Afr8T0sAn7E6hvxhNVMF4ekyUyit9voy
         qEdcNoup7caHzMIUYqZz3I79Hqj5/H4i5AK7k2LqGsm1wl0Md4BaLOJZ0INBvqqR0NUe
         jk+fgpHLhNHIgS+HGIQDOgbGS/EtQir3ABXvmmlLCvYmcBF5GkzpLtbeAthtzuH9IZLM
         kkIw==
X-Gm-Message-State: APjAAAX9xwlwF+siCY0SVnkAZZ143PX92XWMd6vkPX3zt9SZxeN2SLp/
        L660o3SkGl413kR5PYqKnXI=
X-Google-Smtp-Source: APXvYqx968in8J8EQqEB4kZPw7DUzn7BggowcCcKFFiuWwO6Bhwk1geUE/Jc4ubxQqL/Fpwphihjiw==
X-Received: by 2002:aca:fd4c:: with SMTP id b73mr186838oii.33.1581357772474;
        Mon, 10 Feb 2020 10:02:52 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d131sm313031oia.36.2020.02.10.10.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 10:02:52 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pietro Oliva <pietroliva@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 2/6] staging: rtl8723bs: Fix potential security hole
Date:   Mon, 10 Feb 2020 12:02:31 -0600
Message-Id: <20200210180235.21691-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
References: <20200210180235.21691-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In routine rtw_hostapd_ioctl(), the user-controlled p->length is assumed
to be at least the size of struct ieee_param size, but this assumption is
never checked. This could result in out-of-bounds read/write on kernel
heap in case a p->length less than the size of struct ieee_param is
specified by the user. If p->length is allowed to be greater than the size
of the struct, then a malicious user could be wasting kernel memory.
Fixes commit 554c0a3abf216 ("0taging: Add rtl8723bs sdio wifi driver").

Reported by: Pietro Oliva <pietroliva@gmail.com>
Cc: Pietro Oliva <pietroliva@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Fixes 554c0a3abf216 ("0taging: Add rtl8723bs sdio wifi driver").
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index db6528a01229..3128766dd50e 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -4207,7 +4207,7 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 
 
 	/* if (p->length < sizeof(struct ieee_param) || !p->pointer) { */
-	if (!p->pointer) {
+	if (!p->pointer || p->length != sizeof(*param)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.25.0

