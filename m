Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0698B54498C
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 12:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiFIK5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 06:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiFIK5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 06:57:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BC31AD8D
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 03:57:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cx11so21058720pjb.1
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 03:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VNCye5nMm7npW+dhmwJgh/eC9jneJ0nJbMhRVV6+zGk=;
        b=DOYrClBIESpQwUeI6UeMGeoAcsfjNH8W0LqETpzEOVixsSvfPW1mGHj7SOEDXZU5P5
         dbyArDYJz/xN9RNeoZSF2aGqB+34lDu4GwDwp/AscF2i4GXjQUCA0Iw/8YKd9goyaSZW
         PnRxZ/4TI3KmGAOmXcpqaTffeEQ8Fpp0+oyDGpVaIEYjCkRqaCC40Bh+PJwfWlEE0i1G
         vSAPimo5vJptAdXZ8rqUeY7SXUd1uVrhpZrEPJ34Pz7ywd1RB/jB0V418c/CXl1klZgq
         cU/tBreIq9yIRzSkWVH14+vmOcwJInsupbIHY6IsTGLxe9c1cRqbOl8N9KZ9l2mNhzwy
         0iFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VNCye5nMm7npW+dhmwJgh/eC9jneJ0nJbMhRVV6+zGk=;
        b=n04fe5ki8QKuZJ0RVgOV/dCHrkivy0mvWgiNTgD3aU/V3gCORKwDLg7yCEq/GBn25/
         cQhzKuTmaYQ9Jltk+Pyk3psCImvHNW3wep0t1XjT7RxNxkYOJiXkv4IG9DwSb/k8B5Zd
         +EQ0DoYLvfMrVLO2AHj7lY7KMzPZyr055BfgVytdG4MWUSMjVvn1S4uvrpHSnRemhc5v
         tIAVdDftDytePKJfu70kHO9wo29SGWrgHjLveUGKUWGjpOQd2vBkTiNgQuHGKvvhjxtw
         COi5dm8YCVKAFmeFuPoaPmOSzPo10w921rEuB47IgcbLZoX3TqrILS8n4yqIHAhJZBww
         H97A==
X-Gm-Message-State: AOAM530myzeuWpQQsaPtCok/7JN9VB+e436rKh0luj8gf3qbfvQWZW5P
        oZeZqA8DiqGkUJHpFT1FfqU=
X-Google-Smtp-Source: ABdhPJzUvCbHCxO154kUTuplRZS3rM6FnSG04ildmYrp2b4y4bMYQ6YOkzE4uLiERO4z3leawfXKMw==
X-Received: by 2002:a17:902:9006:b0:167:5c8c:4d37 with SMTP id a6-20020a170902900600b001675c8c4d37mr28540720plp.109.1654772271909;
        Thu, 09 Jun 2022 03:57:51 -0700 (PDT)
Received: from nvm-geerzzfj.. ([49.7.38.61])
        by smtp.gmail.com with ESMTPSA id d82-20020a621d55000000b005184fe6cc99sm16949338pfd.29.2022.06.09.03.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 03:57:51 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Cc:     daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org,
        Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH net-next v3 0/2] net, neigh: introduce interval_probe_time for periodic probe
Date:   Thu,  9 Jun 2022 10:57:23 +0000
Message-Id: <20220609105725.2367426-1-wangyuweihx@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a new option `interval_probe_time` in net, neigh
for periodic probe, and add a limitation to prevent it set to 0

Yuwei Wang (2):
  sysctl: add proc_dointvec_jiffies_minmax
  net, neigh: introduce interval_probe_time for periodic probe

 include/linux/sysctl.h         |  2 ++
 include/net/neighbour.h        |  1 +
 include/uapi/linux/neighbour.h |  1 +
 include/uapi/linux/sysctl.h    | 37 +++++++++++++++++-----------------
 kernel/sysctl.c                | 36 +++++++++++++++++++++++++++++++++
 net/core/neighbour.c           | 33 ++++++++++++++++++++++++++++--
 net/decnet/dn_neigh.c          |  1 +
 net/ipv4/arp.c                 |  1 +
 net/ipv6/ndisc.c               |  1 +
 9 files changed, 93 insertions(+), 20 deletions(-)


base-commit: da6e113ff010815fdd21ee1e9af2e8d179a2680f
-- 
2.34.1

