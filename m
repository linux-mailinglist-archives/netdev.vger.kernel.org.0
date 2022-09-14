Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F695B85A5
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiINJxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiINJxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:53:15 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E294073938
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 02:52:26 -0700 (PDT)
Received: from fsav414.sakura.ne.jp (fsav414.sakura.ne.jp [133.242.250.113])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28E9pwQ9089373;
        Wed, 14 Sep 2022 18:51:58 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav414.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp);
 Wed, 14 Sep 2022 18:51:58 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28E9pwX5089370
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 14 Sep 2022 18:51:58 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <d06d0f7f-696c-83b4-b2d5-70b5f2730a37@I-love.SAKURA.ne.jp>
Date:   Wed, 14 Sep 2022 18:51:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Network Development <netdev@vger.kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] net: clear msg_get_inq in __get_compat_msghdr()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is still complaining uninit-value in tcp_recvmsg(), for
commit 1228b34c8d0ecf6d ("net: clear msg_get_inq in __sys_recvfrom() and
__copy_msghdr_from_user()") missed that __get_compat_msghdr() is called
instead of copy_msghdr_from_user() when MSG_CMSG_COMPAT is specified.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 1228b34c8d0ecf6d ("net: clear msg_get_inq in __sys_recvfrom() and __copy_msghdr_from_user()")
---
 net/compat.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/compat.c b/net/compat.c
index fe9be3c56ef7..385f04a6be2f 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -52,6 +52,7 @@ int __get_compat_msghdr(struct msghdr *kmsg,
 		kmsg->msg_namelen = sizeof(struct sockaddr_storage);
 
 	kmsg->msg_control_is_user = true;
+	kmsg->msg_get_inq = 0;
 	kmsg->msg_control_user = compat_ptr(msg->msg_control);
 	kmsg->msg_controllen = msg->msg_controllen;
 
-- 
2.18.4

