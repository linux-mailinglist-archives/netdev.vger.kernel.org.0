Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F4458ECA2
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 15:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiHJNAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 09:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbiHJNAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 09:00:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A06A857216
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 06:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660136447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DXzJM23XfyB2og6RNmsKZ5A3t1PbJU+tVEM6g5Lr+Ok=;
        b=OA1eVOdW2hYGpw09HVBlFhdqJHSM96aw4JrM6gseKkNZLiVduMk3fwLJ3ldLSpYREUMS8q
        MtlzfWzCKvdc/7grUQUBUAMYzaX8sTFUhJZ0UTI763AcWYJkyFZawJ6xmN94tVDsxyR1Ye
        G35N318aAGt6WuwumYCukEu2t2eTVOs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-E8w0n9rvNXKCyZe5kJHrvQ-1; Wed, 10 Aug 2022 09:00:43 -0400
X-MC-Unique: E8w0n9rvNXKCyZe5kJHrvQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDBFA858EFF;
        Wed, 10 Aug 2022 13:00:42 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C69961121314;
        Wed, 10 Aug 2022 13:00:42 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 27AD0gXb019344;
        Wed, 10 Aug 2022 09:00:42 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 27AD0gu7019340;
        Wed, 10 Aug 2022 09:00:42 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 10 Aug 2022 09:00:42 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCH] rds: add missing barrier to release_refill
Message-ID: <alpine.LRH.2.02.2208100858130.19047@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions clear_bit and set_bit do not imply a memory barrier, thus it
may be possible that the waitqueue_active function (which does not take
any locks) is moved before clear_bit and it could miss a wakeup event.

Fix this bug by adding a memory barrier after clear_bit.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/net/rds/ib_recv.c
===================================================================
--- linux-2.6.orig/net/rds/ib_recv.c
+++ linux-2.6/net/rds/ib_recv.c
@@ -363,6 +363,7 @@ static int acquire_refill(struct rds_con
 static void release_refill(struct rds_connection *conn)
 {
 	clear_bit(RDS_RECV_REFILL, &conn->c_flags);
+	smp_mb__after_atomic();
 
 	/* We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk

