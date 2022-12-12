Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64636649CC2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiLLKne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiLLKl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:41:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF410101DB;
        Mon, 12 Dec 2022 02:36:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ADC2B80CA7;
        Mon, 12 Dec 2022 10:36:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAD2C433EF;
        Mon, 12 Dec 2022 10:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841416;
        bh=wObvOxVgY81+JnwDbGQdVQsAyZ8ybz3FsHdnVYGLBTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZAiBPGZt7vs4FiudlrbcPJ/6mt0bQ8cjkP+3uDCYjm1LMfIfmcg+7hnMKoLV62W5
         dV8aVipLFn2iJv6kOgDYfft9X7q9x2AI0cS38XDaKu8p9qmhudJpmAtg8s7MljMwcq
         i6OXoTh/X2+qNK58uCyCYIso83qoaY/Naf97nbBf8zbxHFgxfXOPp68FnIfKN/m9xn
         +tpwr1J2zC+8vCx1x5kB9FYX1Trmj6CAmtAHUZuBrakX177jy8a8oM1Xungyh3MFPP
         gGZi3082uqRY5c3NDb2o62V7n1WVt3QLksi4z6Q329RTlFvGdGfcyAvjKvqG+xIGSI
         9JA/IPOsGGzXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/2] net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
Date:   Mon, 12 Dec 2022 05:36:49 -0500
Message-Id: <20221212103650.300515-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103650.300515-1-sashal@kernel.org>
References: <20221212103650.300515-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]

When the name_assign_type attribute was introduced (commit
685343fc3ba6, "net: add name_assign_type netdev attribute"), the
loopback device was explicitly mentioned as one which would make use
of NET_NAME_PREDICTABLE:

    The name_assign_type attribute gives hints where the interface name of a
    given net-device comes from. These values are currently defined:
...
      NET_NAME_PREDICTABLE:
        The ifname has been assigned by the kernel in a predictable way
        that is guaranteed to avoid reuse and always be the same for a
        given device. Examples include statically created devices like
        the loopback device [...]

Switch to that so that reading /sys/class/net/lo/name_assign_type
produces something sensible instead of returning -EINVAL.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index d192936b76cf..7863918592db 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -210,7 +210,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
-- 
2.35.1

