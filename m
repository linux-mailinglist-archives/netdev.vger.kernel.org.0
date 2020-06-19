Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6208201A36
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389075AbgFSSXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:23:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55658 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387968AbgFSSXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592590997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bc8bgBZaKAykX+oT4Ghe9dJSFsYjpNWBpF2Ak/zUniM=;
        b=eNgDG8eopkX9HAO9j+AuBxLrTJ9ATfQYCWMVs9BWRN4gCvtqhWf0u7cDo2TsfoOPsPKCrK
        KuJsfHw7aWPESto5Qp1FZo/I4T2NZwig3BsGtXCK5Hg2ZlQRJoX6WpfWgTCRv2OVyy99Uj
        7rRukWLxAT3teDbCLTx8/4Gh4qayDrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-78tk4Hn8OS2BD-oyfUyQKg-1; Fri, 19 Jun 2020 14:23:13 -0400
X-MC-Unique: 78tk4Hn8OS2BD-oyfUyQKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2264800053;
        Fri, 19 Jun 2020 18:23:12 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-113-14.ams2.redhat.com [10.36.113.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F73B7C1E4;
        Fri, 19 Jun 2020 18:23:05 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     mst@redhat.com
Cc:     kvm list <kvm@vger.kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC v9 00/11] vhost: ring format independence
Date:   Fri, 19 Jun 2020 20:22:51 +0200
Message-Id: <20200619182302.850-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds infrastructure required for supporting
multiple ring formats.

The idea is as follows: we convert descriptors to an
independent format first, and process that converting to
iov later.

Used ring is similar: we fetch into an independent struct first,
convert that to IOV later.

The point is that we have a tight loop that fetches
descriptors, which is good for cache utilization.
This will also allow all kind of batching tricks -
e.g. it seems possible to keep SMAP disabled while
we are fetching multiple descriptors.

For used descriptors, this allows keeping track of the buffer length
without need to rescan IOV.

This seems to perform better on UDP stream tests, but a little bit worse on
RR tests and TCP streams, based on a microbenchmark.
More testing would be very much appreciated.

changes from v8:
        - fixes fetch_descs returning "no descriptors available" when
          only few descriptors were available, stalling the communications.
        - minor syntax errors in intermediate commits.
        - skipping checking for sane max_descs if vhost device is not going to
          use worker like vDPA devices.

changes from v7:
        - squashed in fixes. no longer hangs but still known
          to cause data corruption for some people. under debug.

changes from v6:
        - fixes some bugs introduced in v6 and v5

changes from v5:
        - addressed comments by Jason: squashed API changes, fixed up discard

changes from v4:
        - added used descriptor format independence
        - addressed comments by jason
        - fixed a crash detected by the lkp robot.

changes from v3:
        - fixed error handling in case of indirect descriptors
        - add BUG_ON to detect buffer overflow in case of bugs
                in response to comment by Jason Wang
        - minor code tweaks

Changes from v2:
        - fixed indirect descriptor batching
                reported by Jason Wang

Changes from v1:
        - typo fixes

Michael S. Tsirkin (11):
  vhost: option to fetch descriptors through an independent struct
  vhost: use batched get_vq_desc version
  vhost/net: pass net specific struct pointer
  vhost: reorder functions
  vhost: format-independent API for used buffers
  vhost/net: convert to new API: heads->bufs
  vhost/net: avoid iov length math
  vhost/test: convert to the buf API
  vhost/scsi: switch to buf APIs
  vhost/vsock: switch to the buf API
  vhost: drop head based APIs

 drivers/vhost/net.c   | 174 ++++++++++----------
 drivers/vhost/scsi.c  |  73 +++++----
 drivers/vhost/test.c  |  22 +--
 drivers/vhost/vhost.c | 372 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  44 +++--
 drivers/vhost/vsock.c |  30 ++--
 6 files changed, 435 insertions(+), 280 deletions(-)

-- 
2.18.1

