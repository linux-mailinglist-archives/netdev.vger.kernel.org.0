Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703FA6E8CA0
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbjDTIXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbjDTIXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:23:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE46335BB
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-63d4595d60fso5325509b3a.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681978970; x=1684570970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=485fSWTzxfO4MaaYixxcOQ+EgmPdfYoR20+Ca5UsZVM=;
        b=V9NbdusIkzMvfYZgqNbfDbrqzg90dFtkrmCrk3ZqAjvytwnS6yts7BN3I2ZBybgXV7
         gTredXCI+LeSNDyCkbbqFIQPGCOCErSC4LrrBkiHLPqbgjO9eC5YVmTGhAEPOFYUt2BI
         DtYGvrzzVuWT5FEXkmEn3UZ3PQiDECO+Odq/5UwGPhuO4IQFTg0KT1b0pv/JFyyXRlhe
         4frgdYPiCnZrsqL+VTxAtNcHy34RSrdXxPm7f0lTte0mRCKNSsECyv83nmjP6X+PVqc+
         C5DnsxfN90ClEdKWDZZgn9iKE95yc0HTv7M3adUwW0N90Ljpf4UiUl+Zk/xjtoPGY3fz
         CS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681978970; x=1684570970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=485fSWTzxfO4MaaYixxcOQ+EgmPdfYoR20+Ca5UsZVM=;
        b=BsauMd0wMcy4VpSS2hiWJNkLv6TpaD6+YiLY4bct1lRo62FOipePZZ/ghQfz7ynrTw
         v88OIgrnog5M74YIYrxk5gbl64WhLRUpAQbwnywHL4d6g53QnNyvxakHHRqoDmW9OSzH
         a8pNdeGfhJUc9055vktMNcOujo/rpwm1i3+LVyhU3tb0LGlqpvIABixzC7wehXZDzGj4
         yBkGg65iTm5gD2SB8ArW0zIy/2LoC+BPmApPSLn9QDWQo7VHGcrJ0drA+O0N1h4VY8p2
         gQbVADeACA1QRqG+gwi70Z6H1LhNKfJ+RTkzhNX+//voxsVlZybF2Dk74Z2F3vHs6Kej
         1GlQ==
X-Gm-Message-State: AAQBX9c/3Yon6DccLsVk/DMnJXOoiC/T8h23It+q1/gQHz30DXtMituY
        Fcfq+EhUyVQLgUocqnepacHcI2pQyKKrEm9ZuXQ=
X-Google-Smtp-Source: AKy350ayCkVMmvE5XuE0o4UpS5YTJYchzx5teI7xTKZ7GF9+nqA+43GgJsJKzIfgoQkLFfmuY4AIAQ==
X-Received: by 2002:a17:903:124a:b0:1a6:bc34:2ee with SMTP id u10-20020a170903124a00b001a6bc3402eemr652519plh.21.1681978970279;
        Thu, 20 Apr 2023 01:22:50 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902d34b00b001a1ed2fce9asm662175plk.235.2023.04.20.01.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:22:49 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 3/4] selftests: forwarding: lib: add netns support for tc rule handle stats get
Date:   Thu, 20 Apr 2023 16:22:29 +0800
Message-Id: <20230420082230.2968883-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420082230.2968883-1-liuhangbin@gmail.com>
References: <20230420082230.2968883-1-liuhangbin@gmail.com>
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

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index d47499ba81c7..426bab05fe0a 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -773,8 +773,9 @@ tc_rule_handle_stats_get()
 	local id=$1; shift
 	local handle=$1; shift
 	local selector=${1:-.packets}; shift
+	local netns=${1:-""}; shift
 
-	tc -j -s filter show $id \
+	tc $netns -j -s filter show $id \
 	    | jq ".[] | select(.options.handle == $handle) | \
 		  .options.actions[0].stats$selector"
 }
-- 
2.38.1

