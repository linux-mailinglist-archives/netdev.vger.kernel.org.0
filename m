Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA6463AFFA
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 18:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiK1RsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 12:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbiK1Rr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 12:47:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B38EF35;
        Mon, 28 Nov 2022 09:42:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F0C4612D2;
        Mon, 28 Nov 2022 17:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B750EC433D7;
        Mon, 28 Nov 2022 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657353;
        bh=0xXbsxiMPlFyZEbS3ZNMvu5qgWqcrJYiqoe5lSqqVj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxrgtMSi4rb+UOeyiE53MgCLWKbfUgYatEl+VGkrW+Yatt5IbywkChI0jYuISZM+u
         WlijvNJkkPKUqF+N05euQoDomgeTsinO8aJpC9l2L1uxFsKOBZ5E8YKLo/kwwBhA+6
         UCZZe/9o0YIRGZ4ee62I9Kx93s8WVm+F1j2Zh5AclQqWd9i0eCEMN7nRrtY/Ho0DOb
         PH5toskeh2Y5ND/hdukwzmvJ64Ye7nCVJ57IZG1BMtnE2tbHuCZk+4VfC7l4yI0mSL
         dJjNm8hVUP4Qc9vnqsH/lJvYJw2VgSOtFE0HpsECdgphLxtMHqS9hI1+vu2PnE/H1g
         MXB/AsDOHgn2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Sasha Levin <sashal@kernel.org>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/16] 9p/xen: check logical size for buffer size
Date:   Mon, 28 Nov 2022 12:41:58 -0500
Message-Id: <20221128174201.1442499-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174201.1442499-1-sashal@kernel.org>
References: <20221128174201.1442499-1-sashal@kernel.org>
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

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 391c18cf776eb4569ecda1f7794f360fe0a45a26 ]

trans_xen did not check the data fits into the buffer before copying
from the xen ring, but we probably should.
Add a check that just skips the request and return an error to
userspace if it did not fit

Tested-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Link: https://lkml.kernel.org/r/20221118135542.63400-1-asmadeus@codewreck.org
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 2779ec1053a0..f043938ae782 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -230,6 +230,14 @@ static void p9_xen_response(struct work_struct *work)
 			continue;
 		}
 
+		if (h.size > req->rc.capacity) {
+			dev_warn(&priv->dev->dev,
+				 "requested packet size too big: %d for tag %d with capacity %zd\n",
+				 h.size, h.tag, req->rc.capacity);
+			req->status = REQ_STATUS_ERROR;
+			goto recv_error;
+		}
+
 		memcpy(&req->rc, &h, sizeof(h));
 		req->rc.offset = 0;
 
@@ -239,6 +247,7 @@ static void p9_xen_response(struct work_struct *work)
 				     masked_prod, &masked_cons,
 				     XEN_9PFS_RING_SIZE);
 
+recv_error:
 		virt_mb();
 		cons += h.size;
 		ring->intf->in_cons = cons;
-- 
2.35.1

