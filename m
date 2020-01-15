Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D304513BE36
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgAOLMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:12:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36472 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgAOLL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:11:59 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so17381311wma.1
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 03:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qoF/LPy8hVWaublfZnT5/MtNhiAeny4VxqVA+5XC0NM=;
        b=IasC8cb4mBVNa5s/sA7OdTTWtd+WxHrwgqkMiQwzOB+Jy01rsiLiA/8FiqPfsH1ELX
         Xfbip8f5oUVBIk/BNaiwSbuHSfnc5peQRnC3Bk96aBxuazI+JHXzX+pqYAlMD+zRmVJ7
         SnGMjvsKOLLUiR1hu2MieUdPXLja/dqi9X68IeDUvwvztlPBX1X9+xz/UAMH7xQgSrJk
         YwO3sMpq+cH4LWlnzzUqtQ1F95vm6gx7kuMHqwqzT2Y8Z1pQK4bN7n3ilZKmdXeR1OLy
         nOAdj2eafAixeL4z5O3w+EI66dvUsgKeIAwHd7BwCyWGxPZ2QkO1cNlkp11ou7A//fFs
         PN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qoF/LPy8hVWaublfZnT5/MtNhiAeny4VxqVA+5XC0NM=;
        b=doHPQ5D0kKzv7a13xfpau6IRfjv92Bin73OgXCHJYyBlTO4eESxjWti3LFnLUEIQtb
         yR6Q6PwuaZJ4Jrf6oX9fnakeO1Zl76FkyH4YeQiFQJSlxM00advrXKGHIWhSjFa504hB
         sy42cDesSZyYOLK96wFAG7b6HBXk3kVVrZ/wqHwCgRvX8dVQ0QjLGWdTC23R2z2WcTWJ
         vhUAHgRHmkTV2voHglQG6t1RvuPWuFPbwevIz9nxVTcGP6ZPx1jjxFRpBdTaJowAAkLt
         E3UQ/wwC5G4rwQdDL+sKeg+VLcparfk6/X55ou9/8YyZ92rMhx7tkLOeDuVM8ZHlXoaI
         Ygzg==
X-Gm-Message-State: APjAAAVf919wSoP+LSRTU27NCBwF8DgPwrNW3qpqs+hiaAOg/IIpsobM
        LYqtbB1K9wFZedKW/xXH4JN7ZPPLxGQ4AQ==
X-Google-Smtp-Source: APXvYqzRvcvBhCFnSkRJOfIUFukabe3hVDgP6v9MhGGSAWH/B1T1tSjL+F6XryoX22JzpqFP6MKBPw==
X-Received: by 2002:a1c:e289:: with SMTP id z131mr31300205wmg.18.1579086717915;
        Wed, 15 Jan 2020 03:11:57 -0800 (PST)
Received: from gir.kopla.local ([87.130.86.114])
        by smtp.googlemail.com with ESMTPSA id v22sm22583032wml.11.2020.01.15.03.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 03:11:57 -0800 (PST)
From:   Ulrich Weber <ulrich.weber@gmail.com>
To:     steffen.klassert@secunet.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] xfrm: support output_mark for offload ESP packets
Date:   Wed, 15 Jan 2020 12:11:29 +0100
Message-Id: <20200115111128.8671-1-ulrich.weber@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200115095358.GQ8621@gauss3.secunet.de>
References: <20200115095358.GQ8621@gauss3.secunet.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9b42c1f179a6 ("xfrm: Extend the output_mark") added output_mark
support but missed ESP offload support.

xfrm_smark_get() is not called within xfrm_input() for packets coming
from esp4_gro_receive() or esp6_gro_receive(). Therefore call
xfrm_smark_get() directly within these functions.

Fixes: 9b42c1f179a6 ("xfrm: Extend the output_mark to support input direction and masking.")
Signed-off-by: Ulrich Weber <ulrich.weber@gmail.com>
---
 net/ipv4/esp4_offload.c | 2 ++
 net/ipv6/esp6_offload.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 0e4a7cf6bc87..e2e219c7854a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -57,6 +57,8 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		if (!x)
 			goto out_reset;
 
+		skb->mark = xfrm_smark_get(skb->mark, x);
+
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index e31626ffccd1..fd535053245b 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -79,6 +79,8 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		if (!x)
 			goto out_reset;
 
+		skb->mark = xfrm_smark_get(skb->mark, x);
+
 		sp->xvec[sp->len++] = x;
 		sp->olen++;
 
-- 
2.20.1

