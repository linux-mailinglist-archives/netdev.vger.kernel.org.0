Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA6345CDEA
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhKXU2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhKXU2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:01 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C98C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:24:51 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u17so2792641plg.9
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mdZuFf+1oV5/8T0i4AD3PjhhawqIIWOYEYMu9lAzV1c=;
        b=mno8dSGvJWA0n+wyB6guDxcz6d5SELr1XOw5BB4vZJL2frhbxSTSTvhlVr8TwXr/SC
         AaeFs4sVT8Tf9lrxiYdLZkRbdjo0ypU7CauTfuBfWRLsOfrNJTXx5eh2FLsvwyNKE6pw
         fM1CAJKP9BjZfZWCF2iObBgMaoP0945DlSPhpfYq3TH6mz+tIG8A/TvMXRVfxC6Y+EMx
         0cezztWpZeO7fRULuxCpY012zvDIbQGVdXrX13E71WKD/Nbwdd9uv89vSHntDW2D6laZ
         qVA6GAMVH4+2Egw5KGcx8a0zX406oubatt62yfXLp3lYiSX/Lao5VPCzFQFiSRp7M6OL
         L7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mdZuFf+1oV5/8T0i4AD3PjhhawqIIWOYEYMu9lAzV1c=;
        b=aeK6omF/TXUu/8F0H5N1opa4tQ3AcH9t9CM5Mv5m85PHIBeIECupLnyELgPyUuvGhB
         6/y3bV1lKvuyZ69Y4xso/54A5xxj+cTzfVwrf1QS+a6gQf8+LUMIpzt4NTU5PaOJ2b4B
         uYL06ygHTcXs1OuarzYlKuWoji6VZpAEx+Asia4fHZxc6k0xizVjXtL4g6KsDC3NaQx/
         dGEGzgeMY99sdqzCGSMZcE5siKs/Ef6Hf2k0ZNGpiC4ZmnkZF+PXf7PuXMiN6bbwvd94
         VF0ux6NNeuaz+fqu+2/7qM+fsFTTAzArkWBTTO4mqhz5MMIjlOYdRLxA6CEORct1hjNJ
         8vvw==
X-Gm-Message-State: AOAM533ELhmvjMMkowM8EHF2HOnzZmE+8a/v2gWttsgMGjxmtE2ltIP3
        mTz2Rhqv+ccU3UNXb2izrJ4JVNGTY24=
X-Google-Smtp-Source: ABdhPJzAi0qjI8Vhs2Brur4gPiW8Bm0gq0jm8EY9YYfdBH/+YjE6xbzKrq3HsSuji7yBLNk6OBsMEA==
X-Received: by 2002:a17:90a:df8d:: with SMTP id p13mr18915276pjv.197.1637785490981;
        Wed, 24 Nov 2021 12:24:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b6ed:6a42:8a10:2f32])
        by smtp.gmail.com with ESMTPSA id i10sm472839pjd.3.2021.11.24.12.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:24:50 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] net: small csum optimizations
Date:   Wed, 24 Nov 2021 12:24:44 -0800
Message-Id: <20211124202446.2917972-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After recent x86 csum_partial() optimizations, we can more easily
see in kernel profiles costs of add/adc operations that could
be avoided, by feeding a non zero third argument to csum_partial()

Eric Dumazet (2):
  gro: optimize skb_gro_postpull_rcsum()
  net: optimize skb_postpull_rcsum()

 include/linux/skbuff.h | 6 +++++-
 include/net/gro.h      | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

