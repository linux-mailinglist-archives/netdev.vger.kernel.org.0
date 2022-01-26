Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCDC49D315
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiAZUF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiAZUF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:05:26 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622F7C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:05:26 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id v74so683314pfc.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BqlGxHnfT5d2bvMbFujRj3PAO50XpwWHt1DqjQB1aEk=;
        b=MO4wAHxh0wC5474F0nBtqjv7iffDFjcyxkouOPvn9qIsK+LRwK+Bz5bG9qvVfXcAMp
         VB2UhPF2qgzrgb3DQ41Xdq3uyHOVw12S5Yo+MvEXSnJ4zoiF5KD8hKOPyFEW/nGJLitL
         9Bv4pfpCikEKyIYT3AUi6Qg08XwHh7E6nKnEuKsXcsysJwBMr8lq6GYOU/A5PEc8MQJ0
         i5indPL6OLxKqhrDArTLq8D/ixGFCaSJgyKJ1JcIc1gZpwA7vUzK+3mEOyVuuUIxyEGL
         A0aJJDem8gcuEX59zHe3/b6IKJJ9vnU38kr84El9IKjvahhYdQ4/whj+OWl5h7L+pS0V
         VInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BqlGxHnfT5d2bvMbFujRj3PAO50XpwWHt1DqjQB1aEk=;
        b=IrROZveg6jswx5JF60wgFvxePGerJfGqnsaMvVnDLqE0k6Wb1kL1tz2pAXW8Yk3Z7y
         zT6M+WXg620AqPF2m+9rrPZkm1zAP5gRtzZu87sqmDIbpgjLHjoDD83HZZGNBJd/FAmv
         9HWSrMn88TNKVmYojwZzcOIm9QKjwUs7VzOw+9rEcZMAQmBN4aScLDvsYKcoIAqL1Q97
         E4PfX7vaCyLv0Bvv8C19d5OqmpBD8ABWa1rF8sOF6X/LksNSRXvnQIsRGANos90mm13u
         vJGqQOJIyzqf0anfeLM+5Q7WJgdtkqka5oCgO5DVppCPA9QtLErFBg3exW5v77VCaQib
         osOQ==
X-Gm-Message-State: AOAM532CBdjhG6LrLkxogQgoLZImA0M1NjUT9grFsE3CyCiONX+evbEi
        xlBgpWKlZNRgQsCgEQAhmNE=
X-Google-Smtp-Source: ABdhPJzI1lFofLEo2FlvFzL/cOtlUpYLEIjfkR9PpVLzJDGO1COjZgrk6GoyyYm1botaK+OykyTdYA==
X-Received: by 2002:a63:4741:: with SMTP id w1mr403213pgk.214.1643227525904;
        Wed, 26 Jan 2022 12:05:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id s8sm2708497pfw.158.2022.01.26.12.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 12:05:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] ipv4: less uses of shared IP generator
Date:   Wed, 26 Jan 2022 12:05:16 -0800
Message-Id: <20220126200518.990670-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We keep receiving research reports based on linux IPID generation.

Before breaking part of the Internet by switching to pure
random generator, this series reduces the need for the
shared IP generator for TCP sockets.

Eric Dumazet (2):
  ipv4: tcp: send zero IPID in SYNACK messages
  ipv4: avoid using shared IP generator for connected sockets

 include/net/ip.h     | 21 ++++++++++-----------
 net/ipv4/ip_output.c | 11 +++++++++--
 2 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

