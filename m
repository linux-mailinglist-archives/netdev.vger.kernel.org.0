Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB324DE19
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfFUAhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:37:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42618 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFUAhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:37:02 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so2605426pff.9
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wr1twM+xbU0bTo4nC05aFTd0j09bncxms61V7GCjnuU=;
        b=MR5Ru88sEqc6GYScfo0XI05B8zt946lA5WZkLfxdIPLIxhTuXEhKBcXg+EevnfRMzQ
         dXy0oJx0s7s+nSWkpUDf8AOLei5Ca+gr5MinQto7b1BLOweuAVW47KBGNIw9Qg0PPtF0
         cLga0qpiCUvqp2fMa6wTUJi3yOxDsoRsUz9kNsXXVAHBt72n6YTJLt8O+TPWF1It2TeG
         7qQzFoWftLvsEp3NuvKg4IrEzahSa4xqczaQL4UStOF7YaEAmeLH5GAFe0SzOXxI8uVf
         yt5DF1NN2e0osPvlDQxH96Tqdmrl2y+fez7nOB50QezJUldg9R49T2wTI3vIzrM2jbEB
         zerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wr1twM+xbU0bTo4nC05aFTd0j09bncxms61V7GCjnuU=;
        b=SnA2BUAPh8d8yJNx9nfZ1ubKE7jgKPIFBIwMuOhjeiVp0duvxsUDUQSatMrhDoSYFd
         UZ5jJHhd2NehyqbGaa430kuXXIpwAGEK6NwmHju1h6RqLHfQp2CpjaIk0COQ2KMTtRtY
         6MOsXFSd4ho9G6sl3/Icc+5337vOgV3cPU4zbzTnmpvt3ZXiOqIkEB0tBVp2xuMSHFFe
         FQfOx+onRmfv4I01QN4VOokj7QVTc02W7Wdk0Wf7nim76Vji8Opj6Y+Lekp58PXHwoAo
         stsiwEOBwz2wqIS8/jYvq5rOtMGO43xsdho1rq/7HUDUhF1y5Z4P8tu429kCm4h/tbDO
         vtew==
X-Gm-Message-State: APjAAAW/QyPWbeND2XgrXoUX5N3NjcX03pcXMPylTg0w3uR9eJQ8Imea
        GSCJ71hHz371Tuq996FZXzg=
X-Google-Smtp-Source: APXvYqxyQuWRZqvOhJwsF1hRWjX05EQw+xslWnh1GKHVQvkoK3oiEeNkRxP51AvmevuTXzDpwdnYqA==
X-Received: by 2002:a63:1d53:: with SMTP id d19mr15362790pgm.152.1561077421018;
        Thu, 20 Jun 2019 17:37:01 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id 2sm588206pff.174.2019.06.20.17.36.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:36:59 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
Subject: [PATCH v3 net-next 0/5] ipv6: avoid taking refcnt on dst during route lookup
Date:   Thu, 20 Jun 2019 17:36:36 -0700
Message-Id: <20190621003641.168591-1-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

Ipv6 route lookup code always grabs refcnt on the dst for the caller.
But for certain cases, grabbing refcnt is not always necessary if the
call path is rcu protected and the caller does not cache the dst.
Another issue in the route lookup logic is:
When there are multiple custom rules, we have to do the lookup into
each table associated to each rule individually. And when we can't
find the route in one table, we grab and release refcnt on
net->ipv6.ip6_null_entry before going to the next table.
This operation is completely redundant, and causes false issue because
net->ipv6.ip6_null_entry is a shared object.

This patch set introduces a new flag RT6_LOOKUP_F_DST_NOREF for route
lookup callers to set, to avoid any manipulation on the dst refcnt. And
it converts the major input and output path to use it.

The performance gain is noticable.
I ran synflood tests between 2 hosts under the same switch. Both hosts
have 20G mlx NIC, and 8 tx/rx queues.
Sender sends pure SYN flood with random src IPs and ports using trafgen.
Receiver has a simple TCP listener on the target port.
Both hosts have multiple custom rules:
- For incoming packets, only local table is traversed.
- For outgoing packets, 3 tables are traversed to find the route.
The packet processing rate on the receiver is as follows:
- Before the fix: 3.78Mpps
- After the fix:  5.50Mpps

v2->v3:
- Handled fib6_rule_lookup() when CONFIG_IPV6_MULTIPLE_TABLES is not
  configured in patch 03 (suggested by David Ahern)
- Removed the renaming of l3mdev_link_scope_lookup() in patch 05
  (suggested by David Ahern)
- Moved definition of ip6_route_output_flags() from an inline function
  in /net/ipv6/route.c to net/ipv6/route.c in order to address kbuild
  error in patch 05

v1->v2:
- Added a helper ip6_rt_put_flags() in patch 3 suggested by David Miller


Wei Wang (5):
  ipv6: introduce RT6_LOOKUP_F_DST_NOREF flag in ip6_pol_route()
  ipv6: initialize rt6->rt6i_uncached in all pre-allocated dst entries
  ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic
  ipv6: convert rx data path to not take refcnt on dst
  ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF

 drivers/net/vrf.c       |   5 +-
 include/net/ip6_route.h |  15 ++++++
 net/ipv6/fib6_rules.c   |  12 +++--
 net/ipv6/ip6_fib.c      |   5 +-
 net/ipv6/route.c        | 112 +++++++++++++++++++++++-----------------
 net/l3mdev/l3mdev.c     |   7 ++-
 6 files changed, 95 insertions(+), 61 deletions(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

