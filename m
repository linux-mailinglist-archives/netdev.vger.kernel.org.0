Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E2D2E4276
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 16:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440897AbgL1PXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 10:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408190AbgL1PWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 10:22:13 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DA8C061799
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 07:21:33 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id t22so6444954pfl.3
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 07:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qp4JeVlH4/rpQTkF1jVc3DzqRHKN9InBN98LAKUkyAM=;
        b=YvllZelX7OsYWqSqnDCoMFjKwjU06QPiUNTdRfQjjshKBKq/rTLgql0GnTVNwyNClF
         WNVKpsMbbSiMrtk1KFAtBqwJL2BPspdP4u5a+2kAbt6GklieaEMFDhre2iW+bFC9oldn
         DWV+GraNw9/2hw90LblKADekJlgAoBBdkqC70TcK85HCPxN9XdPsC9iZqvLwQtE+eufA
         f+T2sLay3G0X4Fhyno6KkNCXev/l+CKrUiEAewY/cww3s+pXqbOzpG3/Sryt0haH+Lcm
         f5XKpixUjRfFEHHFt9Cpntsrp9gZjDwlTS5MN4/rQ4LByTGF+kX0jSYbE3R+v98EBznj
         PRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qp4JeVlH4/rpQTkF1jVc3DzqRHKN9InBN98LAKUkyAM=;
        b=nUfT5i9JVDJg4GacCpRJy0BbuQm8Qeic20NHy9IBHhKSjd7FJfrBrfWMYqt91e+P8b
         Hc65fv1NgrZtfcLSdXCmOnrT5OLHQ9lOrTVyaV8AHzPpigJAeenioeZW+EVT94729AYE
         WbEmWCM5336OKwJwEEn+NTZuNaem9qta2BbNGROy46xFypGPT3t0mmUjr73WrvOxM38r
         kzgW5XPsWG54wEFODYafg0uyj8f0+dQxoDnQqFgekgDCHPmXDKrx5fNcgXRFxXGv7WLr
         BGzXSWxvjCKYq5RRwg11kO0DL6/sckXVpywT1M7a4IJ6Uw6DBkUG3jMXV5u3AxHGD6z/
         0f5w==
X-Gm-Message-State: AOAM5328RuYmw7DuopTf4UU7ua+E2AXprIXIvfP0cjRvDxxUIwdmHRpK
        GRfencucGsyaCkDpXZhOAlIReM3lDgbnFQ==
X-Google-Smtp-Source: ABdhPJwJ4i/HvFTlASeGpBxscLA6kw184xhx5pGfnApsw3S/tiVnCw9miSmor2ofh94wwhH/15PQVg==
X-Received: by 2002:a63:77c1:: with SMTP id s184mr24741775pgc.376.1609168893075;
        Mon, 28 Dec 2020 07:21:33 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id p4sm14530398pjl.30.2020.12.28.07.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 07:21:32 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, gnault@redhat.com
Subject: [PATCH net v2 0/2] bareudp: fix several issues
Date:   Mon, 28 Dec 2020 15:21:21 +0000
Message-Id: <20201228152121.24160-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to fix problems when bareudp is used nestedly.

1. If the NETIF_F_LLTX flag is not set, the lockdep warns about
a possible deadlock scenario when bareudp interfaces are used nestedly.
But, like other tunneling interfaces, bareudp doesn't need xmit lock.
So, it sets NETIF_F_LLTTX.
Lockdep no more warns about a possible deadlock scenario.

2. bareudp interface calculates min_headroom when it sends a packet.
When it calculates min_headroom, it uses the size of struct iphdr even
the ipv6 packet is going to be sent.
It would result in a lack of headroom so eventually occurs kernel panic.

Changelog
v1 -> v2:
 - Change reproducer script in 1/2 patch.
 - Fix reproducer script in 2/2 patch.

Taehee Yoo (2):
  bareudp: set NETIF_F_LLTX flag
  bareudp: Fix use of incorrect min_headroom size

 drivers/net/bareudp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.17.1

