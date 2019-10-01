Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6671C37A4
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389133AbfJAOjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:39:10 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39252 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388932AbfJAOjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 10:39:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so11430333qki.6
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 07:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Yq2wftt2X+S/LjR697B2w5o4NIynHga4LSIVsTk7uQU=;
        b=E2rphrZaiB6jGAsoojWOALkRTkVNfcU6g/XtTRAAD2GJH358T5zaemmi/sK7/IpBw5
         IemUV2LwDiq5qXXC3V9wAcvt+QW5m3QQ5mXGEuoyCrnbNj1dn/uanmPbvbiMzWlUAZFo
         R/NQ644rqU9g00gIKgODYWp6fKov+15wgD8Fkvw4RO01efz5mnDO+HHlexSOOoIfkuB+
         63cogGCPMfhn1uRKFUJroenqMcSNvfzyhCpB9/rOSNGf0UvvR5+lF4TYYZ5kzWvj+MDD
         AOeKjKecvEu/PiE43ICpoXZ0ZFxiYE0a+H5eO4P8RPFXxKzjRjIoDleRYjFPCyFTwLZ2
         4JvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Yq2wftt2X+S/LjR697B2w5o4NIynHga4LSIVsTk7uQU=;
        b=Ql3/j4faxR+KS9hb/NVsu/189EB6aclu8xI+w0t1XTjU2DP5p3n2LBmO0dS6xmYfhD
         D9/2ckokAds9jU8efjt2k9y4VhvTziRvgGpi2HX/+vpR4/ZsXSMV4mrw/kolcIVUpD3E
         /RCTu2Q6kKYqAi5KgUKruoO04KmrffY59N4DG+egN38d4+LPBbeTIs/ASjgvoi4fT7zb
         ajEI+51oubryrUAWFz5Q0fF1W/I9zubO1mqHNu1db3PrutVKUqRxkCe9OOO+JLqIztQt
         msCqijamXozWk7Jl0aeVGirozdMjTwfEkep+Czi3wocqP+oOg03HrWKidnLadHQadEk0
         Kpvg==
X-Gm-Message-State: APjAAAX7TJ+X4IY9WHeTEfPbvTl/8i3ODUDLy+ySWWLxIcAQROWG6wOX
        KAaXCesnYohoq0d5kKO15AC/6GwqZSU=
X-Google-Smtp-Source: APXvYqwim5HYz84ilcVVsMUbHbKD3ijiKsMwGomyhTqhr59EzrSyUayEGi/b4MGyavxVD9shQ2Grxg==
X-Received: by 2002:a05:620a:12d5:: with SMTP id e21mr6411130qkl.152.1569940748823;
        Tue, 01 Oct 2019 07:39:08 -0700 (PDT)
Received: from ubuntu.default ([32.104.18.203])
        by smtp.gmail.com with ESMTPSA id 62sm8232542qki.130.2019.10.01.07.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 07:39:08 -0700 (PDT)
From:   jcfaracco@gmail.com
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] net: core: dev: replace state xoff flag comparison by netif_xmit_stopped method
Date:   Tue,  1 Oct 2019 11:39:04 -0300
Message-Id: <20191001143904.6549-1-jcfaracco@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julio Faracco <jcfaracco@gmail.com>

Function netif_schedule_queue() has a hardcoded comparison between queue
state and any xoff flag. This comparison does the same thing as method
netif_xmit_stopped(). In terms of code clarity, it is better. See other
methods like: generic_xdp_tx() and dev_direct_xmit().

Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
---
Resubmitted as a V2 because V1 was sent during net-next closed window.
This commit message and change have the same structure as V1.
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abaf..21a9c2987cbb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2771,7 +2771,7 @@ static struct dev_kfree_skb_cb *get_kfree_skb_cb(const struct sk_buff *skb)
 void netif_schedule_queue(struct netdev_queue *txq)
 {
 	rcu_read_lock();
-	if (!(txq->state & QUEUE_STATE_ANY_XOFF)) {
+	if (!netif_xmit_stopped(txq)) {
 		struct Qdisc *q = rcu_dereference(txq->qdisc);
 
 		__netif_schedule(q);
-- 
2.17.1

