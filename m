Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42604AC275
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383422AbiBGPFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442510AbiBGOwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:52:19 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D79FC0401C3
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:52:18 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id d27so402853vkn.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 06:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xjCnOU0sLvWX+vekLxUSA4g/zhKs1G47jm1FsaM9SkY=;
        b=avISx7AaE3dddYOA5hk9MWO/39e1yUX4nZZIuwMN/T+U2M6SC+lHp5EPEbzsvVdlsX
         uX/w9sHAauQduMNXqxpSIPTEIrDaqcx1/pJ/AUapN1wVuwWdW4ZeulQLamNUZbqvACtN
         td3rUUqWcai8mQ1ODsY/T23oHO6djLAsQqg0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xjCnOU0sLvWX+vekLxUSA4g/zhKs1G47jm1FsaM9SkY=;
        b=68lf3ZTrX9OO+QPzh2cpYqXciyuYF8YOJ7jraIXqNgWRxBTbhPR0HgO+6ST7FLugRO
         Z95gDl6QNFOpJLwXfIEQ2WoXqJ18P9vZi4b/KodejFOMGni5CdP7yCxkC9yL0X3+wrfL
         hwYgA39/eKiZ2kJTU6Eg+4uXJpy3kuHUOAnjnNAtzA+MdJYXu4QECxNMy0nY6NOMUpuS
         VE32jMbQuoziSMT7QC166Rd17aOtvgEumvpCRZIvc0q1/O+YHXp2Ym7chJ+CrxxmFTdB
         cjdDLPl1zn/T880IPHkAslM9qiwrtlKMLER2Qzy28g8NGJRtkhEnstOViW1rSyuVU9rk
         MPZA==
X-Gm-Message-State: AOAM532UKAIG9kJ8+PxSC3NxyS8tEuZi2uDHV46qTjbjROOO39U8bBwC
        fW7MP9eLB21VX0AqC73AnQzZwL9luOBhV0oW2EGrHVJj99APCGvdbxIYoD9+WkE9sss+tB7Wh1O
        1YG8GHNgLrGfB6QDWJTMGcT08G7JNRcQ4BJFBsPQ4m8gjyb8BE4WUJP4rxC99ioTJY5AMtw==
X-Google-Smtp-Source: ABdhPJy8fboLlgBsr7NTyQTdbL6k86RpEJ9ALKHfTiQ8ly9f0OpXci9S+ZlTSMzOkryZUrHCngj/2w==
X-Received: by 2002:ac5:c94f:: with SMTP id s15mr5005605vkm.35.1644245535145;
        Mon, 07 Feb 2022 06:52:15 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id r14sm581347vke.20.2022.02.07.06.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 06:52:14 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/3] bpf: Fix strict mode calculation
Date:   Mon,  7 Feb 2022 09:50:49 -0500
Message-Id: <20220207145052.124421-1-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes a bad calculation of strict mode in two places. It
also updates libbpf to make it easier for the users to disable a
specific LIBBPF_STRICT_* flag.

v1 -> v2:
- remove check in libbpf_set_strict_mode()
- split in different commits

v1: https://lore.kernel.org/bpf/20220204220435.301896-1-mauricio@kinvolk.io/

Mauricio Vásquez (3):
  libbpf: Remove mode check in libbpf_set_strict_mode()
  bpftool: Fix strict mode calculation
  selftests/bpf: Fix strict mode calculation

 tools/bpf/bpftool/main.c                     | 5 +----
 tools/lib/bpf/libbpf.c                       | 8 --------
 tools/testing/selftests/bpf/prog_tests/btf.c | 2 +-
 3 files changed, 2 insertions(+), 13 deletions(-)

-- 
2.25.1

