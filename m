Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A973AA4C5
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhFPT42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhFPT4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:56:23 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E22C061767
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:54:13 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w31so2890086pga.6
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ta3RbqOIn8BZORbiR4sH2Jl3iefLLCl3kYqOTHV1WDg=;
        b=QrkdJQqzr0NXGF3lxt9ugTPrUAhMSlDlW2SJ9fsA+KH7cm92Li7mXBFD4Wkcsn+sBO
         h8sV1XrNnlfzD0rRV96WfNd0eu5gQQ49QyP9rH5ggr4oiClHxuS+xESkSA1cO4kpL2IZ
         KTEQwm3qKh8NbOrUh0BV80kglJ0Di9sVT+K1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ta3RbqOIn8BZORbiR4sH2Jl3iefLLCl3kYqOTHV1WDg=;
        b=SqTAS8tdU82HzpWh08jVEzZ6xfgRBVJtTWPyvTKALqn6IDWQ3E9X64ys8cohQZyG+b
         ws9/87Wz13ssCrSd3t0EhtnAv44fDVhwlSLqo+lLXuOLD5kP8jRzDISntfCYxScqw07n
         qoB6BlrinPM41Ki6S7sRtl+4woRlC3T8jo/dmwVR+Ms3k05J3i6XrsgQW8JvZ2HN9NhA
         l+aYynhErMwGsyC9v9sgatpM+7Nu9KDJSizfputxBhBe3/Tqpcj8hbtkB6QBpPRSWxRf
         Kw2WRU0iC65gjCIT1jCWmBqTbuWPHgNtiSxv7UNspcSBH8/Da5vFH1ZDYsLuhY+bIPxc
         66Ag==
X-Gm-Message-State: AOAM533pfHH8DXyb29lslsUdPg8yJFC+jn+GaAqwNnHY7xHvDKFYeJ3A
        afpYwdQiQW74nGQllG+0/GMu9Q==
X-Google-Smtp-Source: ABdhPJyV+Ew0riI0HXcKYe6MIMC6k+k3ndOX4eMCoUivqhy2b7e4mAVzoRSDmJfa0dGNcFL/NH1rSg==
X-Received: by 2002:a63:e043:: with SMTP id n3mr1310592pgj.106.1623873252926;
        Wed, 16 Jun 2021 12:54:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c184sm2794609pfa.38.2021.06.16.12.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:54:12 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] ath11k: Avoid memcpy() over-reading of he_cap
Date:   Wed, 16 Jun 2021 12:54:10 -0700
Message-Id: <20210616195410.1232119-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=a0cab8be0bd22cb947a89c25d20b00b86ac2fb47; i=eJo4iKawiWzp/TGJDTmVIE2lOKR+PQjNu4KYQ5F00YM=; m=+6EB5srPoGi1D7Om5kP3HXtskB0VIFJiBD3X5t+nWWw=; p=fNBF6uun0+FYmLLA4u44niS95J1JvHuPRqCzmoIK3D4=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKVuIACgkQiXL039xtwCbTbRAAj9W ByUby95Dh+bLBWJHMugD4XSE2xrtVClsmeigQTMJnmvAxy08rlzrjqIoG+amV8BauQFvk6jc/zFZX 0u4vjIF7f9p65oQ4fBw9YlvkbHTVPqDgO8952UQ1F7Q9gVB1L1Fyz3lIFUkEl3raJljKDCOaEnPee CMZ9iDO61/WRyFCY/iXQ2ofLoOIevL+Fc/TqZPLX7dKZjSwpLrLzw6BrGPNdvc2GyBQqmy5qIHJt9 kT2K2w2QmATu1iZvTmsxAykWfJeoGhIK9yydYRgXatZDNBEI0Ad1XQ0YKllOVCHZWEyaXekZi7iWk VpyL1Z2mLn2zto3be8ZZLOUrKk5xI60KFnmhv1aPWu6YxL/4y6ELEK0qfIl2VZ518wt/jw3uY3nul 4kvV/wG7UFBhRhwt/A7Wi0yV0C6IXgswZga/1vHxfIGHl82M54CyCGEIWtYoC8J0raeshqamo1bbI R7SKkItM6CdhAB5PTlBjy+2XTAYs5SwqCf8SLdwU8pujY/0zvFmrL8P2vbFcrVyAgaZ4R3GBP8vci SyUAlI2nAP3Qy3y/MeVF+n6mLNY7vY28SI9ethoHlKWaZ9cGfLB3bHo2QLSfbEYeilPEM1L9RhDQH m2EL6AmnX8+pqOSu0Pqyd6RHXXtB6rxa4Z35r3ed+A0kQ/L1XchTO6mEVFXyTw0w=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring array fields.

Since peer_he_cap_{mac,phy}info and he_cap_elem.{mac,phy}_cap_info are not
the same sizes, memcpy() was reading beyond field boundaries. Instead,
correctly cap the copy length and pad out any difference in size
(peer_he_cap_macinfo is 8 bytes whereas mac_cap_info is 6, and
peer_he_cap_phyinfo is 12 bytes whereas phy_cap_info is 11).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 9d0ff150ec30..b1178a0b7fc3 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -1314,10 +1314,16 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 
 	arg->he_flag = true;
 
-	memcpy(&arg->peer_he_cap_macinfo, he_cap->he_cap_elem.mac_cap_info,
-	       sizeof(arg->peer_he_cap_macinfo));
-	memcpy(&arg->peer_he_cap_phyinfo, he_cap->he_cap_elem.phy_cap_info,
-	       sizeof(arg->peer_he_cap_phyinfo));
+	memcpy_and_pad(&arg->peer_he_cap_macinfo,
+		       sizeof(arg->peer_he_cap_macinfo),
+		       he_cap->he_cap_elem.mac_cap_info,
+		       sizeof(he_cap->he_cap_elem.mac_cap_info),
+		       0);
+	memcpy_and_pad(&arg->peer_he_cap_phyinfo,
+		       sizeof(arg->peer_he_cap_phyinfo),
+		       he_cap->he_cap_elem.phy_cap_info,
+		       sizeof(he_cap->he_cap_elem.phy_cap_info),
+		       0);
 	arg->peer_he_ops = vif->bss_conf.he_oper.params;
 
 	/* the top most byte is used to indicate BSS color info */
-- 
2.25.1

