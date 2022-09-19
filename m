Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16385BD7CD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiISXJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiISXJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED0B459A8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 16:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663628938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=R1dKVLPEtPONYFfMlt9yC5rT0gFif+Hagw3dbLKh6m0=;
        b=JPu9BsEvAnjcRdrPrd4QZxF1lBwa0RurS6CzZO8sdAoHmQ5LtEUJHddyST2hRstWCZLDiP
        d+upInzMh4mE/QsHh+U5jF4suIv3/ycHSsTlZN13EW+oXUzz82O43y6kuitGJeslvOOekC
        qynIT6iyQv5mhfBdOzVi/maoHpIOoXY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-uGuyCaPfNWW6aiW5GM8cKA-1; Mon, 19 Sep 2022 19:08:57 -0400
X-MC-Unique: uGuyCaPfNWW6aiW5GM8cKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17F26185A78F
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 23:08:57 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.8.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 00585140EBF3
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 23:08:56 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>
Subject: [PATCH net 0/2] bonding: fix NULL deref in bond_rr_gen_slave_id
Date:   Mon, 19 Sep 2022 19:08:44 -0400
Message-Id: <cover.1663628505.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a NULL dereference of the struct bonding.rr_tx_counter member because
if a bond is initially created with an initial mode != zero (Round Robin)
the memory required for the counter is never created and when the mode is
changed there is never any attempt to verify the memory is allocated upon
switching modes.

The first patch provides a selftest to demonstrate the issue and the
second patch fixes the issue.

Jonathan Toppins (2):
  selftests: bonding: cause oops in bond_rr_gen_slave_id
  bonding: fix NULL deref in bond_rr_gen_slave_id

 drivers/net/bonding/bond_main.c               | 15 +++---
 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../bonding/bond-arp-interval-causes-panic.sh | 48 +++++++++++++++++++
 3 files changed, 56 insertions(+), 10 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-interval-causes-panic.sh

-- 
2.31.1

