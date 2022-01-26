Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175AB49D5A8
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiAZWtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiAZWtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:49:19 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A5FC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:49:19 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u11so854686plh.13
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=rfeFv6uMFRSmd34dXCB2P8TO1BNzAaBNEG/YP+AMKhs=;
        b=okd43+CbYvFpS6KRGBTSt2MAaBlieRVCENpTHRE4MfNi9EzLL8SKvXWL3acXnb2bFI
         yEutZq0YD+Avcgk3PcRyV7vO5rF2lZlA70XiaPtkUA70Pf92J15tVNRmkYhtFolcEfGU
         7ngTvHbmsD2NLiaLgYF7OlK1ghzEMtvedNF3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rfeFv6uMFRSmd34dXCB2P8TO1BNzAaBNEG/YP+AMKhs=;
        b=0I8+r+25Y7qt74kkeji34aHoajCXH8NIDEU6roHQWl+Pb3Nc691NVFsYAGiQ8rpgRh
         joJJr4zBmNaWhaawVzgcFgmvX8ep+xf207WNXmglqi4OYHQR9owFeLKkX26dXcOwdj2x
         XjF43uR7cOy0lR415zvvcSbcDo1JI01g4gKht737999zrSaLyYjVAGJRn1m0Jzn7tZ0Z
         aMrccMf8E4dVXsOXmkVDjVvEKZSbRZ0ETn2qXT0g4dl7D1bnXWMPaysIpBWnO1lJKOkq
         tgsVDmeWhU+AwVLjuZ14ZKNjMoHNfqLBROeyli8PK6bJLCdmXY0bOMS4TnSvaKtaG8j7
         Z97A==
X-Gm-Message-State: AOAM530+fbWwnF4L++Az4a1PhvXAK5g4iyH9UFq32Vwxu0nNRKG26WuK
        5k8lDjS7VAQ7oxhN0gYq7JkttbNJifJZSyUaxWLs7V5HJZbDVYG0IFQnDUihXCPAeZymKfvupjI
        Vegj15siBBkjo8SRhGt1oCzCBgWDSQ0iogmwc+sv4mSqW+hx1AGmRQUTqjHTNIKRrDeOVOzY=
X-Google-Smtp-Source: ABdhPJwU3z0ePM9ahtUYCR4ix/EOfY19tvvzTjNXQjlPh0FNBIqIKpdi2ymQAV+zQ00ABtNyDjtLxw==
X-Received: by 2002:a17:90b:3803:: with SMTP id mq3mr1105853pjb.95.1643237358222;
        Wed, 26 Jan 2022 14:49:18 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q15sm3793941pjj.19.2022.01.26.14.49.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jan 2022 14:49:17 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, ilias.apalodimas@linaro.org,
        hawk@kernel.org, Joe Damato <jdamato@fastly.com>
Subject: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
Date:   Wed, 26 Jan 2022 14:48:14 -0800
Message-Id: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

This series adds some stat counters for the page_pool allocation path which
help to track:

	- fast path allocations
	- slow path order-0 allocations
	- slow path high order allocations
	- refills which failed due to an empty ptr ring, forcing a slow
	  path allocation
	- allocations fulfilled via successful refill
	- pages which cannot be added to the cache because of numa mismatch
	  (i.e. waived)

Some static inline wrappers are provided for accessing these stats. The
intention is that drivers which use the page_pool API can, if they choose,
use this stats API.

It assumed that the API consumer will ensure the page_pool is not destroyed
during calls to the stats API.

If this series is accepted, I'll submit a follow up patch which will export
these stats per RX-ring via ethtool in a driver which uses the page_pool
API.

Joe Damato (6):
  net: page_pool: Add alloc stats and fast path stat
  net: page_pool: Add a stat for the slow alloc path
  net: page_pool: Add a high order alloc stat
  net: page_pool: Add stat tracking empty ring
  net: page_pool: Add stat tracking cache refills.
  net: page_pool: Add a stat tracking waived pages.

 include/net/page_pool.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/core/page_pool.c    | 15 +++++++--
 2 files changed, 94 insertions(+), 3 deletions(-)

-- 
2.7.4

