Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4856C78958
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfG2KLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38770 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbfG2KLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:21 -0400
Received: by mail-pl1-f194.google.com with SMTP id az7so27307161plb.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eAXmaafgEAfgGmg6M7fqUc99u1sdmft5b3dJCRTHDB8=;
        b=I5sVbsjyV59P44zEnyKWR+Z7mYoRaSudefoS+Sw30/4+2ycA6qUTlC915yaIsbz/G5
         JYFNSRr2MuTiTYC9Kc16WBAUTiNXFk4Guv9z94pVU0hlW/Cvd5kuKmp41qbwIENoZDZ7
         AlmgX1MfczCcw1lyREJIGH5C0eO+cMhh6vu+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eAXmaafgEAfgGmg6M7fqUc99u1sdmft5b3dJCRTHDB8=;
        b=B5dOcfP5JUkJpfUqff9aaR7FqrrheOV+6tz17US0V3jHyUzN/6+jj31h3n8So2hGua
         Wp1A2mkN/ndgMUcqJv/SQPmh+k0gTnTG3W0ho2HeuWlqCEsYqC9FfmkuwnKFCxHNm3gy
         kBjquwBKpmcHnypPkCicEXlt/YcQI99rmi1R+5g0FW6qBR0YRQzvKj1l5K7xIh7csTCS
         5hKg4OG7wMuo0BWUeeJN6CXdr3WgJ1BAEmtiTPBKzVr3sOKEMsLYpd06tNFnrvNcf4HU
         TnGsGSuflKQJcR8biSDBqCtOsasX9wUf76Y7WQtSYFQhJfnTpgWD0NoN/YKMLt3bS1Ry
         9Dtg==
X-Gm-Message-State: APjAAAUU5hJePJRcDg2waQyCfhDQNxvDX0S/prtc0IoyGy+EDczxiHj8
        nyH/OTpEmMxJiuY3PHMZD7iX1x/WWmQ=
X-Google-Smtp-Source: APXvYqzUGlGoGO0A8z65vwtiZVn+UJPrDI3Pai1XXv1JB7AgPVXi/XPKjoCprm/Eq2xe6/yo1BaZ0A==
X-Received: by 2002:a17:902:28c9:: with SMTP id f67mr70337131plb.19.1564395080540;
        Mon, 29 Jul 2019 03:11:20 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 07/16] bnxt_en: Set TPA GRO mode flags on 57500 chips properly.
Date:   Mon, 29 Jul 2019 06:10:24 -0400
Message-Id: <1564395033-19511-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 57500 chips, hardware GRO mode cannot be determined from the TPA
end, so we need to check bp->flags to determine if we are in hardware
GRO mode or not.  Modify bnxt_set_features so that the TPA flags
in bp->flags don't change until the device is closed.  This will ensure
that the fast path can safely rely on bp->flags to determine the
TPA mode.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4856fd7..b615206 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9345,7 +9345,8 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	if (changes & BNXT_FLAG_TPA) {
 		update_tpa = true;
 		if ((bp->flags & BNXT_FLAG_TPA) == 0 ||
-		    (flags & BNXT_FLAG_TPA) == 0)
+		    (flags & BNXT_FLAG_TPA) == 0 ||
+		    (bp->flags & BNXT_FLAG_CHIP_P5))
 			re_init = true;
 	}
 
@@ -9355,9 +9356,8 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	if (flags != bp->flags) {
 		u32 old_flags = bp->flags;
 
-		bp->flags = flags;
-
 		if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
+			bp->flags = flags;
 			if (update_tpa)
 				bnxt_set_ring_params(bp);
 			return rc;
@@ -9365,12 +9365,14 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 
 		if (re_init) {
 			bnxt_close_nic(bp, false, false);
+			bp->flags = flags;
 			if (update_tpa)
 				bnxt_set_ring_params(bp);
 
 			return bnxt_open_nic(bp, false, false);
 		}
 		if (update_tpa) {
+			bp->flags = flags;
 			rc = bnxt_set_tpa(bp,
 					  (flags & BNXT_FLAG_TPA) ?
 					  true : false);
-- 
2.5.1

