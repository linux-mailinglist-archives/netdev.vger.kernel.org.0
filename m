Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44B532E5EA
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 11:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEKOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 05:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCEKN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 05:13:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0481C061574;
        Fri,  5 Mar 2021 02:13:58 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id bj7so1689930pjb.2;
        Fri, 05 Mar 2021 02:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wSrhAkuioRfi2byGRmhfZaxog1DTberVqOCug0qyBSM=;
        b=etoRr5iN4X9QoGJ6fZX7ml2TdcptAVhelRK0OWZ14r95G+svszfR8AhWYWp1X5YOsZ
         RZwT3GP2ckGE1U54l2SdqBariVkhq0R6QX6XSETBJaFsSh/4uh/pGckEkq3p2s6yIWly
         ofgaA40/IQs815NzpdaMqpPNFs8FfGpKgBMyPCipXi1dhe775NuUWnPrFMbdUJd8zSFA
         Jht9TVeh5LooGGjEBml54BMw1iamXCMrNcZuf9PEHIbzq+0zTqhr9x+fAKqFpLKQt/K1
         f/tzd+kxbH2XAoFbPDRljGzlkGhrQ1tjSvh7k9MlbkSJd5UWaejxXKe3asVZGkcRLZQp
         C8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wSrhAkuioRfi2byGRmhfZaxog1DTberVqOCug0qyBSM=;
        b=ubfp7QWpa1/6UCWK+q+iDp9HDf66dlGCMpIov4RAcEMwHJ5Y+1blYXtJmShRyMnMs8
         5O/9vO/u1AakBtenk7eVUfEqqOoE6z6psU+TAUfkh6CvKOT9siiGPNo3VlOMvIJ0YJtI
         Y4WKza7ZAtwt1X+kSnQciywIakS+n17f/Cp+Jhw1YH9VWMiX+PWX2UEMa3oCe346eUS5
         OoC3NttS3TJvMIY/vQfgAVMTpRV5aL5NxEcrG7EVr8kZBgbGu58+numLRLmrCHlx7pYQ
         TvLaGPEJRiLTDYR7qQHHwn5IEOC8TyEs7pGmPMV6hwVX4KV7WF9G8zG/QydG7Iza8WK5
         y7lw==
X-Gm-Message-State: AOAM531oWe8p42hbZUsTyxwEcvIBzeS9zNoWKuVOL7hlnk7c5DWTukgO
        lKVIkoKK7NmZFBPSHNGetuc=
X-Google-Smtp-Source: ABdhPJw3jtSUflSP8MnmdGWv1kZjOAqwQMsrfnkxygxl4N1ofx/erzRnCiNEfneK8Ld9qgObQ88ENw==
X-Received: by 2002:a17:902:6bca:b029:e2:c5d6:973e with SMTP id m10-20020a1709026bcab02900e2c5d6973emr8136154plt.40.1614939238498;
        Fri, 05 Mar 2021 02:13:58 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id y9sm2074675pgc.9.2021.03.05.02.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 02:13:57 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: smc: fix error return code of smc_diag_dump_proto()
Date:   Fri,  5 Mar 2021 02:13:51 -0800
Message-Id: <20210305101351.14683-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the list of head is empty, no error return code of
smc_diag_dump_proto() is assigned.
To fix this bug, rc is assigned with -ENOENT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/smc/smc_diag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index c952986a6aca..a90889482842 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -201,8 +201,10 @@ static int smc_diag_dump_proto(struct proto *prot, struct sk_buff *skb,
 
 	read_lock(&prot->h.smc_hash->lock);
 	head = &prot->h.smc_hash->ht;
-	if (hlist_empty(head))
+	if (hlist_empty(head)) {
+		rc = -ENOENT;
 		goto out;
+	}
 
 	sk_for_each(sk, head) {
 		if (!net_eq(sock_net(sk), net))
-- 
2.17.1

