Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1F767C4B8
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbjAZHOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbjAZHOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112664A1F2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62B7B81CC6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27363C433A7;
        Thu, 26 Jan 2023 07:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717268;
        bh=41/N6LtRk6c8HHuj5ty3hxm5Z1MeaEyhWU8v1NLK7ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sgjxgCKAjuaYZbsyPkG0fwNc78pk4JbbOqWszTV4eiOn+sPHJoUaohRkwUDG8c1Rp
         erwrGIJSdP0CWptuCNmqUWE7qNtUWWCYAcnH8Lp3ZPzCDy2+9lnQmPjyYFpS8+VNxJ
         /6DBBV4RTCgPpLP6jYQj61FTYvSNDxhY7KaEqT0eQgmOsF/8NzF9LvQvr2Fp9sldV/
         ObIEZ+FS2jhz0ZfpDQBYXriJFe6aXt0vcqdMUjcG9Ey29IozVioWjgUzSbihxzV2aO
         O58M9ohR9S82XQMH97dY5xel+N2BKuOtS8HCpqI+t6Mn3lYnKQCHtb2N2sfTb3gBBO
         rnr9HqesjdDWQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, imagedong@tencent.com
Subject: [PATCH net-next 02/11] net: skbuff: drop the linux/net.h include
Date:   Wed, 25 Jan 2023 23:14:15 -0800
Message-Id: <20230126071424.1250056-3-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
References: <20230126071424.1250056-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears nothing needs it. The kernel builds fine with this
include removed, building an otherwise empty source file with:

 #include <linux/skbuff.h>
 #ifdef _LINUX_NET_H
 #error linux/net.h is back
 #endif

works too (meaning net.h is not just pulled in indirectly).

This gives us a slight 0.5% reduction in the pre-processed size
of skbuff.h.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: imagedong@tencent.com
---
 include/linux/skbuff.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4c8492401a10..b93818e11da0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -23,7 +23,6 @@
 #include <linux/atomic.h>
 #include <asm/types.h>
 #include <linux/spinlock.h>
-#include <linux/net.h>
 #include <linux/textsearch.h>
 #include <net/checksum.h>
 #include <linux/rcupdate.h>
-- 
2.39.1

