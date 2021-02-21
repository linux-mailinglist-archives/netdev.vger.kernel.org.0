Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54164320D6B
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 21:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhBUUKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 15:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhBUUKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 15:10:43 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ABFC061574;
        Sun, 21 Feb 2021 12:10:01 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id r11so7544003ljk.9;
        Sun, 21 Feb 2021 12:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YFe5UFssYILqX7KV4LRHLlpTG2gIquz/MxeYOoRxNfA=;
        b=DaavEhsONevRxSOq+SnH1vIyqBB6YwkUooJbTPlb+vGeuVjOrQM5D8mz0zq6sNM3vk
         fyxlS1tJgfjHFUYHFT+zh+mmDWbsXldbVbkcxYgODB53p0/vBm/ktMNjHKN5lEbEkKsk
         RBbxPh0GrrEvFYtpHuuF8qf9MihTk3hIt+Nmids+G3eZH5p5f/GLs1va4ISX+OLPCfE9
         XxXc3SzRtMV4fpJNfGQBxOoVSGdU1zB6dhF03/ap8lUW7JUJnRR7Hoz6DbC5bbKjGuPm
         FlXIoE7qtpCrP9S9LODaPanL0OMAoFuio8FC4tBCaU7533b2FEzFWVrnidoFK4EHKMSQ
         Xy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YFe5UFssYILqX7KV4LRHLlpTG2gIquz/MxeYOoRxNfA=;
        b=hUzb33oqtmIMXpw0h1mlGpx4SgX+Lve1opFogYaOCqRQVhPwhnAm5Spb0Bt6iYPP23
         ZZ4nxkEuhqhSndk+arNnPWGTetQZxRTIxT4YQrfvaOyXRrs3GLhoCXUuYiankGsvQYOa
         /FHhTtP5+8a1bXb1GxUrRJJFX4krfaRSNj5M/5aVWsFoPsUakaSqjF8eZmAZ3VOVPgWF
         yVsP56YeKRyyicxVdeS5mRXUn0HqB6iEQ1gMiuhCPs+f57mgURwh9mj/LtsOPlooa3pz
         evji7thK7EmKGSZOvFQn7BiRZwupN3s8c442ViUw9GzqIT4BdieT4TxGwTkCaHGVAO5P
         GeJA==
X-Gm-Message-State: AOAM5309l6ZvCiWkFe+Z0zFmLgz8djLCyupHweudPoyjDLzy9O/WFdUM
        d4Kth5Vswhjv1giqpX6iNak=
X-Google-Smtp-Source: ABdhPJyNQx65fSRsexrywPAAeOYLUhIEfIugMyqNiE9uCOZSJ9Yu89ZxrTqEgUPiI09zqDJ9RBfKaQ==
X-Received: by 2002:a2e:858f:: with SMTP id b15mr12701464lji.316.1613938200174;
        Sun, 21 Feb 2021 12:10:00 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id q26sm1657823lfb.86.2021.02.21.12.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 12:09:59 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next v3 0/2] Optimize bpf_redirect_map()/xdp_do_redirect()
Date:   Sun, 21 Feb 2021 21:09:52 +0100
Message-Id: <20210221200954.164125-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi XDP-folks,

This two patch series contain two optimizations for the
bpf_redirect_map() helper and the xdp_do_redirect() function.

The bpf_redirect_map() optimization is about avoiding the map lookup
dispatching. Instead of having a switch-statement and selecting the
correct lookup function, we let the verifier patch the
bpf_redirect_map() call to a specific lookup function. This way the
run-time lookup is avoided.

The xdp_do_redirect() patch restructures the code, so that the map
pointer indirection can be avoided.

Performance-wise I got 3% improvement for XSKMAP
(sample:xdpsock/rx-drop), and 4% (sample:xdp_redirect_map) on my
machine.

More details in each commit. Changes since the RFC is outlined in each
commit.


Cheers,
Björn


Björn Töpel (2):
  bpf, xdp: per-map bpf_redirect_map functions for XDP
  bpf, xdp: restructure redirect actions

 include/linux/bpf.h        |  21 ++--
 include/linux/filter.h     |  20 +++-
 include/net/xdp_sock.h     |   6 +-
 include/trace/events/xdp.h |  66 +++++++-----
 kernel/bpf/cpumap.c        |   3 +-
 kernel/bpf/devmap.c        |   5 +-
 kernel/bpf/verifier.c      |  17 ++-
 net/core/filter.c          | 216 ++++++++++++++++++-------------------
 net/xdp/xskmap.c           |   1 -
 9 files changed, 195 insertions(+), 160 deletions(-)


base-commit: 7b1e385c9a488de9291eaaa412146d3972e9dec5
-- 
2.27.0

