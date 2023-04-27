Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BDE6EFFE7
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242898AbjD0Djd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbjD0Dj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:39:26 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861F6212D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:24 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso5678188b3a.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682566763; x=1685158763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u4GgPuMvOtgtHE50nx3nV3rRoZO6RT1RIo2g9Oqwf7Q=;
        b=ady0oyrs5B1+86YKVMRQtdrbLukvRVeIJrRDjI7jS1xy9tg2Jw8pLIKjGN8+mBinQJ
         iBQzP26wGR9xY/DCNbpckHpwALMZmo5YUdAWu2yUv18q91g6I7+g9BSp+/qGHW4leICh
         5usfZ4NzwlS8t+sSCIzmzzqwAMT/LF6aeOxWDVb7eVPEi2ex/DSfFZLaJ+oNg0HyGCq2
         S0yynzAhHvHG5zVANkqOBPFVlQ6tuRpoen9IdK4ZFu2eQ7uHVsvZm49zlJs9w6NKm2Ul
         Y8RvJlB9J1BmNyA7lwdH70d3Vh4I3ZNzvDCqwt7Xn5KwBP4YwE2cgHZEYkUM5zGFgwFK
         DKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682566763; x=1685158763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u4GgPuMvOtgtHE50nx3nV3rRoZO6RT1RIo2g9Oqwf7Q=;
        b=LyfrTY2lONn3QncidVvMbCe6EILZCyR6T9tSsnL+mm+pN/MUC5TPFY2cs2LOLt4nmd
         i1k7ypGnl31Jilu4OMJkqfclE/ynqT9Q5+EfnB+SXXmnInOBklhygFPAL/E4LE8RiPol
         Nm3yUGqx/+3t9bfQHbzwnJ7wtwRtVoeGszJWumb9rt94BORm6gTxC3wyssCji43hKDuX
         O7leNPvHGNlr6vZxKYzoGWH5UoddOikw1NKOKQxmss0ftwNDiM9i+aIfO0DeimgjYFwj
         oSsJghgqs1Syh0gO6Q4zbUrAIKJ4tvUmojtwSiu1BPUFsOnZX/3/QABcf6bG19xesiNY
         BnSg==
X-Gm-Message-State: AC+VfDwWj6XvxZBpiRgG/vGKlevvFa92tiS3iJzE9PbcSLgxA4gbC61A
        s+3qTDjntvT6zbOEkxXEl6F04aywyrk8OjzS
X-Google-Smtp-Source: ACHHUZ4dzwOvmchzAnphNDDmz4nHHsMa+J0XNAm685xX6ghRvxQI3xYjhACL01Ud0tK+mOB+27dGNw==
X-Received: by 2002:a05:6a00:2344:b0:63d:311a:a16b with SMTP id j4-20020a056a00234400b0063d311aa16bmr333309pfj.23.1682566763458;
        Wed, 26 Apr 2023 20:39:23 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b005abc30d9445sm12017743pfv.180.2023.04.26.20.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 20:39:22 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 2/4] Documentation: bonding: fix the doc of peer_notif_delay
Date:   Thu, 27 Apr 2023 11:39:07 +0800
Message-Id: <20230427033909.4109569-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230427033909.4109569-1-liuhangbin@gmail.com>
References: <20230427033909.4109569-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonding only supports setting peer_notif_delay with miimon set.

Fixes: 0307d589c4d6 ("bonding: add documentation for peer_notif_delay")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 Documentation/networking/bonding.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index adc4bf4f3c50..28925e19622d 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -776,10 +776,11 @@ peer_notif_delay
 	Specify the delay, in milliseconds, between each peer
 	notification (gratuitous ARP and unsolicited IPv6 Neighbor
 	Advertisement) when they are issued after a failover event.
-	This delay should be a multiple of the link monitor interval
-	(arp_interval or miimon, whichever is active). The default
-	value is 0 which means to match the value of the link monitor
-	interval.
+	This delay should be a multiple of the MII link monitor interval
+	(miimon).
+
+	The valid range is 0 - 300000. The default value is 0, which means
+	to match the value of the MII link monitor interval.
 
 prio
 	Slave priority. A higher number means higher priority.
-- 
2.38.1

