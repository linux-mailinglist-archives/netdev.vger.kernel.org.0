Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7285E21D08A
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgGMHmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgGMHmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 03:42:47 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B29C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:42:47 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k5so5828433pjg.3
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=w7p+CAQLgt26UST7S8ZDIeLTGOveJzJZ0hj+PHQ4lWY=;
        b=Vi9OvFl90QN7VKXBpmvwXd5CDx002luqhaqg36twltwP7Cl1QE91WPpml3B0sJLFdO
         I4wRtfF/SVQx/BpsQy9MfmYgLoBiUtp2GtgoXQAUBbnUlTg0IASe3UtQKPiYlh3+I2EC
         f6+r00L3+YdbKNrbo8/CXSp8Kuyoc2l/gwf/yd86ZwtkQwoqofsCXxOnNW608pe1sLsS
         2IXLlUyQ30F2LAsd8c+kR6DGn9+q3Org7lDofrWvkfpxEqAf62M5ghN54ofJIBgV2T73
         mZx4oO2d2tj8hyTX3d1Wo+VuwuV2LsVNvbCwI2srK2XXqaNC+iPrPaSI8XHChZX/+meQ
         DS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w7p+CAQLgt26UST7S8ZDIeLTGOveJzJZ0hj+PHQ4lWY=;
        b=VYogUAfSqYRW3z3CbQkX2m/Q+YH6RG9vbUfuEMrLc8tEmkPBieGTGdwjs0otmxL36I
         cSl3X7MDpcWkcOvom+Sw/YAbIXDU4a/PR3JMkXQd1XtKFedGhV0UtAQ8i0sgjVYBy9QU
         Ab0UEI5FU0k4DD8ra24xstOliHCJxhVE6iQE/spy9ncMiVLjDWZdpyO7cYzA/dtEzVGV
         +mBQZLs8oRSbBB0LkuJ3aO0R449NDNzL5UfjalkB3WxvNq1xHFmRbV16/zxO0mDNX2Qs
         UOBp2spNngqPwRHjPb3jZ7NiXBK7l9FTpMHeDK+/T6e4mi0NXiyD12LjZj9sK00v4C/c
         Rr8A==
X-Gm-Message-State: AOAM530pHnMprRoZuyNWYr5Vow5224Pgzup8PzWE15L+WaaHWK6/FZqG
        FZDkX7loClIVPglwOpaF0v8UwLQK
X-Google-Smtp-Source: ABdhPJwVx6TjuLEZD2d3I46tqPVMpuHPO7Wh+9lBxm81cccph9CIhd86UffHHcit2NJEWVAhYjO/bg==
X-Received: by 2002:a17:902:9692:: with SMTP id n18mr41205021plp.86.1594626166651;
        Mon, 13 Jul 2020 00:42:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b13sm13841161pjl.7.2020.07.13.00.42.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 00:42:46 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/3] xfrm: not register one xfrm(6)_tunnel object twice
Date:   Mon, 13 Jul 2020 15:42:35 +0800
Message-Id: <cover.1594625993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now in ip(6)_vti and xfrm interface tunnel support, it uses the
same xfrm(6)_tunnel object to handle for AF_NET and AF_INET6 by
registering it twice.

However the xfrm(6)_tunnel object is linked into a list with its
'next' pointer. The second registering will cause its 'next'
pointer to be overwritten, and break the list.

So this patchset is to add a new xfrm(6)_tunnel object for each
of them and register it, although its members are the same with
the old one.

Xin Long (3):
  ip_vti: not register vti_ipip_handler twice
  ip6_vti: not register vti_ipv6_handler twice
  xfrm: interface: not xfrmi_ipv6/ipip_handler twice

 net/ipv4/ip_vti.c         | 13 ++++++++++---
 net/ipv6/ip6_vti.c        | 13 ++++++++++---
 net/xfrm/xfrm_interface.c | 22 ++++++++++++++++++----
 3 files changed, 38 insertions(+), 10 deletions(-)

-- 
2.1.0

