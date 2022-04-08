Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19DF4F8E5C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiDHDke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiDHDkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:40:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777E0BF31B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34FF5B829B4
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA92FC385AB;
        Fri,  8 Apr 2022 03:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649389107;
        bh=UwJl6BDqPszWwNv5VLngsMIxuMumeooPMlRztBG5mOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpCEHic5yUT+6ocSgK150R8uCh4RdLdfWrekxRcrTdAEGwxUlUtLAfYl8pnC6rk6i
         MX1WOdbB/QFOD5sXjroekCXN/tCA/gl1H50Iso6cZj+5V0IU0CzxE9o/AwYb9iw4xi
         8Yl91tW1KDfBf34S6SjqpPARRzYFFsnmquoD/srmeY8xxExa3j9Pi4iIMO4IFiWgIo
         pTB+nttFnI/62vNNXIi2EAD8uZule5mEoojBh+feJxE5Mf/aqWBHMvKmM8KVRTzt1p
         2EDz50SqgLA+ODzBs4LkPLirRtMVFJr3KgRR+Y9h7b70ePu5iycwk/e0nDWYbaNyRQ
         H6LC9VfPm8Ncg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/10] tls: rx: drop pointless else after goto
Date:   Thu,  7 Apr 2022 20:38:15 -0700
Message-Id: <20220408033823.965896-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408033823.965896-1-kuba@kernel.org>
References: <20220408033823.965896-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointless else branch after goto makes the code harder to refactor
down the line.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 3b3fe455d680..555269ad7db2 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1789,10 +1789,9 @@ int tls_sw_recvmsg(struct sock *sk,
 	if (err < 0) {
 		tls_err_abort(sk, err);
 		goto end;
-	} else {
-		copied = err;
 	}
 
+	copied = err;
 	if (len <= copied)
 		goto end;
 
-- 
2.34.1

