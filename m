Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627771F3C9D
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 15:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730113AbgFINcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 09:32:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46102 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730056AbgFINb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 09:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591709516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yI7IMsyT2cyUZiENZ8NN7SZy7IVjzdxQU2eq9zUxhow=;
        b=LthrtZVPldLk+OBQjORSzL2+bdHQ4A0jUrcAIr1GfYvarjU17Y63VSUUwQbSMZAsQOGUlB
        nrZSoo8TgUk7F+um+XsuQczzTGZQmBBwX2qOVCK4Zz2nIkDQlKUBPzb17DbSk2uTBksgoQ
        nCQ112Y2gCn8yQM3wbhvV8ktjVZbDWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-mELueZGPPnet7pC3fggmEA-1; Tue, 09 Jun 2020 09:31:47 -0400
X-MC-Unique: mELueZGPPnet7pC3fggmEA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35121872FEB;
        Tue,  9 Jun 2020 13:31:46 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16ADC5D9E4;
        Tue,  9 Jun 2020 13:31:43 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D3944300003EB;
        Tue,  9 Jun 2020 15:31:41 +0200 (CEST)
Subject: [PATCH bpf V2 0/2] bpf: adjust uapi for devmap prior to kernel
 release
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 09 Jun 2020 15:31:41 +0200
Message-ID: <159170947966.2102545.14401752480810420709.stgit@firesoul>
In-Reply-To: <20200609013410.5ktyuzlqu5xpbp4a@ast-mbp.dhcp.thefacebook.com>
References: <20200609013410.5ktyuzlqu5xpbp4a@ast-mbp.dhcp.thefacebook.com>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For special type maps (e.g. devmap and cpumap) the map-value data-layout is
a configuration interface. This is uapi that can only be tail extended.
Thus, new members (and thus features) can only be added to the end of this
structure, and the kernel uses the map->value_size from userspace to
determine feature set 'version'.

For this kind of uapi to be extensible and backward compatible, is it common
that new members/fields (that represent a new feature) in the struct are
initialized as zero, which indicate that the feature isn't used. This makes
it possible to write userspace applications that are unaware of new kernel
features, but just include latest uapi headers, zero-init struct and
populate features it knows about.

The recent extension of devmap with a bpf_prog.fd requires end-user to
supply the file-descriptor value minus-1 to communicate that the features
isn't used. This isn't compatible with the described kABI extension model.

V2: Drop patch-1 that changed BPF-syscall to start at file-descriptor 1

---

Jesper Dangaard Brouer (2):
      bpf: devmap adjust uapi for attach bpf program
      bpf: selftests and tools use struct bpf_devmap_val from uapi


 include/uapi/linux/bpf.h                           |   13 +++++++++++++
 kernel/bpf/devmap.c                                |   17 ++++-------------
 tools/include/uapi/linux/bpf.h                     |   13 +++++++++++++
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |    8 --------
 .../selftests/bpf/progs/test_xdp_devmap_helpers.c  |    2 +-
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |    3 +--
 6 files changed, 32 insertions(+), 24 deletions(-)

--

