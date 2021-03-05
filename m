Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A2532E4BF
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhCEJ0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhCEJZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 04:25:48 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB38C061574;
        Fri,  5 Mar 2021 01:25:48 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id a24so1093132plm.11;
        Fri, 05 Mar 2021 01:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3ZtfAy/DdB98MHPeY8FKZbpkecSyZ6GcXxZiHDxXOzY=;
        b=gr7gqnyAoiRC+O5mo0KISftXCzLIrwlN0RDSw7BtZmpr9MRyG+yaPi0nb0e6PkVohL
         NIfeZJTybWLcpEde2TiplP2s/iFBPC6sL+V0gkz4aba7D5buJbqP7WTu6UWz4/eK231F
         d30yJPb0Mz8/4AY+BAd7nSiRcNPha0O6vtgCi62qf42TI69oP1QXcwN7zhiDFvS5idoN
         7u6t3FNwt6A45HJrgAL+qXZFNiKTbeJxcvWn7RXbq8izZykUYDHV6Cm7uEreY3oZlN/C
         wbv2JX9tYXeWlg1bgVQpcJui2ExeEObKfwCWhzxFhIzW3PE8PG1lkbAUp/8UuAm/C3EC
         OpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3ZtfAy/DdB98MHPeY8FKZbpkecSyZ6GcXxZiHDxXOzY=;
        b=aQ8ZST2rsi3JBtNo76+qTycbb4HJW5WmwuCKjuzCsN/F4Tt55iqBo2SQFypZj6buHE
         gUoWxb5w2am+LFme1te04dYeaabfQmyPBqupK7AXx8gooFXMQ4Beg5AoV5b8Rl+mftd1
         RW11Ox4hF51GcIwfll7qWQpNqP4YWbaDlHWPHHgIWyQe9mZpk4GZ/5jEKI3Wfz02BrsF
         u/Pygyqtha/9KsF6bfW/DpfZbs+w5ahY08MUGzYXVhsA3baWiwdMRqn5sZ0skA7CpgrH
         Zjx+AjUR7VjMtfIKR3hWMH8fUTJ3TgNJVT476ijPRV7FVA/VNEvVzUkmlggGe/yBq8rR
         qbCg==
X-Gm-Message-State: AOAM530B+MzievsbpI+7U4RKgvGs2/hHlzM4yX/ZUJlQ1zUkwRnS4l07
        TO239DhuhOrv03T+2Cf7C28=
X-Google-Smtp-Source: ABdhPJzosWmE06mD7ZTcBU30UPBFyRlz0CWudMs7cisEtmu1jiqKZVAdFGHf258Qm1z+E/g6+DOlFw==
X-Received: by 2002:a17:902:6b85:b029:e5:b91c:a265 with SMTP id p5-20020a1709026b85b02900e5b91ca265mr7961423plk.63.1614936347695;
        Fri, 05 Mar 2021 01:25:47 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id ml17sm1956495pjb.18.2021.03.05.01.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:25:46 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: xdp: fix error return code of xsk_generic_xmit()
Date:   Fri,  5 Mar 2021 01:25:34 -0800
Message-Id: <20210305092534.13121-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When err is zero but xskq_prod_reserve() fails, no error return code of
xsk_generic_xmit() is assigned.
To fix this bug, err is assigned with the return value of
xskq_prod_reserve(), and then err is checked.
The spinlock is only used to protect the call to xskq_prod_reserve().

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/xdp/xsk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 4faabd1ecfd1..f1c1db07dd07 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -484,8 +484,14 @@ static int xsk_generic_xmit(struct sock *sk)
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
+		if (unlikely(err)) {
+			kfree_skb(skb);
+			goto out;
+		}
+
 		spin_lock_irqsave(&xs->pool->cq_lock, flags);
-		if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
+		err = xskq_prod_reserve(xs->pool->cq);
+		if (unlikely(err)) {
 			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 			kfree_skb(skb);
 			goto out;
-- 
2.17.1

