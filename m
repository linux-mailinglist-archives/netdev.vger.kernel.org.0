Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3CB396A4C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbhFAAfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhFAAfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:15 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CECC06174A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:33 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l3so18974463ejc.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nkiW4cgqcNA2wnsGokaWDqLEeknOpooJwCUovxh3/t0=;
        b=n6m2XrTmYtWZPyl1/P3/cR/z7//XuhCe/q3TRsnkCPezT8DxFgwv/3CL5CTpYvnBI2
         egGvm5KvhH/dB/1RlO0WKVQpoz/VptjRGCsnasVuvwl0h38etplYvW6B/Fj+a/zccPLq
         /G+Z01DqXBwadzDbLHMMVwABz1cOn26OXvs0HL08prgl+50dQsZUqn0cUB+plia6S4jJ
         43npgqmWv2TQrAd2pa4ZU3y18BcAfRJg29GbqvV3y4c4Y8uANefkaADUurR7EglE/bm2
         5FwytQbVl9zaSD7RlZHVEK3YSUnWhbP2Sz3Ky09dVFB4IthANo3Ilbj97FWgjSFJudUb
         /jBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nkiW4cgqcNA2wnsGokaWDqLEeknOpooJwCUovxh3/t0=;
        b=sr1cZiOXcHRxFUvmz+wTyxjUGv6SRqnecB2jcfam3RpJ6nWOjX37mfI3LHuOMSr2ZW
         4DZrPPu5b9q+T1k3uPNi3eE67ZKeaEStbfNJIQzoeUpKzFhEu7jOhooFn0zaWUOkHg89
         gwX2Eu0yQZn01Hnx2T53nts/7g00LmIVl/LibIpl1tuAoDZNJAK7Nk/wzeRvHo+DBUtq
         XqGv2r5Xf/NeQVQ9EgRA3wudwUR/U2qc+3gQiUVYtApsEi//CmgBr8Q0R6XFv9gVMK4l
         e3s9LvWSCtdpONIvQDKax8PJHmY0/UWLndwWZRu1ljZRfxEnqNQpihTQuLzd1LGiwGps
         jzNw==
X-Gm-Message-State: AOAM533j5u+eRZa56KN57Ni7wqc2qk/qHgtl798sqwgZeTdlJe2z3pTk
        /PM6xp6SWCmdPufSNm7Ah8U=
X-Google-Smtp-Source: ABdhPJwO9uQLiu2GkV4CtaEggt3sWUDSZKvcUbGB6QP4ZuBin8SqeYGmAsGACL1bAgy+QKhbntV9uA==
X-Received: by 2002:a17:907:970f:: with SMTP id jg15mr4821340ejc.59.1622507612543;
        Mon, 31 May 2021 17:33:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 1/9] net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
Date:   Tue,  1 Jun 2021 03:33:17 +0300
Message-Id: <20210601003325.1631980-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

CONFIG_STMMAC_ETH selects CONFIG_PCS_XPCS, so there should be no
situation where the shim should be needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/pcs/pcs-xpcs.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index 5938ced805f4..c4d0a2c469c7 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -36,13 +36,6 @@ struct mdio_xpcs_ops {
 			  int enable);
 };
 
-#if IS_ENABLED(CONFIG_PCS_XPCS)
 struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
-#else
-static inline struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
-{
-	return NULL;
-}
-#endif
 
 #endif /* __LINUX_PCS_XPCS_H */
-- 
2.25.1

