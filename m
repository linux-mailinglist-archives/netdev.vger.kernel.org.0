Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32F24AFB78
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbiBISr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240983AbiBISqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:46:20 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD5FC03C1B3
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 10:43:36 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id m18so5951802lfq.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 10:43:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c85reDCGkBPaTN3RSyeYt17oyCuDpc1kgEfl/4qYIBo=;
        b=ti/xACF/P3rWEFRgmY8xRpF4JIOnkE1XX/tpD1pz7X0Jla6qa9o/2hKNHFIIdDWSv8
         X/ONhBVLSufHKlG2OGVsgjFHlrQRWQpgdCZe55fMXriplS+tkWWmnPzdDyRZ2++YPcru
         brnkRLdIg0fhDtRPuCiG5dgUmemTbh3Jy1K9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c85reDCGkBPaTN3RSyeYt17oyCuDpc1kgEfl/4qYIBo=;
        b=WpkkRHpKE/ZNnkRx8CqfX4U2tOnFqhmu33hYn8bDbuQu6BoNRMlCVkzxB6m3AFbs5O
         TooUwRr5CwNxcd9VxPJ7j5aG1Tti2vgSUKzEWZqWFkcqLw9OR/FuXfawG98cCrCm/m5l
         viQeu0vmsaHTxocn/AIkRP41cUrkOrdZ4/dsyNJLoyZqvqFVpBmLjaGwBTnKQpZ3q22D
         4MZWx/QyD+6pwbVHWOYZaN/yxZRpuVj1szGavZjEbJqXTnJJ2WIMWuaFI1+VOVNGCq6J
         U1qVvNaSZupYSSP+Vx2yMLOLR3X1EFKZur744sJCRAGChf70P/cylcxJAC+LXyE1ajUz
         tfNQ==
X-Gm-Message-State: AOAM53261fwn69/eF5cSnjljfQrhFcA7p8OpfSlMWthF/Pg1KQ2O7m1y
        0OB+wrC0YBYVOBI9pZIERx4E6w==
X-Google-Smtp-Source: ABdhPJykHK+JSD5pZoJbPdkPZXSjCXcYsujAoQrPx/0tWATv3lOZr/AnZju3fFO8/cwNmbKMSKJ9nA==
X-Received: by 2002:ac2:47ef:: with SMTP id b15mr2411514lfp.95.1644432214328;
        Wed, 09 Feb 2022 10:43:34 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0e00.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id k2sm2465086lfe.213.2022.02.09.10.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 10:43:33 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2 0/2] Split bpf_sk_lookup remote_port field
Date:   Wed,  9 Feb 2022 19:43:31 +0100
Message-Id: <20220209184333.654927-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the recent split-up of the bpf_sock dst_port field, apply the same to
technique to the bpf_sk_lookup remote_port field to make uAPI more user
friendly.

v1 -> v2:
- Remove remote_port range check and cast to be16 in TEST_RUN for sk_lookup
  (kernel test robot)

Jakub Sitnicki (2):
  bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
  selftests/bpf: Cover 4-byte load from remote_port in bpf_sk_lookup

 include/uapi/linux/bpf.h                           | 3 ++-
 net/bpf/test_run.c                                 | 4 ++--
 net/core/filter.c                                  | 3 ++-
 tools/include/uapi/linux/bpf.h                     | 3 ++-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c | 6 ++++++
 5 files changed, 14 insertions(+), 5 deletions(-)

-- 
2.31.1

