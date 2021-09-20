Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E231412281
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351254AbhITSP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:15:59 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:44745 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350780AbhITSH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 14:07:26 -0400
X-Greylist: delayed 3150 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 14:07:26 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Content-ID:
        Content-Description; bh=2acrbVCK2C0tCGf+WWirJP4DaHOyBUdmzXbdsZb3Zuw=; b=QJMEu
        Hq9Fc3t7eU0bk/z6GKQpONkoKF5I4F1kb9FpuVTrxzo4mLcATL/qaDaWfDzNpMMaHl47T13SY3bHN
        qT/4VqxDs/gUcgiwdxtV2ZlDiY6SRnWEUk2E2g/J4LdMaPwEU7E0Iru+JkSYd0U3KqYGE4qYR7h8C
        LSDB/g+cBrhpjgJ7cLwbHFCPymPHWwMkJhJmxzQORaQm9TyuoivgbYHxfdJW9+P0RaeEHbrTvz02j
        /N4BgZzJosVKwCfdsEtrxb1+HkXCBptgt7Ldnf1xtfcMTkfkIJ2/c5MZrIyilTrNyqYc5HDN4PGg2
        uOZj9qc+X5Mt29IqEjs3lcFe1yDxA==;
Message-Id: <cover.1632156835.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Mon, 20 Sep 2021 18:43:30 +0200
Subject: [PATCH v2 0/7] net/9p: remove msize limit in virtio transport
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to get get rid of the current 500k 'msize' limitation in
the 9p virtio transport, which is currently a bottleneck for performance
of 9p mounts.

This is a follow-up of the following series and discussion:
https://lore.kernel.org/all/28bb651ae0349a7d57e8ddc92c1bd5e62924a912.1630770829.git.linux_oss@crudebyte.com/T/#eb647d0c013616cee3eb8ba9d87da7d8b1f476f37

Known limitation: With this series applied I can run

  QEMU host <-> 9P virtio <-> Linux guest

with up to 3 MB msize. If I try to run it with 4 MB it seems to hit some
limitation on QEMU side:

  qemu-system-x86_64: virtio: too many write descriptors in indirect table

I haven't looked into this issue yet.

Testing and feedback appreciated!

v1 -> v2:

  * Fix memory leak [patch 6].

  * Use pr_info() instead of p9_debug(P9_DEBUG_ERROR, ...) for user info
    [patch 1].

  * Show user info message if chained SG lists are not supported on
    architecture [patch 6].

  * Kernel doc fixes [patch 4], [patch 6].

Christian Schoenebeck (7):
  net/9p: show error message if user 'msize' cannot be satisfied
  9p/trans_virtio: separate allocation of scatter gather list
  9p/trans_virtio: turn amount of sg lists into runtime info
  9p/trans_virtio: introduce struct virtqueue_sg
  net/9p: add trans_maxsize to struct p9_client
  9p/trans_virtio: support larger msize values
  9p/trans_virtio: resize sg lists to whatever is possible

 include/net/9p/client.h |   2 +
 net/9p/client.c         |  17 ++-
 net/9p/trans_virtio.c   | 290 ++++++++++++++++++++++++++++++++++------
 3 files changed, 269 insertions(+), 40 deletions(-)

-- 
2.20.1

