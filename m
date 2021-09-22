Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6430414F18
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbhIVRb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:31:57 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:47947 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbhIVRb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:31:56 -0400
X-Greylist: delayed 2675 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 13:31:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Content-ID:
        Content-Description; bh=KsQy5PV1HODqilgg4GtOYXMO7E+CDdwOniV9Pc06enU=; b=ENVlb
        1U982qckCwfdjU/zvXZPYSk6DRr411b3w3KvhwoN8p60uozhEZ0apKQTaxK06XIUrZHwsGbPOl48q
        9DXI95eu4ILZepz8GsgXOCdJo9MKX7vWy9sxcyHKREAsELOYKzH10jLAbllraoEDVHWcADVYXLmLA
        7UzRdQpr7TJBPjW7/W+accUmn8FiiFfJDNcrIWRFLni5W5JiZ7H1/w0qESyLnjRt+dgwLomNzg+mB
        PQ6zRjZWk2XJNJG4s5hW5XdLOU4aSkV8h/sSjr7zJr1AjTqqqDfebd2tkjzmzR+pAui4JZODkn26N
        Y80CHNWAL3KUqmZu92gBdKCL9KzvA==;
Message-Id: <cover.1632327421.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Wed, 22 Sep 2021 18:00:18 +0200
Subject: [PATCH v3 0/7] net/9p: remove msize limit in virtio transport
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

Prerequisites: If you are testing with QEMU then please apply the following
patch on QEMU side:
https://lore.kernel.org/qemu-devel/E1mT2Js-0000DW-OH@lizzy.crudebyte.com/
That QEMU patch is required if you are using a user space app that
automatically retrieves an optimum I/O block size by obeying stat's
st_blksize, which 'cat' for instance is doing, e.g.:

	time cat test_rnd.dat > /dev/null

Otherwise please use a user space app for performance testing that allows
you to force a large block size and to avoid that QEMU issue, like 'dd'
for instance, in that case you don't need to patch QEMU.

Testing and feedback appreciated!

v2 -> v3:

  * Make vq_sg_free() safe for NULL argument [patch 4].

  * Show info message to user if user's msize option had to be limited in
    case it would exceed p9_max_pages [patch 6].

  * Fix memory leak in vq_sg_resize() [patch 7].

  * Show info message to user if user's msize option had to be limited in
    case not all required SG lists could be allocated [patch 7].

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
 net/9p/trans_virtio.c   | 304 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 283 insertions(+), 40 deletions(-)

-- 
2.20.1

