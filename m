Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBABC54CE53
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354862AbiFOQPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353677AbiFOQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:13:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E31B39807;
        Wed, 15 Jun 2022 09:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655309594; x=1686845594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GNXo+trQIlYOwd1aKpe01eUvic84o8Ql1koeEVmB18c=;
  b=Nnidn2RGAnMhIHJun0VeoQ2wfBOtPyqG5Cid6p8NWbftE0qEBuC21Iay
   xPMZkXHGI4oRfO4dbrjCcAYLtrK4O0JWEvrn/xQGb/MDO/w8csC7slAjo
   JxDDFfYf/tWrgrunibeSmLeon2yKFrkKqHr7T0tFV84TItEsY9VRkNtl6
   +wdLC0eBCXqY4LKrVbXoW/s+k8B0EFJ1UClAUvlxAZfnU1lOhN0CDEP/Z
   59SGhg8HnWzfwJ2wWPrDpPjKWMc8ZaNefLRBlODbFhhJ0HaDc7MTpmq2K
   /aRFh0+EV0BhmwrcGnS7c7gnYRVYiPJM0FftFt0Ft8Bji5/z+6Q1CkHx5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280050167"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280050167"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 09:11:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="713005340"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 09:11:12 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 06/11] selftests: xsk: add missing close() on netns fd
Date:   Wed, 15 Jun 2022 18:10:36 +0200
Message-Id: <20220615161041.902916-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
References: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1034b03e54ac ("selftests: xsk: Simplify cleanup of ifobjects")
removed close on netns fd, which is not correct, so let us restore it.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index a1e410f6a5d8..81ad69ed5839 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1591,6 +1591,8 @@ static struct ifobject *ifobject_create(void)
 	if (!ifobj->umem)
 		goto out_umem;
 
+	ifobj->ns_fd = -1;
+
 	return ifobj;
 
 out_umem:
@@ -1602,6 +1604,8 @@ static struct ifobject *ifobject_create(void)
 
 static void ifobject_delete(struct ifobject *ifobj)
 {
+	if (ifobj->ns_fd != -1)
+		close(ifobj->ns_fd);
 	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
-- 
2.27.0

