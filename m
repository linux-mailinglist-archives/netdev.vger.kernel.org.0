Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35BF44527F
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 12:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhKDLv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 07:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhKDLv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 07:51:58 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6600FC061714;
        Thu,  4 Nov 2021 04:49:20 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id g13so3352313qtk.12;
        Thu, 04 Nov 2021 04:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KuPFje2AUfFzNhATj0vA/YQ0MyvJDY+bIV73xrs0RvI=;
        b=DQdZgG7ncr8s3KKVKwa3fXaIh48oz2vApeCPTJucPck1JOjSDVN7AIbtb+3uL9xUU+
         dgDKRIDzuwYPdk5BL1T+3YnwRxfb9krTafY+lzn8rQ63YzNQrM9t3inidG4LS2xc0XaQ
         B9aVyDN1zY0iBjvMQcfjxJP2D/Iv371r55Ycv4h7bZ5vcyDGaFn9sayuxjcNiaqpQmEl
         ZBm1fFbW7oavXzpqqT4DW+Ym7WWpwNzEfesFf6vH1cEZUEGTWs9tWLdSTVBXn+g7EXOp
         uxuK396/sjqZ1LDYdMJ2UYExDPfC5Olgh1SKcCTMsCrF8B9YWc1/lzDpsqbNwszJJ4wG
         D/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KuPFje2AUfFzNhATj0vA/YQ0MyvJDY+bIV73xrs0RvI=;
        b=iPCAwOvII45UPsOdED6iv303mae1k8gsKuy08euTLWAjwodfOmwMTIyDW5vdLziMF8
         tzu5R1nVKAN2ogGN8nSUEFQ0JzZebr+ZaYvgBqMwhjnxxkstU5gJ1MSzCPd7u8iK1vK9
         HtkmVkZcmFPAnu7/7H/El5l04230vm7Xem5ybuok01ifgNCXvKEZ4yjT94fJXeE+dTrQ
         cLAsGQ+Dzs4PvTcc0kpfRLT7Hygj0xvVBzGSG9nx58Xjz5cV9jMfnkCoKPgvCKQEd40Z
         Vg3IdHybpgLuikAmanV9VxjGPvHZz3Y4bKeTmmv4eavvqYsvy7nrAm2tytkQjics6ADy
         EAMg==
X-Gm-Message-State: AOAM532DPaXrEteE7X9oZPpNSiEB39Ck/loeiPe42hA5YS76ngqHCkAE
        iHf8mnv0JpqCy+BV3TOVi3w=
X-Google-Smtp-Source: ABdhPJxWtq2g4hcFUl/W8H1C4ME4cZJ97RFASWfkbGy8eVumbGHOxsZ8yCYR1Aj8YQKSzCDtE8VALg==
X-Received: by 2002:ac8:610b:: with SMTP id a11mr51988133qtm.182.1636026559643;
        Thu, 04 Nov 2021 04:49:19 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id g8sm3314601qka.45.2021.11.04.04.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:49:19 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jing Yao <yao.jing2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] netfilter: xt_IDLETIMER: replace snprintf in show functions with sysfs_emit
Date:   Thu,  4 Nov 2021 11:49:11 +0000
Message-Id: <20211104114911.31214-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING use scnprintf or sprintf

Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---
 net/netfilter/xt_IDLETIMER.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 2f7cf5ecebf4..0f8bb0bf558f 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -85,9 +85,9 @@ static ssize_t idletimer_tg_show(struct device *dev,
 	mutex_unlock(&list_mutex);
 
 	if (time_after(expires, jiffies) || ktimespec.tv_sec > 0)
-		return snprintf(buf, PAGE_SIZE, "%ld\n", time_diff);
+		return sysfs_emit(buf, "%ld\n", time_diff);
 
-	return snprintf(buf, PAGE_SIZE, "0\n");
+	return sysfs_emit(buf, "0\n");
 }
 
 static void idletimer_tg_work(struct work_struct *work)
-- 
2.25.1

