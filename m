Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55A030F18A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbhBDLGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbhBDLGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:06:53 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E97C061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 03:06:13 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id t25so1861671pga.2
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 03:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mznl2x0t9n//eV3qB2RdXE0dndjXVUaokt938SUBRto=;
        b=LHSAVBW27sCFb6iQwtxU74DuseAv5wMI8+f/Gf6Il8eJr/Ghiw0oq2Os4cGUdRKvbr
         8yy6AfxB23g2+WlCl+iwMlWlGnuMDPsbnEvoWpFebviW1h5+hr5Zm3j8eS/yKDylrXxK
         tKvV+yPf1bimY9+GiJFr5ajZMku4oybxeA7SdYoL5tgiwhTf+WqW+RGMouEFVrRgk7OX
         Unc5Da5Zl/HTVhe+sY95/ttinUPUw2oMWCbkIm/gmx01zxz+sNv292Jzs+YcXwUYKBXz
         5dKT/yybIir2qbN5O2VOnJ2B/p3R0tlk/IgnP1EdWy5digzoXPqPIPWvdhmbOa9YYu4W
         b1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mznl2x0t9n//eV3qB2RdXE0dndjXVUaokt938SUBRto=;
        b=tLjPul+jsdSi8xAb+M1zHfZuK8fkr8T5KUma7lkD8jW3QuKpwJZglEjvp3j3/7xVY0
         6KwwThetSQAfMFNd5BkaoFkdKwWUE79eUbmih3NYU1RXduJAbVQAN5LePv3lzx0fIM5v
         HucJLCKKLKlpwxKbUbqxgtjxOOhdoztbuzDaa63gTaQ0ecGk2hmSkirlMCyAnYQ/7vy3
         Y9tU5KX421zKqUi0yEUrcAXjCjhaGLFjoYeIfFdsEX3/g5hn7aW2nf3HdZVGy+3CUp17
         SpuWVd3staEdLYzC+gbH12t7Lfuym31AY3Iv7qULgCRimGJJYhDw2uqen08WQs5l44SV
         H2JQ==
X-Gm-Message-State: AOAM530bWW1U8rB/ruR4Rfsc6nXR/dIDUGcMcsehdEB5FCsTn25k4X9O
        wj82NEnDhnm5xDPeT8hNBpo=
X-Google-Smtp-Source: ABdhPJyYAVIyAFXnm75S+MSVk4RMguWyni4CWitq1UtNWeN1KmeES5X6sMx7Uyxt8osXxWk90pmCJQ==
X-Received: by 2002:a05:6a00:8d0:b029:1b6:3581:4f41 with SMTP id s16-20020a056a0008d0b02901b635814f41mr7533435pfu.56.1612436772030;
        Thu, 04 Feb 2021 03:06:12 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id y15sm5283351pju.20.2021.02.04.03.06.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Feb 2021 03:06:11 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH net-next v3 0/4] net: Avoid the memory waste in some Ethernet drivers
Date:   Thu,  4 Feb 2021 18:56:34 +0800
Message-Id: <20210204105638.1584-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

v3:
  - Adjust patch 1 and 2 according to Alexander's suggestion.
  - Add Tested-by from Subbaraya.
  - Add Reviewed-by from Ioana.

v2:
  - Inline page_frag_alloc() and {netdev,napi}_alloc_frag()
  - Adopt Vlastimil's suggestion and add his Acked-by

In the current implementation of napi_alloc_frag(), it doesn't have any
align guarantee for the returned buffer address. We would have to use
some ugly workarounds to make sure that we can get a align buffer
address for some Ethernet drivers. This patch series tries to introduce
some helper functions to make sure that an align buffer is returned.
Then we can drop the ugly workarounds and avoid the unnecessary memory
waste.

Kevin Hao (4):
  mm: page_frag: Introduce page_frag_alloc_align()
  net: Introduce {netdev,napi}_alloc_frag_align()
  net: octeontx2: Use napi_alloc_frag_align() to avoid the memory waste
  net: dpaa2: Use napi_alloc_frag_align() to avoid the memory waste

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  3 +-
 include/linux/gfp.h                           | 12 +++++--
 include/linux/skbuff.h                        | 36 +++++++++++++++++--
 mm/page_alloc.c                               |  8 +++--
 net/core/skbuff.c                             | 26 ++++++--------
 6 files changed, 61 insertions(+), 27 deletions(-)

-- 
2.29.2

