Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634326EB022
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbjDUREa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjDUREZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:04:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2F616B02
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:03:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a677dffb37so22103095ad.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682096627; x=1684688627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rTwArdqg2xplYbc2Ju1oojR0FWXCjtQ2X1LDWigqEMg=;
        b=haS+pifXFjviXln8ABA/feRfa2HPsiKq1Yb0MMYIuQqKqj4dORC7s/+Fvo4Uc6jEqx
         hOwgWzvw0gukzRaH1klCbK+ghOelKSWscKIiKK2s6SQlS18iv8pC1qXmMagTh+ogiDuq
         lHOX+qABoNVWUfPGraKE0kpvtqeCjLKk43IJHMIJB8Olea80teWQ2ZQ3rvtfs/5WJK79
         TCkbsEdMRRpadpPsJwqkHxAV2JF9vpzSW518T+1eF0ILGAMpyKF4xM5+ZJb5bHe9UcEx
         3D+wfaPI/Lhvxeyrp4yHPONMIPXDwEQC4pGoh6uHJ8EqpWGIctqX+Ym3dU2iM+KjRQWp
         T5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682096627; x=1684688627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTwArdqg2xplYbc2Ju1oojR0FWXCjtQ2X1LDWigqEMg=;
        b=ZOEp6aJIY6gLUoUWtmiTIdND0DHQcsbivWusJDgK6Fw9NDo8leB+qW7/PRqBJcZHB2
         OQ+9crB6Y2ZumaKX26fMbO41EEVrAgxPdYL8nm91RaMDHBj1Y/ZRDd/eu1eXOR8g4caP
         Z3nddhCGl8kERfvvAFYbouZuuYWptGAvFSPhlJ3saavVkh7cT87kofM7na/bTzBJcuk7
         xHV+yPphb5NkjTvb/vm98qcAKtiu4g3Wrw3AnCeX9madxEN+1D0WmvX6u5ppVmJRcSkH
         SdLb7wFTxcmBtQSknYYY3CBhhBU6zngQNsIVTAQEldVq2XS0JQKoe9V3U9b1eglPA16y
         UVpQ==
X-Gm-Message-State: AAQBX9eqTomBx1pcbTSbd38veYR/lJSfdPpA8le6akdpdq5ToIH5AHpr
        O6cet2VLVI9Zcovawj6IOCCSXriPHFxCI5X4504OGA==
X-Google-Smtp-Source: AKy350bqV7Wum+s4hcJMUKsTuBvEzZBxdXTrDdGHbbms1J2YizZ4WRb0T+bWdTaIRxdhMqdTYkuwXQ==
X-Received: by 2002:a17:902:e2d4:b0:1a5:2592:89c6 with SMTP id l20-20020a170902e2d400b001a5259289c6mr5333052plc.29.1682096626707;
        Fri, 21 Apr 2023 10:03:46 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id v19-20020a1709028d9300b001a6ad899eaesm2982431plo.18.2023.04.21.10.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 10:03:44 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] lwtunnel: fix warning from strncpy
Date:   Fri, 21 Apr 2023 10:03:39 -0700
Message-Id: <20230421170339.21247-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code for parsing segments in lwtunnel would trigger a warning
about strncpy if address sanitizer was enabled. Simpler to just
use strlcpy() like elsewhere.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iproute_lwtunnel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index 9fcbdeac3e77..d3100234d241 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -1468,8 +1468,7 @@ static int parse_encap_seg6local(struct rtattr *rta, size_t len, int *argcp,
 			NEXT_ARG();
 			if (segs_ok++)
 				duparg2("segs", *argv);
-			strncpy(segbuf, *argv, 1024);
-			segbuf[1023] = 0;
+			strlcpy(segbuf, *argv, 1024);
 			if (!NEXT_ARG_OK())
 				break;
 			NEXT_ARG();
-- 
2.39.2

