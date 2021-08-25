Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8E83F7EEF
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 01:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhHYXSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 19:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHYXSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 19:18:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5447BC061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:17:34 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e7so1267505pgk.2
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 16:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1m5G+UsB5ONLRV/9EQ6v7GDDkauXARCD4U0abkbFmRI=;
        b=FEIFBVDwRwk4HFQa05LkJTVXRN4xT1b0bqYyHp8uTGnitJGi2AAU225TbRYBTOYHlT
         3o+fw7v3I4EzNZm5IKWcy1o1iwVSkswoUBPYjMl+fgfSBcVjNm6PDe/uSERkUwB/Vz1g
         KDyPrPypchm9Q3sUFFrvYnUZNS8rodVRlEMOm1JiB5vyr0ZBp1DHfQdLeibKBsgN7SNO
         l1P9SHUb7DshuoqSAQrt0Y8fVWB9K5k2XldukEf6nXrlvi1mAibZDRq8SZcasJtNdSoV
         ZnPj9m5FE0i7GqR/ZUTdd6e5d4j2B4kiuLe6nWnl9CgBy7K4VGSOzuyktzc/UWRmGTWY
         RTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1m5G+UsB5ONLRV/9EQ6v7GDDkauXARCD4U0abkbFmRI=;
        b=IlGi4XtgYY+pMPo6xdozhFwm2mTPNspXJf0IBYqEDYs56Ane/3xbn1xNKzc7tO3vvl
         sZ9MzklZzy1p64xD3eH8jLczprbYv6Q9WlbLE9r58M8NaGJ4lE9IAK+IccNreL5qOBic
         ttlXDV4EjPAlxE+QY9HT3IKEfnNsHOxvux9TqIosGscyUFBWQZZ5GXMobXPOeDRbvw9E
         uCZiFdXQfRvBhY31uK3SReAIbeAiq+fXVrW//OPxNx/fF4IfMiUN8ZUvAIQ20hxScZQ0
         V+4vkTXysCR2CpINUM5Ex1/kSqvZtpQuK6LC6zO34mBswh0wmgH7ZnDAnYS1IvJTHV6h
         9bMQ==
X-Gm-Message-State: AOAM530fvxa6NeNPI9EHhfHzfYW0JUQAKjQ5wABz13r82ufPtCrLKUnJ
        SQzXLmBaSjvpCSpwUHmnfZE=
X-Google-Smtp-Source: ABdhPJytMOuCKG1fVgxx7yRWvoqyeJ9EFWiehJ63A9+DrfhRWf52uC06bSNT5G/sQr5J5gu/jArewA==
X-Received: by 2002:a62:5f07:0:b0:3e2:7556:95a0 with SMTP id t7-20020a625f07000000b003e2755695a0mr678554pfb.55.1629933453641;
        Wed, 25 Aug 2021 16:17:33 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d4a1:c5c4:fef5:2e3e])
        by smtp.gmail.com with ESMTPSA id mv1sm6625035pjb.29.2021.08.25.16.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 16:17:33 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Keyu Man <kman001@ucr.edu>
Subject: [PATCH net 0/2] inet: use siphash in exception handling
Date:   Wed, 25 Aug 2021 16:17:27 -0700
Message-Id: <20210825231729.401676-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

A group of security researchers brought to our attention
the weakness of hash functions used in rt6_exception_hash()
and fnhe_hashfun()

I made two distinct patches to help backports, since IPv6
part was added in 4.15

Eric Dumazet (2):
  ipv6: use siphash in rt6_exception_hash()
  ipv4: use siphash instead of Jenkins in fnhe_hashfun()

 net/ipv4/route.c | 12 ++++++------
 net/ipv6/route.c | 20 ++++++++++++++------
 2 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.33.0.rc2.250.ged5fa647cd-goog

