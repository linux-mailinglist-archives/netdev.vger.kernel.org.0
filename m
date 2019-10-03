Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58FCAE04
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387847AbfJCSTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:19:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36180 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbfJCSTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:19:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id o12so4956309qtf.3
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 11:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56dQt4QRF2SuQCAdT1VIYpsb1hq4uXvpEX+7LvkGdzc=;
        b=dNauUMGZkVh6eLPWZWbfFRK9m+oFt54CKa77flZoZxy4IHQcScHXsZKkRkW1iv9dSS
         l7vDJJfUPf756amDdYLwuB6TWCqK/wKAS5NntjBKyCjXkAQ/mt+80GtRx1Qe5IEirwrW
         i4X0n9Ai2ZaSWO/iiz9cXFBm6cUxUZIBkqZBE9QnwsE0f3BPhkTM7gXRcLOmXhpi0fIF
         0jQjKp9lNICpqJ/2VoxiuDzjuM7ToTwMe7mkgrvMfb6grOslt+SJH80DkUxZKM27If1+
         1+obSeljTTvrLFmS/+xQoCrpkrq2VRfq07ZBrgk+/I6NWnPQt0OTheRdAzPs6J0Foy/u
         16uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56dQt4QRF2SuQCAdT1VIYpsb1hq4uXvpEX+7LvkGdzc=;
        b=AibxZCmNUC9CdBwkaZOWp0IrzNe7o+5xdPtW+RF/BERH94ArxgSaEAWwzS0H3rZUPP
         ZmzxIgvLSJBRHpHenRAxC3ESzIbiRoxOlVS5OY4qSVarXwBGa/+B3jfoOZLXBSr4HzNn
         e5+t6cHyPwrOXfn5xtA4BAcq2B67tFu/F9S8w+F2dNAg4Ul6V8sVnzqZDlGWeSb/lt9c
         L7Eeg03wKL2mSdnw0yb+wcoeFFATmOJMLoB3Dgk8ASftqthriPRdkzjElUZ+HawrsGAB
         2dsn116g16GYsgpsWwtj9ZErGCY45eyKVpvHPZT675TQ3Euw7CE0YNNH7OH00ybAk3rJ
         c5pw==
X-Gm-Message-State: APjAAAUIbrFrcknVsXQ7QnMA1eKlPlbAZho9vlcpneJBkxO4+q9aEEL3
        2EVgUkkhOcEHtq/+gaOIbBV3PA==
X-Google-Smtp-Source: APXvYqzUyn9iCVG43i7QUjnCMaJCXjbjsEr9+ZEEaX7NBGvW6gZITH9bOOMIyLqDofrh0U1HzmA0TA==
X-Received: by 2002:a0c:8171:: with SMTP id 104mr9880456qvc.168.1570126777468;
        Thu, 03 Oct 2019 11:19:37 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m91sm1592984qte.8.2019.10.03.11.19.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:19:36 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/6] net/tls: separate the TLS TOE code out
Date:   Thu,  3 Oct 2019 11:18:53 -0700
Message-Id: <20191003181859.24958-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

We have 3 modes of operation of TLS - software, crypto offload
(Mellanox, Netronome) and TCP Offload Engine-based (Chelsio).
The last one takes over the socket, like any TOE would, and
is not really compatible with how we want to do things in the
networking stack.

Confusingly the name of the crypto-only offload mode is TLS_HW,
while TOE-offload related functions use tls_hw_ as their prefix.

Engineers looking to implement offload are also be faced with
TOE artefacts like struct tls_device (while, again,
CONFIG_TLS_DEVICE actually gates the non-TOE offload).

To improve the clarity of the offload code move the TOE code
into new files, and rename the functions and structures
appropriately.

Because TOE-offload takes over the socket, and makes no use of
the TLS infrastructure in the kernel, the rest of the code
(anything beyond the ULP setup handlers) do not have to worry
about the mode == TLS_HW_RECORD case.

The increase in code size is due to duplication of the full
license boilerplate. Unfortunately original author (Dave Watson)
seems unreachable :(

Jakub Kicinski (6):
  net/tls: move TOE-related structures to a separate header
  net/tls: rename tls_device to tls_toe_device
  net/tls: move tls_build_proto() on init path
  net/tls: move TOE-related code to a separate file
  net/tls: rename tls_hw_* functions tls_toe_*
  net/tls: allow compiling TLS TOE out

 drivers/crypto/chelsio/Kconfig            |   2 +-
 drivers/crypto/chelsio/chtls/chtls.h      |   5 +-
 drivers/crypto/chelsio/chtls/chtls_main.c |  20 ++--
 include/net/tls.h                         |  37 +-----
 include/net/tls_toe.h                     |  77 ++++++++++++
 net/tls/Kconfig                           |  10 ++
 net/tls/Makefile                          |   1 +
 net/tls/tls_main.c                        | 124 ++-----------------
 net/tls/tls_toe.c                         | 139 ++++++++++++++++++++++
 9 files changed, 257 insertions(+), 158 deletions(-)
 create mode 100644 include/net/tls_toe.h
 create mode 100644 net/tls/tls_toe.c

-- 
2.21.0

