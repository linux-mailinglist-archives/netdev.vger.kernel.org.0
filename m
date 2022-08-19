Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C41599E0F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349172AbiHSPP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349673AbiHSPP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:15:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F23E0971
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660922127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JOtIMLTpfNA7NQQKsm5aTthLsNkO5t0fxP0i0Y+peyo=;
        b=Db32JqVNOhS+uuingzVBGogig3jPuFhjlEgfM8V2ENms/gAAvrDKpv/xomqpfmoKZODX+l
        B0uAMzEK0FzJhMdRCG0/MGx6j9edjE+Up0tp8DHT6r5EjVmG1NCpprVXKnJ9AgO+5QrAhI
        ZpmW4Yu4fwhka0IUKBOTJsqzvrHgUiU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-9JWhAU72PnSE4krrgwGwxg-1; Fri, 19 Aug 2022 11:15:23 -0400
X-MC-Unique: 9JWhAU72PnSE4krrgwGwxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3526429324B1;
        Fri, 19 Aug 2022 15:15:23 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.34.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD9E340CFD0A;
        Fri, 19 Aug 2022 15:15:22 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org, jay.vosburgh@canonical.com
Cc:     liuhangbin@gmail.com
Subject: [PATCH net v5 0/3] bonding: 802.3ad: fix no transmission of LACPDUs
Date:   Fri, 19 Aug 2022 11:15:11 -0400
Message-Id: <cover.1660919940.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

v5:
 * fixup kdoc
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
 drivers/net/bonding/bond_3ad.c                | 41 ++++------
 drivers/net/bonding/bond_main.c               |  2 +-
 include/net/bond_3ad.h                        |  2 +-
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  6 ++
 .../net/bonding/bond-break-lacpdu-tx.sh       | 81 +++++++++++++++++++
 .../selftests/drivers/net/bonding/config      |  1 +
 .../selftests/drivers/net/bonding/settings    |  1 +
 9 files changed, 108 insertions(+), 28 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/bonding/Makefile
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-break-lacpdu-tx.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/config
 create mode 100644 tools/testing/selftests/drivers/net/bonding/settings

-- 
2.31.1

