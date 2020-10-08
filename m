Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A657A2875A6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgJHOJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:09:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730175AbgJHOJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602166145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lNg244olvJnrEe+Em6GeVtepoBO4gPo9xXAtNaqbKRU=;
        b=JBRX0IbyFzUEp2MsIyId/57GX9SUBAecIo+18DbMy8Gf2lJN0OkThQ3Pg/o6bWm2mI9Zc8
        ALom9xLqsMoGQk34vjW4YV8DZKeqd3OlQvpnzxFdmd5iTU4+yIr/yh44vEUFUDkAJ4FCJe
        zDYA7ijrYj1dxBeTw6YVYW2i+rjGjGQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-_cGUMrveO1-TQBzDaZONvQ-1; Thu, 08 Oct 2020 10:09:03 -0400
X-MC-Unique: _cGUMrveO1-TQBzDaZONvQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8053E1074644;
        Thu,  8 Oct 2020 14:09:01 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82A01757DF;
        Thu,  8 Oct 2020 14:08:58 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5DB5330736C8B;
        Thu,  8 Oct 2020 16:08:57 +0200 (CEST)
Subject: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Thu, 08 Oct 2020 16:08:57 +0200
Message-ID: <160216609656.882446.16642490462568561112.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

V2: Change BPF-helper API from lookup to check
V3: Drop enforcement of MTU in net-core, leave it to drivers

---

Jesper Dangaard Brouer (6):
      bpf: Remove MTU check in __bpf_skb_max_len
      bpf: bpf_fib_lookup return MTU value as output when looked up
      bpf: add BPF-helper for MTU checking
      bpf: make it possible to identify BPF redirected SKBs
      bpf: drop MTU check when doing TC-BPF redirect to ingress
      net: inline and splitup is_skb_forwardable


 include/linux/netdevice.h      |   32 +++++++-
 include/uapi/linux/bpf.h       |   74 +++++++++++++++++-
 net/core/dev.c                 |   25 +-----
 net/core/filter.c              |  166 ++++++++++++++++++++++++++++++++++++----
 net/sched/Kconfig              |    1 
 tools/include/uapi/linux/bpf.h |   74 +++++++++++++++++-
 6 files changed, 326 insertions(+), 46 deletions(-)

--
Signature

