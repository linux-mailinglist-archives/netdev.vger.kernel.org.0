Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A942BC68
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 01:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfE0X4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 19:56:54 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:45457 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0X4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 19:56:54 -0400
Received: by mail-pl1-f202.google.com with SMTP id cc5so12075962plb.12
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 16:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eZ8b0vFIaZs1GTDWAXX9Wt9JuCTIKwk0xrUY829C02Y=;
        b=d0rlKjsMR5JaiII2NXbEXl1MSViLCEmQBAuuz+gGD1cMuO/NETJU+l7NBRHBpDy8Qs
         fyp84nLxxsqbmdDXg7d65dA0oTAqGt2DJAQOiC1F6I6YUT5W7hJl67CJHCFT+VdozuQM
         v19AZuj3f+pS4op98ynTGN+pbjMt/q9Pa/9oUMOGdhGVPxiI0u7Yvuy7FWEY2KiM7BJE
         rVP+9pbkce6ylZSSgEtADg0mTuu0YMgY8aBfSVebezVj/pzyXuNGurr2J2glviZ0J69u
         lXGUAkUx4rhuXVu4/5wQv0JxbAPGf2cbsocAHP8ucw/QG2T3jHM70UpGJU8VetlgDeUj
         6+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eZ8b0vFIaZs1GTDWAXX9Wt9JuCTIKwk0xrUY829C02Y=;
        b=NH4KhEmEKGgL+Ii2E73K1rSmPSPp0OvanAo7tajW3+y2vk9hhF3MvNiIV+3RX5peYc
         JcoZQ1+4WIlhfTLXB6rNW7K+vh0D5zup2wjfEY+mXLU0XSHAr0KTErDYqjDpdU5GQSoT
         S7vdrD8j+mqUT3CIV+T0ce4SZpbbMByc6oPLbewVUxfMBbLKjgrhJD6kQ9zsTZeaktuu
         3C7l0Dq42rTpYDI6P0rp0DRAL8l6BuqIMx1OUEta70jS3ADS0kGMp0AI14BsO6KJnZNv
         iNZwKBRW22YCNepthgyAQQFhpnPxCAWBxqerN28LVSYwMOSH6lNRyFRN0s3RF0X1QHFn
         C+Zg==
X-Gm-Message-State: APjAAAVrXH/6IrqWavVKg51Z8K2hz24gI1XFEi13wsM4pcf5AYjU2ypE
        iYx7jyD/vghUHcjLltYCL0nTRJCfAt9BhA==
X-Google-Smtp-Source: APXvYqzArgZg45ESeq15AX54sijGeD5KcXAA17DPoMl5DXmjJTmMoEzhic27UqcY3dZquVv+jOO0o4QrIt4xLw==
X-Received: by 2002:a65:4649:: with SMTP id k9mr27460399pgr.239.1559001413301;
 Mon, 27 May 2019 16:56:53 -0700 (PDT)
Date:   Mon, 27 May 2019 16:56:46 -0700
Message-Id: <20190527235649.45274-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 0/3] inet: frags: followup to 'inet-frags-avoid-possible-races-at-netns-dismantle'
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Latest patch series ('inet-frags-avoid-possible-races-at-netns-dismantle')
brought another syzbot report shown in the third patch changelog.

While fixing the issue, I had to call inet_frags_fini() later
in IPv6 and ilowpan.

Also I believe a completion is needed to ensure proper dismantle
at module removal.

Eric Dumazet (3):
  inet: frags: uninline fqdir_init()
  inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
  inet: frags: fix use-after-free read in inet_frag_destroy_rcu

 include/net/inet_frag.h             | 23 +++--------------
 net/ieee802154/6lowpan/reassembly.c |  2 +-
 net/ipv4/inet_fragment.c            | 39 +++++++++++++++++++++++++++--
 net/ipv6/reassembly.c               |  2 +-
 4 files changed, 43 insertions(+), 23 deletions(-)

-- 
2.22.0.rc1.257.g3120a18244-goog

