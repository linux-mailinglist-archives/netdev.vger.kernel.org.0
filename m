Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF6E070E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 17:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732118AbfJVPJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 11:09:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40878 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731453AbfJVPJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 11:09:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so16505882wmj.5;
        Tue, 22 Oct 2019 08:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JbHOlykCEqNn0kxc0i+cvgM5oVhh+P5JsXT8fXKGZ8k=;
        b=koaA5MDEJ+V5rHjAyn6mUqlN6DVao8xENHmBDlx1bTRGSiVUfrUp+8pvMYpR1EH4Po
         ZY67Oyq7dhk0wWIA9+gM6D9ZxEI0om7bQZMXs99aRDjFYuArWpyyKokNGKgQQ3Rh5IEi
         tJgOtD7Ie+n0OCuZZfcB6QrO6uinigdjHXDOY/0InAS/DzMJPBZGpMB0DbncndfFk1+l
         jZKtOSdc+0hWTMHwVpPIx8WVB2LkhU6JY1chk6kct+izG7a6TPHfvqnELLlFezwKUZFb
         b5Wc8aK1iazX3JkCrzbII5YOQzUqEB4zTkyRuONGmfR4zfHepOc+/UfaCbLUeK+ReXRF
         RWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JbHOlykCEqNn0kxc0i+cvgM5oVhh+P5JsXT8fXKGZ8k=;
        b=PINvaaPrR5fuYIhuc+KaHVbUiRJO++YnAxBRuq7pRz9PNl1PrzESNN+54fHf7iz+Yz
         t6I0+BQgzA5CBX1PkMyATXmCTzq8zlp19b7giX1/U22krxdNfmiP+sxQBP4y7U5uN30X
         80KNDlEKaLWN3us36fR35/NN1er6IxBsPw8LsFO6rb5eORX6SFGDlwsc3EAbILv7epxC
         ZmKeyGMxvlgmrBVU7NGcHJb2IFL4Lqp6b6HY7A1MuIgcAfmAI7Wk8PtexQGl78fHpydK
         NJqRnreWkHhzwbwt5O3AlD7gSbhE7xM1lElbiuysvwJOw73Pvytg1GhmlyYexasp2yRm
         c2YA==
X-Gm-Message-State: APjAAAWRwdd5Auqha+Xs0ErymsIlGfn9RVYdbKok33vCkK5Hhj/KTeH2
        GApAaASsMaZJx1fRBr95SPo=
X-Google-Smtp-Source: APXvYqycpcjxt0Vhtf26R74XKM40rycbGF4GBlV2OV/+YPrUW0ExQ/A0j5CDN0SmAqV0T5N0ugzZ2w==
X-Received: by 2002:a7b:cd89:: with SMTP id y9mr3709184wmj.51.1571756995033;
        Tue, 22 Oct 2019 08:09:55 -0700 (PDT)
Received: from VM-VPR.corporate.saft.org ([80.215.197.243])
        by smtp.gmail.com with ESMTPSA id n17sm6934802wrt.25.2019.10.22.08.09.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 22 Oct 2019 08:09:54 -0700 (PDT)
From:   Vincent Prince <vincent.prince.fr@gmail.com>
To:     mkl@pengutronix.de
Cc:     dave.taht@gmail.com, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        Vincent Prince <vincent.prince.fr@gmail.com>
Subject: [PATCH v3] net: sch_generic: Use pfifo_fast as fallback scheduler for CAN hardware
Date:   Tue, 22 Oct 2019 17:09:50 +0200
Message-Id: <1571756990-19611-1-git-send-email-vincent.prince.fr@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190327165632.10711-1-mkl@pengutronix.de>
References: <20190327165632.10711-1-mkl@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is networking hardware that isn't based on Ethernet for layers 1 and 2.

For example CAN.

CAN is a multi-master serial bus standard for connecting Electronic Control
Units [ECUs] also known as nodes. A frame on the CAN bus carries up to 8 bytes
of payload. Frame corruption is detected by a CRC. However frame loss due to
corruption is possible, but a quite unusual phenomenon.

While fq_codel works great for TCP/IP, it doesn't for CAN. There are a lot of
legacy protocols on top of CAN, which are not build with flow control or high
CAN frame drop rates in mind.

When using fq_codel, as soon as the queue reaches a certain delay based length,
skbs from the head of the queue are silently dropped. Silently meaning that the
user space using a send() or similar syscall doesn't get an error. However
TCP's flow control algorithm will detect dropped packages and adjust the
bandwidth accordingly.

When using fq_codel and sending raw frames over CAN, which is the common use
case, the user space thinks the package has been sent without problems, because
send() returned without an error. pfifo_fast will drop skbs, if the queue
length exceeds the maximum. But with this scheduler the skbs at the tail are
dropped, an error (-ENOBUFS) is propagated to user space. So that the user
space can slow down the package generation.

On distributions, where fq_codel is made default via CONFIG_DEFAULT_NET_SCH
during compile time, or set default during runtime with sysctl
net.core.default_qdisc (see [1]), we get a bad user experience. In my test case
with pfifo_fast, I can transfer thousands of million CAN frames without a frame
drop. On the other hand with fq_codel there is more then one lost CAN frame per
thousand frames.

As pointed out fq_codel is not suited for CAN hardware, so this patch changes
attach_one_default_qdisc() to use pfifo_fast for "ARPHRD_CAN" network devices.

During transition of a netdev from down to up state the default queuing
discipline is attached by attach_default_qdiscs() with the help of
attach_one_default_qdisc(). This patch modifies attach_one_default_qdisc() to
attach the pfifo_fast (pfifo_fast_ops) if the network device type is
"ARPHRD_CAN".

[1] https://github.com/systemd/systemd/issues/9194

Signed-off-by: Vincent Prince <vincent.prince.fr@gmail.com>
---
Changes in v3:
 - add description

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

