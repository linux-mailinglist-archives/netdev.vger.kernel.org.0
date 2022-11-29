Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482DA63BA4F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiK2HJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiK2HJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:09:28 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8A3554DE;
        Mon, 28 Nov 2022 23:09:19 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669705758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5JK4HIoKLg9eKYYRXNDI+1aSi/Jo6Jz3mVRFqz5T8nI=;
        b=TxQfqP8JzQuqK8rQBPYv45Xl075df8+AwAUWGFevmopf7EPtLSyIlL5Lga8jZH3MxNfcWJ
        73kOFAyBQvIuQLQR2LibrxWl+xLhR0e5LYCkRnh+RWbHjZbX1u0LWSqrTTI7JCAmTmjO7e
        I04G+BZahLCi1/Wl1vv7PyDg6lavKlE=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf-next 5/7] selftests/bpf: Remove the "/sys" mount and umount dance in {open,close}_netns
Date:   Mon, 28 Nov 2022 23:08:58 -0800
Message-Id: <20221129070900.3142427-6-martin.lau@linux.dev>
In-Reply-To: <20221129070900.3142427-1-martin.lau@linux.dev>
References: <20221129070900.3142427-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The previous patches have removed the need to do the mount and umount
dance when switching netns. In particular:
* Avoid remounting /sys/fs/bpf to have a clean start
* Avoid remounting /sys to get a ifindex of a particular netns

This patch can finally remove the mount and umount dance in
{open,close}_netns which is unnecessarily complicated and
error-prone.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c | 51 ++-----------------
 1 file changed, 5 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 1f37adff7632..01de33191226 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -390,49 +390,6 @@ struct nstoken {
 	int orig_netns_fd;
 };
 
-static int setns_by_fd(int nsfd)
-{
-	int err;
-
-	err = setns(nsfd, CLONE_NEWNET);
-	close(nsfd);
-
-	if (!ASSERT_OK(err, "setns"))
-		return err;
-
-	/* Switch /sys to the new namespace so that e.g. /sys/class/net
-	 * reflects the devices in the new namespace.
-	 */
-	err = unshare(CLONE_NEWNS);
-	if (!ASSERT_OK(err, "unshare"))
-		return err;
-
-	/* Make our /sys mount private, so the following umount won't
-	 * trigger the global umount in case it's shared.
-	 */
-	err = mount("none", "/sys", NULL, MS_PRIVATE, NULL);
-	if (!ASSERT_OK(err, "remount private /sys"))
-		return err;
-
-	err = umount2("/sys", MNT_DETACH);
-	if (!ASSERT_OK(err, "umount2 /sys"))
-		return err;
-
-	err = mount("sysfs", "/sys", "sysfs", 0, NULL);
-	if (!ASSERT_OK(err, "mount /sys"))
-		return err;
-
-	err = mount("bpffs", "/sys/fs/bpf", "bpf", 0, NULL);
-	if (!ASSERT_OK(err, "mount /sys/fs/bpf"))
-		return err;
-
-	err = mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL);
-	if (!ASSERT_OK(err, "mount /sys/kernel/debug"))
-		return err;
-
-	return 0;
-}
-
 struct nstoken *open_netns(const char *name)
 {
 	int nsfd;
@@ -453,8 +410,9 @@ struct nstoken *open_netns(const char *name)
 	if (!ASSERT_GE(nsfd, 0, "open netns fd"))
 		goto fail;
 
-	err = setns_by_fd(nsfd);
-	if (!ASSERT_OK(err, "setns_by_fd"))
+	err = setns(nsfd, CLONE_NEWNET);
+	close(nsfd);
+	if (!ASSERT_OK(err, "setns"))
 		goto fail;
 
 	return token;
@@ -465,6 +423,7 @@ struct nstoken *open_netns(const char *name)
 
 void close_netns(struct nstoken *token)
 {
-	ASSERT_OK(setns_by_fd(token->orig_netns_fd), "setns_by_fd");
+	ASSERT_OK(setns(token->orig_netns_fd, CLONE_NEWNET), "setns");
+	close(token->orig_netns_fd);
 	free(token);
 }
-- 
2.30.2

