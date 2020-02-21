Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C318167A00
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgBUJ4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54211 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgBUJ4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:52 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so1030727wmh.3
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wU7XkWqeMwVI7zIqEnTnLliqlehNQFtMvc+LskfXmlg=;
        b=mqLAzsnVJ+q7FEQecrdApJpfvOU9lAgZqEXihzAMq94/EJkyPTshkiI63MJXg8uZBe
         0CYz5RTgRaVI2pkndjsa9XlmdJuADQj7qmnfL/ip7YZGQqsXMuFrD2pwBTot0F1Ts0TK
         pBWR21DSO4WVulmmpfrvX5s4/XRuzs+qDhY4L/2qDKDPghY4PsL2Vfujb0IvPZGXFxgy
         gFjSdSqTfpRvB8xSVLu2yvemIkAwwIRutarBzTybqEN2HEQ8s1FfC3nwT8i/moztTbpd
         x0TcCxS93Gf9SxB3HhHqHQowPx3s0orcD4P88bPrMSkTgN1+yTFhTLt+bJvzXvyE+rl3
         oaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wU7XkWqeMwVI7zIqEnTnLliqlehNQFtMvc+LskfXmlg=;
        b=Fp8uJedmSJbF/Uv+JDywjUBR4Oca7HudXvQ8uLwhDFu5aymj14EPXK6q54glmP+/kT
         cGQHVr58Gablx59sw91hFsUv/k1lpxPz1haymdFdDJprotP3HsupE4Ynb6CEK/Fj0/dR
         m5TcOxSRserxbNLESVnbiIR0JuqXQU0901uh71/KFscrakTKeTFpKgoRpxZDOyRurFgy
         05deT2tDIGMdyj3nghhPXndul+3+CWdcSb0JqFgownDP1S0brGVDGvaZRq3eAqLWpkcF
         /fq3G3/kuNjH8fgwRwIHPSx7nMw961H5zMb2kyvs73NIJCP0VMpm7sFDDiAbOrruiO3B
         vbpw==
X-Gm-Message-State: APjAAAXQD8m4r0t83uk5S8UauWl099BNPCpp3FXWju+MNoq9eydQ7TIv
        icC0emZnePvsBBBfprahGgNL7XDHtqA=
X-Google-Smtp-Source: APXvYqwE3NQXYuzsAFJHuuHv7HY68rENqCOvzfOHd5COggyuwDOixlam0ooNYC4YC/wM0aTNInDqMw==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr2788199wmj.33.1582279009479;
        Fri, 21 Feb 2020 01:56:49 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c74sm3259349wmd.26.2020.02.21.01.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:49 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 04/10] net: extend tc_cls_can_offload_basic() to check HW stats type
Date:   Fri, 21 Feb 2020 10:56:37 +0100
Message-Id: <20200221095643.6642-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

As the default type of HW stats is "any", extend
tc_cls_can_offload_basic() helper to check for it and don't allow any
other type to be handled by the drivers.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 779364ed080a..d3d90f714a66 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -594,6 +594,11 @@ tc_cls_can_offload_basic(const struct net_device *dev,
 			       "Driver supports only offload of chain 0");
 		return false;
 	}
+	if (common->hw_stats_type != FLOW_CLS_HW_STATS_TYPE_ANY) {
+		NL_SET_ERR_MSG(common->extack,
+			       "Driver supports only default HW stats type \"any\"");
+		return false;
+	}
 	return true;
 }
 
-- 
2.21.1

