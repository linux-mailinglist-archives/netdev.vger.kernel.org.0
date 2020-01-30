Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138E214E61B
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgA3X0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 18:26:52 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:32777 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgA3X0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 18:26:52 -0500
Received: by mail-ot1-f66.google.com with SMTP id b18so4884079otp.0;
        Thu, 30 Jan 2020 15:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uiPnoOAYPt0TxpEOOk3xyCGG2sxkTQwY14DXYCt3mdw=;
        b=XlIy0Vu/CiLZtlGrJG2TgfCjV1o+mfeLuhhL+eMsuwQxVRfyGWn+5TE9WRAB4Xq+CF
         wGj16HUb/YW4TQ3G2cAAZ0iEWD7t54L7fE3whumbk2FAgell+92Lotp877b8/JAOuOPp
         QBQiS16J6/ZGaWHMo9kt7WXTAycbonDuW6OXrQzJ6/6ChsS4XZTf9XgItWbI8Xkdh4J4
         0m7pwpRRZGmlqdrZ8wWQBvQ5kVJTcPF1fcELzWSTp5qnf/V0ZiLhKy+UCPm6yDRHbQGU
         xWcxLSfWzDJE3eiri6UV/6UMv+kErLMRGv+Z6RQM0VxEjsNy+vh2zjfxLxFQIu/5aNgy
         YBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uiPnoOAYPt0TxpEOOk3xyCGG2sxkTQwY14DXYCt3mdw=;
        b=BTqAKwLlcU6MwTnsliYJ0kZVlx+jUVniLT0zBTHvLuEuEaR6izDt3UrUo5E9yvAj5u
         7VJtJiz9fr+3z9iCe2bR/755LSDFeKVRE6ii5BteZuP/jkbyNldQhRcW7kzT/ip4oZG2
         FDynvi77bo2tBD4u+xNcppSchyeOnylcArT3M2MoGAH6yUey7dvsG2VZJPsWEGUStRXj
         UfyZftFmnEJLgfzpsaxaeX6+hy2/gKmFhJQhXMo520EAjEtAYPcsfJpgEyobsx9K35Cn
         LH6AGeBbBOdtTPm24KpcEHYYWaLUdSaWeVGjcz6dXnUA/lRVCaZyKxrCgiidJ71kmz9t
         6Rpg==
X-Gm-Message-State: APjAAAWYkdLVa8/iOdeecK02SZx/4omsUuTLqQWE/rhdrx7CdGzdRsa+
        dxix4c+r+Qw8p/6/CzqSi4R2AXdM
X-Google-Smtp-Source: APXvYqxZNaW195FQdMEybZTaiz+asOc491aU3TOUXInHWb5YWmTolmZwK1TemcXXstCDfNxqzUK1HQ==
X-Received: by 2002:a9d:6505:: with SMTP id i5mr5181796otl.121.1580426811624;
        Thu, 30 Jan 2020 15:26:51 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id 96sm2294473otn.29.2020.01.30.15.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 15:26:51 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] mlxsw: spectrum_qdisc: Fix 64-bit division error in mlxsw_sp_qdisc_tbf_rate_kbps
Date:   Thu, 30 Jan 2020 16:26:41 -0700
Message-Id: <20200130232641.51095-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building arm32 allmodconfig:

ERROR: "__aeabi_uldivmod"
[drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!

rate_bytes_ps has type u64, we need to use a 64-bit division helper to
avoid a build error.

Fixes: a44f58c41bfb ("mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 79a2801d59f6..65e681ef01e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -614,7 +614,7 @@ mlxsw_sp_qdisc_tbf_rate_kbps(struct tc_tbf_qopt_offload_replace_params *p)
 	/* TBF interface is in bytes/s, whereas Spectrum ASIC is configured in
 	 * Kbits/s.
 	 */
-	return p->rate.rate_bytes_ps / 1000 * 8;
+	return div_u64(p->rate.rate_bytes_ps, 1000 * 8);
 }
 
 static int
-- 
2.25.0

