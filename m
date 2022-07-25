Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C2A5806EC
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 23:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiGYVtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 17:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGYVtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 17:49:50 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D6421E06;
        Mon, 25 Jul 2022 14:49:50 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r186so11548663pgr.2;
        Mon, 25 Jul 2022 14:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ss8MJHvwK/vlDYhWA+HcXFexm2uxYci4TFflaNfMoYw=;
        b=gjUKJhwjHTAdGNF8kPHtslob3kah/jVfh/OQzRgFs/6dMNt2u9Dvd1wQXbOuWJXIdP
         l+dzOBTjY73MN7eMAcIUDsWtYgjQOjGRQZ9Aqy20r2mHRZWlqS/2FP8Zd0rgzcujiJT7
         RQAmmiRa2mtLvh1JhzCiccF5Om3xF+RR4kTkz6pg4PELRVpRu1q563n7l9s5cKaEdRTw
         4xh0fZL0JWH82agig2mCcac2nvLm68lAFOwFTYaHk6wzQRDGHcIDOsdO8dsRYTaVu8Yv
         We/9wA+XfA2N0ES4CBUTlXTyrwsKpkSVotsrozo1HGvgaPOEzOZa4T8osdZ9nDkcKi7s
         dWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ss8MJHvwK/vlDYhWA+HcXFexm2uxYci4TFflaNfMoYw=;
        b=Uw3R5bVRewRg+KSMMoLBnvSpq5a73GNVNshm9tApkkYXMh0YtJBgtcSSDyAU9pCvxV
         WqokG10jq1jWRj5CCDK7rTWu23nFuD3Bbcip/wEU0X30hCbLqzyGNZ8ZX5Ik1OGb2Rcf
         yJYnFB+JY5wDspoAuEkw+EYf/GxdAfUSa+0AavF/D3vPwmVG1l0I9WWLsxl0t6pgk7pK
         ocbIUQhWq7oitp/NP3HYKScTzkI6bzTaPdL1s5BsotZW1F/TED1iol05107lYtHtxUd+
         YIvBQB9+G4HBsYCayTqlJT4yCZVWDycdR9CFq8NnpxbhgoIqSiU6N+kdgbt+IxVQSOLH
         +UTQ==
X-Gm-Message-State: AJIora8AfKr9mW7pH3L568AtlP8dDmqkMveMQcfdZd2S7AWJwdr4MN4C
        Kps3HYZ2JmLWdhOSAehaDnq1ug9deB0=
X-Google-Smtp-Source: AGRyM1vO1H774ICdPpbD5IB/r1jPD3wFqequv2iYoPQqC4nVor1SwxtHaOyMhgGtmxxe6DK8Z1wl6Q==
X-Received: by 2002:a63:3186:0:b0:41a:64a5:d6a5 with SMTP id x128-20020a633186000000b0041a64a5d6a5mr12981711pgx.293.1658785789220;
        Mon, 25 Jul 2022 14:49:49 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c5-20020a637245000000b004161b3c3388sm9086551pgn.26.2022.07.25.14.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 14:49:48 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all ports
Date:   Mon, 25 Jul 2022 14:49:40 -0700
Message-Id: <20220725214942.97207-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Although this should work for all devices, since most DTBs on the
platforms where bcm_sf2 is use do not populate a 'fixed-link' property
for their CPU ports, but rely on the Ethernet controller DT node doing
that, we will not be registering a 'fixed-link' instance for CPU ports.

This still works because the switch matches the configuration of the
Ethernet controller, but on BCM4908 where we want to force 2GBits/sec,
that I cannot test, not so sure.

So as of now, this series does not produce register for register
compatile changes.

Florian Fainelli (2):
  net: dsa: bcm_sf2: Introduce helper for port override offset
  net: dsa: bcm_sf2: Have PHYLINK configure CPU/IMP port(s)

 drivers/net/dsa/bcm_sf2.c | 130 ++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 67 deletions(-)

-- 
2.25.1

