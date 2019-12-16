Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD5611FE85
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfLPGoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:06 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:36564 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfLPGoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:06 -0500
Received: by mail-pf1-f182.google.com with SMTP id x184so5055595pfb.3
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tFZyLEa5u35tEAAw0JILWdFb54rPhJwMTPMwKzjfD2c=;
        b=KyfS1jke9Pp59XGTLi0DMWrkWWuJBcOqSGVceChTuAuFs5kHOGzZ4KDb+cZN4c07Yo
         Bs5g7alQSOhAL1ZrUHirU8Q+Mk0xKjFL9udNRBC8zH9NAcRQfZPARmlctNebKzTYlAh3
         mKGo7Oji6p/Bhxu80leeIUR0VcxjKz4YpzmTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tFZyLEa5u35tEAAw0JILWdFb54rPhJwMTPMwKzjfD2c=;
        b=rf78vQoxrRHWcOfbQPImaL3cytFDVAswLaLvouk832dr/Jy69Szm1mcD/zCxE1weer
         ZR20oTeSYCuuJYXWGM8qvF9dQb/a6A8v9Gf6qRcyttqZ9OWVyd6MlCGUyc1l8U0V4qXr
         /0tq5CI43ywDBqzwfVylJaWytNvKML93ZpRrSYlwhxZGi9kyT470y9/jYU9PcOUWXarw
         pmJYQ26z6DPSiz6wgZrdo5mWrqCBOZgSE7uy2I4AcmSq+LNMdcEX1JcrgJ2AHWuEy9yG
         GRAI9+Uok2XckiYhoKJm8JGLUxChvb1IqTlnvRkjShGMrf7tl3AsXlwIS1fTK9OhAeI1
         jdQw==
X-Gm-Message-State: APjAAAUaHW8UTyfxHLG5jPvJXebYtoc1EDtQn7ITeHuOysDyKXt3Ty9A
        MmHo1mTtRDxqqrluHkMu2942ADwkBKo=
X-Google-Smtp-Source: APXvYqwM0a748u1MbZbRgROCyQDMlTYEe4yfScbPYNHYO+eAYkmOXXa5biQh76owIyF5EUGIafhfJQ==
X-Received: by 2002:a63:26c4:: with SMTP id m187mr11757774pgm.410.1576478645327;
        Sun, 15 Dec 2019 22:44:05 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:04 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 0/8] bridge vlan tunnelshow fixes
Date:   Mon, 16 Dec 2019 15:43:36 +0900
Message-Id: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix various problems in and around normal and json output of `bridge vlan
tunnelshow`.

Can be tested using:
ip link add bridge type bridge

ip link add vxlan0 type vxlan dstport 4789 external
ip link set dev vxlan0 master bridge
ip link set dev vxlan0 type bridge_slave vlan_tunnel on

bridge vlan add dev vxlan0 vid 1000
bridge vlan add dev vxlan0 vid 1000 tunnel_info id 1000
bridge vlan add dev vxlan0 vid 1010-1020
bridge vlan add dev vxlan0 vid 1010-1020 tunnel_info id 1010-1020
bridge vlan add dev vxlan0 vid 1030
bridge vlan add dev vxlan0 vid 1030 tunnel_info id 65556

Benjamin Poirier (8):
  json_print: Remove declaration without implementation
  testsuite: Fix line count test
  bridge: Fix typo in error messages
  bridge: Fix src_vni argument in man page
  bridge: Fix BRIDGE_VLAN_TUNNEL attribute sizes
  bridge: Fix vni printing
  bridge: Deduplicate vlan show functions
  bridge: Fix tunnelshow json output

 bridge/vlan.c                            | 138 ++++++++---------------
 include/json_print.h                     |   2 -
 man/man8/bridge.8                        |   4 +-
 testsuite/Makefile                       |   3 +-
 testsuite/lib/generic.sh                 |   8 +-
 testsuite/tests/bridge/vlan/tunnelshow.t |  33 ++++++
 6 files changed, 88 insertions(+), 100 deletions(-)
 create mode 100755 testsuite/tests/bridge/vlan/tunnelshow.t

-- 
2.24.0

