Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B26E99E6
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjDTQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjDTQuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:50:12 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD27270E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:03 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 46e09a7af769-6a5f9c1200eso461508a34.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682009403; x=1684601403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWV7EHFDukvZMAhe+Tm4Xz36bsKeCMT2Vv3MRpmyjsE=;
        b=QwXLopqb1crD4VsKq4RtHetYbq6zMiRWJivpaehNlXAqJT7mCksUdQ/MmfGJPbtp4l
         un70gl/qg/qfYRS4O7G9X4/sSDRf0qbsCRUgldWMEkKNilGJi4LE9EYuMWPSRg5YgwPL
         Sza9lb3i3bf8q6kgoyIQV+gc5THbo+AQpxNi5UDUcF9wYr9r0f8oN9nC6P6xHkIjlghd
         QTTbW+NBsBO9NrpwJ1F09OdqLvg0jMOTzRD+z9Z6jHaxNuefCRgTtHm5HK/Prk0shl9B
         0UUSG6ZFaJdFIIj6Te17jqTC+1QrQ8TdCf/oxZZO9kOQFSYYbcJMpWgfcmMGT4qZR/ey
         k13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009403; x=1684601403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWV7EHFDukvZMAhe+Tm4Xz36bsKeCMT2Vv3MRpmyjsE=;
        b=lH315XwMg2yKjwf8bBh24xB0fccdsqWSmyXS6QudwBtIc2tgZbwn7uGdtanpHi90al
         eUfsWIG4NgT+Lb8NZt/pXtysx5kodX6+LReIzmC2ekuFUoCR6If35Lndk5++6QAFk60I
         HHIvrV63hleRPyCEJ9zwSlYnyWZ5EBVA0jSNe0ewzqKTqUaM7CD8zgcEWW73y/CQwsRN
         trX4o2xlYcu+febinJfyByCLhP0pIwkstD+Wz8vV9r52Vpo4/11joMqtbMYYj8al8sF6
         8Rwcy92AuKr7MybSdVcIar/4TldB99JHIvRSUGyAQTEtSP+pjFWbv453RF2vJo3uYMib
         ah+A==
X-Gm-Message-State: AAQBX9eYpemHWt6KiZn+HYFEAE1lsIyEDXj6iTMaRr/TW0M45kRLXOuR
        ZbuCKBIUtWJm1wD0VboHpHzikthxQ4h6N5BjaW4=
X-Google-Smtp-Source: AKy350ZvgboCT2ccJLIXLK4kuMNJch8iM8cmA26bESW8aVcp226OySryTc2HBUxDcHL5oRUfQbo5gQ==
X-Received: by 2002:a9d:5c09:0:b0:6a5:f5ca:f36b with SMTP id o9-20020a9d5c09000000b006a5f5caf36bmr977789otk.18.1682009402876;
        Thu, 20 Apr 2023 09:50:02 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id p26-20020a9d695a000000b006a13dd5c8a2sm894542oto.5.2023.04.20.09.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:50:02 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 2/5] net/sched: sch_qfq: use extack on errors messages
Date:   Thu, 20 Apr 2023 13:49:25 -0300
Message-Id: <20230420164928.237235-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420164928.237235-1-pctammela@mojatatu.com>
References: <20230420164928.237235-1-pctammela@mojatatu.com>
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
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

