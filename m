Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51BBCE1844
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404446AbfJWKwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:52:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52379 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390566AbfJWKwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:52:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so20706787wmh.2;
        Wed, 23 Oct 2019 03:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+i1c7z/vrQkTB+2yIcwqOcwIXxSz3gP95Leb8EuF86o=;
        b=nVIVOcWX+X/egZal8mSWnoQ08UC0P+Vm7Sh51vcDrw3IEF2+2Cs9bCiGtoQZ1MeSM2
         pEZP7CBrlu5OXc5BsYmfF0J6ou921SInevWNcWDrRnFQeXMe3FCi+fMdTubs/g/ad/JS
         gyOizrOeAs9eyO3UqYgk5evhHKNPjNUhcNkHrzdLRROQZ8efJYdnTMuc15BGIiFZN5N0
         GvYUf2ezPdP32EL767P6HACchFxGFzp4Swe/i9QrfYW/FD3KALceoi1clabNF9SXFaFl
         7vO56nqicz3GlaUU/ZRJOiWSZYUj+WLzY73qIHZX9ad56wt4GkszkK5LIx/6CxpdF3sB
         +I9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+i1c7z/vrQkTB+2yIcwqOcwIXxSz3gP95Leb8EuF86o=;
        b=jBWUprAWTAIlvR1t6hLuxGvZ+2xXuo4hC+2k9yVp1j0R5q+9wzAG741jFVM5B+RoHP
         I0/OE1qfTNqYCElLcQD/h/0cfcH/v0g66YvyZlDolBMiP7W+jfUirx0EdqZg9xmHnhoz
         xrAKJ4b6/h6P+eFGKkMHg1c1+xgDxUKJcPjSX33EJc+DcWS3WZhq6lcXk63gsgEO5nP0
         idHxUoOBYUvfVQTLhOlTsvcsuclEB5PqQVhAxTGELnJzrrZHr1Kxmqga53Rv9gbtAZg2
         urchXqjAydRrpHuiA3VoNsySuAngQ02EmPb9q7DQ/x/MRP81A3u9ZmgOFzDneIyiznca
         T98Q==
X-Gm-Message-State: APjAAAU/bpPLM+Hmu1XgHMPG1vH0omHcsvFpjkv3oB/ObdWDgRtmA60z
        r3cGFCws5YKiFDAstQT5iMg=
X-Google-Smtp-Source: APXvYqxF4jxwjd99RwNkgbX3vx0Ih0xjymBplxPaMsoe/BwE5pju2gtoJdmmdtsvKXYcd9mhg7wqSg==
X-Received: by 2002:a1c:410a:: with SMTP id o10mr7280835wma.117.1571827931585;
        Wed, 23 Oct 2019 03:52:11 -0700 (PDT)
Received: from VM-VPR.corporate.saft.org ([80.215.206.132])
        by smtp.gmail.com with ESMTPSA id 143sm35148526wmb.33.2019.10.23.03.52.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 03:52:11 -0700 (PDT)
From:   Vincent Prince <vincent.prince.fr@gmail.com>
To:     mkl@pengutronix.de
Cc:     dave.taht@gmail.com, davem@davemloft.net, jhs@mojatatu.com,
        jiri@resnulli.us, kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        Vincent Prince <vincent.prince.fr@gmail.com>
Subject: [PATCH v4] net: sch_generic: Use pfifo_fast as fallback scheduler for CAN hardware
Date:   Wed, 23 Oct 2019 12:52:00 +0200
Message-Id: <1571827920-9024-1-git-send-email-vincent.prince.fr@gmail.com>
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

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Vincent Prince <vincent.prince.fr@gmail.com>
---
Changes in v4: 
 - add Marc credit to commit log
 
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

