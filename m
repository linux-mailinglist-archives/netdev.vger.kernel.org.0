Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 313D6D5B19
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729954AbfJNGO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:14:58 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:40745 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbfJNGO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 02:14:58 -0400
Received: by mail-pl1-f178.google.com with SMTP id d22so7529079pll.7;
        Sun, 13 Oct 2019 23:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H6bu3gWJSZN/IKjZG1dd30IeA9KNrq0zAYtn48rN5zw=;
        b=R/KYMG9Xya4vGbbTIl2HMAFZXepJIYHQmDmE5JEL4axWcXXSrZzu+zdBWZNNqx3jhK
         XHz5Qer5sOAOfnulkjMCXDc+azkI/1CbphstnmO5WWS6NIU3JgGg1OYAiyNAxoj4At+3
         T8skwcENlngHhe1aulk256g04aQg2+N4thzKExITiy6/xPNFEIja1sXp0XYBVFUGs0v5
         h52tW5ALTjgImXxfWddobWfOQxlK4iupid5mG62G0O8g4xuAxT6KS/HajAsStgRuiLl7
         1TmYy4tQOBJL+iDyIJyx748qbt9PanUQ3l19mtFZcik0ONE3OMNKGPHzj+2x1eAQDpQz
         EvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H6bu3gWJSZN/IKjZG1dd30IeA9KNrq0zAYtn48rN5zw=;
        b=n4oT6A5sbKi0CyHgW6rRa89oYVDmQyCv/HQfBMxOeiZknLZGDnKRM2vDKtWFsvcFVS
         f3HfPqIwqATjtnyQfKdVSMDu1DSo8kRKP0IiYIziPlYC1+5yP5x0E1WYGB9raWBloKaK
         z2tR7xTo2fsLtyBLUH2onHmEjLXXb0hssnkdGfgfJp2N53IL3N35014DuJb3mod2tCPW
         iO4fR+8uUgAJutq64M3+t341YQVNaCPw3XvXljXT7f/RRXL7jsLbSjasWsBzjPN8AdCH
         PCiQk3nx66Iouo/q9lhWZVYMI1O9LJTpXt+nC6GwnHOMIo4fXveHZ56EcFM4BkP6AxO6
         QeHg==
X-Gm-Message-State: APjAAAW+dfjqTmARzvq07JI++FmnNlyG2BLtmZr38CF/ykBRpn87VE3Y
        bketPMOoqX1rCkUZeVzRGHAkmVSE
X-Google-Smtp-Source: APXvYqxfati7o6co2bV8SPe/d6Tq+jRb5lDBN/v8GfCkqZMyudU1IWwBzaj2xjlqNR9q8/PfUZXWgg==
X-Received: by 2002:a17:902:54f:: with SMTP id 73mr28107508plf.329.1571033696968;
        Sun, 13 Oct 2019 23:14:56 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y8sm9167961pgs.34.2019.10.13.23.14.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 23:14:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Date:   Mon, 14 Oct 2019 14:14:43 +0800
Message-Id: <cover.1571033544.git.lucien.xin@gmail.com>
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

Xin Long (5):
  sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
  sctp: add pf_expose per netns and sock and asoc
  sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
  sctp: add support for Primary Path Switchover
  sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt

 include/net/netns/sctp.h     |  14 +++++
 include/net/sctp/constants.h |  10 +++
 include/net/sctp/structs.h   |  13 +++-
 include/uapi/linux/sctp.h    |  15 +++++
 net/sctp/associola.c         |  31 ++++-----
 net/sctp/protocol.c          |   6 ++
 net/sctp/sm_sideeffect.c     |   5 ++
 net/sctp/socket.c            | 147 ++++++++++++++++++++++++++++++++++++++-----
 net/sctp/sysctl.c            |  19 ++++++
 9 files changed, 226 insertions(+), 34 deletions(-)

-- 
2.1.0

