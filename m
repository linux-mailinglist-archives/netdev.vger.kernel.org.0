Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6DCE0427
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388637AbfJVMs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:48:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38255 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388069AbfJVMs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 08:48:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id 3so16046528wmi.3;
        Tue, 22 Oct 2019 05:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=23IYWwe1m0SVry5goG0CA4ET3xRroYCt2o3+8zrmRrk=;
        b=Ijy+IiniksVNSBo3k6tJzqSUqKRRIOWhInLBe1JZaVRGznkvyh/TMFoYxkxBg0sqoQ
         OEZv1hJBsZ9W9FURJ2RabPnuQUHfuXBVlaLDWODLZYqjrowyPhZhAkYWUExy7ZzzLMGG
         yIZcWThD9NQ3yBV1d7E24jPkz2cxpNqup1dmrMxv4rYztu0f69Iox0a03n112NUMwKY2
         UXwOKCXkMFdqnfEmAhlDp46+pThsFXALi87sU8fcoPfe+GwnzFB6g6WFtJE0tBHkRmTI
         BaL1FNUGTuDCuoTsYxIPYJttyFvoEgmlLykT5Zzw7fKFVwFXlgKqMVPo9Nmkj8StDi1/
         HB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=23IYWwe1m0SVry5goG0CA4ET3xRroYCt2o3+8zrmRrk=;
        b=AX4Kjei6iZaO6gOvtTE+ntDtTZL5g7aj5PbUca96FLKsOUDVifqTgQ70TaWGJSpKz3
         gCMKOgxh78avZW/Qma5K1BFQGVoF2jQFWY6jLkOoWC2OxPGbzh+x+9WACn29G8RrYMTY
         XaotYk9CQRg/flZ4bX3Ygdu+Ao5BxjIVAVbBKUttzpMtuLxJ5KrdgTHdG00kS0Rv3Y23
         1ws+jBcxTT3p95f35Kljw0UmMETblowVlkS1NdXFT4H5MUe5uEJVGoIB261bf1woAQip
         Ca0hHt4W2E341u8m4DgTvwcpHdGTUkINuDCW1WgG1vpqy9RRmWAoASiay/5JoNQBCnNB
         gulQ==
X-Gm-Message-State: APjAAAVnc+eF4lggsxzol/NjKAgrASd56CDjFK3HevZaltzCh0CzDCUX
        pRinx4z5AYRnjzdYVH2154g=
X-Google-Smtp-Source: APXvYqyE8xIEMbD9Wn9Wgi32xcN/SlN8YbVuGASMCqg5/+H4LQ4QqE0GbCJBCSHIjtt4iuAphtoTrg==
X-Received: by 2002:a1c:9cc6:: with SMTP id f189mr3127839wme.80.1571748536125;
        Tue, 22 Oct 2019 05:48:56 -0700 (PDT)
Received: from VM-VPR.corporate.saft.org ([80.215.197.243])
        by smtp.gmail.com with ESMTPSA id p15sm18249508wrs.94.2019.10.22.05.48.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Oct 2019 05:48:55 -0700 (PDT)
From:   Vincent Prince <vincent.prince.fr@gmail.com>
To:     mkl@pengutronix.de
Cc:     dave.taht@gmail.com, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        Vincent Prince <vincent.prince.fr@gmail.com>
Subject: [PATCH] net: sch_generic: Use pfifo_fast as fallback scheduler for CAN hardware
Date:   Tue, 22 Oct 2019 14:47:28 +0200
Message-Id: <1571748448-11190-1-git-send-email-vincent.prince.fr@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190327165632.10711-1-mkl@pengutronix.de>
References: <20190327165632.10711-1-mkl@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vincent Prince <vincent.prince.fr@gmail.com>
---
 net/sched/sch_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 77b289d..bff43de 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1008,6 +1008,8 @@ static void attach_one_default_qdisc(struct net_device *dev,
 
 	if (dev->priv_flags & IFF_NO_QUEUE)
 		ops = &noqueue_qdisc_ops;
+        else if(dev->type == ARPHRD_CAN)
+		ops = &pfifo_fast_ops;
 
 	qdisc = qdisc_create_dflt(dev_queue, ops, TC_H_ROOT, NULL);
 	if (!qdisc) {
-- 
2.7.4

