Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043A3642DD5
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiLEQvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiLEQus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:50:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836C42199
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670258946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bsnqQAP9mq9bp37v+PtTYRzX/Oieujg8IWjQ8JkmFYE=;
        b=Z5q7nJ9CLQ5+zmpi6Ys1oErpAxSqyOmYGESczrD7N3Ei2kin2H2T7+AJHmpDzH7/Kb3mI8
        zC1yaVuA/Wxl4/yiqun/5KZbcyCdjAzBa7Zf6+qgdeRP+jPGynMsj0QSBA6G4m2e60+/Vb
        WxSQhHB04UjrJstw/fdVnnKxDhBhm/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-wBQ1drpcOHalFETe-pWhnA-1; Mon, 05 Dec 2022 11:49:03 -0500
X-MC-Unique: wBQ1drpcOHalFETe-pWhnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 265FB185A794;
        Mon,  5 Dec 2022 16:49:03 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BA30141511A;
        Mon,  5 Dec 2022 16:49:01 +0000 (UTC)
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
Subject: [PATCH HID for-next v2 0/4] HID: bpf: remove the need for ALLOW_ERROR_INJECTION and Kconfig fixes
Date:   Mon,  5 Dec 2022 17:48:52 +0100
Message-Id: <20221205164856.705656-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

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

Benjamin Tissoires (4):
  bpf: do not rely on ALLOW_ERROR_INJECTION for fmod_ret
  HID: bpf: do not rely on ALLOW_ERROR_INJECTION
  HID: bpf: enforce HID_BPF dependencies
  selftests: hid: ensures we have the proper requirements in config

 drivers/hid/bpf/Kconfig             |  3 ++-
 drivers/hid/bpf/hid_bpf_dispatch.c  | 20 ++++++++++++--
 drivers/hid/bpf/hid_bpf_jmp_table.c |  1 -
 include/linux/btf.h                 |  3 +++
 kernel/bpf/btf.c                    | 41 +++++++++++++++++++++++++++++
 kernel/bpf/verifier.c               | 17 ++++++++++--
 net/bpf/test_run.c                  | 14 +++++++---
 tools/testing/selftests/hid/config  |  1 +
 8 files changed, 91 insertions(+), 9 deletions(-)

-- 
2.38.1

