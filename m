Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF2813AB1D
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgANN36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:29:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45383 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgANN36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 08:29:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so12132856wrj.12
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 05:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3oj/IqMeX6nnkmtW/taAGUBL7NjhUgVcP1J7GmLSdiU=;
        b=q+Zf5ugJx/KGtdkB5D8HJB1Ewk+1NVZSTpxZlbVXdSvV0848G4VQFSyY2w1fP8PF43
         2R+t3YwlS2IO1mFNUvFCrd+kyftI8OTHdcUeFshXXAvGKBVdUYZAtr1xtzhxuqTI3YnJ
         srx5saWKDoSqawVTFOIgjgB/zOZhxormg+6j3/Lvy9ai/9tJjyl0ApoXzPkqLwZ8mFkZ
         JChfJrq0xpT1NHkExV1cpnoPGGM8Begy9KaiK3Bi3npfc+hxpirWttjLnkrXRR/ix/jO
         S3RHztVwKD0fVQCFl651XB6l7fkMNdPwbZNKClKlvnYV0j7r+seBXVzS7wldLINhYpyu
         wu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3oj/IqMeX6nnkmtW/taAGUBL7NjhUgVcP1J7GmLSdiU=;
        b=mPnEs0d92j+628ToLTam3s7Bo/JAwRilUUooXQpNaQDvO7/zJlutiY/3q5lMqlZOHo
         O8NWdulyRpP/4FAFnyjl1Y4xs/QzxziiSzYuXpnLrvgD050jVB1ZR6OOZoArOihC6/VE
         6jN2G8ORBbFidxt3DlPq2SAP3dSXSTxb/FvAovWNUi9Bu+iiw+U3ViouGrE69Wg/Up2v
         yIjhXEFUmswR478BeUcL0yQWZ4zMLGDXCJ89029MePY2dz0Cn3t0VjojYIN68KjkwO/j
         tGE9eFUctsiN0dfezYOu85/MB0Vr/Cv/QiK2u5vBaJow12eALOevdo1/VqArVUmBZM8X
         aL9w==
X-Gm-Message-State: APjAAAVCj3t7t6pC6izZMqeQHYjtEyUzkNdx4W6iUcRyBnSEnce445Wr
        U1Fqu0AATnPGuP4BWZy1kAtGAMk4QBhyUQ==
X-Google-Smtp-Source: APXvYqysH2hpCxM01CFzYCmdGgPURSXoaBuSzgI2hJsuysl3326BP3rClmPYX1DhTH2o6U1w79RkRg==
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr25023506wrq.43.1579008596117;
        Tue, 14 Jan 2020 05:29:56 -0800 (PST)
Received: from gir.kopla.local ([87.130.86.114])
        by smtp.googlemail.com with ESMTPSA id b67sm19564398wmc.38.2020.01.14.05.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:29:55 -0800 (PST)
From:   Ulrich Weber <ulrich.weber@gmail.com>
To:     steffen.klassert@secunet.com
Cc:     netdev@vger.kernel.org, Ulrich Weber <ulrich.weber@gmail.com>
Subject: [PATCH] xfrm: support output_mark for offload ESP packets
Date:   Tue, 14 Jan 2020 14:29:54 +0100
Message-Id: <20200114132954.6373-1-ulrich.weber@gmail.com>
X-Mailer: git-send-email 2.20.1
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

