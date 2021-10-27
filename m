Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3595543D05E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbhJ0SOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:14:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42010 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbhJ0SOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:14:32 -0400
From:   bage@linutronix.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635358325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNVQc9ygjD1LlmMAQOwIyecjzMr/zGo9tbfPABSVDO0=;
        b=jT+DLQOCFfWo5qDjQSU8H5mgQNBmduDxWrB901xqKkYxLXtwZzLP9O2R6lEV/jxuGAPt57
        /etuuItLpAFtr26J+tixmjWlpUArLlcmMc3L0Td9CKUJS5N1qOAGfAahvKu5yCfhcBMSs0
        DuEkwZcwEUN/G+b1I8XCXkBKGMb9yfFAQ9HxW298nXtRcctJufawmtmxWUc1EVbPvDkAs5
        CuaLG2ZgHtnC6KGOeHmzIurd/KCJ5Y7CI9vQvLdWX0cHd+wiN6NLKo9JtTi2v/4iK5yC23
        f6ngW0L+7GhFbjwjjCd4d66MtQ/EpR6MSKFwwEDZ0AWjuh2y8ykGZO1WsMkyoA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635358325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNVQc9ygjD1LlmMAQOwIyecjzMr/zGo9tbfPABSVDO0=;
        b=IvVjDmecs2LV+ytOSQh6D1l9Ffm+5WdpZdDprhdr3k5Ufmo93/UYqq9EG/qu+MKXLk73or
        lmlDWZ+sk57zlSCQ==
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Bastian Germann <bage@linutronix.de>
Subject: [PATCH ethtool 2/2] netlink: settings: Drop port filter for MDI-X
Date:   Wed, 27 Oct 2021 20:11:40 +0200
Message-Id: <20211027181140.46971-3-bage@linutronix.de>
In-Reply-To: <20211027181140.46971-1-bage@linutronix.de>
References: <20211027181140.46971-1-bage@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastian Germann <bage@linutronix.de>

The port == PORT_TP condition on printing linkinfo's MDI-X field prevents
ethtool from printing that info even if it is present and valid, e.g. with
the port being MII and still having that info.

Signed-off-by: Bastian Germann <bage@linutronix.de>
---
 netlink/settings.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index c4f5d61..4da251b 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -560,8 +560,7 @@ int linkinfo_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		print_enum(names_transceiver, ARRAY_SIZE(names_transceiver),
 			   val, "Transceiver");
 	}
-	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL] &&
-	    port == PORT_TP) {
+	if (tb[ETHTOOL_A_LINKINFO_TP_MDIX] && tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]) {
 		uint8_t mdix = mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX]);
 		uint8_t mdix_ctrl =
 			mnl_attr_get_u8(tb[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]);
-- 
2.30.2

