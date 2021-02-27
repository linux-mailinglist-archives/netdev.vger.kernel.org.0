Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01538326D01
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 13:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhB0MW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 07:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhB0MW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 07:22:27 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C41FC06174A;
        Sat, 27 Feb 2021 04:21:46 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id n16so1031135lfb.4;
        Sat, 27 Feb 2021 04:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbxpzbPndCdDPrdlx9LXXARuC6RHC8GtVIgh3tkL1xo=;
        b=qEHU3lPje/hcQRHLoiQkKddYIymcGpySWWivyxPF11cGpybAqgauectz7/CxKE/q/7
         LezHP/gDr1CePhsIJ1P9xritGaTxZgv66vStgHQmw1GH5iX5U7mBwpvaz246rI6P6Kkr
         Y/dHSrd3mDeE+4qBoaGVIPuMZyQ4orbU240HeWti5FGYaVOAzHF1ep5WMBsNO1yy/DvK
         L7ChfS+t6YJ6/kJ1sTdQax1xk+h5WI16tww2wnyLYZssprb1yQ3TuMBUc/5IcHV7Lm3t
         Gy4qdwFxo263PtSz9R9ap7jVO5uRyA7A9BRb8Q5GXWW2EAydRhQfZqXfmm5WnfOLhIfO
         zU+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CbxpzbPndCdDPrdlx9LXXARuC6RHC8GtVIgh3tkL1xo=;
        b=AYlkiPjcMfRYk1nyLJysjUt0pz37JmuDD64MCTsByCgpevgLGS7qR0WTFJRZb7XUZe
         5g7YCHGMbhIfR9OKYNUmeeKtEJAFkUpCNMx5xBSWs2pY0EnjG5d4kakCPYx0Tw5r33GV
         3YMUcCY+MTJn968jUAgv9hdV87CFiEfEcASFNPFjaoPi5u0dQAHMIg/gm6CmrtDw/OIP
         gus5yFRWVZR9O1MXN7w4VD3WdzO0RiOn7GuMPmEu7we0HZC0GB7Eaj5HjkFJbyzvuHd3
         QFMYpVuYL3hwv9n0X8bDMvEWQjED8oGxYCGGNj0Ile9+8Xhnv2LUO3l+gZ97FEeOFina
         h2Tw==
X-Gm-Message-State: AOAM533oPaC7H4AA5LjhGtWISpsItMKiJKeC/6GSQ0Jg/Q0mbXTSmjAk
        aLf8MirF3lzvwHuIJbCRpyQtS3GnT67s6A==
X-Google-Smtp-Source: ABdhPJxks+OY9YQ6a8AcatCnO8LA4TfR9Lemn0SVC0OVoqhoT7B3/uDu8tLVGjyXzdW4vk5vmAxBgQ==
X-Received: by 2002:a05:6512:34d8:: with SMTP id w24mr4502300lfr.261.1614428504991;
        Sat, 27 Feb 2021 04:21:44 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id u14sm1738091lfl.40.2021.02.27.04.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Feb 2021 04:21:44 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH bpf-next v5 0/2] Optimize bpf_redirect_map()/xdp_do_redirect()
Date:   Sat, 27 Feb 2021 13:21:37 +0100
Message-Id: <20210227122139.183284-1-bjorn.topel@gmail.com>
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
correct lookup function, we let bpf_redirect_map() be a map operation,
where each map has its own bpf_redirect_map() implementation. This way
the run-time lookup is avoided.

The xdp_do_redirect() patch restructures the code, so that the map
pointer indirection can be avoided.

Performance-wise I got 4% improvement for XSKMAP
(sample:xdpsock/rx-drop), and 8% (sample:xdp_redirect_map) on my
machine.

More details in each commit.

Changelog:
v4->v5:  Renamed map operation to map_redirect. (Daniel)
v3->v4:  Made bpf_redirect_map() a map operation. (Daniel)

v2->v3:  Fix build when CONFIG_NET is not set. (lkp)

v1->v2:  Removed warning when CONFIG_BPF_SYSCALL was not set. (lkp)
         Cleaned up case-clause in xdp_do_generic_redirect_map(). (Toke)
         Re-added comment. (Toke)

rfc->v1: Use map_id, and remove bpf_clear_redirect_map(). (Toke)
         Get rid of the macro and use __always_inline. (Jesper)

rfc: https://lore.kernel.org/bpf/87im7fy9nc.fsf@toke.dk/ (Cover not on lore!)
v1:  https://lore.kernel.org/bpf/20210219145922.63655-1-bjorn.topel@gmail.com/
v2:  https://lore.kernel.org/bpf/20210220153056.111968-1-bjorn.topel@gmail.com/
v3:  https://lore.kernel.org/bpf/20210221200954.164125-3-bjorn.topel@gmail.com/
v4:  https://lore.kernel.org/bpf/20210226112322.144927-1-bjorn.topel@gmail.com/

Cheers,
Björn


Björn Töpel (2):
  bpf, xdp: make bpf_redirect_map() a map operation
  bpf, xdp: restructure redirect actions

 include/linux/bpf.h        |  26 ++----
 include/linux/filter.h     |  39 +++++++-
 include/net/xdp_sock.h     |  19 ----
 include/trace/events/xdp.h |  66 ++++++++-----
 kernel/bpf/cpumap.c        |  10 +-
 kernel/bpf/devmap.c        |  19 +++-
 kernel/bpf/verifier.c      |  11 ++-
 net/core/filter.c          | 183 ++++++++++++-------------------------
 net/xdp/xskmap.c           |  20 +++-
 9 files changed, 195 insertions(+), 198 deletions(-)


base-commit: 85e142cb42a1e7b33971bf035dae432d8670c46b
-- 
2.27.0

