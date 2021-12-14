Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DFE4741BD
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 12:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhLNLo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 06:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhLNLoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 06:44:55 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F7CC061574;
        Tue, 14 Dec 2021 03:44:55 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id 8so18052740qtx.5;
        Tue, 14 Dec 2021 03:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/WiGVwXD5szJpXekvLi+rIYbV6iDlKwEbmIuA9qTTxI=;
        b=GTMy6m1uKE/Eu0kGasr5n9WaFtjJAnHIES4JWiDkpkGjJWF1a87bQftjj5DLtdr4YX
         +pFBmBAhDLXbdVmZF9nJ8S8gs+6nPecI6+d7qb+qtBgRq+dmRVLx+7c2AJ+Mzp4UqTtp
         eIwOL8Sin+37oB99VYIYTYmGYltJGbeMCsjQx58qTp5Z9l435FD1IgfbNWiC12flCtoz
         iy8te2/GfNV4oQ/XtG+aBtY3+lPeDfk4ooR5VnBgnpkBABejmXzyh58beXbZlWhPR3bk
         UWvJkf890b+HIo7ogZEVTDiUtHyxe9KZM4316YZH9jOcILc8/q1ysvWtLqHd/VtRbwdh
         gcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/WiGVwXD5szJpXekvLi+rIYbV6iDlKwEbmIuA9qTTxI=;
        b=D3d+MCHCCTELJ/mQePM3NqiSaDUxiyhiSabNh4AQArWkXfY2iYWR9Paks62RT6ISVv
         E+PbyO3VgI6+h7ihSHDtxqbUE1ZaMeFY9wgti+sMEB/IsjMsECpHDJtOnFmuDdx9bnqI
         VMo4e8ctY+o/P6WRTTj0WqkydoEPpADEsmYPxWQ2nTTN5affrBpMyb2OAt/jAalJtt0q
         GuAqZk5rHxueKfY0bcFsvzgW+Hnceb0+2Fg3ktF4C41GHqw6gQArsXsU0SNAUQuK00iQ
         eM8/JNPZXXXZv8feE277OeRWK1Sf/ABxjSubPvLhSxbEGceDMDng/LEPuCaxVL1Fl+Hv
         Q3Lg==
X-Gm-Message-State: AOAM533fytV7VJgX1C7gVC+o2r3gpni2kT5AyO6xwna2vyMc99r6kTxu
        UaH4yIny7mSMJDNT36c5j10=
X-Google-Smtp-Source: ABdhPJzWVwOd87044dfW6ELeRVhrc9UnuAQSqzkdnDsQ6rNe+39K3w9DVsC5AtgSj4aqgLhSh7WCwA==
X-Received: by 2002:ac8:7f06:: with SMTP id f6mr5325214qtk.258.1639482294417;
        Tue, 14 Dec 2021 03:44:54 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id c8sm7225022qkp.8.2021.12.14.03.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 03:44:54 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, richardsonnick@google.com, edumazet@google.com,
        zhudi21@huawei.com, songmuchun@bytedance.com,
        yejune.deng@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] pktgen: use min() to make code cleaner
Date:   Tue, 14 Dec 2021 11:44:47 +0000
Message-Id: <20211214114447.439632-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Use min() in order to make code cleaner. Issue found by coccinelle.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 net/core/pktgen.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 84b62cd7bc57..7a0b07a22692 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2778,8 +2778,7 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 		}
 
 		i = 0;
-		frag_len = (datalen/frags) < PAGE_SIZE ?
-			   (datalen/frags) : PAGE_SIZE;
+		frag_len = min(datalen / frags, PAGE_SIZE);
 		while (datalen > 0) {
 			if (unlikely(!pkt_dev->page)) {
 				int node = numa_node_id();
@@ -2796,7 +2795,7 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 			/*last fragment, fill rest of data*/
 			if (i == (frags - 1))
 				skb_frag_size_set(&skb_shinfo(skb)->frags[i],
-				    (datalen < PAGE_SIZE ? datalen : PAGE_SIZE));
+				    min(datalen, PAGE_SIZE));
 			else
 				skb_frag_size_set(&skb_shinfo(skb)->frags[i], frag_len);
 			datalen -= skb_frag_size(&skb_shinfo(skb)->frags[i]);
-- 
2.25.1

