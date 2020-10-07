Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E922863A3
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgJGQWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:22:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbgJGQWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602087763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Rp7x0JW9bNLOMUE/nE7dKFbiSH89cz3sD3TzyBD4/dk=;
        b=i/oUAjEVYtu0ZJ0xbi+/6Ghb3sOyQkIkglGskAEIp4bc3DckbZ+V7UiMu3kkyNAJytKTRR
        YHhCI8JvcOLqeoH06nsk7k6kkp4O5r/7i3RMO2H7h4grgNBh4enitJBfhOLE3DX0IWPhsr
        4W4ZbTJ7YSmEIExGHDjvyYaaCiElDXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-6Eb2u6ntMBm5d1XJeelfUQ-1; Wed, 07 Oct 2020 12:22:41 -0400
X-MC-Unique: 6Eb2u6ntMBm5d1XJeelfUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8886D10BBECC;
        Wed,  7 Oct 2020 16:22:39 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DA5375120;
        Wed,  7 Oct 2020 16:22:36 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 4CDFF30736C8B;
        Wed,  7 Oct 2020 18:22:35 +0200 (CEST)
Subject: [PATCH bpf-next V2 0/6] bpf: New approach for BPF MTU handling and
 enforcement
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Wed, 07 Oct 2020 18:22:35 +0200
Message-ID: <160208770557.798237.11181325462593441941.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

V2: New BPF-helper design

---

Jesper Dangaard Brouer (6):
      bpf: Remove MTU check in __bpf_skb_max_len
      bpf: bpf_fib_lookup return MTU value as output when looked up
      bpf: add BPF-helper for MTU checking
      bpf: make it possible to identify BPF redirected SKBs
      bpf: Add MTU check for TC-BPF packets after egress hook
      bpf: drop MTU check when doing TC-BPF redirect to ingress


 include/linux/netdevice.h |    5 +-
 include/uapi/linux/bpf.h  |   68 ++++++++++++++++++++-
 net/core/dev.c            |   28 ++++++++
 net/core/filter.c         |  149 ++++++++++++++++++++++++++++++++++++++++++---
 net/sched/Kconfig         |    1 
 5 files changed, 235 insertions(+), 16 deletions(-)

--

