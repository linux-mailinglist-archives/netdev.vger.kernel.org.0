Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8494A2C0D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 03:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfH3BIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 21:08:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36342 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfH3BIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 21:08:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so5249329wrd.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 18:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WHVrCruBU8Kf27dNfMmQo7QoXPT1RhffgPczwJJkz7c=;
        b=i271hOhIcCjAFKMVmcR7MVnoBN/rz8Ju5w7/z8qN26OEFpvyO+MVo0F4FMZ9Vx40bk
         oyYneFQmjljwyIwQUFxzGduP4NpRrLM9oNr1qXXWxe4XVXxyMYlKWQaShRfMivtjE0qg
         J1LXYjClZ4HUIvg/DZhH2H2dGG6z4PEDSvaTAfh5zNCsA1+KZmOj/xT+GH0qUUddeaq8
         JoQQzma2qm3TvxHE5s6tqEnlCmw7mHQstBOe24t4//Pt8laUiYZew6+ZSp1ZlurR7AO8
         zTw5SRQ1OOQcTZYYxCaHFMbKaH48Uqm39tkSgXI/86e7xy8fTKTvtqWaq+nLUU/JpyVT
         Xrkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WHVrCruBU8Kf27dNfMmQo7QoXPT1RhffgPczwJJkz7c=;
        b=XBV8fvgUTxiERTgPmod5b2WmgJFUn71+epG8uYBsa+pBYDFev8BxEf+J1BCM0+OLQm
         ALnBeS7s1RrlxOB6e29G1Tj3XChDf63/35Rd83hZjuWIQbRARfLqNphx/pmrGrBoxW22
         5yljHTOrTnyfkVIesK1F0sM6X++U7P9OZzAjCyh+KiPVEQG/bvzBq5uOXVmFwOixZJPu
         fJWYJeptaoAwgC8sGIJgWis4uvC3X9LZweeNxM20/WuckEe/Gof8KjRqqVK9l5AF6/B/
         jRrmuZj4bU8RUneKwPxYBO4psLtbIgag13izaNqxveYZpRgjOzDU6ZfqTOmTInvLjRdt
         IjvQ==
X-Gm-Message-State: APjAAAX23oyueP4cEzsKvKEmhDl2rU7hWxgSH9xG3TdB5Abn8RXFxhWK
        XuFumhG9thQsWxQ2qhZHTn4=
X-Google-Smtp-Source: APXvYqyuR2z2UN769K/jePsFd2zRSRQwlKTED9rST39P/gkly+iGXLr6dm6LDddXZ/sN8JEFYVpUlA==
X-Received: by 2002:adf:ba0c:: with SMTP id o12mr15720128wrg.284.1567127293027;
        Thu, 29 Aug 2019 18:08:13 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id f13sm2813317wrq.3.2019.08.29.18.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:08:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 1/3] taprio: Fix kernel panic in taprio_destroy
Date:   Fri, 30 Aug 2019 04:07:21 +0300
Message-Id: <20190830010723.32096-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830010723.32096-1-olteanv@gmail.com>
References: <20190830010723.32096-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio_init may fail earlier than this line:

	list_add(&q->taprio_list, &taprio_list);

i.e. due to the net device not being multi queue.

Attempting to remove q from the global taprio_list when it is not part
of it will result in a kernel panic.

Fix it by matching list_add and list_del better to one another in the
order of operations. This way we can keep the deletion unconditional
and with lower complexity - O(1).

Cc: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
Dropped the list iteration approach and just matched the addition better
with the removal.

 net/sched/sch_taprio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 540bde009ea5..72b5f8c1aef9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1245,6 +1245,10 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 */
 	q->clockid = -1;
 
+	spin_lock(&taprio_list_lock);
+	list_add(&q->taprio_list, &taprio_list);
+	spin_unlock(&taprio_list_lock);
+
 	if (sch->parent != TC_H_ROOT)
 		return -EOPNOTSUPP;
 
@@ -1262,10 +1266,6 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt)
 		return -EINVAL;
 
-	spin_lock(&taprio_list_lock);
-	list_add(&q->taprio_list, &taprio_list);
-	spin_unlock(&taprio_list_lock);
-
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct netdev_queue *dev_queue;
 		struct Qdisc *qdisc;
-- 
2.17.1

