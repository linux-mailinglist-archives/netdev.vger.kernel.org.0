Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75A75A656F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiH3NtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiH3Nsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:48:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC4510D4E2;
        Tue, 30 Aug 2022 06:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661867186; x=1693403186;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=er/Bc3XN5jHRYzy7lTmhugLOgFMGvSCPFonl4dxsKnk=;
  b=Xdt88dJFDa5UW3TKbXvqMfqgNmjzy8zvOUPENsSYpDswHyEYYdfJxhNs
   mOPzjC9bSbqG5bGN1OZfxD4Sgj66GfSc+VvexZwkOu28yd8DxfJvMmrGC
   ZnkanmA+MPyx8LtCNTiRubT5WzgO1CvfLp13NpWYeDcrx3nBZflubSxfn
   mqpmBRyoq6Laj1hPBBJMPoIAqNnWlaooOYydQ69gqi8S9ALzQ45IH6ft2
   d7RcUV2YcD7HwOxXXSqmsgV+AkcoG3o8ZjYpx173F1Wqz44UK5LxWZ4S/
   hSVTkUEXnvcQ58OZcY2fNg56cHmw/S7Zeqr8b97Y4wmd+jtqkoGBYqI60
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295956716"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295956716"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:39:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="672868302"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 30 Aug 2022 06:39:10 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf] selftests: xsk: add missing close() on netns fd
Date:   Tue, 30 Aug 2022 15:39:05 +0200
Message-Id: <20220830133905.9945-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1034b03e54ac ("selftests: xsk: Simplify cleanup of ifobjects")
removed close on netns fd, which is not correct, so let us restore it.

Fixes: 1034b03e54ac ("selftests: xsk: Simplify cleanup of ifobjects")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 333cf23c01b5..d64652558d12 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1698,6 +1698,8 @@ static struct ifobject *ifobject_create(void)
 	if (!ifobj->umem)
 		goto out_umem;
 
+	ifobj->ns_fd = -1;
+
 	return ifobj;
 
 out_umem:
@@ -1709,6 +1711,8 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
+	if (ifobj->ns_fd != -1)
+		close(ifobj->ns_fd);
 	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
-- 
2.34.1

