Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A78C52CA2B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiESDQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiESDQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:16:09 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6740C15FFD
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:16:08 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s14so3600124plk.8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=sq2MI4I/kf7cr9Yv2+xzdVyZekgO2TCEQwx1Pray2Bw=;
        b=KbHIsDiw10HQIHEy4YskbW/ekBfbzIpDuQbPTlk12B60j4ruKlw640Sn6nLG58959K
         KI1gKJb7B2z/bJCILIyZUF2VJYpbmYDiL2ekmAYbRQX7sKOCS3vWWDcJJU2jGYuGO+uw
         kWzCVE7N0QACHk7ZPqt7xGefJepqmUJOJJHJHTm0BBQWyeiUZdQF4q+f2n37UHb1HyIy
         H7EMXl3s/W423VTJETVUudE1jjjd6WKB644dSxWUxVaOQqOiZhwSyLTYTtUkn4WcLchx
         SpOm1P23ENFPZ/uZOKBcMWem5jjxuH9NImxrBieN/m7gOSz7KImgVCLei6K38klZfXbR
         77vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sq2MI4I/kf7cr9Yv2+xzdVyZekgO2TCEQwx1Pray2Bw=;
        b=QsKvuSgr1cnHPVey7kZvzz3LBZSjf9gsqXeFpgDiUzPGRc3dAx4hn6kj/dMLwgK2UV
         eGbvdVspHMvQP9uroSu/bP5lCu1oNYPF456hT9WMw7xri8UFDurnnscPZ9noJXCIw4VR
         nM+L/+eLqZxg1rsBbAhxPyDLDa9ett2vy7CTIMLm6m79A5+B2n5zk7mRFUb6KQkyBZsy
         XeJvYhpEI9cm4cLUsQsPRyR4u26Qekerra07bJVncGGwVpbWxW/3zzjdhFydJEHn+VcA
         P5whEYhUYCsCQ/6zEZiinq5uKMv3BtZx8/EJ1dOZUJe4tW8aaW/lT3RO9HrQVorCsfYh
         HGIA==
X-Gm-Message-State: AOAM532QNXgTbMTYIO0+VjM12FZNZ9xoEnD5IYnom+Uit9CGZWC62w2O
        m0B+Abt8A8ORXYbdqpA4u74=
X-Google-Smtp-Source: ABdhPJzOspP2h6u7TrN/PsGZQPguIjT8oYhmuSMgvuwwbOS3saaTGtZuTQjv2SzBkORJkFjBn46Y7Q==
X-Received: by 2002:a17:90b:4b02:b0:1df:d622:dd07 with SMTP id lx2-20020a17090b4b0200b001dfd622dd07mr1307639pjb.160.1652930167866;
        Wed, 18 May 2022 20:16:07 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id f186-20020a62dbc3000000b0050dc7628133sm2833459pfg.13.2022.05.18.20.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 20:16:07 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 0/2] amt: fix several bugs in gateway mode
Date:   Thu, 19 May 2022 03:15:53 +0000
Message-Id: <20220519031555.3192-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes bugs in amt module.

First patch fixes amt gateway mode's status stuck.
amt gateway and relay established so these two mode manage status.
But gateway stuck to change its own status if a relay doesn't send
responses.

Second patch fixes a memory leak.
amt gateway skips some handling of advertisement message.
So, a memory leak would occur.

v3:
 - Update git log message.
 - Do not increase rx_dropped stats twice.

v2:
 - Separate patch.
 - Add patch cover-letter.

Taehee Yoo (2):
  amt: fix gateway mode stuck
  amt: fix memory leak for advertisement message

 drivers/net/amt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
2.17.1

