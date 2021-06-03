Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B591439A5E1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhFCQlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhFCQlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:41:14 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DDDC06174A;
        Thu,  3 Jun 2021 09:39:17 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id v8so9785743lft.8;
        Thu, 03 Jun 2021 09:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VmLmkvFwr4n9oRDeOXVoYKwRtcm1cme7qf3DqyZC2S4=;
        b=SgwD40QBfynEskonig0PPw/VLdgzg3TOt6NT8a6yf7klKA7NIIKiM9cCJzqCo73W6B
         PpB9n52Xcgg+/dByRQBH+jpcDuD5vqig//N0FQ6edFH/OCdR8qjZ71l2l29M0tRWBSV8
         c+QrYXg1mRkrpV/K103H0Gm6OkmqGTpf/SMGbj1Sqv49xACJMEBkhc02FlD7q40zLCwY
         1mMkmfkjTOw4mDJ8u+nupf4F1YefceIqM73sO/hv52enR2M9IMc5SgXh4LPyj+8OOwjb
         rYWCwQG374vnm69Sox+DjCrUBfuq5h9rd5WaMad62gxrdHHv3bX7PXhCr8AFYSzc4hjL
         o1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VmLmkvFwr4n9oRDeOXVoYKwRtcm1cme7qf3DqyZC2S4=;
        b=R9HpVt8DTE7CgpZ0Icl0uv0RoUdmFsFWQrLwM6p4Kj2oY83AZ58elVuu7Vo5YDQJtH
         DqoermNgfQ6ptPLF5FR3Qh6OMRGDtqDRsNSzlEK2L2uRvb5w/sEiYj5KytS+2SlXSpPF
         Puq/7mLDCIsUG0OrE9xzVvH8Dw0/ety4hkfsRhZY5CkmyALGiKrouJSOqyEGwz/ANkGZ
         9MX147nRbfKvHi5gHtj7faIgApEYWPYHeybKha3KLJU9wda8KDwcMGs+nQPVe0r9x1rU
         oW6AM3gtcW8L98rgtcYCeVgB5b16CYiIHSrNL8knts+OEzimCE6Jgl5mBznU830xTuI0
         ndaw==
X-Gm-Message-State: AOAM5301eqHSU20v/+yuz8pCFXvpBjNYrg2z5qXcJ/oFyBD0wUCBv1xj
        FC+heHapjMPWQpkMQNlkVoQ=
X-Google-Smtp-Source: ABdhPJz2jSYS5l86vc8NwNRO5iBauzOK+6UV1BuHhTsM3GwzuSxNWoxoPFjAY+SeP30QguIttMV4Ng==
X-Received: by 2002:a05:6512:21ae:: with SMTP id c14mr334669lft.483.1622738355485;
        Thu, 03 Jun 2021 09:39:15 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id m3sm363468lfk.76.2021.06.03.09.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:39:14 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        sjur.brandeland@stericsson.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org,
        syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com
Subject: [PATCH 3/4] net: caif: fix memory leak in caif_device_notify
Date:   Thu,  3 Jun 2021 19:39:11 +0300
Message-Id: <fcddc06204f166d2ef0d75360b89f6f629a3b0c4.1622737854.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622737854.git.paskripkin@gmail.com>
References: <cover.1622737854.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of caif_enroll_dev() fail, allocated
link_support won't be assigned to the corresponding
structure. So simply free allocated pointer in case
of error

Fixes: 7c18d2205ea7 ("caif: Restructure how link caif link layer enroll")
Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/caif/caif_dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index fffbe41440b3..440139706130 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -370,6 +370,7 @@ static int caif_device_notify(struct notifier_block *me, unsigned long what,
 	struct cflayer *layer, *link_support;
 	int head_room = 0;
 	struct caif_device_entry_list *caifdevs;
+	int res;
 
 	cfg = get_cfcnfg(dev_net(dev));
 	caifdevs = caif_device_list(dev_net(dev));
@@ -395,8 +396,10 @@ static int caif_device_notify(struct notifier_block *me, unsigned long what,
 				break;
 			}
 		}
-		caif_enroll_dev(dev, caifdev, link_support, head_room,
+		res = caif_enroll_dev(dev, caifdev, link_support, head_room,
 				&layer, NULL);
+		if (res)
+			cfserl_release(link_support);
 		caifdev->flowctrl = dev_flowctrl;
 		break;
 
-- 
2.31.1

