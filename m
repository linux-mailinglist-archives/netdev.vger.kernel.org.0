Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B854A3AD780
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhFSDuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhFSDuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:50:54 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEF5C061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 20:48:39 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luRyE-009qXt-0u; Sat, 19 Jun 2021 03:48:34 +0000
Date:   Sat, 19 Jun 2021 03:48:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCHSET] AF_UNIX bind(2) cleanup on failures after mknod
Message-ID: <YM1pEoZxc2P17nlp@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Failures in unix_bind() coming after we'd created a socket
node in filesystem are possible and can leave an unpleasant mess behind.
That had been reported back in February by Denis Kirjanov, but his
proposed solution had holes.

	This is a rebase of the series I'd ended up with back then;
I'd prefer to have it go through the regular net.git path.

	8 commits total, preliminary massage in the first 6, the fix is #7
and #8 is a minor followup cleanup.  Branch is based at net.git/master,
lives in vfs.git #misc.af_unix.  Individual patches in followups.

Al Viro (8):
      af_unix: take address assignment/hash insertion into a new helper
      unix_bind(): allocate addr earlier
      unix_bind(): separate BSD and abstract cases
      unix_bind(): take BSD and abstract address cases into new helpers
      fold unix_mknod() into unix_bind_bsd()
      unix_bind_bsd(): move done_path_create() call after dealing with ->bindlock
      unix_bind_bsd(): unlink if we fail after successful mknod
      __unix_find_socket_byname(): don't pass hash and type separately

 net/unix/af_unix.c | 188 +++++++++++++++++++++++++++--------------------------
 1 file changed, 96 insertions(+), 92 deletions(-)
