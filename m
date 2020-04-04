Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F4119E610
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 17:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgDDPXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 11:23:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42321 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgDDPXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 11:23:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id b10so3442194qtt.9
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 08:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA+ZAN62gafgo5KTsYprZktBzSw40NV5j8/VYA/ERYQ=;
        b=tk8iZrigpI0EsENrI5mTDb6dq/fYSGWihYNjO71zWBDSN0g08rGR37Tp4WYoxfzY+k
         7reveG0ERgj8VqCygwTrUsGw/3B8PXLnvpgu3wn2R50jxyFHbJuknX2nMSOFSVbq5ztZ
         uorrukBpvSXnsbTs53eLTgdH+C3cEu+bO2wcklzP+XcqCG58hC/NmW7onnS5WIzWbnVe
         Hx8vYuqRpPwY+JfctIAM4ahXH03G+DWzAKxWkoYcQZUYJyny9nj0CPAlu4BY31176d9t
         Ripn/epO8Ex19hOKrQCaVeQSSHS34lfYqxCvbYZeBH4fhQku56Vtsy/iITeHmow5oK++
         zT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NA+ZAN62gafgo5KTsYprZktBzSw40NV5j8/VYA/ERYQ=;
        b=kX3fGI490Rm33yzAXe0Ch7xvAbCserTOtCVGyLix/DtEpTegIFIL5vZrpoo5vlgYLO
         ijlyJ81Lcn79OrC05aGmw126/MVRN6faLqp/84lpjpZHreiXXf7BL9CBA/GurBBZXelO
         Z1mSRzk6HkVQjc1W/u7YF7HzFujk5CLBYHWcsJ3aBhqlu0StBeOZrAuBCQbRsrxFKsUi
         FwXCe+1kbaJTQcKQ9IwI3qGRLE0BuhDCg3Hhi4nnrZHfJOhEd8l1dSspkxpBqLegB72R
         CM2MODtxIaNQS9Tfs3eHMojiZI2oTyvZ+TnkKsk15fYwfjZdwOvRoYLUXFvLInE/vUQj
         l+zg==
X-Gm-Message-State: AGi0PuZlUhS7xNxaYANyjIuoCNt2GUUkG/zFd3QY7zrnsebYrEkamWHG
        lxvmVhPz5cwe/1TpcEFv25w=
X-Google-Smtp-Source: APiQypJuJOHjeQdwyBP2rqf1bfQDerdoZ2o4//HWw8sZAt5v3tAM9R0G1PnqmAeE5A+5fIfFrOzgew==
X-Received: by 2002:ac8:2f88:: with SMTP id l8mr13281858qta.139.1586013803929;
        Sat, 04 Apr 2020 08:23:23 -0700 (PDT)
Received: from localhost.localdomain ([45.72.142.47])
        by smtp.gmail.com with ESMTPSA id 18sm9393299qkk.84.2020.04.04.08.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 08:23:23 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        mcr@sandelman.ca, stefan@datenfreihafen.org,
        netdev@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>
Subject: [PATCH net] ipv6: rpl: fix loop iteration
Date:   Sat,  4 Apr 2020 11:22:57 -0400
Message-Id: <20200404152257.32262-1-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fix the loop iteration by not walking over the last
iteration. The cmpri compressing value exempt the last segment. As the
code shows the last iteration will be overwritten by cmpre value
handling which is for the last segment.

I think this doesn't end in any bufferoverflows because we work on worst
case temporary buffer sizes but it ends in not best compression settings
in some cases.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
Sorry, I should have caught this earlier and was sure I tested this code.
It's likely to have a off by one error because sometimes you want to walk
over all segments and sometimes you want to walk over all exempt the last
(because cmpri affects all segments exempt the last one).

 net/ipv6/rpl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index dc4f20e23bf7..d38b476fc7f2 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -48,7 +48,7 @@ void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
 	outhdr->cmpri = 0;
 	outhdr->cmpre = 0;
 
-	for (i = 0; i <= n; i++)
+	for (i = 0; i < n; i++)
 		ipv6_rpl_addr_decompress(&outhdr->rpl_segaddr[i], daddr,
 					 ipv6_rpl_segdata_pos(inhdr, i),
 					 inhdr->cmpri);
@@ -66,7 +66,7 @@ static unsigned char ipv6_rpl_srh_calc_cmpri(const struct ipv6_rpl_sr_hdr *inhdr
 	int i;
 
 	for (plen = 0; plen < sizeof(*daddr); plen++) {
-		for (i = 0; i <= n; i++) {
+		for (i = 0; i < n; i++) {
 			if (daddr->s6_addr[plen] !=
 			    inhdr->rpl_segaddr[i].s6_addr[plen])
 				return plen;
@@ -114,7 +114,7 @@ void ipv6_rpl_srh_compress(struct ipv6_rpl_sr_hdr *outhdr,
 	outhdr->cmpri = cmpri;
 	outhdr->cmpre = cmpre;
 
-	for (i = 0; i <= n; i++)
+	for (i = 0; i < n; i++)
 		ipv6_rpl_addr_compress(ipv6_rpl_segdata_pos(outhdr, i),
 				       &inhdr->rpl_segaddr[i], cmpri);
 
-- 
2.20.1

