Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4809262FEDC
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKRUb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiKRUbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:31:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FBB624B
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668803425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=l+sODI7WiFFeDlHoDqi2zid2mxwhGWUalUTjEvdqFm4=;
        b=InY+kCzUMh86AX+fja64hohk1N+on92d8Dcuu7UA7DuWWENwp0zz2LtVVegMwGSWdusIHS
        Bbf2sN56WXbIiPqXqu+dobuDBlAhQAVNJ0PwHvxPvhimca68AB6FUFvRP8yUK3p9CPWHTa
        80pBJMQ2IljDDxuFLhrWqNxKfO9dmwc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-bDXbiVbYMKqVUwqiaNPpoQ-1; Fri, 18 Nov 2022 15:30:20 -0500
X-MC-Unique: bDXbiVbYMKqVUwqiaNPpoQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7173A3C0D199;
        Fri, 18 Nov 2022 20:30:20 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.10.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C1D5492B04;
        Fri, 18 Nov 2022 20:30:20 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>
Subject: [PATCH net-next 0/2] bonding: fix bond recovery in mode 2
Date:   Fri, 18 Nov 2022 15:30:11 -0500
Message-Id: <cover.1668800711.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a bond is configured with a non-zero updelay and in mode 2 the bond
never recovers after all slaves lose link. The first patch adds
selftests that demonstrate the issue and the second patch fixes the
issue by ignoring the updelay when there are no usable slaves.

Jonathan Toppins (2):
  selftests: bonding: up/down delay w/ slave link flapping
  bonding: fix link recovery in mode 2 when updelay is nonzero

 drivers/net/bonding/bond_main.c               |  11 +-
 .../selftests/drivers/net/bonding/Makefile    |   4 +-
 .../selftests/drivers/net/bonding/lag_lib.sh  | 107 ++++++++++++++++++
 .../net/bonding/mode-1-recovery-updelay.sh    |  45 ++++++++
 .../net/bonding/mode-2-recovery-updelay.sh    |  45 ++++++++
 .../selftests/drivers/net/bonding/settings    |   2 +-
 6 files changed, 211 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh

-- 
2.31.1

