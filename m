Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8BE43A659
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhJYWQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhJYWQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:16:07 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E022C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id np13so9345891pjb.4
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ve71cpRS9UIx/oKI1uIzVRfe3vyY+bO+xzuziUoRE6A=;
        b=aoxADP5qHFYSVtxeKt+ojoDGbqDH+7ce0MsoEe3fYcgvTqIvIjUeq0sVJ1smWZWnF6
         K4v6ofy03iZzh/Ru/ENwt+3oM3sAKpccsVrOg/QSIONSXx1eoM7tEHo86d3zZeDVenZM
         aZtfV6MUKXzaJkgWd4Tk0sp2tu1rW/pJwj5eM8AQwvzRoDWAKnVUT5MhKSsG3vxRcRvb
         TUGQB8B17KQBXnKGO0RA4++yqwhbD+Y3lhH6ywz05+SSHIZ2Hnhu5n9KL8jDWP39lDoA
         oAM2HSYSS/KlliIGG6tDWzVaAJWvbUf21iIswthzgaw3AnZPADb3yO8IlAZYvRtWyK2o
         zV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ve71cpRS9UIx/oKI1uIzVRfe3vyY+bO+xzuziUoRE6A=;
        b=idvRm9xtSsJY5AwuDXQk6gErbwTPIG9k3H+7HQm7yd8CPRjMTpVqLKeCTbDBzRe+EJ
         Xdly2TYWPCU7TMvKf68EcnWuL2kLCYIAJbsmID8Yn57exTOSV3b9KRElFwTLCQRUeG3K
         F7thpdwpR5BdkpXrdffzOsVD259SLopTREv0iaMzwKTz7c9TWMXnJXS0SG4qH6XpfQEK
         uv+Ab1L5DyL59HX2Ph4CLv2gyxygPxT75nevbbfJm0Qj/S3L/5gr4AddeAkupc9j3RXs
         ibUqy3s8pIdK6UwQWoJsOaszJz+sKfw4AdyMDHmLdWsJrcmAxif63e5SJsu79fKmFa0K
         m+JQ==
X-Gm-Message-State: AOAM5310iR7cuYeAmc1IT0sZlGJngAYrF7KCwmltgPcr0e+IAiQiWtN7
        SXC4WE6w3/n3PG42EV24izA=
X-Google-Smtp-Source: ABdhPJxOrQzFC1L0zXTW1efKfFyABulR6n1WyokJbwbBi2lHiFsj9lh5So4PTyu9m8m0cd50jTspLA==
X-Received: by 2002:a17:90b:4ac9:: with SMTP id mh9mr39150480pjb.173.1635200024938;
        Mon, 25 Oct 2021 15:13:44 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id f15sm22351108pfe.132.2021.10.25.15.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 15:13:44 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/3] tcp: tcp_stream_alloc_skb() changes
Date:   Mon, 25 Oct 2021 15:13:39 -0700
Message-Id: <20211025221342.806029-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sk_stream_alloc_skb() is only used by TCP.

Rename it to tcp_stream_alloc_skb() and apply small
optimizations.

Eric Dumazet (3):
  tcp: rename sk_stream_alloc_skb
  tcp: use MAX_TCP_HEADER in tcp_stream_alloc_skb
  tcp: remove unneeded code from tcp_stream_alloc_skb()

 include/net/sock.h    |  3 ---
 include/net/tcp.h     |  2 ++
 net/ipv4/tcp.c        | 19 ++++++++-----------
 net/ipv4/tcp_output.c | 10 +++++-----
 4 files changed, 15 insertions(+), 19 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

