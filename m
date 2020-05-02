Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB541C2227
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 03:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEBBe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 21:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbgEBBez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 21:34:55 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439D8C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 18:34:55 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id q2so5620510qvd.1
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 18:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=NwwxzimPqqoSwBzRxjqXa4BndHO3/v5XpdehEsc5RwE=;
        b=rAifOEUazf9H2imzP3d705CydGjDYKgaF1R77xzvEfc7W1ywbp8fhCUSzwMAq9hJGV
         sGWYIYCLn6mKD55W+xDK3AH7qsEyuYkQwwbWpZ6vHb0bMUBB2N8HmZak1N++WksLjhZN
         nwLh7SCg2AiFSpvgFI8zdUuW+Ox0V7jEQclYHknzgSQbxBM3rQXwOiw7Bq7eD7smqXBM
         MAQ7Hq5MrjmW1xuTKIDoJttd6bprfaLZh8uGKSI4AwcZASdrXUssgDexJFp7RKgfe6qY
         OJSBNbu6W+OzgQYkqdpCB0BgUT01qoTeNdnOmaTYeCkhFrdk2awBm+3XxRoihgNBRJzk
         F22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NwwxzimPqqoSwBzRxjqXa4BndHO3/v5XpdehEsc5RwE=;
        b=dJkjIzH8IuE0vgo0e7H82qNUzeh/XV1syMRWpsZ196LSMoVNTsqMJRp0qzfr/2DGAh
         mRGOyZpp883QBlGAuhRmvXcTL3icCjWXUyo+j4UHOUBYlu+7G3zuXCZF9/JlHNKV2VtC
         ZIdWe6Aop7qCZtaMACZQ2Q4bhetz5EFaCHWkeNeUje3fXhHYP+GKBkhWvXVnpeGz9RD4
         Ckh2euKVusKxfEomrVTKM7uFcWXJ4BbwJkx4H/VITPxGxvFKVTNexU8oz7X2UEpv2md/
         FeIidKVoNjzDL9L+GrpoS2JM+X6ND5PyVs5pKQbzRKpBSUp/HgPT+kFB9OpLSUOVv3sT
         UZWA==
X-Gm-Message-State: AGi0Pubh4h/G3E1Sd3HBTlDd9mxOqQ8sW52DhIgbATAeQqjZzpXVGUor
        4/qD3fHeNDdpj5d5FUwdzQdb+Q==
X-Google-Smtp-Source: APiQypJaSc+uZ2ooKN/WX99zVXn7DhDXsaPedknazbRSeS0doa20wDlmY2Mbcd22KJ8FiAbnoo2RkA==
X-Received: by 2002:a0c:da01:: with SMTP id x1mr6798286qvj.103.1588383293006;
        Fri, 01 May 2020 18:34:53 -0700 (PDT)
Received: from mojatatu.com ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id j92sm3926186qtd.58.2020.05.01.18.34.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 18:34:52 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, dsahern@gmail.com,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 1/1] neigh: send protocol value in neighbor create notification
Date:   Fri,  1 May 2020 21:34:18 -0400
Message-Id: <1588383258-11049-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a new neighbor entry has been added, event is generated but it does not
include protocol, because its value is assigned after the event notification
routine has run, so move protocol assignment code earlier.

Fixes: df9b0e30d44c ("neighbor: Add protocol attribute")
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 net/core/neighbour.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 39d37d0ef575..116139233d57 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1956,6 +1956,9 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 				   NEIGH_UPDATE_F_OVERRIDE_ISROUTER);
 	}
 
+	if (protocol)
+		neigh->protocol = protocol;
+
 	if (ndm->ndm_flags & NTF_EXT_LEARNED)
 		flags |= NEIGH_UPDATE_F_EXT_LEARNED;
 
@@ -1969,9 +1972,6 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = __neigh_update(neigh, lladdr, ndm->ndm_state, flags,
 				     NETLINK_CB(skb).portid, extack);
 
-	if (protocol)
-		neigh->protocol = protocol;
-
 	neigh_release(neigh);
 
 out:
-- 
2.7.4

