Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADF663B049
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbiK1RtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiK1Rrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:47:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF95167E6;
        Mon, 28 Nov 2022 09:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42475B80E56;
        Mon, 28 Nov 2022 17:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3C7C4347C;
        Mon, 28 Nov 2022 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657370;
        bh=gri86OR9ATsXe3TfzHcfa345PcVbomYmI6akjvxvMp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erWrRND+yjZiNylGrRD3mM/tZNhc6nAzmi4IxcGixt17nUWfuwGN5IfH+OCYyWGvC
         D35v/Jo9cGND42baF0ruR9eNOZLgPs3+Mzy0d/U3tg6rSkWU5xFXOhLkoO524PMBDt
         LlDbMwxp3gMSNdmxg441au7k/yTkVrg2wwESJQ5TG3cd2a++0DAxgASFZ7f2rcF5jH
         NwCm73J9M+9oEt52oMNRHkQvH2uSgUXgHQN7QoeYWRZB3QP0mA8pCU0GA1inBsGPZh
         7qSUYKEVFOOSH7l8i5JPrn7DFavwgO4wtO7IOgap3TPaPNHUUAVa+7p8A5D+4eZkh/
         Bj9Drj1hoWdRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     GUO Zihua <guozihua@huawei.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 06/12] 9p/fd: Use P9_HDRSZ for header size
Date:   Mon, 28 Nov 2022 12:42:29 -0500
Message-Id: <20221128174235.1442841-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174235.1442841-1-sashal@kernel.org>
References: <20221128174235.1442841-1-sashal@kernel.org>
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
index 7194ffa58d3e..689117c78deb 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -133,7 +133,7 @@ struct p9_conn {
 	struct list_head unsent_req_list;
 	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
-	char tmp_buf[7];
+	char tmp_buf[P9_HDRSZ];
 	struct p9_fcall rc;
 	int wpos;
 	int wsize;
@@ -304,7 +304,7 @@ static void p9_read_work(struct work_struct *work)
 	if (!m->rc.sdata) {
 		m->rc.sdata = m->tmp_buf;
 		m->rc.offset = 0;
-		m->rc.capacity = 7; /* start by reading header */
+		m->rc.capacity = P9_HDRSZ; /* start by reading header */
 	}
 
 	clear_bit(Rpending, &m->wsched);
@@ -327,7 +327,7 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
-		m->rc.size = 7;
+		m->rc.size = P9_HDRSZ;
 		err = p9_parse_header(&m->rc, &m->rc.size, NULL, NULL, 0);
 		if (err) {
 			p9_debug(P9_DEBUG_ERROR,
-- 
2.35.1

