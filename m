Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46F762B4DB
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbiKPIRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbiKPIRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:17:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6F01C9
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 00:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668586597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=087ZN7fM4BBvE3rd8DvckRX1ZjaoCStvIBq7UhC86nc=;
        b=D4avCnS1QL60MXVPQhkxY9WSx+RwRN6ycHB23NxAboqo9d2ZHqgRSxp0r9Ut70BReRRe2f
        ccjfQ8vdtoqWvbVV//8SglI/NcgBpSs+0IiALyWR4k9hiEbK2g51mXxWWFSoFjf6mWPQRs
        z/SA3B9cA18YhntnbDp/dJ4rB2oHlfM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-2yqOg0J7NeGIlF3gYgtXew-1; Wed, 16 Nov 2022 03:16:36 -0500
X-MC-Unique: 2yqOg0J7NeGIlF3gYgtXew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABCF13814957;
        Wed, 16 Nov 2022 08:16:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C51A140006B;
        Wed, 16 Nov 2022 08:16:35 +0000 (UTC)
Subject: [PATCH 0/3] rxrpc: Fix oops and missing config conditionals
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Nov 2022 08:16:32 +0000
Message-ID: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The patches that were pulled into net-next previously[1] had some issues
that this patchset fixes:

 (1) Fix missing IPV6 config conditionals.

 (2) Fix an oops caused by calling udpv6_sendmsg() directly on an AF_INET
     socket.

 (3) Fix the validation of network addresses on entry to socket functions
     so that we don't allow an AF_INET6 address if we've selected an
     AF_INET transport socket.

Link: https://lore.kernel.org/r/166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk/ [1]

---
The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/rxrpc-next-20221116

And can be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (3):
      rxrpc: Fix missing IPV6 #ifdef
      rxrpc: Fix oops from calling udpv6_sendmsg() on AF_INET socket
      rxrpc: Fix network address validation


 net/rxrpc/af_rxrpc.c     |  9 +++++----
 net/rxrpc/local_object.c |  3 ++-
 net/rxrpc/output.c       | 18 ++++++++++++------
 3 files changed, 19 insertions(+), 11 deletions(-)


