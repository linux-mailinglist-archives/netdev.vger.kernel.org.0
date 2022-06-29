Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790D855F6BE
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiF2Gev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbiF2Geq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:34:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A172C647;
        Tue, 28 Jun 2022 23:34:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c6-20020a17090abf0600b001eee794a478so7660026pjs.1;
        Tue, 28 Jun 2022 23:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCkVZrfBdJMxphgyydQPbFuiNpNH3pg2QzvaiMz3gyo=;
        b=OrkHDd2EIlgUz6HCFOg8GVnwht4HFRs36kaDpiWms5813RfX6H4RVpiMPumsmiEVOX
         gNHUWjjqrAsXwqJcSRNL+4m5fDADBmQkKSRDPQcB6badyHrHkpHqzY+krxQ/C3huTjxV
         Usx4xbvzjSnEibOuy/Z0TxGbcGc3YuUB7/DOzMr+5RgACgMp9oWx7vXCWndb4IF7GUlH
         LaGvawZnk24VckYGFr4quJBCOwGcJyG+oBoTT+5mF/bzo9nD/KEeuIk1nk2svpkKuPyh
         shBL19oE4ha8lG7fh2BZCTWG6cL1XQDPdyypjF+thUau6eAXokdw+hrw2+xZ0MdURksn
         JiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCkVZrfBdJMxphgyydQPbFuiNpNH3pg2QzvaiMz3gyo=;
        b=QQA5uCVmXlV1n2QKxMiSyN9ggBnDogFkpN3o+8IZS4TuheMwPEpGClNgOR/AqN6d31
         3nk4hb58e1WzoJvhfzwvIu3/RYR3psvM5H5szyrxBgKJ8B8Q9n5YA76E7SgqdaEzsEUX
         hTkstEN2YQIHfK52GdHtohgKuHjSXsoSVbWat50DrjYNV5ouhB+mDI9mm708p7zDI/hF
         0M+iLvdfRIRbl7G11D49fvvgDQnGKfL/MGPlm2D8kxvFnHfkJ2HQlSpfDvlryqZiVg+7
         5SKX20HB3mxAOpaLd1922A+78yI7JQySQdApS1nte8Ut5vp43RwDZn9R3z72qplo16wV
         BpkQ==
X-Gm-Message-State: AJIora88NTQUYSy1Dn4A06QKkS5VWzGgWiMJh0Mj6ZvEPYWSmmZwrSFO
        5LHj8rH4tJpRoRbWgl8SBEc=
X-Google-Smtp-Source: AGRyM1s2ppL2hSRpvIn9HTPu9f+TIBG1QARRAvFyT54nJdFqDxZ970cAi02OaEDEXehth9vXKqpifg==
X-Received: by 2002:a17:902:900c:b0:16a:4521:10fd with SMTP id a12-20020a170902900c00b0016a452110fdmr9004623plp.75.1656484484406;
        Tue, 28 Jun 2022 23:34:44 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id l12-20020a62be0c000000b005254344bf48sm10550981pff.5.2022.06.28.23.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 23:34:44 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tung.q.nguyen@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Wed, 29 Jun 2022 14:34:18 +0800
Message-Id: <20220629063418.21620-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Free sk in case tipc_sk_insert() fails.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2: use a succinct commit log.

 net/tipc/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 17f8c523e33b..43509c7e90fc 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -502,6 +502,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
-- 
2.25.1

