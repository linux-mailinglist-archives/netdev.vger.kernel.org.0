Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E724B17CF
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 22:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbiBJVmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 16:42:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242175AbiBJVmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 16:42:35 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0A92724
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id on2so6347201pjb.4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 13:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=302CEXOYC37eE8mNHQtpmFA59qy5jUlcpF9wgI/z7Wo=;
        b=ci7f1RfYLy+H5Yuk3pVu6oFetx7eoErsUt20ntEy03G+KrQ33WOG2aQgR64qBzHTwO
         9XJzzQxJhpCfY5fSVGswOBS+heWchB1YvbVeuZDhIYnb3AcjaVAhSnFPkHrQeD4ZREWA
         1uIbe2dfY4fcZYMk9x/mvtb9OncYVIiA/sZ7DTG+4uv/kTALg1qMDH1Tj0sjDLElHyWR
         PwAmnj6MeflADY8nySxaoGTSzWgTyK6JYzX0Z10sDr1HkUOHWWGGV5uffQIUq8Z1Qivj
         o80VXjFnbi8CxmHN8n2+H7t2S5vBG32dTHENotRHqedt1bnqnFkmVG9pTImtmc8mBseu
         PuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=302CEXOYC37eE8mNHQtpmFA59qy5jUlcpF9wgI/z7Wo=;
        b=YStC6IR6HtbixmD1v//zNj3AEWUySvTW4H/7QgvV0QC1vkNGsdfWo7HAeBFCjo9rIb
         6Gncjj9VLYhf+P8xKtUBGtkmJJLnNGXSrhutOppWd69kLSTS0Zm8TAq1LByiJWIQnP/n
         G9H7ufJlxZ33Z/+f25BJ79WdDdUTnQHhwZXUUAN1/qj6ePm7FbmH+F5DRwnr5mtNxfou
         9QkZQBHRNfCTGPDZqirhUGzWpKb6RG4Qm09swNOPGhkm+iBNestIy4D6oo/onb3TNy1J
         8X0Jh7K4/sGzZKh7V7LFCsKEbB8j+jJJAf7RDhM6Vilvcqe8ETjTJW+u4aILLCtN4XTa
         HlWA==
X-Gm-Message-State: AOAM531AiT2OYlbn/stoaIxBp8wtC+M1sHn7sSUjxDwr7nbHsqpoVNyU
        iurxY4fa9YvzdoUNu4pQCZE=
X-Google-Smtp-Source: ABdhPJw9sS28wGD3ozsjT++MU/AIoF7uAqi2dgB2YUJtJy5a5qwO5tjvKDaAxmYXohC+ynOkutZbUw==
X-Received: by 2002:a17:903:11c5:: with SMTP id q5mr9341433plh.136.1644529355494;
        Thu, 10 Feb 2022 13:42:35 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:60c1:10c1:3f4f:199d])
        by smtp.gmail.com with ESMTPSA id s19sm23824098pfu.34.2022.02.10.13.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 13:42:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] ipv6: remove addrconf reliance on loopback
Date:   Thu, 10 Feb 2022 13:42:27 -0800
Message-Id: <20220210214231.2420942-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

From: Eric Dumazet <edumazet@google.com>

Second patch in this series removes IPv6 requirement about the netns
loopback device being the last device being dismantled.

This was needed because rt6_uncached_list_flush_dev()
and ip6_dst_ifdown() had to switch dst dev to a known
device (loopback).

Instead of loopback, we can use the (hidden) blackhole_netdev
which is also always there.

This will allow future simplfications of netdev_run_to()
and other parts of the stack like default_device_exit_batch().

Last two patches are optimizations for both IP families.

Eric Dumazet (4):
  ipv6: get rid of net->ipv6.rt6_stats->fib_rt_uncache
  ipv6: give an IPv6 dev to blackhole_netdev
  ipv6: add (struct uncached_list)->quarantine list
  ipv4: add (struct uncached_list)->quarantine list

 include/net/ip6_fib.h   |  3 +-
 net/ipv4/route.c        | 12 +++++--
 net/ipv6/addrconf.c     | 78 +++++++++++++++++------------------------
 net/ipv6/route.c        | 42 +++++++++++-----------
 net/ipv6/xfrm6_policy.c |  1 -
 5 files changed, 64 insertions(+), 72 deletions(-)

-- 
2.35.1.265.g69c8d7142f-goog

