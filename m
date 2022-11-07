Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC5461FA93
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbiKGQxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiKGQxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:53:53 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 006DA1180B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:53:50 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id cl5so17133063wrb.9
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 08:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=grU0DtQP4hJdNj1wsQc7pUwt1U3Y3Q6eZxZMM9jMZWY=;
        b=tNLlQ6Qc1ZOHsuJS1P+ynVv1cWklg33yvwhNCPeQFALecSj00EqaGz3T2At2TmsPd7
         JzFeJmLnU5QLbQswlnE2TQj4pQ+K5iiH9ayvEHxkmiW+Vd4uIG0ne4wksT566yxjBhtX
         sfSVPpyT3kWCws3/cXICuMH0sNO27eCIA6hy/eFHw8guDU2mZYKOukfPcuSq26hBdqat
         PfQnoRv/LbO2j8K6bpLjrzx13m04y7mb27Re6eE2CeutpI46DSRTm7YDZHmRDAdde61c
         PzObUjn9i23cJ2/TLFiCBMS67y4ihUKaH3NLfsZrw8sOzOXiK141F15v4z9l5f7zRfN5
         6KoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=grU0DtQP4hJdNj1wsQc7pUwt1U3Y3Q6eZxZMM9jMZWY=;
        b=gQJzOYB1pJo+LHsOuTpPmDp0Hxruean/k/c+XGcPI707+d7Et1akwORsyd5WJNyu8n
         rBdR+k0fUFyuFlqhpr6RFcNvu5nWO0/l1COLfkQT5pH+N82w8M9q8YqXZhXyl9RRXWBo
         iRg8D23/cnp7zLvRDinF0MWlFX7x8YEKv8rZYRbbSGHiQ/NEDGUrVuwiGU5TXG66Aain
         pgb2E1FaYw3+oVvGiB+YZQsRfAMXJskU7i39sNmZgwBgmih2V8tA0swr7w/XpYrDeLtA
         CrWlVWLq59Adu6MqMnFbybliO8AcHDv3g20DWWbomUZMsIkhi8LRPs1QHmcMWoSbmMcj
         Pidw==
X-Gm-Message-State: ACrzQf0C/BqBEZLKXSzmVUlOBgypA4A2r48O5F/aNSpydAA8yjpXKhc9
        E8g4NPTJYFO5JCjaGym77huUqHtbjHTc6mfkJDQ=
X-Google-Smtp-Source: AMsMyM6N6itf1lINLsy9tF+2nlxyDblxPL89w+UsMG7S4WZpI2wGY3jxxHZ1z2kkS6AItIP8X6PIpw==
X-Received: by 2002:a5d:65c9:0:b0:235:7110:bff2 with SMTP id e9-20020a5d65c9000000b002357110bff2mr31844243wrw.46.1667840029583;
        Mon, 07 Nov 2022 08:53:49 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t20-20020a05600c199400b003cf9bf5208esm10546029wmq.19.2022.11.07.08.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 08:53:49 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, kuba@kernel.org, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch iproute2-next 0/2] devlink: get devlink port for ifname using RTNL get link command
Date:   Mon,  7 Nov 2022 17:53:46 +0100
Message-Id: <20221107165348.916092-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Patch #2 is benefiting of newly added IFLA_DEVLINK_PORT attribute
exposing netdev link to devlink port directly. Patch #1 is just
dependency for patch #2.

Jiri Pirko (2):
  devlink: add ifname_map_add/del() helpers
  devlink: get devlink port for ifname using RTNL get link command

 devlink/devlink.c | 118 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 109 insertions(+), 9 deletions(-)

-- 
2.37.3

