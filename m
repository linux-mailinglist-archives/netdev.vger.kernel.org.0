Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28ED2A0BB3
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgJ3QvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:51:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgJ3QvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604076658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MEMmusbGX/O+e3LL3XBF0hvrxPzkfS24s7nqpxx/rko=;
        b=hp4GZ18euqY7eZiA1JUZGuePbRs1rEdIbNiaX2yLQ6vqONjXv43qV6BQaF+sYYXVl8TIAg
        zGWf9vKcdkOV+dsZ8kwJuHjd9NMDp1zYLBu3cb032z05uBCCnVhW4PRgr8AGzeRmdMLB19
        n31X3u29wpBismyqllxADrKO24ChfVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-F_jV20kiNPGoO5ZLbHu54g-1; Fri, 30 Oct 2020 12:50:54 -0400
X-MC-Unique: F_jV20kiNPGoO5ZLbHu54g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 178AD1019642;
        Fri, 30 Oct 2020 16:50:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 570705DA2A;
        Fri, 30 Oct 2020 16:50:48 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 2A5F630736C8B;
        Fri, 30 Oct 2020 17:50:47 +0100 (CET)
Subject: [PATCH bpf-next V5 0/5] Subj: bpf: New approach for BPF MTU handling
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Fri, 30 Oct 2020 17:50:47 +0100
Message-ID: <160407661383.1525159.12855559773280533146.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
BPF-code.

If BPF-prog doesn't comply with the MTU then the packet will eventually
get dropped as some other layer. In some cases the existing kernel MTU
checks will drop the packet, but there are also cases where BPF can bypass
these checks. Specifically doing TC-redirect from ingress step
(sch_handle_ingress) into egress code path (basically calling
dev_queue_xmit()). It is left up to driver code to handle these kind of
MTU violations.

One advantage of this approach is that it ingress-to-egress BPF-prog can
send information via packet data. With the MTU checks removed in the
helpers, and also not done in skb_do_redirect() call, this allows for an
ingress BPF-prog to communicate with an egress BPF-prog via packet data,
as long as egress BPF-prog remove this prior to transmitting packet.

This patchset is primarily focused on TC-BPF, but I've made sure that the
MTU BPF-helpers also works for XDP BPF-programs.

V2: Change BPF-helper API from lookup to check.
V3: Drop enforcement of MTU in net-core, leave it to drivers.
V4: Keep sanity limit + netdev "up" checks + rename BPF-helper.
V5: Fix uninit variable + name struct output member mtu_result.

---

Jesper Dangaard Brouer (5):
      bpf: Remove MTU check in __bpf_skb_max_len
      bpf: bpf_fib_lookup return MTU value as output when looked up
      bpf: add BPF-helper for MTU checking
      bpf: drop MTU check when doing TC-BPF redirect to ingress
      bpf: make it possible to identify BPF redirected SKBs


 include/linux/netdevice.h      |   31 +++++++
 include/uapi/linux/bpf.h       |   81 +++++++++++++++++++
 net/core/dev.c                 |   21 +----
 net/core/filter.c              |  168 ++++++++++++++++++++++++++++++++++++----
 net/sched/Kconfig              |    1 
 tools/include/uapi/linux/bpf.h |   81 +++++++++++++++++++
 6 files changed, 342 insertions(+), 41 deletions(-)

--

