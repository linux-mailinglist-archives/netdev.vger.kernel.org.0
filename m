Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94269E04E3
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 15:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389219AbfJVNXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 09:23:37 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51082 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfJVNXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 09:23:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id q13so7212155wmj.0;
        Tue, 22 Oct 2019 06:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WgH62l/c3MCTBfxpxgUUbskdkglU+QiQR9hRmxDImxc=;
        b=tpdhGr2Y59n+NK9oDAnGC27VK26gVKRcmx5hgUurq4Tg/tfe88BdUTNdDVXMZ2GvnJ
         jouqGuQbRxXgkJDWRTFtntoQU8tK6rtyIEOtZLZkt+fdGwvkv5c9b0gECZySm1P1IV6/
         s8ffL6sbstTfeLoYV8pt91dyhk+aNzOfdJO8aHueZvgxr05WseCgueZOQGirjw8A7GjY
         uucvwzAjM9tFc4DYivCnD8WEuvZM65h2JhvF24rtHgCu40z35zolp6BeZqpyQ/d2L+J+
         P29u9kbsbZGdAeJAb1GsMI/NXDjUrBnJj9MwxLj1vw569GZ+gr1Lm8+OAyS2pqncxBDe
         /fmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WgH62l/c3MCTBfxpxgUUbskdkglU+QiQR9hRmxDImxc=;
        b=GRDCCs8kC1OOwR5K9vo0PmS0z9jr2k2Ci5FCw1iVNwmZXaTBv/ifoZ1xmis2JWHtRd
         +lDuNNA6PU+aoYlEsoxtprw2namlLgYdMvX4B3TDt3U6dcdu0GNfWhQMXcnfm/vsGgv1
         E8FdbjDxOrrCyjFtI7nGBqh3C2wXa0tomVlSMiwo6mdM17Sh7xogkjIa2xPo6MxP9r2p
         vzigPIJbaLTtaEhazBbL8u/TCMbBqIYxDaPFD9Yn2cXud3uT7YTWN+CmlYBNmIXUNiim
         aornSFNclMIEUzpiCjGnFhxZTFqJBWzpyTLoyTxPU10cncw3Wq1F4F67gV7DgIa//Cxj
         MVFg==
X-Gm-Message-State: APjAAAXj3QPka0e9oLYfotdaQdOfCtCz+n+fVhOFVCb8FNgvO1z+54hi
        XDKTYxh64v1aXKaRKkmerYc=
X-Google-Smtp-Source: APXvYqxmEh1MPOpFWacsLY0FDR176Q8lS+8MLKlZ6K6ret01j1MCeHSB2KR5CnvE+hn5o8rw7qP/Pg==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr2963177wmj.91.1571750615169;
        Tue, 22 Oct 2019 06:23:35 -0700 (PDT)
Received: from VM-VPR.corporate.saft.org ([80.215.197.243])
        by smtp.gmail.com with ESMTPSA id g11sm17786916wmh.45.2019.10.22.06.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Oct 2019 06:23:34 -0700 (PDT)
From:   Vincent Prince <vincent.prince.fr@gmail.com>
To:     mkl@pengutronix.de
Cc:     dave.taht@gmail.com, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        Vincent Prince <vincent.prince.fr@gmail.com>
Subject: [PATCH v2] net: sch_generic: Use pfifo_fast as fallback scheduler for CAN hardware
Date:   Tue, 22 Oct 2019 15:23:17 +0200
Message-Id: <1571750597-14030-1-git-send-email-vincent.prince.fr@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190327165632.10711-1-mkl@pengutronix.de>
References: <20190327165632.10711-1-mkl@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vincent Prince <vincent.prince.fr@gmail.com>
---
Changes in v2:
 - reformat patch

 net/sched/sch_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 77b289d..dfb2982 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1008,6 +1008,8 @@ static void attach_one_default_qdisc(struct net_device *dev,
 
 	if (dev->priv_flags & IFF_NO_QUEUE)
 		ops = &noqueue_qdisc_ops;
+	else if(dev->type == ARPHRD_CAN)
+		ops = &pfifo_fast_ops;
 
 	qdisc = qdisc_create_dflt(dev_queue, ops, TC_H_ROOT, NULL);
 	if (!qdisc) {
-- 
2.7.4

