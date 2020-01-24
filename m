Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78231485F1
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389757AbgAXNYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:32 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43371 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387915AbgAXNYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8660421F4C;
        Fri, 24 Jan 2020 08:24:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=aJ0ZJsvGAigkU0kAAyOIHN9MVsJMtw9xE0aGNsXPYkU=; b=Zzawgfm9
        VODvY66/2mSL1YijwcvieDXDEElgn9fKPVjsTLsktGNLK9oGpXZHI1eyO21z8944
        djUQaZSRY6KjYm3wUWNudG87MaHNhFc87O0Mj8umEsgHumyAHtlgznU/ZDL21hcx
        z5EVQ0gATcOeNnc5CyBkqB2PLP1I9zqx6/SeG/NUNbUk7sFR0NOUnnrDbsm5Tu3Z
        rBbiwegTBd+VSc8PO9Rfzv7iG1uS/cqMbg29f7WFsll44HJZzk6Hvj2syLgPyfsK
        lH8UaY90R5ISS+ko9L0r2w7pTnbRuLcC3GqRqcOXK0NKajRCsi9WhItYPbX/3XnD
        M8xutm1qkNBGqQ==
X-ME-Sender: <xms:DvAqXqqF0Scp4_EMqGuLcgfwdF8Wj8T683MSra6vyuM7kfvBkIDkKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:DvAqXkXcM6USFDI_wMlK8yqpLCeUcRDEXrq4dITG9rOOVZlGmuS_mg>
    <xmx:DvAqXnO7RkX0ITP7rJWpGzFEyfA4o3aDcZWoTl9lOt6OOaoN-wOdzA>
    <xmx:DvAqXoCxRdjA04VtDSIlZtGgryZUwWXXBn4d7AXn6HvvWbcp-4IqMQ>
    <xmx:DvAqXnvgoTHE9q2vxs3EWVxbv3LeZalZHHiDrXjx2SSzoUrODJThew>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76B9A3061106;
        Fri, 24 Jan 2020 08:24:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/14] selftests: forwarding: lib: Add helpers for busywaiting
Date:   Fri, 24 Jan 2020 15:23:16 +0200
Message-Id: <20200124132318.712354-13-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The function busywait() is handy as a safety-latched variant of a while
loop. Many selftests deal specifically with counter values, and busywaiting
on them is likely to be rather common (it is not quite common now, but
busywait() has not been around for very long). To facilitate expressing
simply what is tested, introduce two helpers:

- until_counter_is(), which can be used as a predicate passed to
  busywait(), which holds when expression, which is itself passed as an
  argument to until_counter_is(), reaches a desired value.

- busywait_for_counter(), which is useful for waiting until a given counter
  changes "by" (as opposed to "to") a certain amount.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 10cdfc0adca8..096340f064db 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -248,6 +248,24 @@ busywait()
 	done
 }
 
+until_counter_is()
+{
+	local value=$1; shift
+	local current=$("$@")
+
+	echo $((current))
+	((current >= value))
+}
+
+busywait_for_counter()
+{
+	local timeout=$1; shift
+	local delta=$1; shift
+
+	local base=$("$@")
+	busywait "$timeout" until_counter_is $((base + delta)) "$@"
+}
+
 setup_wait_dev()
 {
 	local dev=$1; shift
-- 
2.24.1

