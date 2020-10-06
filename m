Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E591284F5D
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJFQDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbgJFQDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 12:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602000179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UqRFiHQXu/1vXU7kHJ2cG5GHr/c1BIup8F3cPVfmKCU=;
        b=W/FHixIKo8xiJznN3dNnQk/CpJNG1hf5lGavMl4dd7p8jQe+QgZkzPPhje2dwEZij2wiuY
        iOj1d5L5JBIZJOwAzhh2zM3lIEH65Vn2sDpWPYv4FTHYyhj+bpeSz3rTWSvHIXySDNA6KJ
        umuSKadS5vhpuQ2i7oRSzHTvRVD8V3c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-N9baM9wlOl-3SSJdnNfL4Q-1; Tue, 06 Oct 2020 12:02:55 -0400
X-MC-Unique: N9baM9wlOl-3SSJdnNfL4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4374A18C5203;
        Tue,  6 Oct 2020 16:02:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B200B614F5;
        Tue,  6 Oct 2020 16:02:47 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 6D44730736C8B;
        Tue,  6 Oct 2020 18:02:46 +0200 (CEST)
Subject: [PATCH bpf-next V1 0/6] bpf: New approach for BPF MTU handling and
 enforcement
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 06 Oct 2020 18:02:46 +0200
Message-ID: <160200013701.719143.12665708317930272219.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset drops all the MTU checks in TC BPF-helpers that limits
growing the packet size. This is done because these BPF-helpers doesn't
take redirect into account, which can result in their MTU check being done
against the wrong netdev.

The new approach is to give BPF-programs knowledge about the MTU on a
netdev (via ifindex) and fib route lookup level. Meaning some BPF-helpers
are added and extended to make it possible to do MTU checks in the
BPF-code. If BPF-prog doesn't comply with the MTU this is enforced on the
kernel side.

Realizing MTU should only apply to transmitted packets, the MTU
enforcement is now done after the TC egress hook. This gives TC-BPF
programs most flexibility and allows to shrink packet size again in egress
hook prior to transmit.

This patchset is primarily focused on TC-BPF, but I've made sure that the
MTU BPF-helpers also works for XDP BPF-programs.

---

Jesper Dangaard Brouer (6):
      bpf: Remove MTU check in __bpf_skb_max_len
      bpf: bpf_fib_lookup return MTU value as output when looked up
      bpf: add BPF-helper for reading MTU from net_device via ifindex
      bpf: make it possible to identify BPF redirected SKBs
      bpf: Add MTU check for TC-BPF packets after egress hook
      bpf: drop MTU check when doing TC-BPF redirect to ingress


 include/linux/netdevice.h |    5 ++-
 include/uapi/linux/bpf.h  |   24 +++++++++++-
 net/core/dev.c            |   24 +++++++++++-
 net/core/filter.c         |   88 ++++++++++++++++++++++++++++++++++++++++-----
 net/sched/Kconfig         |    1 +
 5 files changed, 126 insertions(+), 16 deletions(-)

--

