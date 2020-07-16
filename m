Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EE9222F26
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgGPXjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgGPXjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:39:03 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC625C061755;
        Thu, 16 Jul 2020 16:39:02 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 17so13815256wmo.1;
        Thu, 16 Jul 2020 16:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zYfLfuvgFUV8PEBfESgp3lpVexuC9B9b5s18aDhPPDA=;
        b=KjY4YyMXuJ4Ay3VqVraGJe6N4ia5nXYWzhIqCpEoG3M0VaRDxF0Icl9uhoqCZCmsTM
         24vUSZgW3rulOjOVa95F6XN7JfJKUwsIsQiLyNS8URLfCqbv+RlE5wywfgI7uXYIDGNC
         CMQsbrjKV2TYRnBKQFAFyRWfx1HU1aA5n7raUpL+7QFWViP5eEvqKSSr1iG10Y3QFkL6
         lQqj1Hc6KGrJam+Za0biuFuGSnMBezzF1UMc+QfZJ0sMSBsW2IxOCR0nySP8h2D4xfrg
         iyo/v0+RNs6yY7H0yJHhoepOg9YR6QjvFX5xR9e7tNC0g71k8rjWtG8i9VB60JsAutav
         r9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zYfLfuvgFUV8PEBfESgp3lpVexuC9B9b5s18aDhPPDA=;
        b=YnLz8s/Sy8gVa9yR+5B/kPANrOMX02/jswZi1QF//ENYE7I3NIsFXa7jz9vvmPPFwU
         XcSwhsSM5Y6rFIhP+UqD9NLFTqIKI5BsiK3S/fE1Q80D2BTdOPR9sMSqSjVZAtbToCQB
         OiAkIzYhdtNH72qezx2mewBs8Ka4VPTLNQ//sFxwUvxAh7U7GTRfvhLUE9hv0pYX3EDK
         6T5oFUnYKPElJb/Wld8Wv8TDwAuzLdvkXU2cEKkS8kZ5z2l1OraS7baQ6kdfFo9kn14r
         eEtjustujRk5kqIrFeJ5h1IY03pndUbyHO9db4xdZkRzP85N3+Q/nAEfz+64bAy1+idF
         89oQ==
X-Gm-Message-State: AOAM532I1Xs3IGGUy56hRqRiUtMM6d9bPRKX3Uf36x42LSPFhqzNhgLo
        D6oEDnnOeCFqNOVBjrsLGW4=
X-Google-Smtp-Source: ABdhPJwi7mSoPtKRy/EszwPIGTwlNt2H+dk4kCnJ2OPp43Rm1i9KUT7DiiAE7OsFT8vPFH8Dz9rE+g==
X-Received: by 2002:a1c:c242:: with SMTP id s63mr6488340wmf.146.1594942741502;
        Thu, 16 Jul 2020 16:39:01 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u65sm11278013wmg.5.2020.07.16.16.38.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 16:39:00 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 0/3] net: bcmgenet: fix WAKE_FILTER resume from deep sleep
Date:   Thu, 16 Jul 2020 16:38:14 -0700
Message-Id: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The WAKE_FILTER logic can only wake the system from the standby
power state. However, some systems that include the GENET IP
support deeper power saving states and the driver should suspend
and resume correctly from those states as well.

This commit set squashes a few issues uncovered while testing
suspend and resume from these deep sleep states.

Doug Berger (3):
  net: bcmgenet: test MPD_EN when resuming
  net: bcmgenet: test RBUF_ACPI_EN  when resuming
  net: bcmgenet: restore HFB filters on resume

 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 138 +++++++++------------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   1 -
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  22 ++--
 3 files changed, 77 insertions(+), 84 deletions(-)

-- 
2.7.4

