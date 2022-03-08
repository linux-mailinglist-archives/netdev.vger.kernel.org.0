Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1809B4D1E18
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbiCHRGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbiCHRGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:06:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D893517E3
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646759121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=S277s+u2rqdJ8zpPIKQm647HReat/J2T6qWQYoT71G8=;
        b=QUJr7y3BuG9Nn28+vdfeFdopyi595E9udxV47hf8v6gNze9bodGb06WqtT/GakczHHT5Am
        TIkQdObGF5OPHpoe1rJxKsPGphaGaKJ2Doo3PiCOY1EFSStcY1S0X4HgvikhtLhCIpkYG+
        TdM2iZx4X2nYWgK61yLv65SGDKAE3lM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-36yXs4J7Nm6ZP9-lSZiWYw-1; Tue, 08 Mar 2022 12:05:20 -0500
X-MC-Unique: 36yXs4J7Nm6ZP9-lSZiWYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D433A1006AA8;
        Tue,  8 Mar 2022 17:05:18 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A947A106D5BD;
        Tue,  8 Mar 2022 17:05:17 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 v3 0/2] fix memory leak in get_task_name()
Date:   Tue,  8 Mar 2022 18:04:55 +0100
Message-Id: <cover.1646750928.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
v2 -> v3
- Use a better API for get_task_name(), passing to it a buffer and its
  lenght just like get_command_name().

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
 lib/fs.c        | 23 +++++++++++++----------
 rdma/res-cmid.c | 18 +++++++++---------
 rdma/res-cq.c   | 17 +++++++++--------
 rdma/res-ctx.c  | 16 ++++++++--------
 rdma/res-mr.c   | 15 ++++++++-------
 rdma/res-pd.c   | 17 +++++++++--------
 rdma/res-qp.c   | 16 ++++++++--------
 rdma/res-srq.c  | 17 +++++++++--------
 rdma/stat.c     | 14 +++++++++-----
 11 files changed, 93 insertions(+), 79 deletions(-)

-- 
2.35.1

