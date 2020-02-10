Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4391581FD
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBJSCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:02:53 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35141 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgBJSCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:02:52 -0500
Received: by mail-ot1-f68.google.com with SMTP id r16so7297580otd.2;
        Mon, 10 Feb 2020 10:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQNvgm53xLH5GOW3/l9QmzzClUzION0bcZc79/JOpE8=;
        b=lh2qP7+TdqUtuWk7IJr2E17NnZSH7Se4VZxOfbE6m+FXVvHYns4wblSHp1SU2BnnQT
         xjP19UDg35gL2yz3jW+Gpk3i6Nmzhu54XvsFAnooSAhDqKl8od4vc4WJMplredof0gJq
         StQWYk+rGIzSB0iOEikULAyhAaEYDSA0Ul3K/Dvz+iXLlh3vNEXOR3Bhm6ENRtizhuDB
         F4LJFjAnGouU6y4IrlYZKJjGb0j6NWoP72GpzM8GOm72BW7LC60SSceOn0RVIsX29Q00
         fOLaH6Kyhjwys3Y2a38LGsrrhsMdrGT35Son5iP7OxaTwnAxOZIiVHI3Tguqe2ndL18X
         pRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=yQNvgm53xLH5GOW3/l9QmzzClUzION0bcZc79/JOpE8=;
        b=jFf+BS+p5myPUIBG7hCAXtntpWbzvD1meNfGcN+Uw4pdrNkiuLNvz+t6RTj+NfMSts
         PfbtZqvmjwyQdseMpI/UZ7wgyuMg9v1+JGtKykRhtuBzfhcFl/ZRrNfC8KLJAwPvS0TO
         Wyyt3rt5q8qoXy1bZZDH5FZv9s8rXGKqgSP7bu5RLXN86/dmzgrcSvA/Jl4HTHZ31Ipk
         IXucYKO+KvEKqS5GzBu1aE81akDG+w30auV9tyW1eHs/Kh2o+ZgISOsxypm8jVaAR10Y
         aDFjNmaYVEOvAckFmSjp9oZlYH9/tRPf/YXMx/v2mLXR5zMiHlYJCJNksHbnyXBI//fy
         BfNQ==
X-Gm-Message-State: APjAAAVq2Q62WEHHJOklkDxhzK7yv9DsQaZZWx1+2qlDkwa4gz3IPe+a
        /i8Q3cmZXmaf/t9OEmpV2xY=
X-Google-Smtp-Source: APXvYqwvFSr6sC8VY/oBSzY7TDiVs6IkW3CNRpoGZmsEUJNFS988f0N/ePJ3ngHcccv00TJeK9aj3g==
X-Received: by 2002:a9d:7f81:: with SMTP id t1mr1823493otp.95.1581357771634;
        Mon, 10 Feb 2020 10:02:51 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d131sm313031oia.36.2020.02.10.10.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 10:02:51 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pietro Oliva <pietroliva@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 1/6] staging: rtl8188eu: Fix potential security hole
Date:   Mon, 10 Feb 2020 12:02:30 -0600
Message-Id: <20200210180235.21691-2-Larry.Finger@lwfinger.net>
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
Fixes commit a2c60d42d97c ("Add files for new driver - part 16").

Reported by: Pietro Oliva <pietroliva@gmail.com>
Cc: Pietro Oliva <pietroliva@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Fixes: a2c60d42d97c ("Add files for new driver - part 16").
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 9b6ea86d1dcf..7d21f5799640 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2796,7 +2796,7 @@ static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
 		goto out;
 	}
 
-	if (!p->pointer) {
+	if (!p->pointer || p->length != sizeof(struct ieee_param)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.25.0

