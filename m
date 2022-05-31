Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239815396A1
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 20:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345154AbiEaS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 14:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbiEaS7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 14:59:38 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0700053707
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 11:59:38 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u2so3097753pfc.2
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 11:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4CU4nIJkZVG/LCxodA+Q7qdEuTs7Vum8dgu+aHgrN4g=;
        b=YR8KPMh2dWD8+dKAyubLJ4shR0f13xVpo0juw5o2VU7MkQfR+tEzoYQXbtiECnvHCA
         A0ZK0+JZVW5A8HA6Y3ZU1SIDUaNNEIGNuPgFy2pa091PpFlbX4HEv2fPHWbR/IcLrKFz
         QptConKwcwNLRO5DMhPtzG+qaS1GtrVEc6pps/mf9Uz5DwWUnbfNj5B7gSR20THr4P5T
         jRi1VJvmxAIBW3HtnyWnQUrrM8OZS8ixgBE5qX/Ki13JLpSVYvQPP+8YAgPN5xiEj4Jl
         dpMY3NMr372RUPCdrnx/aHxD4NY9j21Laj/6Fg5FYWRlVb5zvHzc4ITl4O6Ex6eKokm5
         OuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4CU4nIJkZVG/LCxodA+Q7qdEuTs7Vum8dgu+aHgrN4g=;
        b=5Eey21x6GKp+5PONNYu1ysxlJU5S+uqxdI9qvO2KADG5/OAH0t8QOJRVGdSMW5X6YB
         0WGrDpqTU46KYdXnmfnzvgmEz6r3TlfoZP1wKMKTPPlUkFlhOw7jwYJbhjeK6HRV5TSq
         /cZ68V2Kjqvx0TzvesuuWIRlfEAePR4Q+ataW9VoMYMkAFeJHfQdMdbAZACUS8NTN/AP
         eVY6j3G2f5DHsNQ2vB85Wu6PCfkFkN400CX5WyN0IlyPjIZIJo7necpTREw9z9lVfRso
         wQn71tOwl4403F/j1WEAyTXsvDztAkbdpWxQWdCHKt46MxcRmndXUicxkinoe+f9wKq6
         Oy9g==
X-Gm-Message-State: AOAM5326agwI+vPACJNFFBz+QY55Y2vNJ4pHUQ+TSFzvgeb2DECTHMpO
        O4K8hmjjCu0nOiw1m4UYIOI=
X-Google-Smtp-Source: ABdhPJzIi6fpPIQyTRTIXE7O7QPEs9Yzp6PPaQXPUtr9kvouXpvfLxz5+P272sUF0lIDvfkiYGgrjw==
X-Received: by 2002:a05:6a00:2488:b0:518:afb4:bb60 with SMTP id c8-20020a056a00248800b00518afb4bb60mr41621022pfv.51.1654023577504;
        Tue, 31 May 2022 11:59:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:74f8:d874:7d9d:dabb])
        by smtp.gmail.com with ESMTPSA id y30-20020a056a001c9e00b0050dc762814dsm10941628pfw.39.2022.05.31.11.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 11:59:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] net: af_packet: be careful when expanding mac header size
Date:   Tue, 31 May 2022 11:59:31 -0700
Message-Id: <20220531185933.1086667-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
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

A recent regression in af_packet needed a preliminary debug patch,
which will presumably be useful for next bugs hunting.

The af_packet fix is to make sure MAC headers are contained in
skb linear part, as GSO stack requests.

Eric Dumazet (2):
  net: add debug info to __skb_pull()
  net/af_packet: make sure to pull mac header

 include/linux/skbuff.h | 9 ++++++++-
 net/packet/af_packet.c | 6 ++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

