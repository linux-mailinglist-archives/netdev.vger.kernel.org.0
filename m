Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB1363AFFD
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiK1RsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiK1Rqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:46:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11FF2D751;
        Mon, 28 Nov 2022 09:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2DD561307;
        Mon, 28 Nov 2022 17:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73F7C433D7;
        Mon, 28 Nov 2022 17:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657303;
        bh=incXVb5OeDnPjf8v58URtG3XXnk0WJCxSIRPnAveTqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffkTQpM4l7cVRuA+1gwr9mj4hYz+5pLtLiMaIVHWigoAJcadnGH6jNmPp2g1ou8wI
         fTntwdZEnzp4FG89jNrs75SCXtBzDhadbRqvHh+0ad2e1ls6Cgn6qcQQir6QPVQTqJ
         l+UgZaZMc9dysw8KZjms3tF8WYXIA9FKwuX72aLqSg+3pYLxtp94I9G9UrITSbqyUg
         CtZW1bd5XN/AoAJ281ij29VaT7+ty0yQVCLjcuXYa0eWRv6UJFRGJ20rKNdAQvOjVV
         jxZfrFlEdrn/OqB2uk6mW11aAY53B6Z8QE49Io0HEpQazNEPZRg8vpbdAMuIql0eIH
         Jlg3H5eyq00zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/19] 9p/fd: Use P9_HDRSZ for header size
Date:   Mon, 28 Nov 2022 12:41:10 -0500
Message-Id: <20221128174120.1442235-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174120.1442235-1-sashal@kernel.org>
References: <20221128174120.1442235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: GUO Zihua <guozihua@huawei.com>

[ Upstream commit 6854fadbeee10891ed74246bdc05031906b6c8cf ]

Cleanup hardcoded header sizes to use P9_HDRSZ instead of '7'

Link: https://lkml.kernel.org/r/20221117091159.31533-4-guozihua@huawei.com
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
[Dominique: commit message adjusted to make sense after offset size
adjustment got removed]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index fec6c800c898..4fccefb50a7d 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -118,7 +118,7 @@ struct p9_conn {
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
-	char tmp_buf[7];
+	char tmp_buf[P9_HDRSZ];
 	struct p9_fcall rc;
 	int wpos;
 	int wsize;
@@ -289,7 +289,7 @@ static void p9_read_work(struct work_struct *work)
 	if (!m->rc.sdata) {
 		m->rc.sdata = m->tmp_buf;
 		m->rc.offset = 0;
-		m->rc.capacity = 7; /* start by reading header */
+		m->rc.capacity = P9_HDRSZ; /* start by reading header */
 	}
 
 	clear_bit(Rpending, &m->wsched);
@@ -312,7 +312,7 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
-		m->rc.size = 7;
+		m->rc.size = P9_HDRSZ;
 		err = p9_parse_header(&m->rc, &m->rc.size, NULL, NULL, 0);
 		if (err) {
 			p9_debug(P9_DEBUG_ERROR,
-- 
2.35.1

