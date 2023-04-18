Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D0A6E6FCB
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjDRXCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjDRXCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:02:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576809020
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:02:28 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 10093219D7;
        Tue, 18 Apr 2023 23:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681858947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         in-reply-to:in-reply-to:references:references;
        bh=Ew86kuSNzmlRd98jolTwOGeBQkuaZrCDPXQPRbnDyEg=;
        b=mVReNTbd0yWCGZgXSjfpKRuWHmCNvd7GQBMHcFMc5eCvcqOHkkZKSMfVvJlFPVHE38U98N
        KL/vrzCn1aZKmyhvc06xWShT+slvadzem7INGZN5b1U3tgqS3a8gZ3pW/NWDrMI/hsgQVP
        F8dxqbAs/hECu3ZWsMwrp3HrXumbhGM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681858947;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         in-reply-to:in-reply-to:references:references;
        bh=Ew86kuSNzmlRd98jolTwOGeBQkuaZrCDPXQPRbnDyEg=;
        b=S4PT8XXwv27P8vMzoRJj/K4QkRAtJb+k5OMfBsB7dGHiAz4INXT4iI3Jm4BLQIKnEonh/i
        ByIKM55TblFw3wAA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 012852C141;
        Tue, 18 Apr 2023 23:02:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CD03960517; Wed, 19 Apr 2023 01:02:26 +0200 (CEST)
Message-Id: <2a3cf93556d5f458899721aa7e7e5174d527030f.1681858286.git.mkubecek@suse.cz>
In-Reply-To: <cover.1681858286.git.mkubecek@suse.cz>
References: <cover.1681858286.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 2/3] scripts: add all included uapi files on update
To:     netdev@vger.kernel.org
Cc:     Thomas Devoogdt <thomas@devoogdt.com>
Date:   Wed, 19 Apr 2023 01:02:26 +0200 (CEST)
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On multiple occasions, we had to add another uapi header copy to fix build
on older system where system <linux/...> headers in /usr/include lacked
recent definitions or changes. To prevent these problems, update the
ethtool-import-uapi script to add all uapi headers included either from
a source file or from already copied uapi header which are not present yet.

Omit <asm/...> headers as those are architecture dependent so that we
cannot pick one random version depending on architecture a developer runs
the script on and having all versions and selecting the right one would be
too complicated.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 scripts/ethtool-import-uapi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/scripts/ethtool-import-uapi b/scripts/ethtool-import-uapi
index 8e48332cfcc8..a04a9c971a01 100755
--- a/scripts/ethtool-import-uapi
+++ b/scripts/ethtool-import-uapi
@@ -29,6 +29,32 @@ popd
 
 pushd uapi
 find . -type f -name '*.h' -exec cp -v "${kobj}/hdr/include/{}" {} \;
+
+go_on=true
+while $go_on; do
+    go_on=false
+    while read f; do
+        if [ "${f#asm/}" != "$f" ]; then
+            # skip architecture dependent asm/ headers
+            continue
+        fi
+        if [ -f "$f" ]; then
+            # already present
+            continue
+        fi
+	if [ ! -f "${kobj}/hdr/include/${f}" ]; then
+            # not a kernel header
+            continue
+        fi
+        echo "+ add $f"
+        go_on=true
+        mkdir -p "${f%/*}"
+        cp "${kobj}/hdr/include/${f}" "${f}"
+    done < <(
+        find . -type f -name '*.[ch]' -exec sed -nre '\_^[[:blank:]]*#include[[:blank:]]<.+>_ { s_^[[:blank:]]*#include[[:blank:]]<([^>]*)>.*$_\1_ ; p }' {} \; \
+            | LC_ALL=C sort -u
+    )
+done
 popd
 rm -rf "$kobj"
 
-- 
2.40.0

