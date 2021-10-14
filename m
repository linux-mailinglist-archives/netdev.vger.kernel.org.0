Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75C242E0A4
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhJNSB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhJNSB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:01:27 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8DEC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:59:22 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k23-20020a17090a591700b001976d2db364so5360654pji.2
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBLCTlnK+zZTEWwwCCsMSLDH9fR0KimARbzCBp6r4Tc=;
        b=DgJAHCiTZc1/ThuaiiUIGsdRchtyIaT3d5DX6L4U/dnRvwRZaTxxr02nhG7Pxzv2eU
         Zqxa6+FcNNShHQzIXDgZAnj3TglK3fvKMdSGEdJ2o8X67NysL2ycmOUpDm6I0i7DXIuj
         EOnY0wy9LhsdOHXpQB3q0dMM8JDXMUfEqHIFeeO67qFBhvoJdahqvtROr58PMKAzqvez
         BnF43+9QWpUqcnEEG68JIZmVc9rxd8UCuo01j+1EH35pURWxSwsCJKXzwnzxrzQlrqHb
         asTepgrUaNBc4wxY6kp3dkTEzXDyNcN/ODoFYUVWEhsTUg36lwu/5j6ciIql7Ah1ThtU
         zqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lBLCTlnK+zZTEWwwCCsMSLDH9fR0KimARbzCBp6r4Tc=;
        b=Ra8aATLPJP950vD3XLOkrQAOrmc1+zOlHFhGQ9IV6V43L3FIEEjLqdqIynvbLvuUKw
         dFpzzDxX5YvBZKZWaZ62TqlbOKttmaevnXQv7lgd8tfuJ9YU2iOc6OrQh2DHj4mifRg5
         qHRJ9eTeRiYzmgZ/CTX3bAZF2yqMw8/DxBPkNkx7EzUJT0nVMEv2KvWkSQYT80nXeagx
         32+A21+NqHopGKyH4K/2Kld+xGckUKN3AboPcymJs6OKmPb+bCY6OGyLjoCunQXMJF0A
         Z7n5vKAgvDFILL1f3dylTBoUKJaY+/7/xUluZg5cBVORBhPNa+pEplnMaZjgVRBEdOjZ
         OH9w==
X-Gm-Message-State: AOAM530Y+861uU9Wf2ClptbJoEQSq0Pc6+uslp9N31W/9rR58yjjjvdh
        0sisY59mNfjiwPg2IDqUffQ=
X-Google-Smtp-Source: ABdhPJzjy2uBSCI9iNyJJbfzB0LuUjdwWzdSacnde9j8RSNxfIIOlp7MrQe/RPfhadUiKmYgs/sb8A==
X-Received: by 2002:a17:902:c10c:b0:13f:68b4:4abe with SMTP id 12-20020a170902c10c00b0013f68b44abemr6403872pli.8.1634234362349;
        Thu, 14 Oct 2021 10:59:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b87e:a3bd:898a:99c6])
        by smtp.gmail.com with ESMTPSA id i123sm3060831pfg.157.2021.10.14.10.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 10:59:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] net/sched: implement L4S style ce_threshold_ect1 marking
Date:   Thu, 14 Oct 2021 10:59:16 -0700
Message-Id: <20211014175918.60188-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

As suggested by Ingemar Johansson, Neal Cardwell, and others, fq_codel can be used
for Low Latency, Low Loss, Scalable Throughput (L4S) with a small change.

In ce_threshold_ect1 mode, only ECT(1) packets can be marked to CE if
their sojourn time is above the threshold.

Eric Dumazet (2):
  net: add skb_get_dsfield() helper
  fq_codel: implement L4S style ce_threshold_ect1 marking

 include/net/codel.h            |  2 ++
 include/net/codel_impl.h       | 18 +++++++++++++++---
 include/net/inet_ecn.h         | 17 +++++++++++++++++
 include/uapi/linux/pkt_sched.h |  1 +
 net/mac80211/sta_info.c        |  1 +
 net/sched/sch_fq_codel.c       | 15 +++++++++++----
 6 files changed, 47 insertions(+), 7 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

