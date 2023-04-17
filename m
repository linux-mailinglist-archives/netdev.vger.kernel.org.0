Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC956E4EE5
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDQRMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbjDQRMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:12:43 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724FFF2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:39 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id cg19-20020a056830631300b0069f922cd5ceso12503261otb.12
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681751558; x=1684343558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrgOqbQ8tfhAtqn08b0XzePIyM6gaBBRIcqWgwZFTtY=;
        b=CVqzSS/L0JlyAGNcnWHyUkRIn5nbbn/sne3l4oxTU6izLlnDmazZLLZhbnnVITu/m7
         JPm37IQ3+oeM3eXNWX/1Glu5UijVxs2RqkKkpX1xi+HZ1l4oQo3uspwsdepV3LgHkrXS
         +9GSyzIJvzQ7YdlkRyDA976L02KROz/A6QVmmVVYJ/aKX4bAAlsOtK8avt2lrG/Elngb
         CXrPWaC/Y7Op4XLPvFITLsdJfiee10IXmDbOsMo0ID2oa0rP2qcF9i3oEHX2BcUhBYia
         qLHHT1GU7YE+W3VMPBO2QRBx8Z7cfspshOF5XlNiDnY6PYe9090Rrv2T37ozwHMZVv5t
         TbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681751558; x=1684343558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XrgOqbQ8tfhAtqn08b0XzePIyM6gaBBRIcqWgwZFTtY=;
        b=E0Bud5EXlD9hOoWzTt9Rc50Kylgk/i8af1Yp53Cyc7yivJd6ksuIUKmOCuidp6OCXj
         nPbr1YBQCul0/k64hpY5y2iqseb6IAby0rxxp78BEj50Dz4CRSgHtJDbcyiivdKlVfG9
         jnzZzzJQ1NyS4UiX8bLqb7syQpebeLipgarihZc8h3fCYbDmhXZ2VDE6AqXcY6z4Bw26
         EODzfWqZMwLOVpCk3JduDN86TtWVdfmP3uWac9mxRB/B/egQEr58z2MCSXUcyTCGSaWw
         nAIVmqu2BMDhL9Jb7DWgq3KAO1V6qThm6PiFy2TJWfS2bivHqjFxCUZBRmTGMIUhmO3d
         lt4w==
X-Gm-Message-State: AAQBX9ed80w7ZPzlsbqyukUjohR1VEgVWotNIhUkaaIvhxvPpZEASp4n
        RuFY6+N0QUTwa1JHJRsN2HjCM0BYclhsMGH7/D4=
X-Google-Smtp-Source: AKy350Z/f06YBcQHgG3xzFhTkvDD0ncb7+9crVenr8v/1LmnlY3dgd25bmknb/9KBYD8DByYQXM0xw==
X-Received: by 2002:a9d:7384:0:b0:6a4:32e7:e559 with SMTP id j4-20020a9d7384000000b006a432e7e559mr6567837otk.33.1681751558592;
        Mon, 17 Apr 2023 10:12:38 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:150:be5b:9489:90ac])
        by smtp.gmail.com with ESMTPSA id v17-20020a9d5a11000000b006a205a8d5bdsm4761248oth.45.2023.04.17.10.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 10:12:38 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 2/4] net/sched: sch_qfq: use extack on errors messages
Date:   Mon, 17 Apr 2023 14:12:16 -0300
Message-Id: <20230417171218.333567-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417171218.333567-1-pctammela@mojatatu.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some error messages are still being printed to dmesg.
Since extack is available, provide error messages there.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_qfq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index cf5ebe43b3b4..323609cfbc67 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -402,8 +402,8 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	int err;
 	int delta_w;
 
-	if (tca[TCA_OPTIONS] == NULL) {
-		pr_notice("qfq: no options\n");
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tca, TCA_OPTIONS)) {
+		NL_SET_ERR_MSG_MOD(extack, "missing options");
 		return -EINVAL;
 	}
 
@@ -441,8 +441,9 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	delta_w = weight - (cl ? cl->agg->class_weight : 0);
 
 	if (q->wsum + delta_w > QFQ_MAX_WSUM) {
-		pr_notice("qfq: total weight out of range (%d + %u)\n",
-			  delta_w, q->wsum);
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "total weight out of range (%d + %u)\n",
+				       delta_w, q->wsum);
 		return -EINVAL;
 	}
 
-- 
2.34.1

