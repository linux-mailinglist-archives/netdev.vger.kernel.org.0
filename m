Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1E6327C7A
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhCAKoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbhCAKoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:44:04 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBD1C061756;
        Mon,  1 Mar 2021 02:43:24 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id b1so13898900lfb.7;
        Mon, 01 Mar 2021 02:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5SVbUaLO6lyScQDOQdWN71umvS+bxt/giAzNcvq8axE=;
        b=dC0D2Qul5BLKjzBn6hsZ8pz2x+qXplgxvAJpqhzLLHD3SpEtHiEqDIVd9Tydu+0pnC
         y5M5f1dDvW3m1o5MEo2BTJfCorreBBPCPV0zJQUHQcqIMfGVxTloU66d6KXwqvLOSMYQ
         PMKdsC0xteMVN5DPxvPWZjiH4/H+3YTBOHq8ky1/+uuvnCWzEy5FsHrYK/3VKwgvWj7k
         UOE8GguOZ212nvXxRgQmr281OCoL6n/qh7fUv6G4FHdbNsxeqjNqf8HOCIsj8RVGCH4n
         UusccyN2MpaspKyXqMFbNHE5DNmLLNxdM1NbBsYREfyFoQC3XnkhoXOD8jkGzYO+iOmT
         CyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5SVbUaLO6lyScQDOQdWN71umvS+bxt/giAzNcvq8axE=;
        b=PnBFhhuccixUM3zj6ps7lcEFrND3Mq869z8I55MFbJQ4Uo+jK89kfFHsAfu5XZ5hxb
         H7iXlvJ+Pxgz1C88VEAJUEGvIISXddoHfOuEqa+CfjAan6fmqZej11tqn8Iw6DHWMECi
         jwO6uBbAkYiIQk4bb0ZCBVEqf/xAld5pHx/QRywxjYBLn8SP3bDSHqbpk9q6JFSnuoBn
         XOBNvx9worEoAENE0+j/aSW2YZ0QI44D2WhOvucrB6IGiZFoUAjD66j18cWpRlJk/6Yk
         kLi0H9yE/9HBspepR7Y8yLM7WU1zQRZJEWH6//gjKf/0FoYOHG5dwQCn8Swpw7k4tvvd
         lcFA==
X-Gm-Message-State: AOAM530H5LMIGeTk0CeTFh8S50DgrSimv/u9PTTmctPtFYqaw7QOl0tE
        Ly0FWW0IHf1O3dJVRAfewSM=
X-Google-Smtp-Source: ABdhPJyVZmJvCtcGvLGRsZkFhYXzj9FoGR5YCrl08IEy3vI71tw3H/Z9H7X7qcATB8rEpMWLVCMnHw==
X-Received: by 2002:a19:3f93:: with SMTP id m141mr9070158lfa.423.1614595402936;
        Mon, 01 Mar 2021 02:43:22 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w26sm2247492lfr.186.2021.03.01.02.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:43:22 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maximmi@nvidia.com, andrii@kernel.org
Subject: [PATCH bpf-next 0/2] load-acquire/store-release semantics for AF_XDP rings
Date:   Mon,  1 Mar 2021 11:43:16 +0100
Message-Id: <20210301104318.263262-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This two-patch series introduces load-acquire/store-release semantics
for the AF_XDP rings.

For most contemporary architectures, this is more effective than a
SPSC ring based on smp_{r,w,}mb() barriers. More importantly,
load-acquire/store-release semantics make the ring code easier to
follow.

This is effectively the change done in commit 6c43c091bdc5
("documentation: Update circular buffer for
load-acquire/store-release"), but for the AF_XDP rings.

Both libbpf and the kernel-side are updated.

More details in each commit.


Thanks,
Björn


Björn Töpel (2):
  xsk: update rings for load-acquire/store-release semantics
  libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire

 net/xdp/xsk_queue.h         | 27 ++++++--------
 tools/lib/bpf/libbpf_util.h | 72 +++++++++++++++++++++++++------------
 tools/lib/bpf/xsk.h         | 17 +++------
 3 files changed, 66 insertions(+), 50 deletions(-)


base-commit: 85e142cb42a1e7b33971bf035dae432d8670c46b
-- 
2.27.0

