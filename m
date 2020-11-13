Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D742B1E40
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgKMPIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgKMPIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:08:15 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAA3C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:08:15 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b63so4234464pfg.12
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDPxueAAySKApLbN4V0ld8BCC+3rz7zw7aHNJbbf4AY=;
        b=TP8iqAN9OI2tSU0IX/+9uZQ6kvhL3HZI9RTUM6+Djo5nvd4Iylu/Nd1fwrKF8IRaoM
         9Uy4emXVUbex4zSCkL4okWH2PPU7Wf6AT4Zxuj1yTqYfjAzN1AL1O4oN6WKpWk5JeXo7
         +cq296P2HalChZVMUk9wcUUTN3qja2H+Ho+Yp+NYa5nmWCtDkORtymvZ26zPG2iTnRd3
         947QYan2VIi+AxRNybDZUrvAuQFEz63cYnr+YPUIUTZSLNb7aWxER5EW1I1RmaaH7UwZ
         oPgvO0agRjIGtiHw4kucNmD0bOV+jo20+NM8J/FAtEje4Nf5aXE4/c0If6el9Ugdx7dr
         kPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PDPxueAAySKApLbN4V0ld8BCC+3rz7zw7aHNJbbf4AY=;
        b=NnBVmqLiFyumWdcUTFvef6fajZH19jttgooN3wuigDkhOvZZueaPoaeyswOd5zyBNv
         WM+cddDq/uv3XO4VVr+D/29IpqDhLnNxmGrxdtB1iCQxdli62JhlPeSuGUlTZ2oG0qir
         u74v19u5GCDHDrFb9YZ7i4wvAQP2m/Po9oa/fRLOSMXtdvyeOdaJhQPKMgGwqgECzQfI
         fRvLE5DJPm4fqYRpECG4oIALZqzo8LGyiLl6YzwhJio9UglbsgbPNRUOL1wd/KIth1ER
         GUkgxdmzskdKcPXHekuarqPCriI8jz/1fu21O+qWTwpEQCRdRHHdZI9pivQy4G5RB86o
         Tq3w==
X-Gm-Message-State: AOAM5304YzgodPb89xJKIHgh0nQHsRLH9lVMyqd3llCu+duvsDi/RyzT
        67iwmkIm216B6UX7uy2L4Ms=
X-Google-Smtp-Source: ABdhPJy/EaZCfH4vjSHeB1Iw7LkDL0y48rlYqeY1Q4FT5lgZTh1HQTKuKR2DEFMPhyNlzMqvzitXNQ==
X-Received: by 2002:aa7:8518:0:b029:18b:cc9c:efab with SMTP id v24-20020aa785180000b029018bcc9cefabmr2533247pfn.39.1605280095369;
        Fri, 13 Nov 2020 07:08:15 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id k17sm12043834pji.50.2020.11.13.07.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 07:08:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] tcp: avoid indirect call in __sk_stream_memory_free()
Date:   Fri, 13 Nov 2020 07:08:07 -0800
Message-Id: <20201113150809.3443527-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Small improvement for CONFIG_RETPOLINE=y, when dealing with TCP sockets.

Eric Dumazet (2):
  tcp: uninline tcp_stream_memory_free()
  tcp: avoid indirect call to tcp_stream_memory_free()

 include/net/sock.h  |  8 ++++++--
 include/net/tcp.h   | 13 +------------
 net/ipv4/tcp_ipv4.c | 14 ++++++++++++++
 3 files changed, 21 insertions(+), 14 deletions(-)

-- 
2.29.2.299.gdc1121823c-goog

