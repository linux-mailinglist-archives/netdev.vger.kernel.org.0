Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C4024EC1F
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgHWIHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:07:55 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42421 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728121AbgHWIHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:07:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 506DF5C00CC;
        Sun, 23 Aug 2020 04:07:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GM5l4fy+PnArPH0RRU6fcGrVx1WsoGJPVOhQt3PkpL8=; b=V+qUm0IO
        a0cXb/s9LGeTw6gflOUFMLj2rUPSFz2n/KxgfzxXXzAX7Q+JRgETxv1XjOR4Gn+7
        nHcr5hdd5b7e/h5L+DVFj5pg0brFaOIF78XZXDxyO2muomjMLVcE+jz3e5BQTPH9
        aJP3cPIqzn53Dl5KaRg9XI8eHooapWNV+NQnk1eUGsTpI7srQUGt5Q8msPqqKwxI
        bNZ2sdZdCg3H31rtaWFSgE3Q+p4R1eHIbup+jD6dwjcOo4eVUhxgruSKCGMeLGKH
        ykJSIRwp7d/bEUKNs6vN6trPA7XRgpUM4NmZAu6eMSJl63B4ABvWLMXcocn+oZBG
        COCyMrYeqPIL0Q==
X-ME-Sender: <xms:1iNCXyPE9a2xWBMtD3UXnS0agzxJiEn50IFy1XpwJScu_vVOxIYEEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhefgtd
    fftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeekrddufedurdefheenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:1iNCXw8RFlIF_9_np74H7-6dJT-9wVQkJ5ZKL66v0s-BjGeQC2Zw2w>
    <xmx:1iNCX5QV7XnDNJJJqrJJSFr6RO7-_RzThSrD00YhtGMAl1oxrPSBHg>
    <xmx:1iNCXyuUqGzedeJZDFOul-AY2wTvnWO0sV8v2oKpVsW_VOkkJgD4RA>
    <xmx:1iNCX-HZT_DGxqreM0oNqgfMSv_cYKNmOo0vHb8mrgLQ7I71eGhwMw>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1971B3280059;
        Sun, 23 Aug 2020 04:07:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/7] selftests: mlxsw: Increase burst size for rate test
Date:   Sun, 23 Aug 2020 11:06:24 +0300
Message-Id: <20200823080628.407637-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The current combination of rate and burst size does not adhere to
Spectrum-{2,3} limitation which states that the minimum burst size
should be 40% of the rate.

Increase the burst size in order to honor above mentioned limitation and
avoid intermittent failures of this test case on Spectrum-{2,3}.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
index bd4ffed1cca3..ecba9ab81c2a 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
@@ -207,7 +207,7 @@ __rate_test()
 
 	RET=0
 
-	devlink trap policer set $DEVLINK_DEV policer $id rate 1000 burst 16
+	devlink trap policer set $DEVLINK_DEV policer $id rate 1000 burst 512
 	devlink trap group set $DEVLINK_DEV group l3_drops policer $id
 
 	# Send packets at highest possible rate and make sure they are dropped
-- 
2.26.2

