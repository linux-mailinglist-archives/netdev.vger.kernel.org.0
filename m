Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABEBC49C0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfJBIlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46125 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfJBIlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B3B3217DD;
        Wed,  2 Oct 2019 04:41:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=4gI1xXMO6ADs28S+fqwxb1iqtfH1ULfLs1z3cyLCMZs=; b=S+wocu4u
        tWt8EwQU+t0qwstMKKubLVmMOFMdoiNJnWO0+5VJF9fzAu11J0w22W5XSy1jSlxN
        1nj9iL6Ld/qqFgP7h0/RJpqPnXu0EY49UNEIL6TBtU3Ko9grM+vu0M6yQrNnSVPU
        JsiMfOxI0XieTpkiUuBhTfSxJtbQpsJjgXGSMBN0LQW2Gxfgvs5Hv9Q/SjOSYb9J
        /cGBo+++BlcGD1hXxnZJbbxtnC3W7xuJgS0qJNkgcJ1+V2Mz+LraZqK9ALr1P7fA
        F+4x3zG/AEQ3/VXH7Dhdlo4IHmBdi3Td3KJed/gjIokZxpdkUOtnHjylXwS1ugAd
        UcQcWxrt5HV58g==
X-ME-Sender: <xms:u2KUXabCFOL2pbcMwqMIAbMp2gKBm98duVaeJBbkLMzd1YXfCrb7bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:u2KUXZEXWjnuZo6-2nzODqVmuna097yrPKdd5WqFYPmv1rYxjU52Xw>
    <xmx:u2KUXQk0oNjWhQhu-s9y4vlpjdeyt_krs8KWDl1CP8ymbJDC6hsigA>
    <xmx:u2KUXYycpuDuIQFXkegf8EVaRUb-jB03jVoA48Qj9DKBr0ZE7pQHMQ>
    <xmx:u2KUXVAq2Ou3_epcEPXZ6yZH36EJmESc8amuGWf6ejvnCppiP9HeGA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D9E14D60062;
        Wed,  2 Oct 2019 04:41:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 01/15] ipv4: Add temporary events to the FIB notification chain
Date:   Wed,  2 Oct 2019 11:40:49 +0300
Message-Id: <20191002084103.12138-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Subsequent patches are going to simplify the IPv4 route offload API,
which will only use two events - replace and delete.

Introduce a temporary version of these two events in order to make the
conversion easier to review.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/fib_notifier.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/fib_notifier.h b/include/net/fib_notifier.h
index 6d59221ff05a..b3c54325caec 100644
--- a/include/net/fib_notifier.h
+++ b/include/net/fib_notifier.h
@@ -23,6 +23,8 @@ enum fib_event_type {
 	FIB_EVENT_NH_DEL,
 	FIB_EVENT_VIF_ADD,
 	FIB_EVENT_VIF_DEL,
+	FIB_EVENT_ENTRY_REPLACE_TMP,
+	FIB_EVENT_ENTRY_DEL_TMP,
 };
 
 struct fib_notifier_ops {
-- 
2.21.0

