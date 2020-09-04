Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873D525DAA6
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgIDNzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730593AbgIDNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:54:22 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10089C06124F;
        Fri,  4 Sep 2020 06:54:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so1178778plk.10;
        Fri, 04 Sep 2020 06:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2aCjamiYVf5Fz4JcQ9yUML0QnDOk7OXiiU5nDXWEwD0=;
        b=puo0JhpFM/7egg5fp7hRaI8LDpHmsLvXJv7riq9oNdHutC17OsH/HaGt09Qdfho+iO
         ZuXgAcjON8xjCojcMtVrta52BIVNECoc1wvjQoInsk5sR+P4m3qxxvKOQmV67+syZwy8
         ajsrBDj98PNiaaPd59YLt5UIEy+BO3IPWYRMgKTKGqUjVBzMU0ZzMuVs7KidXjCFzbaM
         R+JaVn971EJHeA5Hkd8ukyC48yko5ArskqvG/qx3Jc2q8MkQNoVBJ9X0moWDG12w+V5C
         AXFPXOtpfIG1R6/L83pQBRslDUq3tIeaOr+Y74mwjoZXjEknXHRy/bnaChvTEW2aTdQ3
         gkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2aCjamiYVf5Fz4JcQ9yUML0QnDOk7OXiiU5nDXWEwD0=;
        b=YGtVH/XjQI4APsdT0m2sQq6gm2O2k4y4L+furHHOqzblo6hTJc9Fk4pnQciwYF1Vwh
         iOTfWwhIESi2LqqP2Tb2YqfGhOt7Ygv+QHH6USyNiPP++9fpjfgkp0Q1Am9mNyDwRQm8
         h6Y+r209flfqFqEOoOv1uYhp6ckE5fgneCDY36feb88xVA5iU791hVzF2KImSywnPZAv
         Uu/AG63QU8LIxYLocgfE+w3ffiP+gkeFvzCUlgYjdUyioo1d46UCWwACJkUDPil1RbK1
         qICLIWDEj1byescLz0n/amjDQn0OrkhuIAn6ONO7Q5fpmGkZBjM298cZP1VWo1f8Epuy
         Mh6Q==
X-Gm-Message-State: AOAM531hUsaFSXs82M2WkKMxTBiaSnl4OdD55ipriMu0nlDr4CUDL/nG
        WU2ACbzg2pPBa3I+q4/A0Qr6npy5BFzLSSD+
X-Google-Smtp-Source: ABdhPJxZgvJHgq3RHHk1C3vHyPEaKjSQXka5JtO6smUfKJcJRynh77CPs2qFRIPnqjv1dUCbwUdbMw==
X-Received: by 2002:a17:902:8eca:: with SMTP id x10mr8823985plo.129.1599227649496;
        Fri, 04 Sep 2020 06:54:09 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g9sm6931239pfr.172.2020.09.04.06.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 06:54:08 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is full
Date:   Fri,  4 Sep 2020 15:53:25 +0200
Message-Id: <20200904135332.60259-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses a problem that arises when AF_XDP zero-copy is
enabled, and the kernel softirq Rx processing and userland process is
running on the same core.

In contrast to the two-core case, when the userland process/Rx softirq
shares one core, it it very important that the kernel is not doing
unnecessary work, but instead let the userland process run. This has
not been the case.

For the Intel drivers, when the XDP_REDIRECT fails due to a full Rx
ring, the NAPI loop will simply drop the packet and continue
processing the next packet. The XDP_REDIRECT operation will then fail
again, since userland has not been able to empty the full Rx ring.

The fix for this is letting the NAPI loop exit early, if the AF_XDP
socket Rx ring is full.

The outline is as following; The first patch cleans up the error codes
returned by xdp_do_redirect(), so that a driver can figure out when
the Rx ring is full (ENOBUFS). Patch two adds an extended
xdp_do_redirect() variant that returns what kind of map that was used
in the XDP_REDIRECT action. The third patch adds an AF_XDP driver
helper to figure out if the Rx ring was full. Finally, the last three
patches implements the "early exit" support for Intel.

On my machine the "one core scenario Rx drop" performance went from
~65Kpps to 21Mpps. In other words, from "not usable" to
"usable". YMMV.

I prefer to route this series via bpf-next, since it include core
changes, and not only driver changes.


Have a nice weekend!
Björn

Björn Töpel (6):
  xsk: improve xdp_do_redirect() error codes
  xdp: introduce xdp_do_redirect_ext() function
  xsk: introduce xsk_do_redirect_rx_full() helper
  i40e, xsk: finish napi loop if AF_XDP Rx queue is full
  ice, xsk: finish napi loop if AF_XDP Rx queue is full
  ixgbe, xsk: finish napi loop if AF_XDP Rx queue is full

 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 23 ++++++++++++++------
 drivers/net/ethernet/intel/ice/ice_xsk.c     | 23 ++++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 23 ++++++++++++++------
 include/linux/filter.h                       |  2 ++
 include/net/xdp_sock_drv.h                   |  9 ++++++++
 net/core/filter.c                            | 16 ++++++++++++--
 net/xdp/xsk.c                                |  2 +-
 net/xdp/xsk_queue.h                          |  2 +-
 8 files changed, 75 insertions(+), 25 deletions(-)


base-commit: 8eb629585d2231e90112148009e2a11b0979ca38
-- 
2.25.1

