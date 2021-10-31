Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F90440F3E
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 17:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhJaQCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhJaQCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 12:02:45 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69727C061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 09:00:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m21so14906721pgu.13
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 09:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=eRYuaFUo1+RSVYyfo0af58Pt9faqfm6NIVSCp7R9v74=;
        b=Y+ycJDfrTsRhneUYdN2TiR9PpyMhywQKnGJARQsjsM8UJehoOguHO5Wml6q6elt62Z
         yWNSwHEP7CSlVxpXlMRlfjbYg9th3MzH7Cho3iEe4DYMlfy3mnN3VohkD6b1uXAX91Cl
         I6JwVwhq8rUE9/imXQAHchQp/gTCIKIkDdzOu2e73LBfFFnL/Sb40eGlQczqx99HRvqe
         wk/TEOksnrcPz3NRIVWgbSL3BgcZw47tMUbLvzm68VGE1q4ELUxB7uSt2i1w7ZtHPZv6
         sODYeGDHA7T8NFjOPMhPoAjw1kJviYMZjt91sCqmys7WTuFnUj3PJlZsAblA7Gid+yKX
         RVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eRYuaFUo1+RSVYyfo0af58Pt9faqfm6NIVSCp7R9v74=;
        b=1IO8Km7cWHD6FN2VJlPEIErv7vZlcCuXLoKaMBbwvx9ED1wOccQ1s85+NsGOSgpltE
         EucZGWWEWK2asK4Mm+6Cc78+ThJbNhdVBCXWGre4B+PLFI9vJwuw4jJZoHqmUTck/lky
         TaEeGXWs3RGISsXiLuIPYUDX5nYD4LHxUR/aUC7Bptq7uUOneY2X8Lue2AVFdYE5SIDO
         0DA/SHbVvA6YiUnMF08fF9k37a2UmLmzc7PCXdgUnE0YkhX0Z1OnrfKuTI6mm8Rs16Ug
         WoqtMQtQrtFD+HPBGlUOIYi7VHuJgH/9cZJNZfK6ka/xGAT0uxz5u3K6qAo/J/thfR6s
         aiDw==
X-Gm-Message-State: AOAM532uKPg37XFD8ZQ8ZNbnfq7Z3owSpQiFa/443VYg/MbsG43pNrhb
        a0JXrgTLUcUokhsbG5zRHdZVJ/NSkuEzSg==
X-Google-Smtp-Source: ABdhPJy6BKlnGsds/V+c4zj1Xq3SZppejSH1Xs04imLiHEouHqCeqXLdemVwcFXth8XUWyAsduHZ9g==
X-Received: by 2002:a63:8642:: with SMTP id x63mr976003pgd.376.1635696012735;
        Sun, 31 Oct 2021 09:00:12 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 1sm12297943pfl.133.2021.10.31.09.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 09:00:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v7 0/5] amt: add initial driver for Automatic Multicast Tunneling (AMT)
Date:   Sun, 31 Oct 2021 16:00:01 +0000
Message-Id: <20211031160006.3367-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an implementation of AMT(Automatic Multicast Tunneling), RFC 7450.
https://datatracker.ietf.org/doc/html/rfc7450

This implementation supports IGMPv2, IGMPv3, MLDv1, MLDv2, and IPv4
underlay.

 Summary of RFC 7450
The purpose of this protocol is to provide multicast tunneling.
The main use-case of this protocol is to provide delivery multicast
traffic from a multicast-enabled network to sites that lack multicast
connectivity to the source network.
There are two roles in AMT protocol, Gateway, and Relay.
The main purpose of Gateway mode is to forward multicast listening
information(IGMP, MLD) to the source.
The main purpose of Relay mode is to forward multicast data to listeners.
These multicast traffics(IGMP, MLD, multicast data packets) are tunneled.

Listeners are located behind Gateway endpoint.
But gateway itself can be a listener too.
Senders are located behind Relay endpoint.

    ___________       _________       _______       ________
   |           |     |         |     |       |     |        |
   | Listeners <-----> Gateway <-----> Relay <-----> Source |
   |___________|     |_________|     |_______|     |________|
      IGMP/MLD---------(encap)----------->
         <-------------(decap)--------(encap)------Multicast Data

 Usage of AMT interface
1. Create gateway interface
ip link add amtg type amt mode gateway local 10.0.0.1 discovery 10.0.0.2 \
dev gw1_rt gateway_port 2268 relay_port 2268

2. Create Relay interface
ip link add amtr type amt mode relay local 10.0.0.2 dev relay_rt \
relay_port 2268 max_tunnels 4

v1 -> v2:
 - Eliminate sparse warnings.
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.
 - Use CHECKSUM_NONE instead of CHECKSUM_UNNECESSARY.
 - Fix compile error.

v4 -> v5:
 - Remove unnecessary rcu_read_lock().
 - Remove unnecessary amt_change_mtu().
 - Change netlink error message.
 - Add validation for IFLA_AMT_LOCAL_IP and IFLA_AMT_DISCOVERY_IP.
 - Add comments in amt.h.
 - Add missing dev_put() in error path of amt_newlink().
 - Fix typo.
 - Add BUILD_BUG_ON() in amt_smb_cb().
 - Use macro instead of magic values.
 - Use kzalloc() instead of kmalloc().
 - Add selftest script.

v5 -> v6:
 - Reset remote_ip in amt_dev_stop().

v6 -> v7:
 - Fix compile error.

Taehee Yoo (5):
  amt: add control plane of amt interface
  amt: add data plane of amt interface
  amt: add multicast(IGMP) report message handler
  amt: add mld report message handler
  selftests: add amt interface selftest script

 MAINTAINERS                          |    8 +
 drivers/net/Kconfig                  |   16 +
 drivers/net/Makefile                 |    1 +
 drivers/net/amt.c                    | 3296 ++++++++++++++++++++++++++
 include/net/amt.h                    |  385 +++
 include/uapi/linux/amt.h             |   62 +
 tools/testing/selftests/net/Makefile |    1 +
 tools/testing/selftests/net/amt.sh   |  284 +++
 tools/testing/selftests/net/config   |    1 +
 9 files changed, 4054 insertions(+)
 create mode 100644 drivers/net/amt.c
 create mode 100644 include/net/amt.h
 create mode 100644 include/uapi/linux/amt.h
 create mode 100644 tools/testing/selftests/net/amt.sh

-- 
2.17.1

