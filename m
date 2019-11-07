Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B224F2F3F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 14:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388999AbfKGN2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 08:28:01 -0500
Received: from mail-lf1-f51.google.com ([209.85.167.51]:38226 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730958AbfKGN2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 08:28:01 -0500
Received: by mail-lf1-f51.google.com with SMTP id q28so1600188lfa.5
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 05:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=otw/LMNaCwhQgMmtphcj9FWjbVudliiaHCPb5fKJ7oY=;
        b=o9DFkbSgfcONILRXfz2vEJwroONNdr/qnLpSEg2Ki5GZW3ZAp2fGK9f8iEMBkObjtI
         A784rbh5Zdb1R3CbMZr2gn4z2+F4iqs/B3zgPUJtzq5xDr2rsTzs+k2Sn49S7kEjjUlI
         /shcDaMltMxTtRhx3q8jtyAcOtl3TZWRlG2dDVXn6SzAuOlSkd6IHy/e2IxX+6lsewtk
         jov5+9zUPw5WgkfEKzByYoRLz2JwIRYBJUYeyTSN9DQ3SvGreYzpHxXGVYARg7/noQBK
         eOmeS9qKO6cjBQy7S4HM2SxsdBG4m1YHEIj1F52RmqHV581u+CqH5vrnFDKq4tIYd3r0
         97pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=otw/LMNaCwhQgMmtphcj9FWjbVudliiaHCPb5fKJ7oY=;
        b=mEsNpmYP7oWjlKZ7yyCVAzwjoeTg8Is1cKRmmz3Rx0bhkG04WaG7sXWE8trtRUJfHx
         KGhhaLb/EWpJQkAkcfRfpfPd1JOfrmuYO6ipBWVv82z2ZWX1C3kO21+9S3McEmq3GG+F
         IemtEzdQHtwNxFBBNlUdUQhL/wWrW+fqePShRUmdlQ3er9JMjWrJ04e32Mj9oVPimc4A
         kDlj/RSJ2tRHs/3/LLWP02ZsrPMzSW5FeV66PJJvYoU/bJ9HLdJxFPpnjg3KpDUkbWun
         PZTQetve+04GzK0UWdCNUYzE+By2msAm4lLSfEj0VQiOYBzw1dTcbmefLD07TCqMd4nP
         na/w==
X-Gm-Message-State: APjAAAUa11rWkbIhkqFd/qjl7Icyg7ldgaIz0xt+rSeTfNfeYNk+BLj9
        0FlqnyM3avEl3nGCzTF+Q92z1g==
X-Google-Smtp-Source: APXvYqwBOahQPdDfqFrzvyNe/0wXA1CuMAdtA0EO4BM/bJ3R2ViH1fJ6lzXjluZp9R3Joi1oXI7/AQ==
X-Received: by 2002:a19:6d12:: with SMTP id i18mr2456723lfc.153.1573133278543;
        Thu, 07 Nov 2019 05:27:58 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id y20sm3151507ljd.99.2019.11.07.05.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 05:27:57 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v3 0/6] Add namespace awareness to Netlink methods
Date:   Thu,  7 Nov 2019 14:27:49 +0100
Message-Id: <20191107132755.8517-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed in v3:
- added patch 6 for setting IPv6 address outside current namespace
- address checkpatch warnings
- address comment from Nicolas

Changed in v2:
- address comment from Nicolas
- add accumulated ACK's

Currently, Netlink has partial support for acting outside of the current
namespace.  It appears that the intention was to extend this to all the
methods eventually, but it hasn't been done to date.

With this series RTM_SETLINK, RTM_NEWLINK, RTM_NEWADDR, and RTM_NEWNSID
are extended to respect the selection of the namespace to work in.

/Jonas

Jonas Bonn (6):
  rtnetlink: allow RTM_SETLINK to reference other namespaces
  rtnetlink: skip namespace change if already effect
  rtnetlink: allow RTM_NEWLINK to act upon interfaces in arbitrary
    namespaces
  net: ipv4: allow setting address on interface outside current
    namespace
  net: namespace: allow setting NSIDs outside current namespace
  net: ipv6: allow setting address on interface outside current
    namespace

 net/core/net_namespace.c | 19 ++++++++++
 net/core/rtnetlink.c     | 80 ++++++++++++++++++++++++++++++++++------
 net/ipv4/devinet.c       | 61 ++++++++++++++++++++++--------
 net/ipv6/addrconf.c      | 13 +++++++
 4 files changed, 145 insertions(+), 28 deletions(-)

-- 
2.20.1

