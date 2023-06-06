Return-Path: <netdev+bounces-8319-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6716472398A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:41:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 803151C20D6F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727AC168D8;
	Tue,  6 Jun 2023 07:41:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6803F1C29
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:41:29 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A397E55
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:41:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb39316a68eso783441276.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686037277; x=1688629277;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jh1lwi31YNQ3ux5fMQM8Bst7VilDQsNM9ZlZ0Gonvoo=;
        b=MDt4PMxNv9OxqENC9igoHnkyxuLD7U/CZM6rJma5+wVjGTLkgV/3niM/Cko4PDuRhq
         4l0ySi0kX5OQudC6MJLHvoHZ6GmYvnishQy6yX9WZTW3h+AwDDFEtI8uk02v8CYPBEdC
         zQB+I2UQ3WGeMkLOklahsp7fCF7t7IVApU1KJ/aQGjUoqLpktXjN3CoPf6jXBARpAzTc
         7DhyGNbjPJHuXUtS6+hJFgKe3Olz442vkXxP4IBys5TmMpXujRLEjioymV9LqIa2dnQi
         INpT/g2xn0DLOIljuZ4WUQaqVYZ5aTo8ysYFvku1T+eSLEAeSGyVr8Hg6+v291rSlxmB
         EoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686037277; x=1688629277;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jh1lwi31YNQ3ux5fMQM8Bst7VilDQsNM9ZlZ0Gonvoo=;
        b=Wk2+SMfoRJsQ+P0cHtP20FMQnyXl1lpuDjzVCUoAv/YtcV0OuwfnBIBZuMyX3eK9Pd
         8ihZlmR82/8LW4CoXPQ/TGDA02PDcwbZhjYKsydebMua3pgrRdadv2SPZmVzJUL48fLY
         pUDmmvRtsMhpkVN7+76u21gGRW21wY77zc06gOLnG6HNQH7cN7frcHk3nLIRclWXPTd8
         lZxo5bB7+B0mqbo2SGRDUohbxYgxjdXd6FUE6KcB3YuojeK9fD77KTODDMztS7epKowe
         XJzd3OilcGOBQqqLHGRRPzxdtkS86qdQ239ztVFhikFrA5GNvSV3hHQVdvfEArqYAXZO
         5qxg==
X-Gm-Message-State: AC+VfDzTqPOoUBW9aiO0PHpwVHeYh6X8YR94KyP41+JAH6vTJakMrFqd
	OVpI1EYy2sx3OjFXo9tYL1vJQJOUY9AccQ==
X-Google-Smtp-Source: ACHHUZ72AYwBWYgJlRVw5thp9q0rpWftj36su3EDDxmPNgOOHoAqTAZhuZS1U1XlgOz+h6W6ZADaquHd8Wmzyw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1202:b0:bb0:f056:cf43 with SMTP
 id s2-20020a056902120200b00bb0f056cf43mr399500ybu.1.1686037277479; Tue, 06
 Jun 2023 00:41:17 -0700 (PDT)
Date: Tue,  6 Jun 2023 07:41:13 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230606074115.3789733-1-edumazet@google.com>
Subject: [PATCH v2 net 0/2] rfs: annotate lockless accesses
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

rfs runs without locks held, so we should annotate
read and writes to shared variables.

It should prevent compilers forcing writes
in the following situation:

  if (var != val)
     var = val;

A compiler could indeed simply avoid the conditional:

    var = val;

This matters if var is shared between many cpus.

v2: aligns one closing bracket (Simon)
    adds Fixes: tags (Jakub)

Eric Dumazet (2):
  rfs: annotate lockless accesses to sk->sk_rxhash
  rfs: annotate lockless accesses to RFS sock flow table

 include/linux/netdevice.h |  7 +++++--
 include/net/sock.h        | 18 +++++++++++++-----
 net/core/dev.c            |  6 ++++--
 3 files changed, 22 insertions(+), 9 deletions(-)

-- 
2.41.0.rc0.172.g3f132b7071-goog


