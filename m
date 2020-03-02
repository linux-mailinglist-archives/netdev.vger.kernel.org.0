Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F93E1757CE
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 10:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCBJ7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 04:59:13 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40861 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCBJ7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 04:59:12 -0500
Received: by mail-pg1-f196.google.com with SMTP id t24so5177029pgj.7
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 01:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AiSCSm0YKmAXxxcDYngamziAVb3vhFOed38o1iIg7ro=;
        b=AGG67msNbYQZYgPohwGDw1uDQlnewqsWyKa4cYs/2WbzMM8NUl+91jU4aX4cK4Oo5E
         UQyJaTW5TblvKVCc5oq4XuKBxXI+KZn9EuNf8VvBOMTxb7yHn5Rsg/KVpctDP1zlHkja
         dKHeDtuO2eVizNdZ7Ed5O/Xvm0S6q/GjMoDjSVTFqP0+MMO5A+PMJrHOsIbw/VY7H3r4
         ynDpx7xqerVMVxAFuRbIXcM5emtFECAEQFB6sspr+8V62a6NQSfoSn5yFhuBFwvOatYw
         dPWv/gzcwXFsJxRau0JRFQCtIUAkBuPN6RBOOy1qjxm95mzRD6vliP/QmHh3wJstn3dR
         1mAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AiSCSm0YKmAXxxcDYngamziAVb3vhFOed38o1iIg7ro=;
        b=N3NHb3z4IV1M9Q9V8Vc63G9R9JCAuYgKLBWrtKZ3x+C16CYDaZQJlbX0RouGOFxCX2
         U1e8j3Ws8gdlnCBBPW+6a0KtuvZ9XTJuFM1jcEBpStsTJbQ7Ag8RL5VW7SWAYFUBcZwG
         l+CkYdw/8nSQ1eZ3cIBlEdqG71hAAQdbPT7/vlyiusTsriOLGlBCGmlSqk93kp0rBpTg
         8PjW5eWrAWvSRoWjrxZruxJj4ZTM8zPWoHMmL5ETA3sou6ehJrx3qteGNtrIFfzgqwcP
         zXnCcnsbQvfi4+7C48hVDgY2g7p8gtmTyPwbnvuBIhKxUse7GKcW4CXmWSLDl43iEfFt
         HLeg==
X-Gm-Message-State: APjAAAXD/o0NqNCctX9nsn48//KdgD6c00yrmDQcJNGhOwHmZOdhiRjh
        y4HI4uc0ytPrBxRvWK97DASXjEVINZA=
X-Google-Smtp-Source: APXvYqzpEI2KNWe8LMQdGy1amA4+uthHxQl2hn4g1K/zSpgruFGh3PnqjCzAs21a4OqWu2XDH4w05w==
X-Received: by 2002:a63:a351:: with SMTP id v17mr18342865pgn.319.1583143151362;
        Mon, 02 Mar 2020 01:59:11 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z13sm20564307pge.29.2020.03.02.01.59.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Mar 2020 01:59:10 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 1/3] net: thunderx: Adjust CQE_RX drop levels for better performance
Date:   Mon,  2 Mar 2020 15:29:00 +0530
Message-Id: <1583143142-7958-2-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

With the current RX RED/DROP levels of 192/184 for CQE_RX, when
packet incoming rate is high, LLC is getting polluted resulting
in more cache misses and higher latency in packet processing. This
slows down the whole process and performance loss. Hence reduced
the levels to 224/216 (ie for a CQ size of 1024, Rx pkts will be
red dropped or dropped when unused CQE are less than 128/160 respectively)

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/cavium/thunder/nicvf_queues.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
index bc2427c..2460451 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
@@ -100,8 +100,8 @@
  * RED accepts pkt if unused CQE < 2304 & >= 2560
  * DROPs pkts if unused CQE < 2304
  */
-#define RQ_PASS_CQ_LVL         192ULL
-#define RQ_DROP_CQ_LVL         184ULL
+#define RQ_PASS_CQ_LVL         224ULL
+#define RQ_DROP_CQ_LVL         216ULL
 
 /* RED and Backpressure levels of RBDR for pkt reception
  * For RBDR, level is a measure of fullness i.e 0x0 means empty
-- 
2.7.4

