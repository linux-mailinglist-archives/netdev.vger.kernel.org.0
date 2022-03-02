Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B134CA4CD
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 13:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbiCBMaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 07:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbiCBMaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 07:30:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1EDA2606F6
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 04:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646224169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uAIaLdj2QUt0ZlrkHXRDvLUjgbmX6xdnjWdxHcjFNUY=;
        b=chOTu8kTBDfFWjG4fj3FjM4x7nHLeP6Wlr2QUsQOqHaJVMvqiRHjCsty6gZraWo5360PVE
        Ah26MIYJ0sxjJMB7yh+6NBxu5k82MsQMixHj+qlQ4ft1kLhJ4uomXjTrc2sMZ7VoTX7JYO
        anto3JIxWo6BBvo1B/1sgCAsbGS3a+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-v9p1Juj2PvyAAjgsrww-hQ-1; Wed, 02 Mar 2022 07:29:26 -0500
X-MC-Unique: v9p1Juj2PvyAAjgsrww-hQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A71F520F;
        Wed,  2 Mar 2022 12:29:25 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.192.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6E6E78344;
        Wed,  2 Mar 2022 12:29:23 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 v2 0/2] fix memory leak in get_task_name()
Date:   Wed,  2 Mar 2022 13:28:46 +0100
Message-Id: <cover.1646223467.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some memory leaks related to the usage of the
get_task_name() function from lib/fs.c.

Patch 2/2 addresses a coverity warning related to this memory leak,
making the code a bit more readable by humans and coverity.

Changelog:
----------
v1 -> v2
- on Stephen's suggestion, drop asprintf() and use a local var for path;
  additionally drop %m from fscanf to not allocate memory, and resort to
  a param to return task name to the caller.
- patch 2/3 of the original series is no more needed.

Andrea Claudi (2):
  lib/fs: fix memory leak in get_task_name()
  rdma: make RES_PID and RES_KERN_NAME alternative to each other

 include/utils.h |  2 +-
 ip/iptuntap.c   | 17 ++++++++++-------
 lib/fs.c        | 20 ++++++++++----------
 rdma/res-cmid.c | 18 +++++++++---------
 rdma/res-cq.c   | 17 +++++++++--------
 rdma/res-ctx.c  | 16 ++++++++--------
 rdma/res-mr.c   | 15 ++++++++-------
 rdma/res-pd.c   | 17 +++++++++--------
 rdma/res-qp.c   | 16 ++++++++--------
 rdma/res-srq.c  | 17 +++++++++--------
 rdma/stat.c     | 14 +++++++++-----
 11 files changed, 90 insertions(+), 79 deletions(-)

-- 
2.35.1

