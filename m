Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE39440C42
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhJ3XP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231387AbhJ3XP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:15:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A1560EFF;
        Sat, 30 Oct 2021 23:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635578;
        bh=vNYNAaE4GdYxq/3gd6yc0R0Yul1U0c692CREoukMsyU=;
        h=From:To:Cc:Subject:Date:From;
        b=rNCjPMWPIauNw7EmSrR+7BFaFH8EQ6YMmM5vKfV/S87Dz2pbrecl4/6l5EigD42v8
         aCCV2hspmEwhfQm2Xn/7lrfBvXsBtK1E5yxHbqtnB7ymx9HaK5vGOLQjYfEOYbpFOj
         xKHIDIee7HyA+zcHgwAilbDLmZBJVY4Yi8N43E2ls1UFA/ByV0XaQspuy8gmpPpj79
         dpS8vu8iEeO5OGyOum6iYo4uGgE7WgFuYctgA7BrXuJ3y7K34VpZ8qm/Cr3vHmPK2D
         dYxqOUBszL/TGfOoOnTDd/4xbbQktMswgfD9yCn40n3FlMK9fb+feAtiSBojQoiRId
         7kuUWo7oeWZaw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     leon@kernel.org, idosch@idosch.org
Cc:     edwin.peer@broadcom.com, jiri@resnulli.us, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 0/5] devlink: add an explicit locking API
Date:   Sat, 30 Oct 2021 16:12:49 -0700
Message-Id: <20211030231254.2477599-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements what I think is the right direction for devlink
API overhaul. It's an early RFC/PoC because the body of code is
rather large so I'd appreciate feedback early... The patches are
very roughly split, the point of the posting is primarily to prove
that from the driver side the conversion is an net improvement
in complexity.

IMO the problems with devlink locking are caused by two things:

 (1) driver has no way to block devlink calls like it does in case
     of netedev / rtnl_lock, note that for devlink each driver has
     it's own lock so contention is not an issue;
     
 (2) sometimes devlink calls into the driver without holding its lock
     - for operations which may need the driver to call devlink (port
     splitting, switch config, reload etc.), the circular dependency
     is there, the driver can't solve this problem.

This set "fixes" the ordering by allowing the driver to participate
in locking. The lock order remains:

  device_lock -> [devlink_mutex] -> devlink instance -> rtnl_lock

but now driver can take devlink lock itself, and _ALL_ devlink ops
are locked.

The expectation is that driver will take the devlink instance lock
on its probe and remove paths, hence protecting all configuration
paths with the devlink instance lock.

This is clearly demonstrated by the netdevsim conversion. All entry
points to driver config are protected by devlink instance lock, so
the driver switches to the "I'm already holding the devlink lock" API
when calling devlink. All driver locks and trickery is removed.

The part which is slightly more challanging is quiescing async entry
points which need to be closed on the devlink reload path (workqueue,
debugfs etc.) and which also take devlink instance lock. For that we
need to be able to take refs on the devlink instance and let them
clean up after themselves rather than waiting synchronously.

That last part is not 100% finished in this patch set - it works but
we need the driver to take devlink_mutex (the global lock) from its
probe/remove path. I hope this is good enough for an RFC, the problem
is easily solved by protecting the devlink XArray with something else
than devlink_mutex and/or not holding devlink_mutex around each op
(so that there is no ordering between the global and instance locks).
Speaking of not holding devlink_mutex around each op this patch set
also opens the path for parallel ops to different devlink instances
which is currently impossible because all user space calls take
devlink_mutex...

The patches are on top of the cleanups I posted earlier.

Jakub Kicinski (5):
  devlink: add unlocked APIs
  devlink: add API for explicit locking
  devlink: allow locking of all ops
  netdevsim: minor code move
  netdevsim: use devlink locking

 drivers/net/netdevsim/bus.c       |  19 -
 drivers/net/netdevsim/dev.c       | 450 ++++++++-------
 drivers/net/netdevsim/fib.c       |  62 +--
 drivers/net/netdevsim/netdevsim.h |   5 -
 include/net/devlink.h             |  88 +++
 net/core/devlink.c                | 875 +++++++++++++++++++++---------
 6 files changed, 996 insertions(+), 503 deletions(-)

-- 
2.31.1

