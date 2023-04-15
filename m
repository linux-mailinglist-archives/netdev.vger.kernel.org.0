Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1DA6E2F37
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 07:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjDOFtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 01:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDOFtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 01:49:13 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674304EF3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:49:12 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id kt6so12691213ejb.0
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google; t=1681537751; x=1684129751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2YebPOWU1AKbeUIaxSAasxQVn0uumixYChKM0jWLz0=;
        b=gKSabgnyjhooZFul3T8lL2HPpbvoo+I/l7jZ/S7xpRUZtbaNEc4eHceikQIZ7PwJxT
         f5y2cY6ysZH1xjmSWC3Qk2mxHAChxkDV1dY1Xhryc+Itgwa3Jpklex/QbzG43lBItIf/
         tfDxwkjOd/tEpszTToNrp7XlAXuBfesPMgO7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681537751; x=1684129751;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y2YebPOWU1AKbeUIaxSAasxQVn0uumixYChKM0jWLz0=;
        b=eEbHV/yP3QnSjaF14fyNv6Hx+NLRE3JxG8afgIBpn5vnTXy2brNQlF76uwJGQP6ob9
         rwxOGm/zsmL1xZH+eddj4If3V1Fpz5SpDGCqZPHZTJaxXJbN96Z3KbE5nuia6gT9Up9g
         3U+e2qLQN+Rf/3BXm5VdKhgRIlJQgy9/ZR6pz4OGiCXX8lT9iZ1JqPoIsImwiBsbjbKq
         +9GaJDqAxGp5NAwWf0dNb9ACE4YToCV5lXc2FDYpVkQhrx1YkfEOyDmuxK/1nBP7KNjt
         t7/9nKd/3ImahI3B6gs0V0ILif7mpHuEPQD/Akbb0asmS6auKpusQXEWNXUrm3ZbS+DE
         TbHg==
X-Gm-Message-State: AAQBX9eTWSbInjYIb8Py9cghwOrWoNZZnwmlUjYUETeTQofLtyzQZ9Iw
        NQS1bycp8JyAlLCjK2AeIeCbXQ==
X-Google-Smtp-Source: AKy350Zmw/ebZONsYzTdEBUgREaqpGfr3D0sH3dmepp6YGStEND7N2EasiFdz8K8Ctti/lLzhKMggA==
X-Received: by 2002:a17:906:e118:b0:94a:6c0a:63e7 with SMTP id gj24-20020a170906e11800b0094a6c0a63e7mr1129867ejb.54.1681537750817;
        Fri, 14 Apr 2023 22:49:10 -0700 (PDT)
Received: from perf-sql133-029021.hosts.secretcdn.net ([2620:11a:c018:0:ea8:be91:8d1:f59b])
        by smtp.gmail.com with ESMTPSA id b1-20020a170906038100b00947ccb6150bsm3294856eja.102.2023.04.14.22.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 22:49:10 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        Joe Damato <jdamato@fastly.com>
Subject: [PATCH net 0/2] ixgbe: Multiple RSS bugfixes
Date:   Sat, 15 Apr 2023 05:48:53 +0000
Message-Id: <20230415054855.9293-1-jdamato@fastly.com>
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

Joe Damato (2):
  ixgbe: Allow flow hash to be set via ethtool
  ixgbe: Allow ixgbe to reset default flow hash

 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 23 ++++++++++---------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
2.25.1

