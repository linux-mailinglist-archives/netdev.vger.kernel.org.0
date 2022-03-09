Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF9C4D3A41
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbiCITZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237930AbiCITY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:24:56 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2246126ACC
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:23:33 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id g17so5593014lfh.2
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=o9BL2aq+Glp2GiaLr9E4laerFqbm/h9Uz40Nep85fZU=;
        b=O4Zxp7e1PLWFxMQITyMkHGc4MzqEMWDLA+nTEH7yyL7IPOW+Gqyvz0J3XtyJ6+1LDU
         Aj7o9gPRxZfI9fX0R0/a8J+GMgY5cO7FGP2gh5WCKBuqwkJ+pm4rbt3rpDnqzCICWNYi
         CBRbPx/4o5Jvsj+jyZh739E5rmwm8U7stE9PnejKFP+VS7JLFMlxDCw1acx6ablO11TI
         Pw1Bf55kJCVV9B09oJI+hJMdEbHSzJkelrZEFCkNNuvcU24Fo08L3sa+RbaQwK8lRYOe
         4ewkMMBMAa9gpu/Xu3gQgC+1DEFGf+SGC6Whu4j+1biOFUs0DoaF94GPYWF/cXVg/DPt
         rwxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=o9BL2aq+Glp2GiaLr9E4laerFqbm/h9Uz40Nep85fZU=;
        b=WTyS8EfRAEO6waRi+UZAOWQdRIj2lZmWpJV/Nc9ta2LeHvtlBa4c+zl3F3VzqVZJae
         iA4Df+C0nxn/aae1IhRdy+Y9FU+9lHdXjHVEWQOdE5bbpASYb7SpVFrmp5hxI7xBrya2
         hbx/vy3te0TKcLceCzErdyg9TleCZGNHXCBMieBTBzoX8shIZ4YmzTPENy8sjdRCkG7S
         5EfmWnSdU3kJh6MKG3z8X51gaXBErSm80lUhpor6t13fh3NU1665xk9O1dL/qaoIsq2+
         N5xRi0Q9zK2i58KZT/XEZLzNHBV+8E4tOx/2fFAD3iE9boGUHq8mhgyHexuabnUALgKY
         BOxA==
X-Gm-Message-State: AOAM532Fin3//Fb4f/Xv/7AQRtqbKAuB8ctIv+JI8eBJxUdQuvnVV9i2
        wctvNeZ23kGGX1h35GfoCHXAReCE9UVkRg==
X-Google-Smtp-Source: ABdhPJzwOLecmQQ2wcTvAqBvG+eJx7Y5RRu7ES1sw0LNMQHBQtjQMJbNuIkKw3BkVcrD7Nh8rU9JMQ==
X-Received: by 2002:a05:6512:2185:b0:448:5d78:d283 with SMTP id b5-20020a056512218500b004485d78d283mr685316lft.221.1646853810805;
        Wed, 09 Mar 2022 11:23:30 -0800 (PST)
Received: from wbg.labs.westermo.se (h-98-128-229-222.NA.cust.bahnhof.se. [98.128.229.222])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm540691lfj.164.2022.03.09.11.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:23:29 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v3 0/7] bridge: support for controlling broadcast flooding per port
Date:   Wed,  9 Mar 2022 20:23:09 +0100
Message-Id: <20220309192316.2918792-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Hi,

this patch set address a slight omission in controlling broadcast
flooding per bridge port, which the bridge has had support for a good
while now.

v3:
  - Move bcast_flood option in manual files to before the mcast_flood
    option, instead of breaking the two mcast options.  Unfortunately
    the other options are not alphabetically sorted, so this was the
    least worst option. (Stephen)
  - Add missing closing " for 'bridge mdb show' in bridge(8) SYNOPSIS
v2:
  - Add bcast_flood also to ip/iplink_bridge_slave.c (Nik)
  - Update man page for ip-link(8) with new bcast_flood flag
  - Update mcast_flood in same man page slightly
  - Fix minor weird whitespace issues causing sudden line breaks
v1:
  - Add bcast_flood to bridge/link.c
  - Update man page for bridge(8) with bcast_flood for brports

Best regards
 /Joachim

Joachim Wiberg (7):
  bridge: support for controlling flooding of broadcast per port
  man: bridge: document new bcast_flood flag for bridge ports
  man: bridge: add missing closing " in bridge show mdb
  ip: iplink_bridge_slave: support for broadcast flooding
  man: ip-link: document new bcast_flood flag on bridge ports
  man: ip-link: mention bridge port's default mcast_flood state
  man: ip-link: whitespace fixes to odd line breaks mid sentence

 bridge/link.c            | 13 +++++++++++++
 ip/iplink_bridge_slave.c |  9 +++++++++
 man/man8/bridge.8        |  8 +++++++-
 man/man8/ip-link.8.in    | 20 +++++++++++++-------
 4 files changed, 42 insertions(+), 8 deletions(-)

-- 
2.25.1

