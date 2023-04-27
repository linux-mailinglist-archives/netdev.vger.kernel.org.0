Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479A56EFFE8
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242875AbjD0Dji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242874AbjD0Dja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:39:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A223C3F
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:28 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b60365f53so9654610b3a.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682566767; x=1685158767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=485fSWTzxfO4MaaYixxcOQ+EgmPdfYoR20+Ca5UsZVM=;
        b=dIrrH3IwkElvUoeIorcmymSLJ+4vaxcoTUhLWSQkA5t4Rd7+Tv2HHPMtKou7/M8Gaj
         II4m/XOm0jDh1c7fC4n9/6YX8oZ1gpUehmNCrUkEv6fLjsq47oYLyyUMEFHFT8mT9l9f
         nXU1GGUQVhdt65QQwJI5KZTBsDike6EjCrE/LeZtINZPlBs/ih7OUvj6f8f2bvCdLw0C
         tobufRF7PkpL7YDjSom6Vzg+dmX2pWK81JvGsLrlr33ayhVowLnyVGxffGkKreLe3uzi
         Mw88VGF6U/Y3skA2fg7JOhmJYRBNwkW6fvo8G7dkXsCl9u2u9y+Ttk/Ae3S34ukxiCVi
         fHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682566767; x=1685158767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=485fSWTzxfO4MaaYixxcOQ+EgmPdfYoR20+Ca5UsZVM=;
        b=Z9cPB4l441oOX3Dk9crOZzgWsAPT5x0XwW+L2u/x1fi3JBDETIlEs5B1T1m50csRKj
         fB7NqJM3KPAicHfIYuSDWu14Xetq7VDWFg/TwO2yGOhXzyE78ILxF1cvMjCXDVOej56A
         8KeaiqR1DY6p4AV5iblNaQ1Vb+MN1HYxsiQmk+z+rVX8T4ya7OX2C58oxf3hHuFGal8N
         SJ0nJ+NSMbSgRbghekGSevbQTbJ/OyYL3NhTaMlpzDs1xh0WQHK4QHB5U9DrkYq5PgxO
         5K/ObnWTofG/gVPZAYmICk8DJI7aL9+j4flQtcxwXZ6pTsxS4CUVShN0OIoApn/kQTog
         TBiw==
X-Gm-Message-State: AC+VfDxo7Dh1wWttANw/QOF0ejenaKuGFzyDjDuUqbMKmwiW6Nf1ePoq
        fuhdBzm426Ufl6uPtxIFWLXoEMEzARN9pEtl
X-Google-Smtp-Source: ACHHUZ6F2pTSLl+BGQIFDZ/vuR4lh+NyXbbBcqna6OiEOdITBL9BY7BOXSzpF8/0HjWKPpO9UYNTMQ==
X-Received: by 2002:a05:6a00:2d84:b0:63b:e4:554 with SMTP id fb4-20020a056a002d8400b0063b00e40554mr548530pfb.4.1682566767326;
        Wed, 26 Apr 2023 20:39:27 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b005abc30d9445sm12017743pfv.180.2023.04.26.20.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 20:39:26 -0700 (PDT)
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
Subject: [PATCHv2 net 3/4] selftests: forwarding: lib: add netns support for tc rule handle stats get
Date:   Thu, 27 Apr 2023 11:39:08 +0800
Message-Id: <20230427033909.4109569-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230427033909.4109569-1-liuhangbin@gmail.com>
References: <20230427033909.4109569-1-liuhangbin@gmail.com>
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

