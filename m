Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDC78C825
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfHNCRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:17:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbfHNCRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060DA21743;
        Wed, 14 Aug 2019 02:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749020;
        bh=PffihcjvD0g7CbrtREsuGAPrLh7k4Se+VjzT2+ZC7nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UukRyRbK34yNNxl+LIQgqJIpzlcE7J1A775+Xcxd9ZNiUyhIiLQ394140nufhjdoe
         3tT0bbBDZtqWJ6J+eggwJYDoZ3BtuqxqD9RMn6MvWFKFgX7BU84ZmGpACu4noPrR8G
         YsD5Lp32YBC0noyEGbUnP3RNxhYYtx4t2ov/NnwY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Xiayang <xywang.sjtu@sjtu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 39/68] net/ethernet/qlogic/qed: force the string buffer NULL-terminated
Date:   Tue, 13 Aug 2019 22:15:17 -0400
Message-Id: <20190814021548.16001-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>

[ Upstream commit 3690c8c9a8edff0db077a38783112d8fe12a7dd2 ]

strncpy() does not ensure NULL-termination when the input string
size equals to the destination buffer size 30.
The output string is passed to qed_int_deassertion_aeu_bit()
which calls DP_INFO() and relies NULL-termination.

Use strlcpy instead. The other conditional branch above strncpy()
needs no fix as snprintf() ensures NULL-termination.

This issue is identified by a Coccinelle script.

Signed-off-by: Wang Xiayang <xywang.sjtu@sjtu.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index b22f464ea3fa7..f9e475075d3ea 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -939,7 +939,7 @@ static int qed_int_deassertion(struct qed_hwfn  *p_hwfn,
 						snprintf(bit_name, 30,
 							 p_aeu->bit_name, num);
 					else
-						strncpy(bit_name,
+						strlcpy(bit_name,
 							p_aeu->bit_name, 30);
 
 					/* We now need to pass bitmask in its
-- 
2.20.1

