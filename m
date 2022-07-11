Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC78856D50A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 08:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiGKG7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 02:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGKG7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 02:59:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F6D10FC8;
        Sun, 10 Jul 2022 23:59:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id j1-20020a17090aeb0100b001ef777a7befso5319901pjz.0;
        Sun, 10 Jul 2022 23:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GeihzPQ4gDEvIfkX96rheatYD9BEj0zBOuDE5t7m6pM=;
        b=EIA8veF/UGA6fCHdCpgvNU75iz7I0Xiw+YjywF2DlGNY3pW+zQaJqrxRSJiMRssuSM
         9kL0NmgU/ZtKKMJTLwYUROa6z4I/fy6H7GVLPf9ar03+iNjIJO/P96wjO+p7Zejopony
         dEqnA5B8YWWyfSbOj3OqqLhOHQ7YgC95YVeuCUVSrWjPJt0wUMZtleG+W/3nPs8WJAjm
         2n6Gj4A8CSVh0gg2kEDXIX9OdwgefV+I3pxo6FtJpG/Uql4lD9X1yf+3zA3wLdiknrlc
         86LQpDBNszaGwTe0G9VcKxXYNif6TJwMvGwiPXsTaPZHtPFtM/eXtBBuJFx8J5wekm60
         BSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GeihzPQ4gDEvIfkX96rheatYD9BEj0zBOuDE5t7m6pM=;
        b=SYV/GfjUlV/R0X9BTZpaK4vzbhUZh5gOsPHWd5zq2xTyoHbTVHSFIHpiYkh5AegbIK
         shw24DCUKPzo88m3qSQyg1JMcd0Odf1SyAj2E5xldSg5ebO64+xOVLwXUEO6D9hM7+5Z
         QPX1YMVZagJXfZVRQEIcAhtMWx5kgptYWMfxwGRQaQncoYNUoItpIFuv6V5Ru8bOodEO
         Tb+0LYvwEtJWfFkPHlfAIeg87z45nAqvU3LrQGkUbhBz89mRevu8J3/k5rJiCxDFZjeU
         mIncQ30RRSpSGOpqVsVR6IogIXM77ahL1PJYinUgB5cWEE/IO8bAcA5EqwpHcK7vzjl1
         BMDQ==
X-Gm-Message-State: AJIora+CBdAanAPI6EfR/Hv8k6N5ZEGSVtRtChqSoYu979pZpxk88+wo
        K8VnQ84qkbmijmCkJY1L4xA=
X-Google-Smtp-Source: AGRyM1uCInwr/NUdysJ0b7sefaWPA1c+O7e2tIqHEY64v2pvje38AiK2iGkVPsi0juW35BrPY2yGEg==
X-Received: by 2002:a17:902:e850:b0:16c:41d1:19d2 with SMTP id t16-20020a170902e85000b0016c41d119d2mr5672566plg.125.1657522770331;
        Sun, 10 Jul 2022 23:59:30 -0700 (PDT)
Received: from localhost.localdomain ([129.227.148.126])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b00168c52319c3sm3910010plp.149.2022.07.10.23.59.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 23:59:29 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, tomasbortoli@gmail.com
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: 9p: fix possible refcount leak in p9_read_work() and recv_done()
Date:   Mon, 11 Jul 2022 14:59:07 +0800
Message-Id: <20220711065907.23105-1-hbh25y@gmail.com>
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

A ref got in p9_tag_lookup needs to be put when functions enter the
error path.

Fix this by adding p9_req_put in error path.

Fixes: 728356dedeff ("9p: Add refcount to p9_req_t")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/9p/trans_fd.c   | 3 +++
 net/9p/trans_rdma.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8f8f95e39b03..c4ccb7b9e1bf 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -343,6 +343,7 @@ static void p9_read_work(struct work_struct *work)
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
 				 m->rc.tag, m->rreq);
+			p9_req_put(m->rreq);
 			m->rreq = NULL;
 			err = -EIO;
 			goto error;
@@ -372,6 +373,8 @@ static void p9_read_work(struct work_struct *work)
 				 "Request tag %d errored out while we were reading the reply\n",
 				 m->rc.tag);
 			err = -EIO;
+			p9_req_put(m->rreq);
+			m->rreq = NULL;
 			goto error;
 		}
 		spin_unlock(&m->client->lock);
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 88e563826674..82b5d6894ee2 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -317,6 +317,7 @@ recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	/* Check that we have not yet received a reply for this request.
 	 */
 	if (unlikely(req->rc.sdata)) {
+		p9_req_put(req);
 		pr_err("Duplicate reply for request %d", tag);
 		goto err_out;
 	}
-- 
2.25.1

