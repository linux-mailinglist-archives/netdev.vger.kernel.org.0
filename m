Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DBE634810
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 21:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiKVU0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 15:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiKVU0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 15:26:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BE92126B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 12:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669148715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6TX9CPKewG/vvB2/40uvqxFgh/SBaEyBTSm1iXAngs8=;
        b=gDUtEnY2EP9eaSAwvm3pHvznGm7YbhQIexdnXDbntBOWCMfy65vJhLb41RpthuitUHdP3v
        ijCP/xDKPVoeicUgVOp17R+khCcasHmS0hgYbsjUfARDJH3bdsDDQvy3JK4wvBjV5S7jd1
        /QtPalIbn6tfMZNPcctQ6MVFK5O5f4w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-HqpzW9PGOLGAxZITN6lK-g-1; Tue, 22 Nov 2022 15:25:12 -0500
X-MC-Unique: HqpzW9PGOLGAxZITN6lK-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B90FD101A528;
        Tue, 22 Nov 2022 20:25:11 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.32.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84C3940C6EC6;
        Tue, 22 Nov 2022 20:25:11 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        pabeni@redhat.com
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>
Subject: [PATCH net-next v2 0/2] bonding: fix bond recovery in mode 2
Date:   Tue, 22 Nov 2022 15:25:03 -0500
Message-Id: <cover.1669147951.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

v2:
 * repost to net tree, suggested by Paolo Abeni
 * reduce number of icmp echos used in test, suggested by Paolo Abeni

Jonathan Toppins (2):
  selftests: bonding: up/down delay w/ slave link flapping
  bonding: fix link recovery in mode 2 when updelay is nonzero

 drivers/net/bonding/bond_main.c               |  11 +-
 .../selftests/drivers/net/bonding/Makefile    |   4 +-
 .../selftests/drivers/net/bonding/lag_lib.sh  | 106 ++++++++++++++++++
 .../net/bonding/mode-1-recovery-updelay.sh    |  45 ++++++++
 .../net/bonding/mode-2-recovery-updelay.sh    |  45 ++++++++
 .../selftests/drivers/net/bonding/settings    |   2 +-
 6 files changed, 210 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh

-- 
2.31.1

