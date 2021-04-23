Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB763690CE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbhDWLGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:06:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhDWLF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 07:05:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619175922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jr7f/c656B14iZH1W7iqJ5TVJAXFbRzcz+BEzN3sEdE=;
        b=cMNx+9LHPEr8euShxVGrPsTz/+E5IDXZlDWkE7SEFn7q1FDzmkcilSBLj7J2R1sy9DmGO2
        /py5mDiw58dvU8p8mPtHu7IMJepwuhZLz1UBP+pPUVThfQ3T7ufjzfSLkHGsXuzlLabyvD
        GoBQzdqVwmAKHRVCI/OY+0dwt+f+ACQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-i6w-qtGqNouLxVKPJPDqgQ-1; Fri, 23 Apr 2021 07:05:18 -0400
X-MC-Unique: i6w-qtGqNouLxVKPJPDqgQ-1
Received: by mail-ed1-f69.google.com with SMTP id f9-20020a50fe090000b02903839889635cso16438902edt.14
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 04:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=jr7f/c656B14iZH1W7iqJ5TVJAXFbRzcz+BEzN3sEdE=;
        b=Mot078JBDqMNvCr5NYC552FSRnhHmponGtkHtR/fuwZ4btdcAtJFwJe05KVFinNU1C
         68zPbbeb1or4cZyDDeGNybYmueD32HPblE2TAsADT2f+tVirzzMeGVu6+4z6SbMen0NV
         s4CmvphU7GXFBCmCunJaFhI3TmctPvOOPi+3jrb9OpBF8vr9TRIlDIgX/aOVH5mf9mP1
         7uKaGOcQVQ4Bo3jm8XoUtPUbOORVf7HzKCQDhfdr55xQI3XhmVWEZeHHb8462n875C5/
         0S7y/B8hpQ2KuVDgqui2oTWAqH0BtL7QYiUCnyi/DIWYe2y4odCEZZIDp1KCDRVwq98H
         1DiA==
X-Gm-Message-State: AOAM532enlYwpYtIrYriikzLoWrPNYrtLR41rYy3fywMGn9FJOimSA4E
        aQY7wLz++1gV28EMQLI+EjBvrj7kM0+cT6OJd34oOGIjT9yT6ruVXw3UcvvMAwtE4Crfn71RzXJ
        X2gM4cxv7fzj+amo/
X-Received: by 2002:a50:e848:: with SMTP id k8mr3711100edn.179.1619175917568;
        Fri, 23 Apr 2021 04:05:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXXZ2dv5SzDhemDUOV/fCE22p57ll81ceIAP/uMuiIiYIkTTmOwirVTG7v6dZRooXO3JjS4A==
X-Received: by 2002:a50:e848:: with SMTP id k8mr3711072edn.179.1619175917300;
        Fri, 23 Apr 2021 04:05:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id gz10sm3720420ejc.25.2021.04.23.04.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 04:05:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A7A42180675; Fri, 23 Apr 2021 13:05:15 +0200 (CEST)
Subject: [PATCH RFC bpf-next 0/4] Clean up and document RCU-based object
 protection for XDP_REDIRECT
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Date:   Fri, 23 Apr 2021 13:05:15 +0200
Message-ID: <161917591559.102337.3558507780042453425.stgit@toke.dk>
User-Agent: StGit/1.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the discussion[0] of Hangbin's multicast patch series, Martin pointed out
that the lifetime of the RCU-protected  map entries used by XDP_REDIRECT is by
no means obvious. I promised to look into cleaning this up, and Paul helpfully
provided some hints and a new unrcu_pointer() helper to aid in this.

This is mostly a documentation exercise, clearing up the description of the
lifetime expectations and adding __rcu annotations so sparse and lockdep can
help verify it. I'm sending this as RFC since I don't have any i40e hardware to
test on. A complete submission would also involve going through all the drivers,
of course, but I wanted to get some feedback onthis first. I did test on mlx5,
but that uses an rhashtable in the driver code, so we can't actually remove the
top-level rcu_read_lock() from that without getting lockdep splats.

Patches 1-2 are prepatory: Patch 1 adds Paul's unrcu_pointer() helper and patch
2 is a small fix for dev_get_by_index_rcu() so lockdep understands _bh-disabled
access to it. Patch 3 is the main bit that adds the __rcu annotations and
updates documentation comments, and patch 4 is an example of driver changes,
removing the rcu_read_lock() from i40e.

Please take a look, and let me know if you think this is the right direction for
clarifying the usage.

Thanks,
-Toke

[0] https://lore.kernel.org/bpf/20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com/

---

Paul E. McKenney (1):
      rcu: Create an unrcu_pointer() to remove __rcu from a pointer

Toke Høiland-Jørgensen (3):
      dev: add rcu_read_lock_bh_held() as a valid check when getting a RCU dev ref
      xdp: add proper __rcu annotations to redirect map entries
      i40e: remove rcu_read_lock() around XDP program invocation


 drivers/net/ethernet/intel/i40e/i40e_txrx.c |  2 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  6 +--
 include/net/xdp_sock.h                      |  2 +-
 kernel/bpf/cpumap.c                         | 14 ++++--
 kernel/bpf/devmap.c                         | 52 +++++++++------------
 net/core/dev.c                              |  2 +-
 net/core/filter.c                           | 28 +++++++++++
 net/xdp/xsk.c                               |  4 +-
 net/xdp/xsk.h                               |  4 +-
 net/xdp/xskmap.c                            | 29 +++++++-----
 10 files changed, 85 insertions(+), 58 deletions(-)

