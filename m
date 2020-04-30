Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA321C070D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgD3Tyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3Tyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 15:54:52 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5EDC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:54:51 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o27so3342560wra.12
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 12:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=R0rgVh3++rm6lReKmZCcntpKuZY49V6ZTMwj4KgLhbY=;
        b=bkyfYwYpdflspndfqCnXyRNzntqJFguEEdTKKGH8qxJjFdC+QrFc9XfYPp6vXzgTYf
         zTlgJfh1XDbWf1y6MlMTCNwG7mafPPpOoBgorNgWTIFKipu3PBDYTY7A79s0zkTLrKji
         Izpc+YGkqHmyn+bY7UBpbxUgV3px7v82oAr2OjdPTnO8VqFAnjyZOp2S36r0OYTRmvSd
         JLD6beuRVHo0YzfkxMnB+2oZzmL1btgOglZkbyENVx0L5Eug0ACaXaOVnnDLh70l6C/7
         teIzHWSGFUvaVZMTcB64KeG6GU3ETh8mw4vA2agrq8r5Q4ToeWsnl5/5Gsv/veiGrhJp
         bjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=R0rgVh3++rm6lReKmZCcntpKuZY49V6ZTMwj4KgLhbY=;
        b=tislG79rie6y+lxUB1YrdjRwfuRsKHJzKxoktBLaYr/v+tNSTt7Ear3/kjmLe/vyTZ
         Dc0m3J3V6MqinCbqqJdwEiPWq7RCIiql/3yyv1/PebxMqGPVsJWVUipnbtjzSD3bDDZW
         LzW1u/4ns+xkI5seaUdRaPdumsX5CLTKFaw48Ze7Z8IEU6wb4pkaQcue0hjKs32EVI6E
         JnEnXwTWiZx3wS4je7ORjAnKZBAMqAHUs34W+b+G8R8ur0y9arNFrSJa4lcnZe2iWmep
         V0XVeEnJkUL7ThaDfGscP6DaWm8QG2ICSvkV1HJzkJsgpOUIwF2Ktqaex9SUFF3mLQNR
         1XKg==
X-Gm-Message-State: AGi0PubpAVHAIrDfrpu159Ijey6T26v1wwPUWhalNNZAx5P4hDzMd0TS
        o/PE3f/RuF/FKgsZEPxYj+2MJ13/
X-Google-Smtp-Source: APiQypK761o+81l/2VBqfnUXS12E4GC1vnzGNysuboqL5e39ISvaMXxcuGgnuZG8fQYttAjdjVlsFQ==
X-Received: by 2002:adf:82b1:: with SMTP id 46mr235418wrc.44.1588276490274;
        Thu, 30 Apr 2020 12:54:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f0e:e300:b04f:e17d:bb1a:140e? (p200300EA8F0EE300B04FE17DBB1A140E.dip0.t-ipconnect.de. [2003:ea:8f0e:e300:b04f:e17d:bb1a:140e])
        by smtp.googlemail.com with ESMTPSA id y70sm957421wmc.36.2020.04.30.12.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 12:54:49 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/7] r8169: refactor and improve interrupt coalescing
Message-ID: <d660cf81-2d8d-010e-9d5c-3f8c71c833ed@gmail.com>
Date:   Thu, 30 Apr 2020 21:54:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor and improve interrupt coalescing.

Heiner Kallweit (7):
  r8169: don't pass net_device to irq coalescing sub-functions
  r8169: merge scale for tx and rx irq coalescing
  r8169: improve rtl_get_coalesce
  r8169: improve rtl_coalesce_choose_scale
  r8169: improve interrupt coalescing parameter handling
  r8169: improve rtl_set_coalesce
  r8169: add check for invalid parameter combination to rtl_set_coalesce

 drivers/net/ethernet/realtek/r8169_main.c | 189 ++++++++++------------
 1 file changed, 82 insertions(+), 107 deletions(-)

-- 
2.26.2

