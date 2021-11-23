Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA49B45AF92
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhKWW7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhKWW70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:59:26 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DE3C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:56:17 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id m24so280213pls.10
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tfAJRMwBp9PrDzW6ksruC0LKNsPoqvsPFRZpX0SpYUs=;
        b=CFALNg4Mt4Rlt7Ldles8H8AGKTrfJ0/OIdhDfEimZa3OiVc3vzxaw0EnNAit2aEXbW
         W7W7GdcPak95P7hICPuudXjVH3rpMsaUPU6paWxnJ8wxFW0qcR9dAS3v2r8puJSmf7me
         fcsO0kLX4/FYLPwYO3xXOfyOsyMZ3PNz6VJXjPHC5V3iLQspCPPZTjuxCsvDX3zaKWQd
         DIlp5nIaZ71YeV86SbrxFAegH5kZ0tHzbSArWYuh8N5D8oaPpP6vU8ZyUaQijWsrefLO
         6DgFkLJ2Qk72Ff+0qkMt5visWAV3PuH+O4/9dKuP1afyqaIUzCqEcUowMl/TA0TAo6IP
         NhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tfAJRMwBp9PrDzW6ksruC0LKNsPoqvsPFRZpX0SpYUs=;
        b=3cleCyaeQ/YzTk2jQgbf2bGri51ikTUgkjMuYLLae9eTmGQuu9OneEUyOdvX/bSr46
         h8VBp8CkljWgnPVYSoJ/qT9syEh3gU3EKp5WsHcvtdDKgvho3xdphXWBHEd2FJ/6beRD
         4OVJmFQOReswCatbAdg1TLeerDYOZ7vKbfoVI3hnVG3c/sMJ0ZBUq4dtE01w7ePkbQAV
         oGUA6NlWUDZReHhBwZqlcqdBhKzuiLe5nJS8TgdoiUlTT6p3w13V6v7rkXxX/DJTvxTD
         VBjt7i0iq0l4KFLq7FfXxzVIOjfQg4k2b8McyrZwCYrUOU97zq7h8nUSR4uHXLobugEe
         JUzQ==
X-Gm-Message-State: AOAM531gRleC0IIlC7sAIt83BJzNiNhJxQaUUMKsmKm3Yu81bl07GBsl
        wDrlPoyGjcTYvyaBdyCj4k8=
X-Google-Smtp-Source: ABdhPJxzo1NURi6oDJSHS+G/sSrRitFxV/6r/PDQnrAs5eZMdvD3ld4W49MqO3W7WWG4ohUoBm7vLQ==
X-Received: by 2002:a17:90b:4b0d:: with SMTP id lx13mr1537686pjb.146.1637708177099;
        Tue, 23 Nov 2021 14:56:17 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8b31:9924:47bf:5e47])
        by smtp.gmail.com with ESMTPSA id u6sm14342185pfg.157.2021.11.23.14.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:56:16 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] gro: remove redundant rcu_read_lock
Date:   Tue, 23 Nov 2021 14:56:06 -0800
Message-Id: <20211123225608.2155163-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Recent trees got an increase of rcu_read_{lock|unlock} costs,
it is time to get rid of the not needed pairs.

Eric Dumazet (2):
  gro: remove rcu_read_lock/rcu_read_unlock from gro_receive handlers
  gro: remove rcu_read_lock/rcu_read_unlock from gro_complete handlers

 drivers/net/geneve.c   |  8 +-------
 net/8021q/vlan_core.c  |  7 +------
 net/ethernet/eth.c     |  7 +------
 net/ipv4/af_inet.c     | 19 ++++++-------------
 net/ipv4/fou.c         | 25 +++++++------------------
 net/ipv4/gre_offload.c | 12 +++---------
 net/ipv4/udp_offload.c |  4 ----
 net/ipv6/ip6_offload.c | 14 +++-----------
 net/ipv6/udp_offload.c |  2 --
 9 files changed, 22 insertions(+), 76 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

