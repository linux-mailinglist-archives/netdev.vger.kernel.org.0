Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096048D13C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 12:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfHNKrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 06:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfHNKrx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 06:47:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7611311A08;
        Wed, 14 Aug 2019 10:47:53 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9315883280;
        Wed, 14 Aug 2019 10:47:52 +0000 (UTC)
Subject: [PATCH net 0/2] rxrpc: Fix local endpoint handling
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 14 Aug 2019 11:47:51 +0100
Message-ID: <156577967167.1405.3581547705200268244.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 14 Aug 2019 10:47:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here's a pair of patches that fix two issues in the handling of local
endpoints (rxrpc_local structs):

 (1) Use list_replace_init() rather than list_replace() if we're going to
     unconditionally delete the replaced item later, lest the list get
     corrupted.

 (2) Don't access the rxrpc_local object after passing our ref to the
     workqueue, not even to illuminate tracepoints, as the work function
     may cause the object to be freed.  We have to cache the information
     beforehand.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20190814

and can also be found on the following branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

David
---
David Howells (2):
      rxrpc: Fix local endpoint replacement
      rxrpc: Fix read-after-free in rxrpc_queue_local()


 include/trace/events/rxrpc.h |    6 +++---
 net/rxrpc/local_object.c     |   21 +++++++++++----------
 2 files changed, 14 insertions(+), 13 deletions(-)

