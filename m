Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90354571782
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiGLKoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiGLKoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:44:54 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2D9AC051;
        Tue, 12 Jul 2022 03:44:53 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r6so4478109plg.3;
        Tue, 12 Jul 2022 03:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LHFcdt/M7EFun7/LtZfwRF7i8tXqFEDcoXVMpTsmevI=;
        b=CM6E0gWMLJ5qt1wx2A0YMDp8y9kCQQgtYbH1SKHLAFqJVb63vwoe/DZn5fwC1LwOcr
         Y0vht9vEm5cX6CMdJSfktp7VvHZBTWyvjBZJs13dbyWLzPZzh0TIgWi4JjL01TuBUwxJ
         KjOk/5ujryU/QK8/g0zh2ogzWP/RIrtGFfpZ+mBKgNBXf94PbeCTDVelL/n66A/cWl+d
         8OTa0f8rMJNoKL2KuvMIFuUO3/IWeBz6SH+5IQFEBfej9z3j5PvdBIh6QHflaVwSfQsr
         5ApVBLrcIxJUsFf4blFPQMH6WlOz8X8Uj4Z/8Voz4Gnu+Lj04YOYZdJzBGMeY8NPtpUY
         Z/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LHFcdt/M7EFun7/LtZfwRF7i8tXqFEDcoXVMpTsmevI=;
        b=NCsEQSjj+8OH2/ewFbVlKgPyjrY6vHqN4XCSynfYaCCbQ3tZAF9Zbb8wk0SU17froK
         K9x8ZyuTgUsK5DWYHsYyZIKtr/TbZ2zmcRw3DHJp8M+R4nZg3dCSr01MeC9ClfPAr5Kz
         2d08fjIkn7MjNrgkWYgsg+dL+mchSINs1WDGzPwtwoZPOVkTFgW1ntaVF9eRa5w/w0lh
         VXUYiVI3IcBvJPdnIlIMouyCrdU0zJFF1UE62Rm33bftEagOic8m/LH0bLpy9v5d3YHm
         r3grndrg+dQxlRlCDqFlChjNz39wHyBGZaA46A7DAIKnuUHIx7Clh5OywvuqhJQU/JMR
         CkAQ==
X-Gm-Message-State: AJIora+TlMBHbiJnPbPqfITm1ABE0mf2cLskBKIsg0+jzQxgURWOEXy1
        GXy6PIkgthvMhexWRnNn8rA=
X-Google-Smtp-Source: AGRyM1sY+jWNlR0EFF9t2eMZ6mOWYimqBONWbupdaAhQg9KJfZr6VZpWoVzoBUG0ZYdInWu3ykHutA==
X-Received: by 2002:a17:902:8345:b0:167:879c:abe8 with SMTP id z5-20020a170902834500b00167879cabe8mr22981968pln.7.1657622693149;
        Tue, 12 Jul 2022 03:44:53 -0700 (PDT)
Received: from localhost.localdomain ([223.104.159.146])
        by smtp.gmail.com with ESMTPSA id p10-20020a1709028a8a00b0016c0408932dsm6438727plo.129.2022.07.12.03.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:44:52 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, tomasbortoli@gmail.com
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: 9p: fix possible refcount leak in p9_read_work()
Date:   Tue, 12 Jul 2022 18:44:38 +0800
Message-Id: <20220712104438.30800-1-hbh25y@gmail.com>
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

p9_req_put need to be called when m->rreq->rc.sdata is NULL to avoid
possible refcount leak.

Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

Add p9_req_put in the "No recv fcall for tag..." error path according to Dominique's suggestion.

 net/9p/trans_fd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 507974ce880c..090337f446d7 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -345,6 +345,7 @@ static void p9_read_work(struct work_struct *work)
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
 				 m->rc.tag, m->rreq);
+			p9_req_put(m->rreq);
 			m->rreq = NULL;
 			err = -EIO;
 			goto error;
-- 
2.25.1

