Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E913D276D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhGVPf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGVPf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 11:35:57 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E4CC061575;
        Thu, 22 Jul 2021 09:16:31 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o30-20020a05600c511eb029022e0571d1a0so3285352wms.5;
        Thu, 22 Jul 2021 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uUijDMlwf66Vepiz2SA/l8IhtRRiKMWBDC91ym25DGY=;
        b=BhR7+5yZHxXBFGVNMAKcnaGuntaopLXHQRE5h+q7FtTa7FyEiHhIzM3sREmZLvSNXP
         wrSshMJcbRbb8P+kaxI5JV5dE1hBNz/0GCtHNvYJYjY5reiQ2vRQWs7U/HJND5FmoR7G
         jEQQIJGtmrTtPwP7ZaUexmph+D7ab/L1zE+ljcp2PH1Q78zIiZPf87AKtKIfXrWd30GK
         5esKC9+qccKWW0djwtZ+LtLgW+VNz94tmbUdP01B9iMc4i+EyV8EsxWX5sbWm43r6WIl
         KwDAj3I0DuTghhZ/R+zlyLVeEnLDXqZ1lMiVHanqet0P1F1iBqNoQudgGwOHKj1L+LaY
         G64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uUijDMlwf66Vepiz2SA/l8IhtRRiKMWBDC91ym25DGY=;
        b=l22c7K7hHYMJJpi9SSboubsTW2efatjSIs8da/4lFOOoYms1N3D3qIB4/fya+2Hqkj
         iMDsuBo0XLSWE4btYIOtXtqipQfd6nOJSh0Y0va5As71yfm2gjCZ35c6+YFj1ru5+UWd
         4jOV9v7Pcc54zb1eUhi0hTAO6FBvGshH87Dkdi8+zStcqLlNfPVARWGSMydsaDgxWLFY
         wE47nzV6lD/7JKNlbVWMZLx2A//06jq6yRF3Bk8m8Fgk4kYuvhBMHyO6CE08gb9KKCtA
         WagFxCfFY0rzYTvGRbht1Uvc7vzbdMdluCaf260XZJJVczJuZuaF5vGBrMmGpgpHEzf3
         87Ug==
X-Gm-Message-State: AOAM533DJp8zApUVGT3spT3Rk0Emr+CogZ0B7hd2WlkM/ZfUi0IoWr0V
        kl2LTKIWJsrVhN0EPbZUHf0=
X-Google-Smtp-Source: ABdhPJyvxfPmN771LA53eyYvC2w1VleRrv7+iyYmnrWPyZJqpmkQvtdm04VZ+XgZ12btuYoBrpfUbg==
X-Received: by 2002:a7b:ce82:: with SMTP id q2mr9913989wmj.60.1626970589996;
        Thu, 22 Jul 2021 09:16:29 -0700 (PDT)
Received: from localhost.localdomain ([176.30.243.91])
        by smtp.gmail.com with ESMTPSA id w15sm4697060wmi.3.2021.07.22.09.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 09:16:29 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org,
        bjorn.andersson@sonymobile.com, courtney.cavin@sonymobile.com
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Subject: [PATCH] net: qrtr: fix memory leak in qrtr_local_enqueue
Date:   Thu, 22 Jul 2021 19:16:25 +0300
Message-Id: <20210722161625.6956-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in qrtr. The problem was in unputted
struct sock. qrtr_local_enqueue() function calls qrtr_port_lookup()
which takes sock reference if port was found. Then there is the following
check:

if (!ipc || &ipc->sk == skb->sk) {
	...
	return -ENODEV;
}

Since we should drop the reference before returning from this function and
ipc can be non-NULL inside this if, we should add qrtr_port_put() inside
this if.

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Reported-and-tested-by: syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/qrtr/qrtr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index e6f4a6202f82..d5ce428d0b25 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -839,6 +839,8 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	ipc = qrtr_port_lookup(to->sq_port);
 	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
+		if (ipc)
+			qrtr_port_put(ipc);
 		kfree_skb(skb);
 		return -ENODEV;
 	}
-- 
2.32.0

