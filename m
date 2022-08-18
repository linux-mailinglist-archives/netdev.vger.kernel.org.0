Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62700598635
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343592AbiHROl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343582AbiHROlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:41:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9C3B8F32
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660833684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IExWhRc/tNjSdReXwK5OyE3mQp8/jgiRqNLPK768A2M=;
        b=NOpyh+GpD17owDqnBOkuSUm9NY75THL6vdOrMguNAVYqUhcK32vDSVrCpJEX7GEc3WPUoE
        ON0h73+tZC9VRmX7VMJFtbfBnu3HQOzkwzNLmWBVJQC5bGITzJRlL3Pd6CxGj3GwG9bxsH
        OqLKQljrGoaKWQnIgRUR9IRIyk1i15U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-Db-ZWP6ENvy3dPiUZB6WYQ-1; Thu, 18 Aug 2022 10:41:21 -0400
X-MC-Unique: Db-ZWP6ENvy3dPiUZB6WYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 947D985A584;
        Thu, 18 Aug 2022 14:41:20 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.33.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A70F400EAB2;
        Thu, 18 Aug 2022 14:41:20 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, jay.vosburgh@canonical.com
Cc:     liuhangbin@gmail.com
Subject: [PATCH net v4 0/3] bonding: 802.3ad: fix no transmission of LACPDUs
Date:   Thu, 18 Aug 2022 10:41:09 -0400
Message-Id: <cover.1660832962.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configuring a bond in a specific order can leave the bond in a state
where it never transmits LACPDUs.

The first patch adds some kselftest infrastructure and the reproducer
that demonstrates the problem. The second patch fixes the issue. The
new third patch makes ad_ticks_per_sec a static const and removes the
passing of this variable via the stack.

v4:
 * rebased to latest net/master
 * removed if check around bond_3ad_initialize function contents
 * created a new patch that makes ad_ticks_per_sec a static const
v3:
 * rebased to latest net/master
 * addressed comment from Hangbin

Jonathan Toppins (3):
  selftests: include bonding tests into the kselftest infra
  bonding: 802.3ad: fix no transmission of LACPDUs
  bonding: 3ad: make ad_ticks_per_sec a const

 MAINTAINERS                                   |  1 +
 drivers/net/bonding/bond_3ad.c                | 40 ++++-----
 drivers/net/bonding/bond_main.c               |  2 +-
 include/net/bond_3ad.h                        |  2 +-
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  6 ++
 .../net/bonding/bond-break-lacpdu-tx.sh       | 81 +++++++++++++++++++
 .../selftests/drivers/net/bonding/config      |  1 +
 .../selftests/drivers/net/bonding/settings    |  1 +
 9 files changed, 108 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/bonding/Makefile
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/config
 create mode 100644 tools/testing/selftests/drivers/net/bonding/settings

-- 
2.31.1

