Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29D237A640
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 14:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhEKMFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 08:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhEKMFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 08:05:44 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438C2C061574;
        Tue, 11 May 2021 05:04:37 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u21so29303204ejo.13;
        Tue, 11 May 2021 05:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=utHsOPyt6B8QXxA11NN5m8mL0JLPynGEISGvlJw01Dw=;
        b=DJOC2gJ+9BqIl8iGZTYXjHSpKzt9qYnQddJouDekoEZBXlY6a9GiWOqUxM0ewytfnB
         Ntpeb2WS5/afAMzZUruFzLMokit7N46Erik4mrAoLzLK8myuvt7fhXBvvq3R3Z1jzxvV
         juZPGlt8pnWytGV2zaQVsBayzMO6A4oq/ScWZWy5ArI1I1xYEgTocBj4fTkM3YjEIxgK
         ppAdR9W/wI0wlroUyQGZHiNFyXxsUzr3Td7e/fyj6tPh8scDAps9kXu5bCohmVD19pfa
         6BAWishF/1NO9E5e+nFGXGJ4d0JShCf9klj2n/Zq0IAxINYeD0LsOFIHM6VJUJWUK0yc
         SaJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=utHsOPyt6B8QXxA11NN5m8mL0JLPynGEISGvlJw01Dw=;
        b=dqzjkl0EkuNcOF2ASVciySl81RJecj2c4QEie1LbJ4FRYBUPGIM6QIX5dznqi9JS64
         Okqqlu+4S/L3+lLZnf3fPrRrJoxei22wAznD3NVrOxlfy+U27FcEXS333gpg4KtyKa/X
         Pfd2RhkiX4f9zDZiNUf67vIkq1OaXHAT/KF1wXomBakkqnTQ2qshZSrwsX8BZ14UIZZX
         EfNJebXlgob9/Cal9hj8xcKT10kKM+Mi05MNHKoxtpcO4Y3fcnhPnKpNU2WwjI3hhDKs
         KCsTd6vhtJsJWpdIguqPZkHMGb7DbBOIw/14Z3NT19AN163gcRFhBHLPzMrFm9Kgi6Kh
         HT7w==
X-Gm-Message-State: AOAM530FGdW3wFTLCZ5r50FIyu5Ld5/I1zDKjCUyvqi5TUesmUAXll0c
        kD+/JX8n6Q3y6r03XnRYS1s=
X-Google-Smtp-Source: ABdhPJweOxuNLVl2iNxPeVgpWKCkpBdUN+5NE2ejoq2KCSllQoBPAAZbhQcodlRDwFqG7O+Dc7LlpQ==
X-Received: by 2002:a17:906:4143:: with SMTP id l3mr31716237ejk.509.1620734675971;
        Tue, 11 May 2021 05:04:35 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:58c4:451b:d037:737c])
        by smtp.gmail.com with ESMTPSA id o20sm8212615eds.20.2021.05.11.05.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:04:35 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Neal Cardwell <ncardwell@google.com>,
        Matt Mathis <mattmathis@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        John Heffner <johnwheffner@gmail.com>,
        Leonard Crestez <lcrestez@drivenets.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/3] tcp: Improve mtu probe preconditions
Date:   Tue, 11 May 2021 15:04:15 +0300
Message-Id: <cover.1620733594.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
in order to accumulate enough data" but in practice linux only sends
probes when a lot of data accumulates on the send side.

Bigget improvement is to make tcp_xmit_size_goal (normally used for TSO)
take the probe size into account. This makes probes more likely to be
sent when applications use short writes. This should introduce no delays
beyond existing autocork heuristics.

TCP RACK allows timely loss detection with fewer outstanding packets
than fast transmit, if enabled we can use this to shrink the probe size
and require much less data for probing.

Successive mtu probes will result in reducing the cwnd since it's
measured in packets and we send bigger packets. The cwnd value can get
stuck below 11 so rework the cwnd logic in tcp_mtu_probe to be based on
the number of packets that we actually need to send.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>

---

Previous RFCs:
* https://lore.kernel.org/netdev/d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com/
* https://lore.kernel.org/netdev/c575e693788233edeb399d8f9b6d9217b3daed9b.1619403511.git.lcrestez@drivenets.com/

The sysctls can probably be dropped, they're there for easy
experimentation.

It is possible that I misunderstood the meaning of "return 0 to wait"
from tcp_mtu_probe.

This introduces a bunch of mtu-to-mss calculations inside
tcp_xmit_size_goal which is called on every write. It might make sense
to cache the size of a pending probe inside icsk_mtup.probe_size. Right
now it's zero unless a probe is outstanding; a separate bit could be
used intead.

Leonard Crestez (3):
  tcp: Consider mtu probing for tcp_xmit_size_goal
  tcp: Use mtu probes if RACK is enabled
  tcp: Adjust congestion window handling for mtu probe

 Documentation/networking/ip-sysctl.rst | 10 ++++
 include/net/inet_connection_sock.h     |  4 +-
 include/net/netns/ipv4.h               |  2 +
 include/net/tcp.h                      |  1 +
 net/ipv4/sysctl_net_ipv4.c             | 14 +++++
 net/ipv4/tcp.c                         | 11 +++-
 net/ipv4/tcp_ipv4.c                    |  2 +
 net/ipv4/tcp_output.c                  | 72 +++++++++++++++++++++-----
 8 files changed, 102 insertions(+), 14 deletions(-)


base-commit: 3913ba732e972d88ebc391323999e780a9295852
-- 
2.25.1

