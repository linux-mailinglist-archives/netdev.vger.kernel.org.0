Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70965720C4
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiGLQ0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234323AbiGLQZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:25:58 -0400
X-Greylist: delayed 1810 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 09:25:57 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1950ACC003;
        Tue, 12 Jul 2022 09:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=p78n0j+aija+d8Yb4f8ouk+I4Dnzsq0NMzCi4AYsSxU=; b=py8F9
        hYhY8+dGDBcqTZo9UX97sZyab9Y+6UPXYg0gOLCs7L3OLhWmfg3z1U644dBCLnsyw7oRXVQiuRwtq
        8JLYjO5ccPMq5heCaEVdu0v7TFCcR/F5IP1vNoz1YqsFehoV2ezv+XfkE4wwIdcRENrAH6whjXWxH
        58sh5ty23IexJWLD7Uk0dBdYN2il93xNGyb9o62IQN/m72jxVsgPWJIEMpQF5Ntr+s6rU6WBJgAF5
        wwulgVLcm3P/8D6RnrmX2FEB8LT2r6jQUiSvxAHpn7MDWOuNsfXKVhVGInW8e5OY3glai+/Mi4w3h
        S4odkqtNIsrHsf733KObRlUyM3asg==;
Message-Id: <2506fd2ed484f688826cdc33c177c467e2b0506c.1657636554.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657636554.git.linux_oss@crudebyte.com>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Tue, 12 Jul 2022 16:31:26 +0200
Subject: [PATCH v5 07/11] net/9p: limit 'msize' to KMALLOC_MAX_SIZE for all
 transports
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This 9p client implementation is yet using linear message buffers for
most message types, i.e. they use kmalloc() et al. for allocating
continuous physical memory pages, which is usually limited to 4MB
buffers. Use KMALLOC_MAX_SIZE though instead of a hard coded 4MB for
constraining this more safely.

Unfortunately we cannot simply replace the existing kmalloc() calls by
vmalloc() ones, because that would yield in non-logical kernel addresses
(for any vmalloc(>4MB) that is) which are in general not accessible by
hosts like QEMU.

In future we would replace those linear buffers by scatter/gather lists
to eventually get rid of this limit (struct p9_fcall's sdata member by
p9_fcall_init() and struct p9_fid's rdir member by
v9fs_alloc_rdir_buf()).

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---

Hmm, that's a bit too simple, as we also need a bit of headroom for
transport specific overhead. So maybe this has to be handled by each
transport appropriately instead?

 net/9p/client.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index 20054addd81b..fab939541c81 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1042,6 +1042,17 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	p9_debug(P9_DEBUG_MUX, "clnt %p trans %p msize %d protocol %d\n",
 		 clnt, clnt->trans_mod, clnt->msize, clnt->proto_version);
 
+	/*
+	 * due to linear message buffers being used by client ATM
+	 */
+	if (clnt->msize > KMALLOC_MAX_SIZE) {
+		clnt->msize = KMALLOC_MAX_SIZE;
+		pr_info("Limiting 'msize' to %zu as this is the maximum "
+			"supported by this client version.\n",
+			(size_t) KMALLOC_MAX_SIZE
+		);
+	}
+
 	err = clnt->trans_mod->create(clnt, dev_name, options);
 	if (err)
 		goto put_trans;
-- 
2.30.2

