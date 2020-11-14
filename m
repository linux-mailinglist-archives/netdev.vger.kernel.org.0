Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA902B3175
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgKNXqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNXqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 18:46:17 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D83C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 15:46:16 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id f11so19531224lfs.3
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 15:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=grtNjwxMYBgnVZQT+8x+A3iorsWqWeNsIxm14WpmDRA=;
        b=JYo+zDabHFi4h6u7no7w0AcneELLnmBdvImKdJCdO2wVz7OQttpjyDacbDKzDFvwQb
         oMxiaF1J71OIpZhDnBewTA00MioWUpq0B4XcemABgQSpTkuDsjMTUFaUNH9n+YfzWb8A
         TAQLZnxV6/T7zxgazGyFSQ6vMUosheLE9Xk3XO6LGEubVPtdByvMOpQAgHm546r8bcsN
         HfO/qkhFkjQxfe462vB7FRWxBrWooUm17MN0uoHO8DoLSsDQ0JwyPXShcnnsDpV1LfIk
         RdyUx7YxBVcR4TUdCKb2Sdu2BuFK2BRso8Ni0vxDhEJfcpftw9UdigN3hRM/GH/eEpHB
         CYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=grtNjwxMYBgnVZQT+8x+A3iorsWqWeNsIxm14WpmDRA=;
        b=Hw5FUB/ywTjpeYXaOMubN2mGmRRdi375GLvoQGwrhcDEv+tPtXHySSQQwVLudXHrPR
         GrX+i+KQSq/kYX3FLXTnGwiG2/SmDZczgdfIV+Ua4JubClWJKbMrkM0emb8NEpx6BpF1
         Z9dqw/y842BCE56DqaJPx8vgc1SWgzDZFnpuPYf6xWXJ+CMn8AiLUHclAe15KNi4gIOx
         6XXb5YFZc4T4I1p71dTKs7IWKKVShjPLhutOXMN3UPywaq9JILuczWloAKTI3CJPq0TX
         e44GpmsJ2zHQFo08VbNoloa8iNdwYNMLYs11BdQAdwdqAhHWEE77CxDZX82sNfB1jX3+
         6lwA==
X-Gm-Message-State: AOAM532yxHgF2+nS6KpmD9H7/SwXq/SYvLLNDjNbQ0pgjb+VGcSqqMlt
        LxNZeKcbun55Uiqid8Fd/zi6Ew==
X-Google-Smtp-Source: ABdhPJwjqW5r3z4uavC9UPmfj2/hXutIixteEvFmIOA9MH+TRMv1bO+/wOdxb9FNAoeFKcmnlUzHBw==
X-Received: by 2002:a19:cb0e:: with SMTP id b14mr2961230lfg.496.1605397575379;
        Sat, 14 Nov 2020 15:46:15 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g3sm2112157lfd.209.2020.11.14.15.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 15:46:14 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 0/3] net: dsa: tag_dsa: Unify regular and ethertype DSA taggers
Date:   Sun, 15 Nov 2020 00:45:55 +0100
Message-Id: <20201114234558.31203-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch ports tag_edsa.c's handling of IGMP/MLD traps to
tag_dsa.c. That way, we start from two logically equivalent taggers
that are then merged. The second commit does the heavy lifting of
actually fusing tag_dsa.c and tag_edsa.c. The final one just follows
up with some clean up of existing comments.

v2 -> v3:
  - Add the first patch described above as suggested by Andrew.
  - Better documentation of TO_SNIFFER and FORWARD tags.
  - Spelling.

v1 -> v2:
  - Fixed some grammar and whitespace errors.
  - Removed unnecessary default value in Kconfig.
  - Removed unnecessary #ifdef.
  - Split out comment fixes from functional changes.
  - Fully document enum dsa_code.

Tobias Waldekranz (3):
  net: dsa: tag_dsa: Allow forwarding of redirected IGMP traffic
  net: dsa: tag_dsa: Unify regular and ethertype DSA taggers
  net: dsa: tag_dsa: Use a consistent comment style

 net/dsa/Kconfig    |   5 +
 net/dsa/Makefile   |   3 +-
 net/dsa/tag_dsa.c  | 329 ++++++++++++++++++++++++++++++++++++---------
 net/dsa/tag_edsa.c | 202 ----------------------------
 4 files changed, 271 insertions(+), 268 deletions(-)
 delete mode 100644 net/dsa/tag_edsa.c

-- 
2.17.1

