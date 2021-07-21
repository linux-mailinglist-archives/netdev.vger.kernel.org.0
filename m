Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4E63D106A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhGUNWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 09:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbhGUNWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 09:22:01 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33961C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:02:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id v1so2530184edt.6
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z3HxhlcjFVfeTyolNsFE13TofseeVib/v3WCt+5AZBY=;
        b=YIl2GYpXvGrgpJUodUsU5XJOMKa8DPllLYd4a12ymeCI1rkodJiWdKD/6HonJF5ian
         unwbtoayynN2Gn0gTy6miC9gtThNlZbT4sT0V8DCZ/G8YB2s08vT/wfj4BuwwILLrrz5
         dqy27jZcbeoY+88NzzaIfhZrJNzBNZyfZA3+l5cIOO4hfoWKRXtFmJov8OV3IrvjeGNO
         lEKx3nuqH0qSLk66wkfmLg+96wGqyb02y8K8S6g62oOUjZf8DvDh1JVAQ9NeGP93QooJ
         npbtWJIqWekdJ9zW8Rl+IRWQPqvgozJcHXSMPn5RecGX0kWuH0+EbwDKAwYkRkPI1Sg5
         XRUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z3HxhlcjFVfeTyolNsFE13TofseeVib/v3WCt+5AZBY=;
        b=ocr0GGowfkkBbkJPuJ95w3Gj2SchBD5XEYkxhOOfue3ehVQA7gq+YSR9UNWdbhv66V
         RDhvdonsPDDHEaxLrBw8eKwif8ceA7SfgH0gJJEED0asDgnekK5cvqLMejnjPGt4dBwz
         Di7z4Ki4+8UEc7O+FXmFLl/1gOIXsCiw7O4hgepZ0Z/dCQPDDNRhnwClH0sTdTzIA9l8
         zjAPpTcTCZ4SITf6V81GpEpVYPpRSO0Oi7eWYnYEJCalrgOe5Cr4Fg2iqkiQxtVMgZ9E
         XRimgLfyd3g3jc7mMgPeTh/zTRUtVEa1tcsv89ph9v5q5mRZUyd+jgSTHfmGpTLeQwmn
         CBVA==
X-Gm-Message-State: AOAM533PgUW4gvykClyCB14L8TwfeGaw+WH2F7gcfHH5L4r0MH2ja0l5
        foxk+FOn/oK6ge56ZEmJXFDAqusWiydYHsaKTSM=
X-Google-Smtp-Source: ABdhPJzvKxIJl7J4QCQSCFGFErBQW1E9V4zYkfHYD/mFJ9fBqEkcIvx4v1IHsLoU4mkT3RP5bKIdOQ==
X-Received: by 2002:aa7:db11:: with SMTP id t17mr47664722eds.297.1626876156414;
        Wed, 21 Jul 2021 07:02:36 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm8362925ejc.61.2021.07.21.07.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 07:02:35 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/2] net: bridge: multicast: add mdb and host context support
Date:   Wed, 21 Jul 2021 17:01:25 +0300
Message-Id: <20210721140127.773194-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This is a minor context improvement which chooses the proper multicast
context when adding user mdb entries or host-joined entries (pointing to
the bridge device). Patch 01 adds a helper which chooses the proper
context when user-space is adding an mdb entry, note that it requires
the vlan to be configured on at least 1 device (port or bridge) so it
would have a multicast context. Patch 02 changes br_multicast_host_join
to take a bridge multicast context parameter which is passed down from
the respective functions, currently it is used for the timer config
value only. This set is in preparation for adding all multicast options
for vlans.

Thanks,
 Nik


Nikolay Aleksandrov (2):
  net: bridge: multicast: add mdb context support
  net: bridge: multicast: add context support for host-joined groups

 net/bridge/br_mdb.c       | 45 +++++++++++++++++++++++++++++++++++----
 net/bridge/br_multicast.c |  8 +++----
 net/bridge/br_private.h   |  3 ++-
 3 files changed, 47 insertions(+), 9 deletions(-)

-- 
2.31.1

