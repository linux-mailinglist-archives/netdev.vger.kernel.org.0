Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E311D15BB4D
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgBMJOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:14:52 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39164 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729637AbgBMJOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 04:14:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so2101127plp.6
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 01:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3B2WVvkuAA9A6bwYgb8u2nBzsvuVPQHZafhOD4bZX4A=;
        b=difkvvXIqPLjHVlUb8Sl1R3LEnTQF9AxuER7YiQ8LdqdpaS1IfPhNFBddZlHkViHqM
         pt0Jc6koDTYj9x1cKmQgs7rRH5OCM5fuAcZ1usyQoV3ktpOPjzxabK5SGl4De3Wq/p31
         /xF2B4eq95O1rFysOb1NjE/VBmUrqYMRKwk4psc5athjHRtlXYd5eA1MR+ix/QIWoHtA
         V9KYqzzu4Db4mKh2XmRcAxn1aKrb0MdItlVlnAYl0cdtb7BrCQCh0xp36suFFASDEXUi
         4Di03LalY+qJxb74SfcApCV6iRD9cK2jne9EXLkFpJL4H2pqMjuKKYOc5Po5mhHbR2jz
         BF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3B2WVvkuAA9A6bwYgb8u2nBzsvuVPQHZafhOD4bZX4A=;
        b=Ugv+05xKptsuCaN64g23SGxXgBwwe9Q8uqYjB4EQ3Cg3l5uNp0E4uvkanYvBbCaMR+
         OMMg1VeEz5naNSoyhOzsxumn5DkDiECQhRZyVT7rafSIJMxOYSxFaSR50xlFqgPvFJ9x
         5QPG+dE8Xa/Bc/0fQ2bpQcYGxPSEYoY8qeK3IlBfQWc2B211UpFLsB1z0ISjCkXU6fXC
         HJTAE2vejPpw8CMDv1D/LO8j3JXNTLbxhSFgDDbleFn3eTsw5Jz0oCT9AiHLC4U7ovE3
         KcVT+7wjRlRjBiL3BcyPaYhCBuU9pDNYv7iYmhBfde+qFGX5hHno/UpT37sTYmgvNxXn
         R9fQ==
X-Gm-Message-State: APjAAAW8zOCCIbhQUxi/robzOUnMikxWZH54D3LYeUxRPgVCoW8E1lMi
        5m6ZJbA9i16RndkY0ByvdEaT
X-Google-Smtp-Source: APXvYqwdYHQFYGY2OpbEyxFS+D//8KHJ/NOIMk7Imb1dWdDbbx+JR0qJtCjne6j/WZ04ib8I7t+jHQ==
X-Received: by 2002:a17:90a:c691:: with SMTP id n17mr4022465pjt.41.1581585290331;
        Thu, 13 Feb 2020 01:14:50 -0800 (PST)
Received: from localhost.localdomain ([103.59.133.81])
        by smtp.googlemail.com with ESMTPSA id s206sm2294391pfs.100.2020.02.13.01.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 01:14:49 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 2/2] net: qrtr: Fix the local node ID as 1
Date:   Thu, 13 Feb 2020 14:44:27 +0530
Message-Id: <20200213091427.13435-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
References: <20200213091427.13435-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to start the QRTR nameservice, the local node ID needs to be
valid. Hence, fix it to 1. Previously, the node ID was configured through
a userspace tool before starting the nameservice daemon. Since we have now
integrated the nameservice handling to kernel, this change is necessary
for making it functional.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/qrtr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index e97d20640de3..03616b9f4724 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -7,7 +7,6 @@
 #include <linux/netlink.h>
 #include <linux/qrtr.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
-#include <linux/numa.h>
 #include <linux/workqueue.h>
 
 #include <net/sock.h>
@@ -95,7 +94,7 @@ static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
 	return container_of(sk, struct qrtr_sock, sk);
 }
 
-static unsigned int qrtr_local_nid = NUMA_NO_NODE;
+static unsigned int qrtr_local_nid = 1;
 
 /* for node ids */
 static RADIX_TREE(qrtr_nodes, GFP_KERNEL);
-- 
2.17.1

