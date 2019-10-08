Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CFCCF80B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbfJHLZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:25:18 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:34465 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730051AbfJHLZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:25:18 -0400
Received: by mail-pg1-f171.google.com with SMTP id y35so10116208pgl.1;
        Tue, 08 Oct 2019 04:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=78CxxKrplW7tPUE38N910xMYJGm43osKQQXzlCJXfgo=;
        b=f89TVBsNKEBeAmWa+P3W42TugXVhOHrCSFawHi/8iFQPuvXLMlts1kBRnio6JZRnS5
         g8u7yWlJ/0guC8sll7gRMKgBsuOhMBPoQc7mtR2mtiXKPTK2wcdiFiAYWg4jN4dgME7G
         nIPhcyN69XoZq90O/Z0EZ/u9zSUzFC4C8UyTm3y9qiCW9EpPSUDstv3e4O67nV3TkXIr
         XwtckhkI2nOb+iW+lyG/ElyIKwkM7UAgKo8VSfubgZpISrVAjPxU1lCzOMyC14w4q1Uc
         0IdY3dmMxn+dOcgL2UGgkOhv8l4JDbSgbpWveTzGxh0+Eig3GEVRzIv9OLVWMxjwi5MT
         p5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=78CxxKrplW7tPUE38N910xMYJGm43osKQQXzlCJXfgo=;
        b=CDzCcAxsVD5KN0QjNodeKHaWWLmOzpRfDXlue76iKQoOQKDROvl+pQ5/GNpkPmr17r
         MvUBcrwTpkQ2iqo7Lr4kp1OhXTEf5xeKdK/o19HzJVzwDwa3OcIEgEhKSIEgj4pOGnYx
         cCWrMTLGLktnBNumhH5iW2lnn0SGdqFMtyqWG+/NDeQmF8teROhPsDaUPStxpH48/ev3
         u92fFkFJw27HY6tlgOEwrLU8g1dEWYYVq0wFje1FbDQFI7+iamm9kE6u/TlI0Ca0rCDj
         qM+LlqbRgPT5nklEDhFbsxMl7sHKnRW10LbAr12jgF4iqfnj8lIbEg9FDcrKaH452VH+
         3mdQ==
X-Gm-Message-State: APjAAAUz63werbZs4kzicQChsYbea1Elrz4cAa3foxUORAB4lrr726uY
        MADsvnt2pfAg569zdzks3qZ6cer/
X-Google-Smtp-Source: APXvYqx4VRCY7w6WKiy9zN/AMN3o2o2BQU8VSkKQM6yCF80pJPXBs1krNztpg/0W6ZLcS5LKR1k8Kg==
X-Received: by 2002:a65:6102:: with SMTP id z2mr35655044pgu.391.1570533915580;
        Tue, 08 Oct 2019 04:25:15 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b69sm19527975pfb.132.2019.10.08.04.25.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:25:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 0/5] sctp: update from rfc7829
Date:   Tue,  8 Oct 2019 19:25:02 +0800
Message-Id: <cover.1570533716.git.lucien.xin@gmail.com>
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

Xin Long (5):
  sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
  sctp: add pf_expose per netns and sock and asoc
  sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  sctp: add support for Primary Path Switchover
  sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt

 include/net/netns/sctp.h   |  13 +++++
 include/net/sctp/structs.h |  13 ++++-
 include/uapi/linux/sctp.h  |  13 +++++
 net/sctp/associola.c       |  26 ++++-----
 net/sctp/protocol.c        |   6 ++
 net/sctp/sm_sideeffect.c   |   5 ++
 net/sctp/socket.c          | 143 ++++++++++++++++++++++++++++++++++++++++-----
 net/sctp/sysctl.c          |  16 +++++
 8 files changed, 203 insertions(+), 32 deletions(-)

-- 
2.1.0

