Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27452644774
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiLFPGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiLFPGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:06:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3DC32BB5
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 06:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670338786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cc4Vy7WMYhGoahXShwfLWL6RdpHCDWpUvTljVdwasiw=;
        b=OTL6VUHeieeyEZ45+Kp/e1qORtl1V8P80P8nnQK0XpaMgcFdfGN1d6r8S4ndhwUcgBOuHT
        oE/mNMYEsx/Jg1PoZQTni9bt6k5mwmKxtdMskkgCJIZuTAHwObNucbZTzk73/bcjJHGXLh
        iHQfgCzTPu/tGZUbDD121Y8Jmytsrrs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-S2Syx4JLPVm-UdqJSo8ciQ-1; Tue, 06 Dec 2022 09:59:43 -0500
X-MC-Unique: S2Syx4JLPVm-UdqJSo8ciQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AD3A2833B13;
        Tue,  6 Dec 2022 14:59:42 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C5684A9254;
        Tue,  6 Dec 2022 14:59:40 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v3 0/5] HID: bpf: remove the need for ALLOW_ERROR_INJECTION and Kconfig fixes
Date:   Tue,  6 Dec 2022 15:59:31 +0100
Message-Id: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a new version of the ALLOW_ERROR_INJECTION hack removal.

Compared to v2, I followed the review from Alexei which cleaned up the
code a little bit.

I also got a kbuild test bot complaining[3] so add a fix for that too.

For reference, here is the previous cover letter:

So this patch series aims at solving both [0] and [1].

The first one is bpf related and concerns the ALLOW_ERROR_INJECTION API.
It is considered as a hack to begin with, so introduce a proper kernel
API to declare when a BPF hook can have its return value changed.

The second one is related to the fact that
DYNAMIC_FTRACE_WITH_DIRECT_CALLS is currently not enabled on arm64, and
that means that the current HID-BPF implementation doesn't work there
for now.

The first patch actually touches the bpf core code, but it would be
easier if we could merge it through the hid tree in the for-6.2/hid-bpf
branch once we get the proper acks.

Cheers,
Benjamin

[0] https://lore.kernel.org/all/20221121104403.1545f9b5@gandalf.local.home/
[1] https://lore.kernel.org/r/CABRcYmKyRchQhabi1Vd9RcMQFCcb=EtWyEbFDFRTc-L-U8WhgA@mail.gmail.com
[3] https://lore.kernel.org/all/202212060216.a6X8Py5H-lkp@intel.com/

Benjamin Tissoires (5):
  bpf: do not rely on ALLOW_ERROR_INJECTION for fmod_ret
  HID: bpf: do not rely on ALLOW_ERROR_INJECTION
  HID: bpf: enforce HID_BPF dependencies
  selftests: hid: ensures we have the proper requirements in config
  kselftests: hid: fix missing headers_install step

 drivers/hid/bpf/Kconfig              |  3 ++-
 drivers/hid/bpf/hid_bpf_dispatch.c   | 20 +++++++++++++++++--
 drivers/hid/bpf/hid_bpf_jmp_table.c  |  1 -
 include/linux/btf.h                  |  2 ++
 kernel/bpf/btf.c                     | 30 +++++++++++++++++++++++-----
 kernel/bpf/verifier.c                | 17 ++++++++++++++--
 net/bpf/test_run.c                   | 14 ++++++++++---
 tools/testing/selftests/hid/Makefile | 26 +++++++++++-------------
 tools/testing/selftests/hid/config   |  1 +
 9 files changed, 86 insertions(+), 28 deletions(-)

-- 
2.38.1

