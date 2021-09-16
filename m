Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A369040EAD7
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhIPTcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:32:00 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:42925 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbhIPTcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Content-ID:
        Content-Description; bh=ik1mOPhHb219qFHw9mwE2yMv9/LvK/U8Z7AlP83Kzrw=; b=XE9A1
        A4xteQqWYuuXCJk8nAkFULgkG112yddY0a5bRZkv40AmTAPMYaNqxzhwNSHNAfbxgUmKDaLM/kGy9
        1aimAtHANoA1LFy2qaNvafx5DJ4sVfCLJL02Xhsec5WiYemFJEesZhDNJKtPAfw1QRXWajsSIzuGx
        o2MIUjONTxjd2tG4R4SHtFVl66P75AujcWtJiD+tussAu8kKjH1AeQq2lctUaKmCqBk/TE2ih8Hej
        CpKDErQ8sMS5/JpbHR5gLPsub4/skqX9deWcxUOsRyYeX6xupBl0oGJSJRBrIsV36iFRzO04+Irtf
        C5lOrNuUrRPZaIdAxEHpEb0CBwyww==;
Message-Id: <cover.1631816768.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 16 Sep 2021 20:26:08 +0200
Subject: [PATCH 0/7] net/9p: remove msize limit in virtio transport
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an initial draft for getting rid of the current 500k 'msize'
limitation in the 9p virtio transport, which is currently a bottleneck for
performance of Linux 9p mounts.

This is a follow-up of the following series and discussion:
https://lore.kernel.org/all/28bb651ae0349a7d57e8ddc92c1bd5e62924a912.1630770829.git.linux_oss@crudebyte.com/T/#eb647d0c013616cee3eb8ba9d87da7d8b1f476f37

Known limitation: With this series applied I can run

  QEMU host <-> 9P virtio <-> Linux guest

with up to 3 MB msize. If I try to run it with 4 MB it seems to hit some
limitation on QEMU side:

  qemu-system-x86_64: virtio: too many write descriptors in indirect table

I haven't looked into this issue yet.

Testing and feedback appreciated!

Christian Schoenebeck (7):
  net/9p: show error message if user 'msize' cannot be satisfied
  9p/trans_virtio: separate allocation of scatter gather list
  9p/trans_virtio: turn amount of sg lists into runtime info
  9p/trans_virtio: introduce struct virtqueue_sg
  net/9p: add trans_maxsize to struct p9_client
  9p/trans_virtio: support larger msize values
  9p/trans_virtio: resize sg lists to whatever is possible

 include/net/9p/client.h |   2 +
 net/9p/client.c         |  18 ++-
 net/9p/trans_virtio.c   | 281 ++++++++++++++++++++++++++++++++++------
 3 files changed, 261 insertions(+), 40 deletions(-)

-- 
2.20.1

