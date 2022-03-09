Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7357A4D379F
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbiCIQey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239587AbiCIQdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:33:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592941AD39C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:28:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1194561973
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A78CC340EC;
        Wed,  9 Mar 2022 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843320;
        bh=x+ZtHawGGr2C3B3ZHNVbqNgf3OV5xbP3GuZ6o7r9J/o=;
        h=From:To:Cc:Subject:Date:From;
        b=WqVz0kWbCC6IFCGqD5EQoNNH/lkRJe0A0pjOX243tyndarqIzcvhvjtQBE39ZdQZm
         fJJSIvOawn/UO0tDgkb6gnnZA0px9uCVgSA1yCuxvIrAH72stqphjgN7eXnPg/dQzk
         nZC2Owz4Veq6FDr1Hid/IePr+rGGc5miuwUc18GRrU3Her/ywXthGBHBCuZnOAY3mf
         czmjrV2F3aftZp0t1D0IjfsTB4oPO8pqGppoS1us17dvhIAhZZUR8P1DTW01HtBMF4
         pN1E7D1M+Fn9dC8TX4uo0+vX1NC7vPwuBhpAYo0G4UUBRbCE7+tODG5SAjMTxq/FvS
         1kt6XvfzWGLUQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] tcp: fix build problem in tcp_inbound_md5_hash()
Date:   Wed,  9 Mar 2022 08:28:37 -0800
Message-Id: <20220309162837.407914-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Semicolon snuck in, this breaks the build with CONFIG_TCP_MD5SIG=n.

Fixes: 4be98688274d ("skb: make drop reason booleanable")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/tcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index ee8237b58e1d..70ca4a5e330a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1693,7 +1693,7 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 static inline enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
-		     int family, int dif, int sdif);
+		     int family, int dif, int sdif)
 {
 	return SKB_NOT_DROPPED_YET;
 }
-- 
2.34.1

