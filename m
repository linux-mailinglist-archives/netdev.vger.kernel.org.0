Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BA953BC50
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiFBQTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiFBQTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:19:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182AE66AE2
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:19:04 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id e66so5138151pgc.8
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 09:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WAUG6zcMKjrVcprQdaEgs0zUtw8MrPH76L3UJK0Do+8=;
        b=LvRDQDm8m86SAxoNP/xujAN+knxDACGzMElxlN/f/xO7calPA71oS0hKngJ55rCXwR
         wnZF8SuBpJ7t5td8Pig6S2Ky3KIdQZQy4MrjlFbxIsz/akXAbA6scCA5qQ4/dsoMY4XG
         IBdqoSNZTp3peIctBKSYxN9iCWpZ5vkX8hP5d/onhOZJbhtgj2BEA/b+crEaCi3TzqPC
         Bsf7ZOjHbrQ6AKdgRn0BT3uky1YIqgg53qgy9ENHzDD2TD71s583Wcjr2MFtA3ktFx9h
         iPot0j+zB17/FMf7xgKMWTpYdP+mjDo51kTlPvFr5dpDFYYD2e9hJ/mkzd8Ma1ACR7Xf
         FY+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WAUG6zcMKjrVcprQdaEgs0zUtw8MrPH76L3UJK0Do+8=;
        b=wVvuelD2G8dbZWLHWGUzMolFWMzKZoiMbS7F5HgM2JCQmBWvWPeL9ZU5sQODcRgNtg
         AdARw+l3lwrR/qZBk+rooJ+zA2jMMQeNbfuUdeTW5UF4WOei4cH5uLGR1ZfIfYGknZny
         9PHMvtCp2GX9fsT1f7cBCdDy0bSA0fq88X2h7ULeAtPQnWsZQY6w1o169SU6s3BY5Ghq
         8eYEIeNiHbWwP9YqvefnbUu5uhqnS1jUyCtaLXTWeffnRwdayb93lZ/u/z1WFLVIM3uS
         yGCXzbE5+CDtQb0oGMMMDMCLFi7cYInBCUbWqpPn9rLtJmAEkrORkmhOdglLentEPr3Y
         HcJA==
X-Gm-Message-State: AOAM532mxNkkoRFJoNv6yeajN/Bfmu27DQDse3AwXYbISUwN6x8Gsx1i
        Dpx59jKq+fYYVAeiB85j+Uo=
X-Google-Smtp-Source: ABdhPJybPMvh+mkaRSbVicPoBLoLyo9grgLjXVP+r8yHt6GeYb0eTXKKvj562/KVxZe88iuBbWKsTA==
X-Received: by 2002:a63:e017:0:b0:3f2:543b:8402 with SMTP id e23-20020a63e017000000b003f2543b8402mr4858876pgh.209.1654186743539;
        Thu, 02 Jun 2022 09:19:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:1ff3:6bf6:224:48f2])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b00518895f0dabsm3751072pfh.59.2022.06.02.09.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 09:19:02 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net 0/3] net: af_packet: be careful when expanding mac header size
Date:   Thu,  2 Jun 2022 09:18:56 -0700
Message-Id: <20220602161859.2546399-1-eric.dumazet@gmail.com>
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

v2: CONFIG_DEBUG_NET depends on CONFIG_NET to avoid compile
   errors found by kernel bots.

Eric Dumazet (3):
  net: CONFIG_DEBUG_NET depends on CONFIG_NET
  net: add debug info to __skb_pull()
  net/af_packet: make sure to pull mac header

 include/linux/skbuff.h | 9 ++++++++-
 net/Kconfig.debug      | 2 +-
 net/packet/af_packet.c | 6 ++++--
 3 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

