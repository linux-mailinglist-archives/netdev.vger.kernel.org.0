Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0B556CB4C
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 22:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiGIUAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 16:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGIUAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 16:00:21 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CD33E01D;
        Sat,  9 Jul 2022 13:00:20 -0700 (PDT)
Received: from sequoia.devices.tihix.com (162-237-133-238.lightspeed.rcsntx.sbcglobal.net [162.237.133.238])
        by linux.microsoft.com (Postfix) with ESMTPSA id AC919204C8E0;
        Sat,  9 Jul 2022 13:00:18 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AC919204C8E0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1657396819;
        bh=0/4/je5F3ph2qO9T5M9uqjsKhrJMFF9mOYX6DBCeVVI=;
        h=From:To:Cc:Subject:Date:From;
        b=WwAVohwjMEHgPxZC8fl/YVpl7hgLuB3Ct1y5ziEld3gJ5uEsMj6vCC0cCBu3Dp7ih
         VSHgbFIzLHlkoc8NIssRqOYG4OviGqXv49J/OBO9QtU7me0jYqpcT1KMMLGvqDmqe6
         8jdmkB7MWMeAbmYcLMWWtX0+QxOXQPWlaPeUUKpg=
From:   Tyler Hicks <tyhicks@linux.microsoft.com>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/9p: Initialize the iounit field during fid creation
Date:   Sat,  9 Jul 2022 15:00:05 -0500
Message-Id: <20220709200005.681861-1-tyhicks@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that the fid's iounit field is set to zero when a new fid is
created. Certain 9P operations, such as OPEN and CREATE, allow the
server to reply with an iounit size which the client code assigns to the
fid struct shortly after the fid is created in p9_fid_create(). Other
operations that follow a call to p9_fid_create(), such as an XATTRWALK,
don't include an iounit value in the reply message from the server. In
the latter case, the iounit field remained uninitialized. Depending on
allocation patterns, the iounit value could have been something
reasonable that was carried over from previously freed fids or, in the
worst case, could have been arbitrary values from non-fid related usages
of the memory location.

The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
after the uninitialized iounit field resulted in the typical sequence of
two getxattr(2) syscalls, one to get the size of an xattr and another
after allocating a sufficiently sized buffer to fit the xattr value, to
hit an unexpected ERANGE error in the second call to getxattr(2). An
uninitialized iounit field would sometimes force rsize to be smaller
than the xattr value size in p9_client_read_once() and the 9P server in
WSL refused to chunk up the READ on the attr_fid and, instead, returned
ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
the READ and this problem goes undetected there. However, there are
likely other non-xattr implications of this bug that could cause
inefficient communication between the client and server.

Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
---

Note that I haven't had a chance to identify when this bug was
introduced so I don't yet have a proper Fixes tag. The history looked a
little tricky to me but I'll have another look in the coming days. We
started hitting this bug after trying to move from linux-5.10.y to
linux-5.15.y but I didn't see any obvious changes between those two
series. I'm not confident of this theory but perhaps the fid refcounting
changes impacted the fid allocation patterns enough to uncover the
latent bug?

 net/9p/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index 8bba0d9cf975..1dfceb9154f7 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -899,6 +899,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	fid->clnt = clnt;
 	fid->rdir = NULL;
 	fid->fid = 0;
+	fid->iounit = 0;
 	refcount_set(&fid->count, 1);
 
 	idr_preload(GFP_KERNEL);
-- 
2.25.1

