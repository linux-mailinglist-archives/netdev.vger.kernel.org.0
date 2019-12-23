Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE1C129673
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 14:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLWN24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 08:28:56 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44803 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726676AbfLWN24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 08:28:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6FB5621BF9;
        Mon, 23 Dec 2019 08:28:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 08:28:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=5GKCO1NfaI9n0X5f0MumRgH9ey4vfegTBOnPqq+MgM0=; b=W2UL7loK
        0z1O8QLpChUoGb90MSJP5AfQl2+z0dpeq1SoWiTPa5Fhw1KIxlf0bLTi3OLrQnlj
        r8N0S9bOH/3p1gimTbdSEKL5LvMGg1dKhtldApvSeOQmcI+xVbyfB5rap/JNliak
        dTFoA7YkVYpgi8/LXnQIGHTs7edn+IC0MFnrSKwDTYD6TDQGiHOWU7VgHFyiMNja
        OU4AOtuXOfx6siD7bF39JhR4iELNfAkkCS0EA83QBG0EpzgkXjWxfDNsNkGkZs1s
        okfjOFd8lAUHmzyYyJHBwSBhClOt5z/qHptkm9GFZ0DRycfQhjg5rPgDT77xZyDg
        jxQsbMx8IHlHwg==
X-ME-Sender: <xms:F8EAXv0tlbRW-Kbqt37t-7wCLkvIcGGX74WxKfLSlOkrwfKasS6wlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:F8EAXiAqPIS5Z9S_vf6qv2OyDWXOWClPFtsK3Th3QzATLsXex8UJcw>
    <xmx:F8EAXobvszklQNqt90NrnlXsz7XHx-yC_aVf9xtat3ChHbggBQniyw>
    <xmx:F8EAXuZwM7Brs421_G8nVKZUgxPTo_TN1YLszxoSkN4i0JtPboQ_-Q>
    <xmx:F8EAXs3XGB23-bqMIokG9hZ3xQlh8pOcCUUFZJ-vPDUOaHb2a0uZOA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B9473060AAA;
        Mon, 23 Dec 2019 08:28:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/9] net: fib_notifier: Add temporary events to the FIB notification chain
Date:   Mon, 23 Dec 2019 15:28:12 +0200
Message-Id: <20191223132820.888247-2-idosch@idosch.org>
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

Subsequent patches are going to simplify the IPv6 route offload API,
which will only use three events - replace, delete and append.

Introduce a temporary version of replace and delete in order to make the
conversion easier to review. Note that append does not need a temporary
version, as it is currently not used.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
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
2.24.1

