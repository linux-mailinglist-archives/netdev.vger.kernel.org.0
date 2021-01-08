Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBFD2EF648
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 18:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbhAHRMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 12:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbhAHRMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 12:12:36 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A2AC061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 09:11:56 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id z11so9038338qkj.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 09:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y2DOlNQqrTzdFsAQ91KwyDIooFneFM3ZoGyAw5nSLTM=;
        b=ETexeyJFvtQ640gBcXNZ0YvyHGxPAX2auqKXYW2zlsQ6UEMU9TOk29O3MuW1c1THdA
         BPtwcxAer9XUZDbj3GhLcuKPySI6IkFSHb/eDMcldAAT/yw3Cf0V94WSLtoMLjIIFHJz
         vwR8M/dtx9hrXGqzd7Y6D9yBZm4QRfNhRKAy60lD1J2PUNu8bor7zKXzTE8eKEVnUtuE
         rKUv7W5pzQR+uGqryQo9+A6JX1hPQ+KYvhYtqRjVMPy47bFeEbSkH6VtNFgn0PZgM5Co
         LUWhf4OqaYJ53vxnFFUOp6LdEHeIe92wDLsHrebQ3OEBCGZ9Zw20DsOIHcK4wKcatWN+
         CNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y2DOlNQqrTzdFsAQ91KwyDIooFneFM3ZoGyAw5nSLTM=;
        b=tTA0HY6B0Ok3EIvHhsN75iw98HVM4yolw8WnVguPmrccjxuZtvFPtuFZ5AJr1OukLz
         uwdPA7LHfy9eBEpgrA70ZFXNsQKOvnY+GIEXx6wJcsXf698KFuIc2hWRxxtR6pjFUYYv
         HqqzWSQkIDpI2SoOVzLb2aOSv0kb1ve1wlgmKVFovzp+8U+7W7g8opbfCPB5w5+cdJyW
         MJrw1dNfaEgrgJd/F39Zt6+I3772f7BbW5u4llHdY5poSWAWOJnLXeCYWPjLEpLI0v0D
         asWvEzdinMWYkDd2xlyTUAmqYx6BQrXGTli6fy8u90LySKWIbye3xDynuRb/+zE2S/+H
         rgLA==
X-Gm-Message-State: AOAM533H1Yh162vDwjHGmZl+l4x13ZdrF7IOs0T6ZodXgit1EolelYf6
        eUkJoJLmEu700GrGSXNI+gpX4NBwiP8=
X-Google-Smtp-Source: ABdhPJzz9o0ZY9f8o4OFrDC7T55DxYtBdcucQp0B8O2Iriv7Kkr66BZXqwUauHE+kw2VNwIPmFVmaA==
X-Received: by 2002:a05:620a:983:: with SMTP id x3mr4916024qkx.231.1610125915615;
        Fri, 08 Jan 2021 09:11:55 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id c2sm5081600qke.109.2021.01.08.09.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:11:54 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net 0/3] skb frag: kmap_atomic fixes
Date:   Fri,  8 Jan 2021 12:11:49 -0500
Message-Id: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

skb frags may be backed by highmem and/or compound pages. Various
code calls kmap_atomic to safely access highmem pages. But this
needs additional care for compound pages. Fix a few issues:

patch 1 expect kmap mappings with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
patch 2 fixes kmap_atomic + compound page support in skb_seq_read
patch 3 fixes kmap_atomic + compound page support in esp

Willem de Bruijn (3):
  net: support kmap_local forced debugging in skb_frag_foreach
  net: compound page support in skb_seq_read
  esp: avoid unneeded kmap_atomic call

 include/linux/skbuff.h |  3 ++-
 net/core/skbuff.c      | 28 +++++++++++++++++++++++-----
 net/ipv4/esp4.c        |  7 +------
 net/ipv6/esp6.c        |  7 +------
 4 files changed, 27 insertions(+), 18 deletions(-)

-- 
2.30.0.284.gd98b1dd5eaa7-goog

