Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6924EFC5
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 23:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHWVAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 17:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgHWVAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 17:00:54 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F61AC061573
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:00:54 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i10so7393911ljn.2
        for <netdev@vger.kernel.org>; Sun, 23 Aug 2020 14:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o4o/RWuZSVyt2KxX1fFudlYA+bRugpK9nsAuSbD4TK0=;
        b=XTeKMDZ+OQwHT2AbGK01DqX1gidUgqaTmXRexHXdJQZGSoRCjIZue9zjTKjZlETg7M
         19a2rGynO60OWfRIYD78Zc+28nA3giFOatcWM74/Zx1ktNkR46ioHg7c2QJb48EVLL1/
         SPPXgHPr8OR8kL8TMwwtVjji2zTh7zLDzYIIqwKl0bHEVPK5BCLmjDd8fDnTclnHYap5
         1TbG2eOUuaotfff0vhbgpbu6FlJ1prmd2Cev+B5QWnMkWRV75DDKaLqrk8Dg7q/njn5H
         UI8dEuw2tI02MRB5lBPFqP/HroJ5u3D8PNaHBDKKTxhS4bVWrgpgkxAxedNXoobzdCSc
         wI+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o4o/RWuZSVyt2KxX1fFudlYA+bRugpK9nsAuSbD4TK0=;
        b=P1tmw3kDUEFtSlXuCtGz/5fKRm/26cLBoHO/ZHnjrBe+NruL1oLGpejZiZK6Gw2kfT
         g/wjbHUw+GZ89Ax9zDZeqMInKLO17RRPuLDRTtMuohfbz2E6nHJJcfXIUX1q10AHMFUz
         P1mSc2MG2NXfttyapQKcw34BoZ5YHZO92z2I5SzNHk3lAzKt2IOKhHOiLIcVJYmTR7jt
         StcIh/xAZwzOuuKg7pgW2VENt9c2VG0YwbZzzt2UDpOLF8LEpigK3kjWTzR9GMvpdtTu
         TeOht5aYJ6IRr7wvemdpN/SOneh0rIltVDZJWBcD1sjuRDwI8MQ6hzRQcIP8jyjQkxJW
         oScQ==
X-Gm-Message-State: AOAM533SaQHwKgqGAGfVfL4RD0mYCKWFzqOVQr162DTkcNR6+pSKMy3x
        fSRMVDhQkbnZqWrtdCSKFyDsMg==
X-Google-Smtp-Source: ABdhPJzksVthGnLrpKSERzccx5cz8lPz+YB5j0x5n46ZvOQ4ajCnhrmbMUKWaElW7xab/OWli3Oprw==
X-Received: by 2002:a2e:99d5:: with SMTP id l21mr1143354ljj.320.1598216452652;
        Sun, 23 Aug 2020 14:00:52 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id y9sm1786184ljm.89.2020.08.23.14.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 14:00:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 1/2] net: dsa: rtl8366: Check validity of passed VLANs
Date:   Sun, 23 Aug 2020 22:59:43 +0200
Message-Id: <20200823205944.127796-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823205944.127796-1-linus.walleij@linaro.org>
References: <20200823205944.127796-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtl8366_set_vlan() and rtl8366_set_pvid() get invalid
VLANs tossed at it, especially VLAN0, something the hardware
and driver cannot handle. Check validity and bail out like
we do in the other callbacks.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 8f40fbf70a82..7c34c991c834 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -43,6 +43,9 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	dev_dbg(smi->dev,
 		"setting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
 		vid, member, untag);
@@ -118,6 +121,9 @@ int rtl8366_set_pvid(struct realtek_smi *smi, unsigned int port,
 	int ret;
 	int i;
 
+	if (!smi->ops->is_vlan_valid(smi, vid))
+		return -EINVAL;
+
 	/* Try to find an existing MC entry for this VID */
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		ret = smi->ops->get_vlan_mc(smi, i, &vlanmc);
-- 
2.26.2

