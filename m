Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7260667F4B0
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 05:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjA1Ecg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 23:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjA1EcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 23:32:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65F97BBEB
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 20:32:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56780B8222B
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE8AC4339E;
        Sat, 28 Jan 2023 04:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674880342;
        bh=AgNHGmz/pHx5tPRVf5ALTdu81co3nVwX1T5nzqRfS9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czzO3GpwNWFOl8jVUzl5vntlzHy2WIWwrtl66T/5YYw+xZ7EsRluHz5u5eWHr/Jm+
         Xs4Z2bbAJIai+B6ulKoSzfU48H+JhVzKWYjTvGzl6NCP5VhYqmbtJUeX5LKZxJMJCG
         6PdiznEXj8GBH33U3oyh78ik2KA854Cf6DarHmGE+HnnNUeWTyCBHiTViM4ysjH9U0
         r9CNoBNo8ql76Zeehk11cXgqaj7xB9OmpYNJ6I3//gt9Hvv/gBJy7T7/EuFu2PM5el
         G7eAPapgJjzfDSw8hqz0K4+5+7gZTK/raz1w2lvd1Uj1xxbEgwt2XtYKNCHaaSEw4h
         BZGaSzEYN3LJQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/13] tools: ynl: support directional enum-model in CLI
Date:   Fri, 27 Jan 2023 20:32:10 -0800
Message-Id: <20230128043217.1572362-7-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230128043217.1572362-1-kuba@kernel.org>
References: <20230128043217.1572362-1-kuba@kernel.org>
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

Support families which use different IDs for messages
to and from the kernel.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/ynl.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index a656b655d302..690065003935 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -313,7 +313,7 @@ genl_family_name_to_id = None
 
         for msg in self.msgs.values():
             if msg.is_async:
-                self.async_msg_ids.add(msg.value)
+                self.async_msg_ids.add(msg.rsp_value)
 
         for op_name, op in self.ops.items():
             bound_f = functools.partial(self._op, op_name)
@@ -398,7 +398,7 @@ genl_family_name_to_id = None
         if self.include_raw:
             msg['nlmsg'] = nl_msg
             msg['genlmsg'] = genl_msg
-        op = self.msgs_by_value[genl_msg.genl_cmd]
+        op = self.rsp_by_value[genl_msg.genl_cmd]
         msg['name'] = op['name']
         msg['msg'] = self._decode(genl_msg.raw_attrs, op.attr_set.name)
         self.async_msg_queue.append(msg)
@@ -435,7 +435,7 @@ genl_family_name_to_id = None
             nl_flags |= Netlink.NLM_F_DUMP
 
         req_seq = random.randint(1024, 65535)
-        msg = _genl_msg(self.family.family_id, nl_flags, op.value, 1, req_seq)
+        msg = _genl_msg(self.family.family_id, nl_flags, op.req_value, 1, req_seq)
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value)
         msg = _genl_msg_finalize(msg)
@@ -458,7 +458,7 @@ genl_family_name_to_id = None
 
                 gm = GenlMsg(nl_msg)
                 # Check if this is a reply to our request
-                if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.value:
+                if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.rsp_value:
                     if gm.genl_cmd in self.async_msg_ids:
                         self.handle_ntf(nl_msg, gm)
                         continue
-- 
2.39.1

