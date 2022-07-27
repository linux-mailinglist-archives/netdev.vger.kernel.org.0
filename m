Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564A9581E13
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240271AbiG0DPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240254AbiG0DPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:15:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166E7DF04
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:15:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9030DB81F4F
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FCBC43142;
        Wed, 27 Jul 2022 03:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891729;
        bh=sna5E5sG3oBAOlbVSdT6jMHgsjMQhZFKpv2LSh4jnGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFL4Zufjfxxj3Kv23X7ci1tcjUd6DEh/yJp7MGVR8w0qzToH8vxPvv4rHR48JlTNc
         wp3FO9itiq6QIh9p07ZCt0hGaJmcZPrcmUp6psuROlv+Nr158f4zEMoxvFa9CFqVau
         KwqREU4+5CIu/0qGloxEtzm40YXn4AU9UB+e+vmDmjfiDVrfezAlYX8aJXJSYzGgQE
         /l4Baptj1LXAHC4DzMC6jdwdSZcUG3q6qHJ/Sc2bxMOrRm7j0KOjxkZ/bDqYMfc5pJ
         PYjcdCO8Rg/S/d0RU1tA9INSFizpLElTCLtDUeNiHwFqEGYyYngY+7DQ2QbXtdM+kF
         650ANy87UEtDA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/4] tls: strp: rename and multithread the workqueue
Date:   Tue, 26 Jul 2022 20:15:23 -0700
Message-Id: <20220727031524.358216-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727031524.358216-1-kuba@kernel.org>
References: <20220727031524.358216-1-kuba@kernel.org>
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

Paolo points out that there seems to be no strong reason strparser
users a single threaded workqueue. Perhaps there were some performance
or pinning considerations? Since we don't know (and it's the slow path)
let's default to the most natural, multi-threaded choice.

Also rename the workqueue to "tls-".

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index b945288c312e..3f1ec42a5923 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -480,7 +480,7 @@ void tls_strp_done(struct tls_strparser *strp)
 
 int __init tls_strp_dev_init(void)
 {
-	tls_strp_wq = create_singlethread_workqueue("kstrp");
+	tls_strp_wq = create_workqueue("tls-strp");
 	if (unlikely(!tls_strp_wq))
 		return -ENOMEM;
 
-- 
2.37.1

