Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C54C1CAE
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 10:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfI3IPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 04:15:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56088 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfI3IPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 04:15:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id a6so12236704wma.5
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 01:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cE/sibx2iPZOblQTNy18Le1yxE0X08JX8c+yNiafmbE=;
        b=Ht42xRyTDvcH1X1h1KiprH+m+OET3Lzbmqa+I8tJehGziR12IFG96hHAZwBhkSBwjQ
         BUjufRVHNONxalxVr+qJkhKCraEi7yhROxE6z9pTHaNjvXMHfO8Vpf9Iue4roZZcw/oP
         SZdNjVcbMcFK2eoOdYT5jhEVhVdYiz3mzdmsDkhvbc2rv3MN50uQoiPU2efnuDE4/NSs
         022gDZFFCjVzeTFM/kVSJv0s4lPHN+vGWWHBxMA8mpcYIklnjQWFaD1ptrpweJfIdLye
         JQnCzSu1ybrv8NEKVf77oUe8IlM15YkjNxXgh2FKOGmNJCWzGitx5ggO8NkSyBm8mDwp
         vr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cE/sibx2iPZOblQTNy18Le1yxE0X08JX8c+yNiafmbE=;
        b=isB7kBzlHsadbrdhJWX4AaUdPSmJweq1lpRJwm3Wt6w35AFscvFxCtOiRpNSMEfCxS
         VurLdODsWx2ruTqHO3c5alnbD+j3rZhxHvI/aRG7hIebZz0zN7+LyMpA7O1QdWsMiDJi
         C7eZaiZZ+KBKv8Y0DgVjwd6yIwG4SzfstEObe9Jpw7FvDOV2DJi83MCAbdwWstNVvos5
         EzukuN1cu1pt4vRnI+SCxp0oAUVV7v6WAXRE87IUXBiJILfY8FPIX7hKOhA9ckB7XqG3
         +kTOdddG1mI4qGqncPC66Panoau2RkaANx1r5DFSJt3PdxsSxIX2hk2Py0GMbQNWsqpL
         zlJg==
X-Gm-Message-State: APjAAAXWKnFXYlSRxRtYjl8ac/8oFzcgWgOi40BNZHi6qkeXNqnmZbCA
        X9CoWdQrEgqCZU1llmdt0hGquTQ9bFE=
X-Google-Smtp-Source: APXvYqz1TjQfmNi/41Z2xnii54zOEV2fWg+0gUcJ5c1//MvHXKX6qi6WP9sWGaegHqu0biXezW8cnw==
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr17027292wmi.26.1569831312874;
        Mon, 30 Sep 2019 01:15:12 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id h6sm10891754wru.60.2019.09.30.01.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 01:15:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, pabeni@redhat.com,
        edumazet@google.com, petrm@mellanox.com, sd@queasysnail.net,
        f.fainelli@gmail.com, stephen@networkplumber.org,
        mlxsw@mellanox.com
Subject: [patch net-next 0/3] net: introduce per-netns netdevice notifiers and use them in mlxsw
Date:   Mon, 30 Sep 2019 10:15:08 +0200
Message-Id: <20190930081511.26915-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Some drivers, like mlxsw, are not interested in notifications coming in
for netdevices from other network namespaces. So introduce per-netns
notifiers and allow to reduce overhead by listening only for
notifications from the same netns.

This is also a preparation for upcoming patchset "devlink: allow devlink
instances to change network namespace". This resolves deadlock during
reload mlxsw into initial netns made possible by
328fbe747ad4 ("net: Close race between {un, }register_netdevice_notifier() and setup_net()/cleanup_net()").

Jiri Pirko (3):
  net: push loops and nb calls into helper functions
  net: introduce per-netns netdevice notifiers
  mlxsw: spectrum: Use per-netns netdevice notifier registration

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   9 +-
 include/linux/netdevice.h                     |   6 +
 include/net/net_namespace.h                   |   6 +-
 net/core/dev.c                                | 176 +++++++++++++++---
 4 files changed, 165 insertions(+), 32 deletions(-)

-- 
2.21.0

