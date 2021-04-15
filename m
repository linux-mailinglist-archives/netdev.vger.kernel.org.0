Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862A8361135
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbhDORiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbhDORiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 13:38:24 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA38C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 10:38:00 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i190so16527932pfc.12
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 10:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+x0EU4BTEonaGnIhnl1qOCN28fEaN5Zv4Usct7ILtU=;
        b=DFoEmQQ1h0gkzWLFHb2ZpOf7WaqMtvEiY0Jl3bTUp8iXF7/tf3Q8VtoNYzNcTvOQom
         uK8Np0pvcM53vBxMlk4lHDROulPD/plKlgS/kwo+RBpEdg0nJ0fOggf/6qKx9E3sWRRB
         JBXUo4N8lMXnL+M0gq29gxtktTDfiyRw0gqAwZfNB+xVq/9pEzaRph9pQmqNIHGvhhQc
         StEArV63W4VbuD7M+idxjXJTqjSL+LibZUUTotAFKHu5QzvuO0Y1HGDDHMmTdU8wCkAP
         OsVt6AixuanNIr6rZYkIUOyRioz3xmHbprBooq0hao4FJbYwHaRc5coiDIO+TYQap8Nw
         hdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+x0EU4BTEonaGnIhnl1qOCN28fEaN5Zv4Usct7ILtU=;
        b=gOQR9vKgp2+875ge/+h6ZP67NiJJFoZ4bmD5Bz3DWce6WMAyRZWD3r2M8aFvuraEoL
         neX5Ka+wn22wphbW/uocfWAuV0+c2NnG4ry1HNFcf6dM4GJ7KB1JhVo/W4PwG1FzsdcI
         A8GxgIDeF9fZGsDBN+2z93y043ctpnNc26dLu20EZTeG+My2Xn4DLvpytotgZWb+ugSC
         SFGKRIHeq1OVKsIVuPfxM6d3ExtRBZchlUIYAGXpOGZpDBLqHebpIsrBZ9mlwBsI5F8s
         YlwVdf2JxzneVUTidWyDCIdzUPiDXH802q/BpSAB6m2NqqXLH9zxMwkNcb48lfvjQSjh
         niZg==
X-Gm-Message-State: AOAM532A3k0FYpjVkWMiAnbXbGYUBw2ZbY+ZEcpAS+GBaJKuQ2cw3bko
        zdHwCwdvXjF64G1jspEjsnQ=
X-Google-Smtp-Source: ABdhPJy9R7er3KwA/V8lNPdLD1/hLssYbsJLkCYoT0FWChgKpW5vMB6ZYaShJdGpTmmQJM6pBE+ylw==
X-Received: by 2002:aa7:824e:0:b029:20a:3a1:eeda with SMTP id e14-20020aa7824e0000b029020a03a1eedamr4099110pfn.71.1618508280154;
        Thu, 15 Apr 2021 10:38:00 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9374:6e64:669f:465e])
        by smtp.gmail.com with ESMTPSA id b14sm2670444pft.211.2021.04.15.10.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 10:37:59 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH net-next] scm: optimize put_cmsg()
Date:   Thu, 15 Apr 2021 10:37:53 -0700
Message-Id: <20210415173753.3404237-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Calling two copy_to_user() for very small regions has very high overhead.

Switch to inlined unsafe_put_user() to save one stac/clac sequence,
and avoid copy_to_user().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/core/scm.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 8156d4fb8a3966122fdfcfd0ebc9e5520aa7b67c..bd96c922041d22a2f3b7ee73e4b3183316f9b616 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -228,14 +228,16 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 
 	if (msg->msg_control_is_user) {
 		struct cmsghdr __user *cm = msg->msg_control_user;
-		struct cmsghdr cmhdr;
 
-		cmhdr.cmsg_level = level;
-		cmhdr.cmsg_type = type;
-		cmhdr.cmsg_len = cmlen;
-		if (copy_to_user(cm, &cmhdr, sizeof cmhdr) ||
-		    copy_to_user(CMSG_USER_DATA(cm), data, cmlen - sizeof(*cm)))
-			return -EFAULT;
+		if (!user_write_access_begin(cm, cmlen))
+			goto efault;
+
+		unsafe_put_user(len, &cm->cmsg_len, efault_end);
+		unsafe_put_user(level, &cm->cmsg_level, efault_end);
+		unsafe_put_user(type, &cm->cmsg_type, efault_end);
+		unsafe_copy_to_user(CMSG_USER_DATA(cm), data,
+				    cmlen - sizeof(*cm), efault_end);
+		user_write_access_end();
 	} else {
 		struct cmsghdr *cm = msg->msg_control;
 
@@ -249,6 +251,11 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 	msg->msg_control += cmlen;
 	msg->msg_controllen -= cmlen;
 	return 0;
+
+efault_end:
+	user_write_access_end();
+efault:
+	return -EFAULT;
 }
 EXPORT_SYMBOL(put_cmsg);
 
-- 
2.31.1.368.gbe11c130af-goog

