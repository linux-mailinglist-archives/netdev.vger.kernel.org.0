Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DC019A815
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 10:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgDAI7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 04:59:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37835 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgDAI7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 04:59:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id u65so1582321pfb.4
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 01:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lG1ghcspACgZLEmgMcA84iprDirIsm87dZC5cB9GAwI=;
        b=k5TMDhDISpD5hN47hFSC1HZ82vv5+noPbKerxE6Rr2ipMC8GOQLeU4Rk66wqFEJWHJ
         Dmn5uliAb80tK8YdzKaKrSKbzoIVn/SoWv9gst92pWoQss5EqEhPXildZf/ino9zMYyA
         uoHCUBVinK0WDbK9WgNawZcXGTYQmXG2WvA61YUOM5BcC/zBeyQZfGuTPePeEhCtGyB9
         W4sFvdxLVbbYGRxTWExo9CR8K1tXjeUlaDgbB/jAIqM0Q6PfGTqk/MMUBOx2MAhG3wqR
         l8i5kRLrgow74oxV1YD+dK/G5VqahIr1B957ubIbhMiyZEq4bLJ+MPh15V+FR+FjQE1E
         0row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lG1ghcspACgZLEmgMcA84iprDirIsm87dZC5cB9GAwI=;
        b=tZ5461aBRUT1dLywAIplDUJk8YeU8phRZ5MkptmtIJuwymClXLQ+X8Row6aGxTQtnB
         LIUnvwIpxK0GfUhuhVcygY+n5yq+Fp6q0TiC2QQ3SClk3R4ZJDRHlpPezWJM04BL9YPG
         hu0oZfwSgxARtg4GSApPw8LR3Z1/Rc8TYI293XJ6Jga4JQ4unfERoBn98sjSaDEUlCIx
         zza1gsj12jCLVTXLmDrdTV/xVSgjoqD8FSWANuD+EhIg4xJA0i3oL8fXgi2X6vbUkw8W
         NkZChoPbsoM+7xiQPYtpd8f6HmsBCQ3cw51X6RZ3WiX6oMKc+BpshxVLvJ3nuv6nZ5Dz
         b9ig==
X-Gm-Message-State: AGi0PubqEhKtFb55OCkrCsh+VbaZoiE+Hl2Cq0dzeOCYOzMwMXCQymfF
        VP/eCb1VlK+PTDu5EqOoQVw5e1IA
X-Google-Smtp-Source: APiQypLx20eFZmI0azbae+47cmacu8GmE2Iuf+jMhwaacIlQIYrq71dB242rwzg3q2pxvHzxHtUiTQ==
X-Received: by 2002:a63:8c4b:: with SMTP id q11mr4989416pgn.131.1585731573771;
        Wed, 01 Apr 2020 01:59:33 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q43sm1141672pjc.40.2020.04.01.01.59.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 01:59:33 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/5] xfrm: support ipv6 nexthdrs process in transport and beet modes
Date:   Wed,  1 Apr 2020 16:59:20 +0800
Message-Id: <cover.1585731430.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For esp transport and beet modes, when the inner ipv6 nexthdrs
are set, the 'proto' and 'transport_header' are needed to fix
in some places, so that the packet can be sent and received
properly, and no panicks are caused.

Note that the inner ipv6 nexthdrs problems don't affect tunnel
mode, as in which ESP nexthdr proto is always IP(6).

Xin Long (5):
  xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
  xfrm: do pskb_pull properly in __xfrm_transport_prep
  esp6: get the right proto for transport mode in esp6_gso_encap
  esp6: support ipv6 nexthdrs process for beet gso segment
  esp4: support ipv6 nexthdrs process for beet gso segment

 net/ipv4/esp4_offload.c | 14 ++++++++++----
 net/ipv6/esp6_offload.c | 19 ++++++++++++++++---
 net/xfrm/xfrm_device.c  |  8 +++-----
 net/xfrm/xfrm_input.c   |  2 +-
 4 files changed, 30 insertions(+), 13 deletions(-)

-- 
2.1.0

