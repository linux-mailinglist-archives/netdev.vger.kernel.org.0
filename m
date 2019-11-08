Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B872FF3FAA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 06:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbfKHFUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 00:20:49 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33188 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfKHFUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 00:20:47 -0500
Received: by mail-pg1-f196.google.com with SMTP id h27so3337021pgn.0;
        Thu, 07 Nov 2019 21:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mRcwZXi+fTKaf/q3/3qnzbsEsLK//Y2roDv+tqox8g0=;
        b=L5MEGmwPskvLT6Bw7U4jc1sp+VixT1Km9JHoBE1uderXv5+CCu7APG4vc2DR2THtMe
         AcqulwQCpTKbf4f9JDGDh0WpnBPYE6BDhFFwMaQQVhwFYwBJ38XIVQicIOaP0SiJhM5M
         asl+qNtonpjiZjDARecZc28gZefvJ3Yz+lFEbKSvBw6SZ6TUvx2MI9EcTPHGaSBMNPNv
         NIvhrDU08wnKSGrjjBCfVjkani9nTDoqX+Op19qb3MMsKau5SyFURm6Kb397e9s4IrKb
         KTG+iS4PDaCPKIvsFeqBJJBdB5NAdmZpgFHIwcKSZUsZcsXxkeeNAeCLd1y+tLkz7ebh
         4CSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mRcwZXi+fTKaf/q3/3qnzbsEsLK//Y2roDv+tqox8g0=;
        b=epphi2YljNT8D7p0fIOs+EnNfraYaD2bgML+3+f75ZIxnwvVeRkJLs6Bjcea+Acrpe
         k8jq5ImK1Yhdkqg2alPUEgs7w5j1vwtTYo1AC5Iv8UwBRlQre8/a0imf5+0tLighJByl
         MTDV29JOsObwNHVYVRwymljLovaq/Ehj3jQrYSVpRP9wpM8YLng/SP0gPmm1a9roblN7
         zkPk1dc8ybrrC0SgoT7G5LB16/1qmfnGDxj95hpBVZn+tEd0cDQq4pIarpApcmh1FS0d
         YYJBF0ZMkCNpN951UIVxZeYgKEGAQJXX1sS4FZdmTrDzcyHGgSd3fH2EnHBFKBZW6LlK
         ZDOw==
X-Gm-Message-State: APjAAAXJCLBsCNwVvkhqXqLaiYxIdNEZ2+NeHzrBXe/g+YLgLDY9u7V2
        8oN25JwlDhJ66D/5E7jMEJ2M7y+a
X-Google-Smtp-Source: APXvYqzHumEca+Ni47jDLp+Z2jhIFEduYSs0IhjclSZBE76Uk4PWQ6QceZw/NhF354UeiKA8VzQjNQ==
X-Received: by 2002:a63:5960:: with SMTP id j32mr9583414pgm.281.1573190445370;
        Thu, 07 Nov 2019 21:20:45 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w62sm4887177pfb.15.2019.11.07.21.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 21:20:44 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv4 net-next 0/5] sctp: update from rfc7829
Date:   Fri,  8 Nov 2019 13:20:31 +0800
Message-Id: <cover.1573190212.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP-PF was implemented based on a Internet-Draft in 2012:

  https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05

It's been updated quite a few by rfc7829 in 2016.

This patchset adds the following features:

  1. add SCTP_ADDR_POTENTIALLY_FAILED notification
  2. add pf_expose per netns/sock/asoc
  3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  4. add ps_retrans per netns/sock/asoc/transport
     (Primary Path Switchover)
  5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt

v1->v2:
  - See Patch 2/5 and Patch 5/5.
v2->v3:
  - See Patch 1/5, 2/5 and 3/5.
v3->v4:
  - See Patch 1/5, 2/5, 3/5 and 4/5.

Xin Long (5):
  sctp: add pf_expose per netns and sock and asoc
  sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
  sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  sctp: add support for Primary Path Switchover
  sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt

 Documentation/networking/ip-sysctl.txt |  34 ++++++++
 include/net/netns/sctp.h               |  14 ++++
 include/net/sctp/constants.h           |  12 +++
 include/net/sctp/structs.h             |  13 ++-
 include/uapi/linux/sctp.h              |  15 ++++
 net/sctp/associola.c                   |  36 ++++----
 net/sctp/protocol.c                    |   6 ++
 net/sctp/sm_sideeffect.c               |   5 ++
 net/sctp/socket.c                      | 147 +++++++++++++++++++++++++++++----
 net/sctp/sysctl.c                      |  22 ++++-
 10 files changed, 266 insertions(+), 38 deletions(-)

-- 
2.1.0

