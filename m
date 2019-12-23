Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EDB129674
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLWN27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:28:59 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55481 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbfLWN27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:28:59 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 566A521240;
        Mon, 23 Dec 2019 08:28:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:28:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=gWffXrYe8XhOtZo/rbQte9ePKcjJ6hiouR3PUpAkNSQ=; b=eVg8Fn+K
        PcNbi61TOKmtGlVgJIu3RDGuH2BuTnyKQAXCl5dhWMwuwYsBWfJnm4s9Sm2+jfBN
        j4EBYvYEwMCjc+hTfmpTUTkcVr+ziVZjMSfoCCQOnm0gjHuPMWK6eYKtYjVBSlwq
        cBDYKm54xih7jxD95dw8ZvoFldrwf9wLsSAzWFrkYtmU6jSEZgLLDlHLKxq1S26o
        4B1yHwNfOB8kV7HFqqCuS+UQBtD5f0h2SbA172Oo/7WJtox6QmU8RqzA0iieN666
        bsn4M63A0nrdDq6L1EPfcTtB8SXSWuqAGWa2nC3cPLm0ZU15eAzDUNl7fDhWfhxQ
        P9UNzxeXcDFF0g==
X-ME-Sender: <xms:GsEAXhcHq-nHkz1U6kWD3qDIfdKlsOVs91taFYvNx4AH3ezM7KQwlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:GsEAXv0eSAKd5PrFZTMyj701btEeOwcnJXPPwhDHSfQ1PxB6AqzmZg>
    <xmx:GsEAXlpPWhJz9ctONcdvrpAuFZ7c8BkvEX2KJLdb_BWh2cMG1RunfA>
    <xmx:GsEAXvivYUGnhwX6rFQbS_IkuU0DqT70gNVhRMJmxW8RVul3oRHQCg>
    <xmx:GsEAXgg3qQFHNR0jV1Ik56mZYXyHNyqRviXc5B6ZLNNq2zHc4ISjmQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 003E430609A0;
        Mon, 23 Dec 2019 08:28:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/9] ipv6: Notify route if replacing currently offloaded one
Date:   Mon, 23 Dec 2019 15:28:14 +0200
Message-Id: <20191223132820.888247-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191223132820.888247-1-idosch@idosch.org>
References: <20191223132820.888247-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Similar to the corresponding IPv4 patch, only notify the new route if it
is replacing the currently offloaded one. Meaning, the one pointed to by
'fn->leaf'.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/ipv6/ip6_fib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 045bcaf5e770..7cf9554888b0 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1231,6 +1231,13 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 		}
 
 		if (!info->skip_notify_kernel) {
+			enum fib_event_type fib_event;
+
+			fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+			if (ins == &fn->leaf)
+				err = call_fib6_entry_notifiers(info->nl_net,
+								fib_event, rt,
+								extack);
 			err = call_fib6_entry_notifiers(info->nl_net,
 							FIB_EVENT_ENTRY_REPLACE,
 							rt, extack);
-- 
2.24.1

