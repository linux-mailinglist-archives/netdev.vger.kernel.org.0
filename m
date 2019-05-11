Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F101A95A
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 22:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfEKUQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 16:16:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53130 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfEKUQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 16:16:11 -0400
Received: by mail-wm1-f65.google.com with SMTP id y3so1004174wmm.2
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 13:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hpO6TU3D/wUn9J5rBZ8ayU5V/PLYkIM00zTu2Xz4J1s=;
        b=Vto9ILSJdXgaKg2VmfO+ZyXL2+OqI9GnJ42kitCA5oAaXNCphvHlJL18mHIX4fB0li
         gYZc17KT9JmPlBEdOZrVzREyouGkyWJPbAHb11daGegDUv5pcmLuqDnfG7Q0tGF5728s
         6/df5QPP9gvS9eTRj78HJTw63mWmpkjnubEFnflmr3mTNNshWG39OmLlJnUysr/z8L7T
         +B1HaqBFOUBKBX3t4ZW+v8Cx0G6RdfV3LlEpiVcOKIJbuT3ryxt6Uyuzrv8ntd+X2de2
         qjWUJqFvvxHx+ENELyb90Lr8aCyKRQ6KjvPrBad9OuXw51O53sjxrMxWnYi4PzvCGwq2
         lLYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hpO6TU3D/wUn9J5rBZ8ayU5V/PLYkIM00zTu2Xz4J1s=;
        b=hI5/LcEGatPYtZY7S3hfFBXaJ4qUuqwHhM5lpGUY6g3qeY7ZH86hlqEzS/3y26aS+/
         xgONAHkR/nPn5q5FBBEoYIwFzjd60QK57qjD4QDOau7NDRdFcLUgb2idCu4Wx5Uh0DYI
         qtrrNVAnHbpBC7Zkg8yqskvJoe6T3Pl1LPq3qsCL2fGeBHgGz9RHU2wdd0sEx4t8mQUu
         kziRmiTAip5grWG03HTTgCrK7Z1h9FDZ7AdqaE+Zys9J0mCznp5I+vqBxKrXsPtrP0bS
         wKPt20Y6czY2LYfqQrszfWlglMV4jlfpVjmDKpHsRI/HYzlyveu/AnCpwDsghUYnubbV
         rxBQ==
X-Gm-Message-State: APjAAAXr34J0LA9rItSk5UpdiM0yAY/3LgNVyE7SwWTYn7Gi5SkByoyI
        5FFD2DcDe8kITQVn4TEJ8ng=
X-Google-Smtp-Source: APXvYqzWA0WTClSmOQucMWLp66/brQmDg3aHo11Tg5pSEBDGwniiFUJt1gRL5ERkDBdGv2f7QAkYAA==
X-Received: by 2002:a05:600c:506:: with SMTP id i6mr11310303wmc.3.1557605769235;
        Sat, 11 May 2019 13:16:09 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id c20sm11853275wre.28.2019.05.11.13.16.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 13:16:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/3] Fix a bug and avoid dangerous usage patterns
Date:   Sat, 11 May 2019 23:14:44 +0300
Message-Id: <20190511201447.15662-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Making DSA use the sk_buff control block was my idea during the
'Traffic-support-for-SJA1105-DSA-driver' patchset, and I had also
introduced a series of macro helpers that turned out to not be so
helpful:

1. DSA_SKB_ZERO() zeroizes the 48-byte skb->cb area, but due to the high
   performance impact in the hotpath it was only intended to be called
   from the timestamping path. But it turns out that not zeroizing it
   has uncovered the reading of an uninitialized member field of
   DSA_SKB_CB, so in the future just be careful about what needs
   initialization and remove this macro.
2. DSA_SKB_CLONE() contains a flaw in its body definition (originally
   put there to silence checkpatch.pl) and is unusable at this point
   (will only cause NPE's when used). So remove it.
3. For DSA_SKB_COPY() the same performance considerations apply as above
   and therefore it's best to prune this function before it reaches a
   stable kernel and potentially any users.

Vladimir Oltean (3):
  net: dsa: Initialize DSA_SKB_CB(skb)->deferred_xmit variable
  net: dsa: Remove dangerous DSA_SKB_CLONE() macro
  net: dsa: Remove the now unused DSA_SKB_CB_COPY() macro

 include/net/dsa.h | 15 ---------------
 net/dsa/slave.c   |  2 ++
 2 files changed, 2 insertions(+), 15 deletions(-)

-- 
2.17.1

