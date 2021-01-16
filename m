Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBDD2F8B3A
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 05:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbhAPEc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 23:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAPEc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 23:32:57 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC81C061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 20:32:17 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i5so7340669pgo.1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 20:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UTfoDj4UYkB+qkhv0fSY11wvbE3M/Ek9Rz7CG+0/s2E=;
        b=BdjLTTDSJbmGtQ2sSTh7PQ2i11yF3e4BKOmFUbEk+FFI+Dvuhd3Mm5K2jcAZ+rM8hi
         k0gg7j227klp4lgHk6Xu4CFED0vaw5GLNXr2WS+9DS9lZ00qZxVO5dhHSG1T3+JjsYYZ
         PCkuzRzc3GDNKDuswsLZhECZLd/6eK5irak+TiDq667VXlXpCOA7yicV9c1rYvz/n1jm
         Ox4AWxECbhed0gDPdpXvrXmOA5zzIMpMcZOXe/xkU7DVE1D7tQ7OyBMM0SJjV7jmFnLm
         TLFEjNQAdt4ZNuMYfLekii2Lccsbh/+Qtw8/JCm1Ldv+XyWOMoFzn++bP2VjP1LIpN09
         O1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UTfoDj4UYkB+qkhv0fSY11wvbE3M/Ek9Rz7CG+0/s2E=;
        b=UzCvCctpYpPsVrWdR5+PNbyKhjOZafGfjC+TYan5bX2a+by/1gSmoe+0ECuxCaF70G
         WRXte9npoMzU5IqpbmDvb1Tqv7WFi1iJ4TndmwkG+8Ou6BdOAWZay5vv+Gtq9bHVj3X6
         vfZ5AI8p7Y7PDLv+07PWwOid15C3RywJAGQn+G2ArSiUAQXaUuvGUj4mLPtE/IMOFrhX
         /QLjmcGqdq8UVTLKTec4kEaDER2fFLj+yqHEUMYqej9sUJz5puqjPGVY8S+0FHENpKgg
         rXb2dZZGu/g59S8MPzxWkjU685TRqNfDtlb+y2rUl/1xUQ6QLxgo0sVGf5EK3VAhXaUR
         y9mA==
X-Gm-Message-State: AOAM533PllXfdEdWMtWBhcCHZhAJz3Q2dxvCi0ppe025kUJ/e2bfz326
        bqL1F2cVFRSPNq5iSSPiJuKKr5F98N53LA==
X-Google-Smtp-Source: ABdhPJxNw52sgJ3EBnCj36/hxY+QUPaMX4eMbOUs5o7r/kwPZHB1q/9QW11ZPA2L+2hE8ztb9mDZNQ==
X-Received: by 2002:a63:5d7:: with SMTP id 206mr16355120pgf.384.1610771536406;
        Fri, 15 Jan 2021 20:32:16 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u25sm9639719pfn.170.2021.01.15.20.32.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 20:32:15 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCHv3 net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP GRO
Date:   Sat, 16 Jan 2021 12:32:06 +0800
Message-Id: <cover.1610771509.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, udp v6 socket can not process v4 packets with UDP GRO, as
udp_encap_needed_key is not increased when udp_tunnel_encap_enable()
is called for v6 socket. This patchset is to increase it and remove
the unnecessary code in bareudp.

v1->v2:
  - see Patch 1/2.
v2->v3:
  - see Patch 2/2.

Xin Long (2):
  udp: call udp_encap_enable for v6 sockets when enabling encap
  Revert "bareudp: Fixed bareudp receive handling"

 drivers/net/bareudp.c    | 6 ------
 include/net/udp.h        | 1 +
 include/net/udp_tunnel.h | 3 +--
 net/ipv4/udp.c           | 6 ++++++
 net/ipv6/udp.c           | 4 +++-
 5 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.1.0

