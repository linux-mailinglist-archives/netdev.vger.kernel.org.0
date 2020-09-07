Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEF125FCB7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgIGPLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbgIGPCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 11:02:37 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAD2C061573;
        Mon,  7 Sep 2020 08:02:33 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so712312pjb.0;
        Mon, 07 Sep 2020 08:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0rqXxTT69QR+tdQjYDIQPE0Qtp2NoCEa1nO9jCml3jI=;
        b=Aw6nqVXlGQ6/E/S7jAtGuKo1QEUoT6KshOgSWt9tSSZJ1JJGfjFS7Xh+7UjFzJYPDP
         yZ9Huy4s+Fw4sjXauZ+5T7d5NGDs666FcN48Vzh1mHBtNnZ361zIGDILg+5NLL9wj48i
         xWJOlUq7lRb6PAxXcsgs4ykP8AVyWt4UlUloupkGmVMFyHM4UB3d/EpAu3Cm+ETxSQdk
         3YspfnSSGNlRIt2nXDnzEXKEIjgce/n5dBRIyXZv0s/Ca2N3QICB2PqTf+Vy2dbNwILv
         3Gv3JZO3AnstSYHJG8eaH3yf58VjdvUdbPFxG4+P+/WO4aQ84kkmstO+pAdSe6NC8ey6
         EqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0rqXxTT69QR+tdQjYDIQPE0Qtp2NoCEa1nO9jCml3jI=;
        b=ZOmQH0y5m4KKj9yTPB5sKuPIi9hfaaKWdK0+4ZJVCEp6bsatpeDLu0mJw9dgJKpEID
         CWEIePde7IoY8+gRL8ujhH4HFpHBtrWTqkUTv5qD24lgwYcoTKz8+2wiCtmtAaYOdgD9
         5ytSNevRq9WZa2JrfMde5wvw9ZxhYo6UvpKOzMMBZJPX/y21n0nGTb1SuDFDS7FZYTae
         baHplTML1ffzVwW6XG6UjZjcuM7tFe/WA3YuyJjOklulcgD+8y4lsDriLucfSTdxNAtt
         enXDZXBzf7Pxkgu6b0rSU+lvD5jTN9F55e0sQHKOniGviBcDBCtVxAjHtbY/PC4/s4EQ
         UdbA==
X-Gm-Message-State: AOAM532h7tOhDDzBlwQ+v32oMADxL93wZU3Z/gxtIvMPSx8uY9nVz4k6
        NGa9ID2bKZVilVWkeNKYFo7P/FpK9pkd3TzC
X-Google-Smtp-Source: ABdhPJyvgdPliUEK7HsEk9mwj7waxTAXKzNs8sTmOrMveRoy9NgevilxsWjV3+o89QQxBS0zsH2lfQ==
X-Received: by 2002:a17:90a:49c8:: with SMTP id l8mr7140863pjm.24.1599490953163;
        Mon, 07 Sep 2020 08:02:33 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id g129sm15436022pfb.33.2020.09.07.08.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 08:02:32 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 0/4] xsk: increase NAPI budget for AF_XDP zero-copy path
Date:   Mon,  7 Sep 2020 17:02:13 +0200
Message-Id: <20200907150217.30888-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NAPI budget (NAPI_POLL_WEIGHT), meaning the number of received
packets that are allowed to be processed for each NAPI invocation,
takes into consideration that each received packet is aimed for the
kernel networking stack.

That is not the case for the AF_XDP receive path, where the cost of
each packet is significantly less. Therefore, this commit adds a new
NAPI budget, which is the NAPI_POLL_WEIGHT scaled by 4. Typically that
would be 256 in most configuration. It is encouraged that AF_XDP
zero-copy capable drivers use the XSK_NAPI_WEIGHT, when zero-copy is
enabled.

Processing 256 packets targeted for AF_XDP is still less work than 64
(NAPI_POLL_WEIGHT) packets going to the kernel networking stack.

Jakub suggested in [1] that a more generic approach was preferred over
"driver hacks". It is arguable if adding the budget as a define which
is a scaled NAPI_POLL_WEIGHT would classify as "generic", but it is a
bit further away from "driver hacks". ;-)

The first patch adds the actual define, and last three make the Intel
drivers use it.

The AF_XDP Rx performance for "rxdrop" is up ~8% on my machine.

Routing this series via bpf-next instead of Intel Wired/netdev, since
it is a core AF_XDP addition, and hopefully Nvidia will pick this up
for the mlx5 driver.


Björn

[1] https://lore.kernel.org/netdev/20200728131512.17c41621@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

Björn Töpel (4):
  xsk: add XSK_NAPI_WEIGHT define
  i40e, xsk: use XSK_NAPI_WEIGHT as NAPI poll budget
  ice, xsk: use XSK_NAPI_WEIGHT as NAPI poll budget
  ixgbe, xsk: use XSK_NAPI_WEIGHT as NAPI poll budget

 drivers/net/ethernet/intel/i40e/i40e_xsk.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c     | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
 include/net/xdp_sock_drv.h                   | 3 +++
 4 files changed, 6 insertions(+), 3 deletions(-)


base-commit: bc0b5a03079bd78fb3d5cba1ccabf0a7efb1d99f
-- 
2.25.1

