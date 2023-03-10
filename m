Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395F16B4C59
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjCJQNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjCJQMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161D5136D3
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678464488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rFrEXheoagyGuGhHvjwBBfDFiECGzjLiqrbLv4R0rvY=;
        b=et8bqYWeGDOeao6/ogKo7F+6a2I2kFadSVcGlDiS+R2+pBEAcY8n9DO5LHaRS5UuOXdVaN
        t5gp6BBGGgrwFSAj8IRwv47Y/eP8GwHexK5VG8MW53AWnFzTaX3PVJ+w4o+C76CzFp+AKd
        YdnWN4HJuFuZiSW31p/I/t6uHRG5XlI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-1qJTywyZPHettNgAt-TBhg-1; Fri, 10 Mar 2023 11:08:03 -0500
X-MC-Unique: 1qJTywyZPHettNgAt-TBhg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08D53100F909;
        Fri, 10 Mar 2023 16:08:02 +0000 (UTC)
Received: from thuth.com (unknown [10.45.224.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89FD3492B00;
        Fri, 10 Mar 2023 16:07:59 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 0/5] Remove #ifdef CONFIG_* from uapi headers (2023 edition)
Date:   Fri, 10 Mar 2023 17:07:52 +0100
Message-Id: <20230310160757.199253-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uapi headers should not use the kernel-internal CONFIG switches.
Palmer Dabbelt sent some patches to clean this up a couple of years
ago, but unfortunately some of those patches never got merged.
So here's a rebased version of those patches - since they are rather
trivial, I hope it's OK for everybody if they could go through Arnd's
"generic include/asm header files" branch.

v2:
- Added Reviewed-bys from v1
- Changed the CONFIG_CDROM_PKTCDVD_WCACHE patch according to Christoph's
  suggestion
- Added final patch to clean the list in scripts/headers_install.sh

Palmer Dabbelt (3):
  Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
  Move ep_take_care_of_epollwakeup() to fs/eventpoll.c
  Move bp_type_idx to include/linux/hw_breakpoint.h

Thomas Huth (2):
  pktcdvd: Remove CONFIG_CDROM_PKTCDVD_WCACHE from uapi header
  scripts: Update the CONFIG_* ignore list in headers_install.sh

 drivers/block/pktcdvd.c                  | 13 +++++++++----
 fs/eventpoll.c                           | 13 +++++++++++++
 include/linux/hw_breakpoint.h            | 10 ++++++++++
 include/uapi/linux/atmdev.h              |  4 ----
 include/uapi/linux/eventpoll.h           | 12 ------------
 include/uapi/linux/hw_breakpoint.h       | 10 ----------
 include/uapi/linux/pktcdvd.h             | 11 -----------
 net/atm/svc.c                            |  5 +++++
 scripts/headers_install.sh               |  4 ----
 tools/include/uapi/linux/hw_breakpoint.h | 10 ----------
 10 files changed, 37 insertions(+), 55 deletions(-)

-- 
2.31.1

