Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4A9645B5A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiLGNt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLGNt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:49:27 -0500
X-Greylist: delayed 102 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Dec 2022 05:49:23 PST
Received: from forwardcorp1c.mail.yandex.net (forwardcorp1c.mail.yandex.net [178.154.239.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D5B5B59A;
        Wed,  7 Dec 2022 05:49:23 -0800 (PST)
Received: from myt6-23a5e62c0090.qloud-c.yandex.net (myt6-23a5e62c0090.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1da3:0:640:23a5:e62c])
        by forwardcorp1c.mail.yandex.net (Yandex) with ESMTP id F07875E5DC;
        Wed,  7 Dec 2022 16:47:29 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:a404::1:33])
        by myt6-23a5e62c0090.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PlYMLB0QbOs1-3FCNEUJ4;
        Wed, 07 Dec 2022 16:47:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1670420849; bh=wlk/kmPiuhOJpnEViTq2iNMZ0ypTYk84Ra5N6RKEQ/k=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=f/HHtHQVdLIpVtShc4A4WVXU/m0EHk61x5nJpWj6ef1LaW4XdrqbyceSexlP4QhEq
         xEz1uZE0nzEOpaF8zYi4FUYiOGoE9flTvPnjpnfFJRLWsW5y2tUvXa3/COvtxxhht3
         KNm3BncBffkauH4lYDuNanylUXJLJlTTl9dq8Nx8=
Authentication-Results: myt6-23a5e62c0090.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] drivers/vhost/vhost: fix overflow checks in vhost_overflow
Date:   Wed,  7 Dec 2022 16:46:31 +0300
Message-Id: <20221207134631.907221-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The if statement would erroneously check for > ULONG_MAX, which could
never evaluate to true. Check for equality instead.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826cff0..8df706e7bc6c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -730,7 +730,7 @@ static bool log_access_ok(void __user *log_base, u64 addr, unsigned long sz)
 /* Make sure 64 bit math will not overflow. */
 static bool vhost_overflow(u64 uaddr, u64 size)
 {
-	if (uaddr > ULONG_MAX || size > ULONG_MAX)
+	if (uaddr == ULONG_MAX || size == ULONG_MAX)
 		return true;
 
 	if (!size)
-- 
2.25.1

