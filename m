Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED93263A43
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgIJCYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730516AbgIJCMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 22:12:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA3DC06136D
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 17:51:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j20so3846339ybt.10
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 17:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=wqGisfGQ6OcxFXOQJKoebNEGYvNJGgn022GabJKUWVo=;
        b=ev124PECm0PRukRTjjCj9SEHsPttLHUjUS2f66PlIi4yE7nbfkSUmOUxX8EVMrKAIZ
         A0b5kSuvvPPT/17GdU0UChnx7ZY/pYnMd2iiJEL73CKUrTnJIx+sUbDYfFkiWmIJI2sL
         BBcZVxE4p8V6tG/1aT9l+DnOGyBArG+aePU2oXHYZdnp/Lts7GD2eEcnPav/LL1yfZAP
         PltZAS+oCTyqTPvPeHTLD+VP4GIQWQnvCOp7zIVAWul355ddozHHQAEs0AFcaxOJ6lUE
         MVm1qSVN0Z6/TZbYN137j3uSCn719/DxIn/tZQp4+yrg6Avk38CkboCu/3cWdkEojL+9
         J1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=wqGisfGQ6OcxFXOQJKoebNEGYvNJGgn022GabJKUWVo=;
        b=gb77hk+3CrSsoFsPgvDW9F6pp6cscEF2o87k50YmW6IALR45Jf9KfGptQ/iTQJ1e+Q
         1T8uN7Rb2N0tQNrmHwzQpHTs+cvu/VpeuhMZBEJYRqhjAvOlx8BWCmT7Cf9XX+4/wDcU
         X4gqBKpw3zNPiC8/N5mfS7FkTd5mAHKNA7Ea+bVGuR8uS6LzAbiGAFDv1PS4P4XvyBEX
         etenBDjA1+jLlQOS+eHOVPpcwlYGEXqO3nzZfIH3N5uL0+Bo0/ws1mMXYD0VvbuV5rnB
         UGv0Of8VS0ikBbQjffYvq/O0Qw45xyLdlCIj8nEKp5hi6VDprHF0QvXImFW9qK5kBHh3
         D27Q==
X-Gm-Message-State: AOAM530vYvfVjRDxN0M6ynzbdD7xv36JaaJ8cdH8N7DXN0+nLKrPOZjB
        eFe4p7EzsuchBWvFSin1BA8SCGFfBko=
X-Google-Smtp-Source: ABdhPJweZv6GIevMuhbJEYEgokpCj2QhqnSJeelmkAnXRNJnwLB0DzT2iNeEtnzO/2vmj5dX3QdqJOF/OGc=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:3357:: with SMTP id z84mr10653603ybz.234.1599699065813;
 Wed, 09 Sep 2020 17:51:05 -0700 (PDT)
Date:   Wed,  9 Sep 2020 17:50:45 -0700
Message-Id: <20200910005048.4146399-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next 0/3] tcp: add tos reflection feature
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds a new tcp feature to reflect TOS value received in
SYN, and send it out in SYN-ACK, and eventually set the TOS value of the
established socket with this reflected TOS value. This provides a way to
set the traffic class/QoS level for all traffic in the same connection
to be the same as the incoming SYN. It could be useful for datacenters
to provide equivalent QoS according to the incoming request.
This feature is guarded by /proc/sys/net/ipv4/tcp_reflect_tos, and is by
default turned off.

Wei Wang (3):
  tcp: record received TOS value in the request socket
  ip: pass tos into ip_build_and_send_pkt()
  tcp: reflect tos value received in SYN to the socket

 include/linux/tcp.h        |  1 +
 include/net/ip.h           |  2 +-
 include/net/netns/ipv4.h   |  1 +
 net/dccp/ipv4.c            |  6 ++++--
 net/ipv4/ip_output.c       |  5 +++--
 net/ipv4/syncookies.c      |  6 +++---
 net/ipv4/sysctl_net_ipv4.c |  9 +++++++++
 net/ipv4/tcp_input.c       |  1 +
 net/ipv4/tcp_ipv4.c        | 11 ++++++++++-
 net/ipv6/tcp_ipv6.c        | 10 +++++++++-
 10 files changed, 42 insertions(+), 10 deletions(-)

-- 
2.28.0.618.gf4bc123cb7-goog

