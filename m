Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA56E6FCA
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjDRXC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDRXC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:02:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA21F8A55
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:02:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0E97A219DA;
        Tue, 18 Apr 2023 23:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681858942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         in-reply-to:in-reply-to:references:references;
        bh=oQ+QMTbVMlzZ5DLt5kpaSF2dRBnbAMV+gqsIomm3LVw=;
        b=ujJIF+q5s7O7U022tMN1My/JIlmTXwxdbGIz9pYODOrjYnk4KkuYMFrbfTpIvG8pDCzklu
        6AjeHoMJXqs6kckcTMzU8NcDFz1c3PEEm3qBPgyu81O6Y4W9eFyei8zZnAr3O4SPYxCHb1
        Cv2FSrWQ61Dyil9qFZrfY6owCYdaaRw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681858942;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         in-reply-to:in-reply-to:references:references;
        bh=oQ+QMTbVMlzZ5DLt5kpaSF2dRBnbAMV+gqsIomm3LVw=;
        b=D/X02OzXgUmOZ+KPrA4lNJxENPINT6AEwMl2reCesScmfOzW2r4/NJisEeNelsEbg/qJw/
        st5jUvNHazrf42CA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id F2FB22C142;
        Tue, 18 Apr 2023 23:02:21 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C8F1360517; Wed, 19 Apr 2023 01:02:21 +0200 (CEST)
Message-Id: <34207c8fbffc4b35b03f2ab45d3691edc09f063e.1681858286.git.mkubecek@suse.cz>
In-Reply-To: <cover.1681858286.git.mkubecek@suse.cz>
References: <cover.1681858286.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 1/3] scripts: add ethtool-import-uapi
To:     netdev@vger.kernel.org
Cc:     Thomas Devoogdt <thomas@devoogdt.com>
Date:   Wed, 19 Apr 2023 01:02:21 +0200 (CEST)
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add script to update sanitized uapi header copies. This script has been
available on kernel.org ethtool web for some time, adding it into the
repository is going to make it more at hand and will allow tracking its
history publicly.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 scripts/ethtool-import-uapi | 41 +++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100755 scripts/ethtool-import-uapi

diff --git a/scripts/ethtool-import-uapi b/scripts/ethtool-import-uapi
new file mode 100755
index 000000000000..8e48332cfcc8
--- /dev/null
+++ b/scripts/ethtool-import-uapi
@@ -0,0 +1,41 @@
+#!/bin/bash -e
+#
+# ethtool-import-uapi [commit]
+#
+# Imports sanitized copies of kernel uapi headers from <commit> (can be
+# a commit id, a tag or a branch name). If the argument is omitted,
+# commit currently checked out in the kernel repository is used.
+
+sn="${0##*/}"
+export ARCH="x86_64"
+mkopt="-j$(nproc)" || mkopt=''
+
+if [ ! -d "$LINUX_GIT" ]; then
+    echo "${sn}: please set LINUX_GIT to the location of kernel git" >&2
+    exit 1
+fi
+
+pushd "$LINUX_GIT"
+if [ -n "$1" ]; then
+    git checkout "$1"
+fi
+desc=$(git describe --exact-match 2>/dev/null \
+       || git show -s --abbrev=12 --pretty='commit %h')
+kobj=$(mktemp -d)
+make $mkopt O="$kobj" allmodconfig
+make $mkopt O="$kobj" prepare
+make $mkopt O="$kobj" INSTALL_HDR_PATH="${kobj}/hdr" headers_install
+popd
+
+pushd uapi
+find . -type f -name '*.h' -exec cp -v "${kobj}/hdr/include/{}" {} \;
+popd
+rm -rf "$kobj"
+
+git add uapi
+git commit -s -F - <<EOT
+update UAPI header copies
+
+Update to kernel ${desc}.
+
+EOT
-- 
2.40.0

