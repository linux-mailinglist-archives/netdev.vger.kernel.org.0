Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA132EAA98
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 13:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbhAEMZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 07:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbhAEMZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 07:25:09 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C4BC061794
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 04:24:28 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id i9so35990636wrc.4
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 04:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=9oioH7fTimHXbwiOIluI6SOkD883+857JncYScStEP4=;
        b=FbMwTrKR3cHf2zWL9klv6VK4ofspjXiOKHz6DEaLIOOalGVtItVxyCqOPP800WhLbi
         wFi2HsKPNvZdpo8E+hNyGsuYb7ssalbqsyvaK4oPI22KlV6BRH2bG3u6FWkFlB69pIR8
         Mzaj2gSyw79793NiaO9r8vQXW0XGCyB1lJb/cNMOIFP6X5gMbJupxKnIKYgchD6hT1RF
         3kUDGDsAVgBLnNjdVJgpY2NMvK3HVuNu8jjjV09c7XxKRBfAdMS1iZcmfavT0ykU6hY6
         zpqj71VsNbRoA/gW9DVTYd7a9uYGYPekodMcNhXvVlRFdX46g4pKll/xxPRoLsSoHmnh
         c0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9oioH7fTimHXbwiOIluI6SOkD883+857JncYScStEP4=;
        b=T8Mi+lXfbJx6Ju2u8mbhxSWorLyRJdEF2HjtIYfj+obB4Rzu6VGuvzV2Re5pdy8Jo7
         jzGqbacv9D9JTlEHYUUlJI3bvhzlrqb6s8jBBWhtcX9FnErTcdg1m4XdWebisRLi8KX/
         GzXTfkvMSkVcPi0VW2cAHMse6cWWFc3L5Vj5lUb6KbjKkLg94v/6gEFP1nY6LhBnwTdT
         ng4XwasES2RNw5slDyNGAm/wrHEb4En6LXBx6AsMY5NAY3Fpzsv6xtMO+WSQa+adRs3Q
         cjO/k42Ngb2j3ewPysm/EhxawRZPWHpMTK10uWiuRjnpkCrXy+W7YO6YPSm9u5r9Thcg
         W6Tg==
X-Gm-Message-State: AOAM533ZtFXuJ2UbEBxyhGsxwwHo2uONN+R2+ZhJ1aypUjFWsyt3k6u8
        Ta2CUBP8R8TGncg+8nHaBjnuow==
X-Google-Smtp-Source: ABdhPJzDFqgXfrQp5xp/ZdVS3eJS4pVr3HLwm3vZVbK5A1KjbHq655u+3K3H13y3kF8I1PPCp/eltQ==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr81535395wrt.223.1609849467537;
        Tue, 05 Jan 2021 04:24:27 -0800 (PST)
Received: from f2.redhat.com (bzq-79-183-72-147.red.bezeqint.net. [79.183.72.147])
        by smtp.gmail.com with ESMTPSA id 138sm4242281wma.41.2021.01.05.04.24.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Jan 2021 04:24:26 -0800 (PST)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     yan@daynix.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [RFC PATCH 0/7] Support for virtio-net hash reporting
Date:   Tue,  5 Jan 2021 14:24:09 +0200
Message-Id: <20210105122416.16492-1-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Existing TUN module is able to use provided "steering eBPF" to
calculate per-packet hash and derive the destination queue to
place the packet to. The eBPF uses mapped configuration data
containing a key for hash calculation and indirection table
with array of queues' indices.

This series of patches adds support for virtio-net hash reporting
feature as defined in virtio specification. It extends the TUN module
and the "steering eBPF" as follows:

Extended steering eBPF calculates the hash value and hash type, keeps
hash value in the skb->hash and returns index of destination virtqueue
and the type of the hash. TUN module keeps returned hash type in
(currently unused) field of the skb. 
skb->__unused renamed to 'hash_report_type'.

When TUN module is called later to allocate and fill the virtio-net
header and push it to destination virtqueue it populates the hash
and the hash type into virtio-net header.

VHOST driver is made aware of respective virtio-net feature that
extends the virtio-net header to report the hash value and hash report
type.

Yuri Benditovich (7):
  skbuff: define field for hash report type
  vhost: support for hash report virtio-net feature
  tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
  tun: free bpf_program by bpf_prog_put instead of bpf_prog_destroy
  tun: add ioctl code TUNSETHASHPOPULATION
  tun: populate hash in virtio-net header when needed
  tun: report new tun feature IFF_HASH

 drivers/net/tun.c           | 43 +++++++++++++++++++++++++++++++------
 drivers/vhost/net.c         | 37 ++++++++++++++++++++++++-------
 include/linux/skbuff.h      |  7 +++++-
 include/uapi/linux/if_tun.h |  2 ++
 4 files changed, 74 insertions(+), 15 deletions(-)

-- 
2.17.1

