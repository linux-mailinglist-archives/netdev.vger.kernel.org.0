Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB036EA766
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbjDUJoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjDUJoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:44:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92398B76F
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b96ee51ee20so887587276.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682070242; x=1684662242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rmluk50Zu7PRRL48KZk1HGCw/Y9JVzhxBTme4bZP35A=;
        b=iAapxRvcNRvnUpuapN5hzepl9J0gJW4ZONWLQCTARdjEtUPSbx477FA3om8uJWa1GJ
         gLgld0RYguMCj6aSWOIIt/IgRBm+oRIBWkP1icEcf4GelCL2ETwhn5Al/TLEymVu2lsX
         YXhkNTL47hEJ2X2jfdTK5rvT48APEqKoBNtCSPcNQlTn4DPIX9JVdl+4Obxhcj2BkVlP
         h4LKqPBLkwhVUZ5TMAhUk6C9nRSBFmrDmlbi/6yZjApqdmBVCuq8UC+kZ8diO2tevjC9
         ZIhxjybKWi54v6t1UmFZaV7DYNvgq94NW/mZjIS//QvhDGoppGF4fQ3vNk6yhmx9YWjm
         HM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070242; x=1684662242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rmluk50Zu7PRRL48KZk1HGCw/Y9JVzhxBTme4bZP35A=;
        b=eXiLe0gp8343d7t9Fg8kOY9IWs4liRpI5xwQjTktmgHNn3a0zKZ3oZ+E6dKDlHrWpd
         ocPw9pZ4XTJX0MbuzlMJGETNMECBhLlp8jvcfUYvI06lP3iBqfQONe9d0glEYL28opMd
         VkCG5MXD28QS3YUSZN6bwIn/XZAUd5nn5fB6nvAFng1TeiOTZlm9rM9Hg+WWeKU/NXtl
         QukXy9h1hMkW4/UZrhvQ51UlWQxSXy5i6SFgfbHkcqg5uLMg40Ncgp9o9kp8LwGszWlq
         MSRKRBLoVVqKBgYZ5ti0/fsR1wV3kiF/Fc2/5+xynWg4LiQFsQJcT75jL+mtyUzS3JfH
         Iu8A==
X-Gm-Message-State: AAQBX9dz9dA560+RPyAWRB4XwuF55tlo52nwszEALnNAmtb64fd2P+Vw
        iRL3XpIVCanssqtkeSZrwcJL74iHCLanUw==
X-Google-Smtp-Source: AKy350ZrT5EDYpUNG8gRJ/s7jEAutk6Zqd33rT1U8rzWwtUfsiaUI7kmQGfPUWRfRgYV5Rq3cP9aK8LupFJrZg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d74a:0:b0:b95:de44:ece4 with SMTP id
 o71-20020a25d74a000000b00b95de44ece4mr1371130ybg.6.1682070242852; Fri, 21 Apr
 2023 02:44:02 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:43:53 +0000
In-Reply-To: <20230421094357.1693410-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230421094357.1693410-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421094357.1693410-2-edumazet@google.com>
Subject: [PATCH net-next 1/5] net: add debugging checks in skb_attempt_defer_free()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure skbs that are stored in softnet_data.defer_list
do not have a dst attached.

Also make sure the the skb was orphaned.

Link: https://lore.kernel.org/netdev/CANn89iJuEVe72bPmEftyEJHLzzN=QNR2yueFjTxYXCEpS5S8HQ@mail.gmail.com/T/
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0d998806b3773577f6fc7ca2bfffd5304ea8b20f..bd815a00d2affae9be4ea6cdba188423e1122164 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6881,6 +6881,9 @@ nodefer:	__kfree_skb(skb);
 		return;
 	}
 
+	DEBUG_NET_WARN_ON_ONCE(skb_dst(skb));
+	DEBUG_NET_WARN_ON_ONCE(skb->destructor);
+
 	sd = &per_cpu(softnet_data, cpu);
 	defer_max = READ_ONCE(sysctl_skb_defer_max);
 	if (READ_ONCE(sd->defer_count) >= defer_max)
-- 
2.40.0.634.g4ca3ef3211-goog

