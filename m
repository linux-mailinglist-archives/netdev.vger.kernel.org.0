Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1922E0FF4
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 22:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgLVVvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 16:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgLVVvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 16:51:16 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F46AC0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 13:50:36 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4D0qlG0B0RzQlLY;
        Tue, 22 Dec 2020 22:50:34 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1608673832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TY4LDJh9wcqqtp5tnR+ZsWCbZ9+r9ZBo+R2YqzcN4Dg=;
        b=SZZ6v9DQYjEAlYELFcPkPkyKv1Q9t5lZkTX/WfXTTQBybcDjrZWEh/m5BPRR8rYcPHTunN
        UZPpDoJvQ0xyaeRKKfUF0EmcuYBCOJjr/Z/NyPTdxaAG0ct6zu2MbPovPO2KIIqwy9aRvm
        TtdaSxkUoQ/fpJfkWRrAhZYMlBQRUAxMSctPcZ5LoJcxoePF2UEIOPkwIkyrb0W/KSdjsX
        z7QiLavkMDpdOciNqXbQxmKW4pO1ooafLWLVHcNK+QAmgRoN2adiPkCJK/dlXpAd0xDrV0
        kv8ipV1EQgSZgOrCOjByzZxdf46wR8x+kNgE4T9rdVuydaV4MSsB96xQAFEADg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 0OpqD9u4VWWj; Tue, 22 Dec 2020 22:50:30 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Petr Machata <me@pmachata.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH net] net: dcb: Validate netlink message in DCB handler
Date:   Tue, 22 Dec 2020 22:49:44 +0100
Message-Id: <a2a9b88418f3a58ef211b718f2970128ef9e3793.1608673640.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 0.16 / 15.00 / 15.00
X-Rspamd-Queue-Id: 07B60170D
X-Rspamd-UID: 82b425
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DCB uses the same handler function for both RTM_GETDCB and RTM_SETDCB
messages. dcb_doit() bounces RTM_SETDCB mesasges if the user does not have
the CAP_NET_ADMIN capability.

However, the operation to be performed is not decided from the DCB message
type, but from the DCB command. Thus DCB_CMD_*_GET commands are used for
reading DCB objects, the corresponding SET and DEL commands are used for
manipulation.

The assumption is that set-like commands will be sent via an RTM_SETDCB
message, and get-like ones via RTM_GETDCB. However, this assumption is not
enforced.

It is therefore possible to manipulate DCB objects without CAP_NET_ADMIN
capability by sending the corresponding command in an RTM_GETDCB message.
That is a bug. Fix it by validating the type of the request message against
the type used for the response.

Fixes: 2f90b8657ec9 ("ixgbe: this patch adds support for DCB to the kernel and ixgbe driver")
Signed-off-by: Petr Machata <me@pmachata.org>
---
 net/dcb/dcbnl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 084e159a12ba..7d49b6fd6cef 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1765,6 +1765,8 @@ static int dcb_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	fn = &reply_funcs[dcb->cmd];
 	if (!fn->cb)
 		return -EOPNOTSUPP;
+	if (fn->type != nlh->nlmsg_type)
+		return -EPERM;
 
 	if (!tb[DCB_ATTR_IFNAME])
 		return -EINVAL;
-- 
2.25.1

