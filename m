Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDCB11F29F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 16:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfLNPyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 10:54:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:43811 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfLNPyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 10:54:51 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 57A072255B;
        Sat, 14 Dec 2019 10:54:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 14 Dec 2019 10:54:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=y/FtCl0QftzNvgOtn8pCj5olUEonpOtX8nx8teDiBjU=; b=DJagt5ec
        ea60TdhLDAOqtrdWWUqLi6qiRIUAlxrrR7XAv6tHtUPZ2RxeaBzFppr8SF8gTZDC
        OZt11CV+hyL2eqVHZLmTV6CoRH3Ryc7IfhdIqrnhNpHnDsHapbFfgeUauo+6FMLW
        APKzCFEPEqcSrjTsZ0U8oifr4F4/yIRNAbe/KhtZSeB/c2WRcl/Ehtiw4o7hGawx
        aRsEwH6kpEaTOdbIWu9toxWR05g12C6YkmFEBfzmoG12yBixn54v6gAsJSb0cGrC
        f5oq83W9EvcTDwqOIC7D1kr+Wf2pn0vmBT+MqutNqGpNtKSJK3EitAFbYsGWosbx
        jq+j63fc6mvO1w==
X-ME-Sender: <xms:ygX1XaIxfQfaRkf3MUBfWbvpf1OCobvT-hZ5QMxjMXTwtsHqtndo2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekvddruddtjedrieejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:ygX1Xd37QH00PXh_Kd9gYgCn2Mt9Sw_oHDN57EeJwadZozlCfJm2GQ>
    <xmx:ygX1XeVo60bhhKgXHZuHTQimQvXLJsJHIwVnh35zuOvIfpMlq-L8wg>
    <xmx:ygX1Xfo1l-jz7vi6uYbJ6iX0cUufycWsX3R19O4ivGF5jAqUkTsaNQ>
    <xmx:ygX1XUu8FDODzHcCJ2T9CMBGIMW9u6sbnt2-WaCrgWPJDWBPiHTtEg>
Received: from splinter.mtl.com (bzq-79-182-107-67.red.bezeqint.net [79.182.107.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3629A8005C;
        Sat, 14 Dec 2019 10:54:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 01/10] net: fib_notifier: Add temporary events to the FIB notification chain
Date:   Sat, 14 Dec 2019 17:53:06 +0200
Message-Id: <20191214155315.613186-2-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191214155315.613186-1-idosch@idosch.org>
References: <20191214155315.613186-1-idosch@idosch.org>
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
2.23.0

