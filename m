Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647186E3B72
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 21:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjDPTMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 15:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDPTMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 15:12:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1472D73
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 12:12:41 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id fw30so5983000ejc.5
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 12:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681672359; x=1684264359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mt9Jd2VCFKl3SzvC7vwKe2P24ZGqydFJ65cEp9GQs5Q=;
        b=ahEqYoNUh669zRcKT9P9S0+oKFhp/Z15pN/OWxPP7z3563ZU8sNGYIGoWP1FlrRSOA
         LJk5z0dkKLSiQaHzIUYZKq/RT7yTVSfYoR5OBoYCsJ6tkVwD1gPsTjE4PIXy+RroWK35
         N07eroXOrOMvkCnhhCijQRyZWsgkDHD/GjS9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681672359; x=1684264359;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mt9Jd2VCFKl3SzvC7vwKe2P24ZGqydFJ65cEp9GQs5Q=;
        b=CUFyuQr5kk7n+gXYJHztX7fMknK//1EqLSX4K2wSS5fg1e9lu87s7mTW+YkmhjM0JD
         uKxwIc1qkNcrclnsC2n/Q6QE2YwMSB9QXpn5W+akyJPco/dYL9oDcBgXtiLL/pdrNaox
         VBd0eziQJemblyMnIpWOT40wxMyukKOJqKy+avr/5xOwX8eFjLjGFpcyDX6scA9XaDSO
         XBK+Bx1PzL5L2RwhvjnX0xh64VpowDzn8EVoTLWThutcFkrNbrNhTAADKsm0hm0TnFOG
         MtkmfGHNF+BOOL4E+MD4KcitA4I4UBKRHGKsfxSF84mqrVWWbRBH8cQ1lEMUSNcnQWTe
         yCuw==
X-Gm-Message-State: AAQBX9dR3HEtZIwuSqpWwuTJ7wJ2injEfbT46sH727Qky+U3JcSc8UFT
        s1+LpNRaTXOSq3NwPjdgFXs0fQ30kikH4GqRssc=
X-Google-Smtp-Source: AKy350ZG0733pE9h8xyhVHNIGFiEKgx4s3WzWi6+1pXB0Knb/0PfeOv9vte5Uiae9KaUN9gtqdOQnA==
X-Received: by 2002:a17:906:824e:b0:94f:31da:8c37 with SMTP id f14-20020a170906824e00b0094f31da8c37mr3577984ejx.52.1681672359530;
        Sun, 16 Apr 2023 12:12:39 -0700 (PDT)
Received: from perf-sql133-029021.hosts.secretcdn.net ([2620:11a:c018:0:ea8:be91:8d1:f59b])
        by smtp.gmail.com with ESMTPSA id mp30-20020a1709071b1e00b00947ed087a2csm5463902ejc.154.2023.04.16.12.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 12:12:39 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [PATCH net v2 0/2] ixgbe: Multiple RSS bugfixes
Date:   Sun, 16 Apr 2023 19:12:21 +0000
Message-Id: <20230416191223.394805-1-jdamato@fastly.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

Welcome to v2.

See the v2 change summary below; v2 contains only cosmetic changes to
commit messages. No other changes were made from v1.

This series fixes two bugs I stumbled on with ixgbe:

1. The flow hash cannot be set manually with ethool at all. Patch 1/2
addresses this by fixing what appears to be a small bug in set_rxfh in
ixgbe. See the commit message for more details.

2. Once the above patch is applied and the flow hash can be set,
resetting the flow hash to default fails if the number of queues is
greater than the number of queues supported by RSS. Other drivers (like
i40e) will reset the flowhash to use the maximum number of queues
supported by RSS even if the queue count configured is larger. In other
words: some queues will not have packets distributed to them by the RSS
hash if the queue count is too large. Patch 2/2 allows the user to reset
ixgbe to default and the flowhash is set correctly to either the
maximum number of queues supported by RSS or the configured queue count,
whichever is smaller.

I believe this is correct and it mimics the behavior of i40e;
`ethtool -X $iface default` should probably always succeed even if all the
queues cannot be utilized. See the commit message for more details and
examples.

I tested these on an ixgbe system I have access to and they appear to
work as intended, but I would appreciate a review by the experts on this
list :)

Thanks,
Joe

v2:
  - Include Reviewed-by tags from Sridhar Samudrala.
  - Fix title of patch 2/2:
      previously: ixgbe: Allow ixgbe to reset default flow hash
      now: ixgbe: Enable setting RSS table to default values
  - No functional changes.

Joe Damato (2):
  ixgbe: Allow flow hash to be set via ethtool
  ixgbe: Enable setting RSS table to default values

 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
2.25.1

