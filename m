Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1186B1E4D87
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgE0S5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE0S5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:57:34 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BFDC08C5C1;
        Wed, 27 May 2020 11:57:34 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id o13so411503otl.5;
        Wed, 27 May 2020 11:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g2vGCR2PwAa8F8IRmSQFqWywN7G/iorR2bDg1oKx8vo=;
        b=X03nVfPdug4RLL9gFajwkD9X1dXJRgMj6UpuvRAP5x2I7C+wsVQZv0J/lq6NEHyJ/w
         KFNz7ToWGwbG/4ygXmqisP20ueqPe5D11ikiQ9wmdquB5OwoWc8AA8URym1B+/ISNFKF
         bQdXYIgdO6lUwRlcDuEnXw6aZNS7yARjxmxzxdC+nFcttt9tzRXGTnW8wzZ5Matpg1w5
         fUZdpRth/AHhknhwaCiVLLhUmB7hHSnptWv17xQ4Nhw9+psXftQ5a3HAHGNlxG3p3CdW
         l6SnX5l4WbIks37e4EfzvHAJET02jWmd6w8ak9RD1ZuOzaGL+wisew46c9TSaRtQXxST
         tgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g2vGCR2PwAa8F8IRmSQFqWywN7G/iorR2bDg1oKx8vo=;
        b=G72qaz4D5bbnjsc6mdRNusI4/gTVMuMVF/BSh2mkK/1L6kwrM07b3Hv+juFcySyy5e
         jQSVymVNT/UADRmCGO6M3ZVYjOVoZArvL24H1Cy/xYAzwMQ4D1tvjSEOOUHI62w0XaPu
         ra/8taL3jYI5yI69Xc6+9ETiGKUOiDqCI7VxT1nDsTv1L1SFiX71qUeLOnsPrvs5Wclh
         Lj4OJWc8SdJ7fvv6kW2N6t9TIFgFFfM5LivTtAaY+YPycSsbthD9UPH+lSqps+vHSWbG
         W/27/vmGKu3TN4zcP3Ekp1sMe1jf1h9L4KY2wajnYaDrPtztNzKcBv8oFiuddVVCwAeG
         mfmQ==
X-Gm-Message-State: AOAM5312ZE7xw0HPcKB9tVHmohasCBHt4kvGq6OKuTbgZkevhFMfQu9j
        Vhs1SH4CGIn7kE98tZfnCtE=
X-Google-Smtp-Source: ABdhPJx7QW5rtnii9GahYXYsoy8Y9wuPRD1GGETX+w1AIBIT5C6KfNwkEHUciNW24C8t41i+AE+ggA==
X-Received: by 2002:a05:6830:1584:: with SMTP id i4mr5862035otr.285.1590605854107;
        Wed, 27 May 2020 11:57:34 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:92ff:fe3e:1759])
        by smtp.gmail.com with ESMTPSA id i127sm1074596oih.38.2020.05.27.11.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 11:57:33 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <shuah@kernel.org>
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 0/5] bpf: fix map permissions check and cleanup code around
Date:   Wed, 27 May 2020 18:56:55 +0000
Message-Id: <20200527185700.14658-1-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes a bug in the map_lookup_and_delete_elem() function which
should check for the FMODE_CAN_READ bit, because it returns data to user space.
The rest of commits fix some typos and comment in selftests and extend the
test_map_wronly test to cover the new check for the BPF_MAP_TYPE_STACK and
BPF_MAP_TYPE_QUEUE map types.

Anton Protopopov (5):
  selftests/bpf: fix a typo in test_maps
  selftests/bpf: cleanup some file descriptors in test_maps
  selftests/bpf: cleanup comments in test_maps
  bpf: fix map permissions check
  selftests/bpf: add tests for write-only stacks/queues

 kernel/bpf/syscall.c                    |  3 +-
 tools/testing/selftests/bpf/test_maps.c | 52 ++++++++++++++++++++++---
 2 files changed, 49 insertions(+), 6 deletions(-)

-- 
2.20.1

