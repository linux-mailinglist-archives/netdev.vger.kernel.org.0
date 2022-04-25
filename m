Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FA450ECAD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 01:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbiDYXgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 19:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiDYXgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 19:36:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A879072E0B
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4572E615CE
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 23:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B133C385A7;
        Mon, 25 Apr 2022 23:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650929592;
        bh=pJOXMwtLRC3fZcpU9indsg6hexRnrn/x7TeF+CjAc7o=;
        h=From:To:Cc:Subject:Date:From;
        b=rhfrcudzAOIF6/0GIfbPuYX9wjkC9i+A1Y4c2S9NH22/vahhgOKjYun+leqJhxllj
         vNMNuUTirDjNY1jm834JTNswCmVf7ve+trMhAmN5HqNU/03+XPPg7SbhsFh8i+j4Z1
         QauNFlPGMvqly5oPY20Jm2S5vNAaVgItOUEYv7PsXCdEVDVINncSO/1MwlsX72fG7O
         zJrknURFhKgGJWjjxPbg4X6CsQlrn+y+T/VWMYnEZGNkbLF04LY4fWID0Sw44RWrQR
         BzVgMh/US9wREtZ4iMMaIbIUfOx5jDVJ57gHzbRGUIgAoMm2gdEGKHGD0Chu1ksvk0
         LOc4xr4AO8Dmg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, gal@nvidia.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: tls: fix async vs NIC crypto offload
Date:   Mon, 25 Apr 2022 16:33:09 -0700
Message-Id: <20220425233309.344858-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NIC takes care of crypto (or the record has already
been decrypted) we forget to update darg->async. ->async
is supposed to mean whether record is async capable on
input and whether record has been queued for async crypto
on output.

Reported-by: Gal Pressman <gal@nvidia.com>
Fixes: 3547a1f9d988 ("tls: rx: use async as an in-out argument")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index ddbe05ec5489..80094528eadb 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1562,6 +1562,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 
 	if (tlm->decrypted) {
 		darg->zc = false;
+		darg->async = false;
 		return 0;
 	}
 
@@ -1572,6 +1573,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		if (err > 0) {
 			tlm->decrypted = 1;
 			darg->zc = false;
+			darg->async = false;
 			goto decrypt_done;
 		}
 	}
-- 
2.34.1

