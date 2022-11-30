Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1DC63CCE0
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 02:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiK3BgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 20:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiK3BgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 20:36:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683466D4A5
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 17:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B690B810C3
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF61C433C1;
        Wed, 30 Nov 2022 01:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669772161;
        bh=bMdvq9o7Dil7h2q1HG2fpZpYfXRwEivoWbe/+RHIWfQ=;
        h=From:To:Cc:Subject:Date:From;
        b=POf8wio1oeGGLYxLAZMMtcEykH5uR6VStlx8xhGvmfRXK4+reNbxRFiXuGuGG2vmu
         IBfPujaT3uiULyCxolyLKA5q8S5wJ8amcS5YzniyDj4CkDZ67unZIHQINCipO1+Zsv
         DvVbUHVza+cmDZP0dO8QNVRfF+iEh8OmTlfZ/Lqjz79DrKld8R3yEqgXocjExLaNjm
         Ab0NjMQRk5EhA2Grc+uU7LbeqPz2BDSAnRCB7AtBpl2eZajiMMpTSGjjaDB90UeG6a
         Lu+GOAq+Xby2oK3Tpk3/g9jhI9sbsswazVM4Ja3T0DQJ+I3+xLJYXJ6IydTfUKjsls
         /WqswqQ2zMLfw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next] ethtool: rings: report TCP header-data split
Date:   Tue, 29 Nov 2022 17:35:57 -0800
Message-Id: <20221130013557.90739-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report if device is in HDS compatible mode or not.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/rings.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/netlink/rings.c b/netlink/rings.c
index d50bbac47701..628403520f4a 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -20,6 +20,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	const struct nlattr *tb[ETHTOOL_A_RINGS_MAX + 1] = {};
 	DECLARE_ATTR_TB_INFO(tb);
 	struct nl_context *nlctx = data;
+	unsigned char tcp_hds;
 	bool silent;
 	int err_ret;
 	int ret;
@@ -50,6 +51,24 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE], "CQE Size:\t\t");
 	show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
 
+	tcp_hds = tb[ETHTOOL_A_RINGS_TCP_DATA_SPLIT] ?
+		mnl_attr_get_u8(tb[ETHTOOL_A_RINGS_TCP_DATA_SPLIT]) : 0;
+	printf("TCP data split:\t");
+	switch (tcp_hds) {
+	case ETHTOOL_TCP_DATA_SPLIT_UNKNOWN:
+		printf("n/a\n");
+		break;
+	case ETHTOOL_TCP_DATA_SPLIT_DISABLED:
+		printf("off\n");
+		break;
+	case ETHTOOL_TCP_DATA_SPLIT_ENABLED:
+		printf("on\n");
+		break;
+	default:
+		printf("unknown(%d)\n", tcp_hds);
+		break;
+	}
+
 	return MNL_CB_OK;
 }
 
-- 
2.38.1

