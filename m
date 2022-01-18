Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875E2492FA6
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 21:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbiARUqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 15:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiARUqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 15:46:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B2BC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:46:50 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id hv15so411033pjb.5
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 12:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYA6sLmHIme6ayOsccO5BBgOfny3rgHA1kTO4BLVmxw=;
        b=IZvgkT2H2f6hNlhqI3yRgfu52pjF6eYlff8WMkEu6+JzMOYM58lh8I38QmIYqT31Qe
         XzaspkxUI/6ZcH1WgJt+2/cbJNQNCikrRRNNRDna2un4PbAnfxQoUbC63xEDB45PHQBC
         TBUCRjt4xyJd9BEm3O/5WoHMGvGXBPcoJrji74l3MC+tRV6IyZnyT6RYh71nPAiK9cB+
         pbmTXfLbO2ma804izMfIJL0l/kX48ZoXISZq0gzjtbfQfeMz22thKzmtK/bL94MASlu3
         KKTQb8b9OFuM27Ei1TxYyCHI3n2IeGT24qPZ/1kGRm1MyDggDSe3Iui2fD1Ow7xO80MK
         RRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BYA6sLmHIme6ayOsccO5BBgOfny3rgHA1kTO4BLVmxw=;
        b=bNnDMNpETYdwV4hO4Sph7EEbwb5rFuY+9Dtuxk0hD0HRZXCLbt3nvIoecwE7jbyJqe
         7TBScuJDaJD59R8iDbx8hxo0aqxC1L1AqZ9XmKC1i9XdL8X5th8QsYYnVQhhISXiYheB
         Ur3PFCdl3KVgHAgHX4jogl++mq8XMXYpfUsAGneFEuGiD5403XQChrUj8wsZNWoefJHI
         PbjOoHqhFiKtQXgKY6pDzsMwBeh5EzX0c3WkV/5RXiNJNUXOUOslnoHxFWedGTajtC0m
         3J1MwL5JRih0JgINS7DXPlwPNixVIjHqoyzMIzmnfzjxT0xxeC/mZ1gwpd6D4z9AIu/w
         Gyqw==
X-Gm-Message-State: AOAM531bViHnp0+VgbnK86AbBhhzOFExORXZREKfmEbU9T3gFM17HM3r
        pNek3v/1BTPCBlai28iKd0E=
X-Google-Smtp-Source: ABdhPJy8H264b4BrlY+JwBkiyt3296BdkRl9oJOm81fKggHy+oQLlRs3xFpf02IfPukqiSOvgQLmzg==
X-Received: by 2002:a17:90b:1a84:: with SMTP id ng4mr340057pjb.237.1642538810072;
        Tue, 18 Jan 2022 12:46:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a634:e286:f865:178a])
        by smtp.gmail.com with ESMTPSA id x29sm18908915pfh.175.2022.01.18.12.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 12:46:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] ipv4: avoid pathological hash tables
Date:   Tue, 18 Jan 2022 12:46:44 -0800
Message-Id: <20220118204646.3977185-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This series speeds up netns dismantles on hosts
having many active netns, by making sure two hash tables
used for IPV4 fib contains uniformly spread items.

Eric Dumazet (2):
  ipv4: avoid quadratic behavior in netns dismantle
  ipv4: add net_hash_mix() dispersion to fib_info_laddrhash keys

 net/ipv4/fib_semantics.c | 56 +++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

-- 
2.34.1.703.g22d0c6ccf7-goog

