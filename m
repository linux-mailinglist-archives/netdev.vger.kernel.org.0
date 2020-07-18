Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D872248F3
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 07:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgGRFTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 01:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgGRFTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 01:19:03 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB0BC0619D2;
        Fri, 17 Jul 2020 22:19:03 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p15so9027073ilh.13;
        Fri, 17 Jul 2020 22:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kHjOURK4DhiFr+8WdSKVhameGC2lcUCFfkIT+BIwwgU=;
        b=gcK8CL06wY2tNWr+KKELSMvOxlgr4rC7QHgJdD2X+vpa1mxZ359f7zLlNZ9rOMS9zg
         CmD6KRazy4RD5REmOGr2aWy9/yZd0lUsyiruIv13bWoNK3AG34LmljY3t/F+AdiG4nNU
         a9zhX0APo/dOj8oKITTs3incAnm+lZcmnhTh30/jE52USwn6naThShP6uZG1BgQ+Jkm5
         NNDf3kuLNd++Og+6VmBI/xF5OggidLa+SdbFqybVllXUUhvV5wa1DPRwYXpkmsKeIK68
         s010vwhnBXleNMKudUk8AmtEpBs4hXvvRwmM265O8dQrs1X2HXEpr0tHGevsLZWhkRIF
         LEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kHjOURK4DhiFr+8WdSKVhameGC2lcUCFfkIT+BIwwgU=;
        b=uZVmNX5eYrfllaavMv+V1eYNbi04U3C2tsEiQbj67ZuPDWBEtZt2b89AaLILU/gcZJ
         eqtPAO7/us2UNDxFGNFR38czWe/hMvVLVYVoxR9AJS4hIqX7x3cQqEl6cFbpMEtOGkft
         9woG00uJhRR+jzcpeLjlHn71jYOw9CEZ4Lz/cWW/+IUe8vnaA79l/4Gtf9zygp9WGg/a
         3KxQ1AKvsKjzcxZC+rklTUPS8ZXCLSMNb53fnaQGWlq3lz4rhnw8ldGPcEpJeGmHzulU
         6+hj8M4dcP96G6MO34XMeIToF7WWuhg7we6imolkSXW+oFpVs7NaAEtPCwZ7SMLqUrcf
         GPDw==
X-Gm-Message-State: AOAM531RnERoqozsLKqOrGzyIqW+KkewwlNapgbr/EBk9Z7/KoXimBfW
        EEAK1iGBiQ3BKOFlZxUplo0=
X-Google-Smtp-Source: ABdhPJwzKbSELbyxuteloc9VHi/Z0kyifVe1tzB6XQ+ws4XwVvQDvLRJc8IBohUqFQc85hWaKbZ0Yw==
X-Received: by 2002:a92:41d0:: with SMTP id o199mr13245377ila.205.1595049542477;
        Fri, 17 Jul 2020 22:19:02 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [160.94.145.20])
        by smtp.googlemail.com with ESMTPSA id a11sm5616559iow.26.2020.07.17.22.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 22:19:01 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] cxgb4: add missing release on skb in uld_send()
Date:   Sat, 18 Jul 2020 00:18:43 -0500
Message-Id: <20200718051845.10218-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of uld_send(), the skb is consumed on all
execution paths except one. Release skb when returning NET_XMIT_DROP.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 32a45dc51ed7..d8c37fd4b808 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2938,6 +2938,7 @@ static inline int uld_send(struct adapter *adap, struct sk_buff *skb,
 	txq_info = adap->sge.uld_txq_info[tx_uld_type];
 	if (unlikely(!txq_info)) {
 		WARN_ON(true);
+		consume_skb(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.17.1

