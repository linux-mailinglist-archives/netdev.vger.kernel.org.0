Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1BA3AF8CF
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhFUWxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbhFUWxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:30 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1D5C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:15 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a16so5907421ljq.3
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2RophEWmKGfalis8s/rgDbmaYuR38nADcNkhX8xfF5M=;
        b=pCyInXwcEMOjWDwY0QDL5DfN7Eu3+KdaCJHxAD6nvDyas1jUxC1pX2vJh+QohgHpoa
         EwlFnUmOOe53RZVnHcsTCKxr9F6shPuhG4LFZYB8H3ArTqycfZiDKOpnNloKtInOA4X+
         NZd7z1A5USHf21YwfpqIhoeWGDzYT9a073114dl5Hp9+nsjIUiJSBV7Wj64NWYT4pQuI
         Obwi9CiC/S3oyMi/vyXryEV9dnytaOwbhLb9wxsXNGXkTGvarykP2Kjxlx/eyvmj4/Qe
         CdYRAPhq3YiBKhKu5yddKaBieWhLeYkHBI46QnDNcFiVs8bRbu6JxP2lsU68TYGfEnjW
         0xig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2RophEWmKGfalis8s/rgDbmaYuR38nADcNkhX8xfF5M=;
        b=F+cdStwZoXu31J8BCfCEgLddAAdjt0YE45TuotavQLPH5zlVVq9Zq6ZvjLQUUEXjKM
         qgIBtFv8f6nAM1ZQG2MC+ui7cqoMWUR3KFwAoEP/svBVZZq2BjNVSU2c5TJgFJRN61Tf
         Sc+eZCM69vPVg5acn9WoyZ681s7YY0fB0hqs4M48tWUEsCMyKb2WfyfsbtQBOY27cdmL
         tzTtp5qri7Mx886rRmSAe0zYz4kj8n6vh5yIYG693yIopXYW0bHL8XopSSGgnJwMNZdQ
         1ELuUw8FBF5TMBF1Vq+nN67Xl+HWBq/TxpljRdXt3GPJStr08sKXLvg8AUiHqKBVRq3n
         u95A==
X-Gm-Message-State: AOAM531Wr7UoCwN6gRIqQOEfdA/T8Gz83GGHiQ/wzSBxflJeKT75tcog
        gOLsgvckF2aPg8sFdoCj9mI=
X-Google-Smtp-Source: ABdhPJxqbqzVgFLZ1xg/2BvmPbkLCyqNXsF7jCNiQ5YWzsn2lXy3gucAg3DZVxr/M9wXphyVW7wMdw==
X-Received: by 2002:a2e:b78f:: with SMTP id n15mr410680ljo.495.1624315873477;
        Mon, 21 Jun 2021 15:51:13 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:13 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Subject: [PATCH net-next v2 09/10] net: iosm: create default link via WWAN core
Date:   Tue, 22 Jun 2021 01:50:59 +0300
Message-Id: <20210621225100.21005-10-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the just introduced WWAN core feature to create a default netdev
for the default data (IP MUX) channel.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC: M Chetan Kumar <m.chetan.kumar@intel.com>
CC: Intel Corporation <linuxwwan@intel.com>
---

v1 -> v2:
 * new patch

 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h | 3 +++
 drivers/net/wwan/iosm/iosm_ipc_wwan.c     | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
index 84087cf33329..fd356dafbdd6 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -30,6 +30,9 @@
 #define IP_MUX_SESSION_START 1
 #define IP_MUX_SESSION_END 8
 
+/* Default IP MUX channel */
+#define IP_MUX_SESSION_DEFAULT	1
+
 /**
  * ipc_imem_sys_port_open - Open a port link to CP.
  * @ipc_imem:	Imem instance.
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index adb2bd40a404..d3cb28107836 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -317,8 +317,9 @@ struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 	ipc_wwan->dev = dev;
 	ipc_wwan->ipc_imem = ipc_imem;
 
+	/* WWAN core will create a netdev for the default IP MUX channel */
 	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan,
-			      WWAN_NO_DEFAULT_LINK)) {
+			      IP_MUX_SESSION_DEFAULT)) {
 		kfree(ipc_wwan);
 		return NULL;
 	}
-- 
2.26.3

