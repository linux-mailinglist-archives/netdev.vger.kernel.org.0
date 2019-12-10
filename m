Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB85118EEA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfLJRYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:24:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42413 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727561AbfLJRYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:24:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 81EFB22008;
        Tue, 10 Dec 2019 12:24:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Dec 2019 12:24:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=y/FtCl0QftzNvgOtn8pCj5olUEonpOtX8nx8teDiBjU=; b=TN4tsnkz
        +wygMDp5twcnUy/AfLAZbRj2lK/WeId132bk1waCskCSipmLeMVSwu3kocpA1+r0
        cXXsI13LSLToTi6kugZIQWAc1UXQdLYN/fxuKsUnrLCp4X0nt3Gt4S7AirFqypQi
        ynU04vo8JM12VsW/w0I7zvcc9hPrKuZwAtpnDSfTF+FfFzbrB/rhbwPjNldJ8MN9
        rD0PsXTVZIXid9EB20nV2Of+7mOIwDFGqYOZ922LeYU5vMtNH6YWyuub3uKUoGBd
        2n9Oi/3eTO5HiWAs7gofFjbLilHASUr2kbwTblWsxwqt5l1jwAlusJuv4V3ZU+Zq
        IUD+Or+HYE9xOA==
X-ME-Sender: <xms:4dTvXUWxvc_GOuw9qmNqjAesByubbcu1xYhORWV18F-42WYT-TtaqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudelfedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:4dTvXaZGcKTZeKsgZwqjMxAqMRxQZVZQYZhpWqcHMektyUxh8D1Ngw>
    <xmx:4dTvXXhWVA-eHt_b5Onz_gGY2paaO2DY7p4dTnAGTZB2cryxv51L0g>
    <xmx:4dTvXWoqEufE4SUbaHWpD6ygWP2lKq4v4Kd5EdVqu8MfVu8FOMFghw>
    <xmx:4dTvXavlR81U1c9fp86zu2qDlpMdmHp0sKAs5jXiu0cjZJG79TbFxQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D99D8005C;
        Tue, 10 Dec 2019 12:24:48 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/9] net: fib_notifier: Add temporary events to the FIB notification chain
Date:   Tue, 10 Dec 2019 19:23:54 +0200
Message-Id: <20191210172402.463397-2-idosch@idosch.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191210172402.463397-1-idosch@idosch.org>
References: <20191210172402.463397-1-idosch@idosch.org>
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

