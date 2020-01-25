Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029F6149522
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgAYLRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:17:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42340 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgAYLRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 06:17:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so5130575wro.9
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 03:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EeSX0lFa/oWQhAGW849cdExNIxrryOwO4I+9HOmWO70=;
        b=c0Ye6w1q/8E4GXWCgk+0sM87S2kGL2lxXTozDRsAdiEa+iE2Z4/js894KiK95twhFU
         IRlcxvFe5wOtV/UqDTiXwTZGiQJLCczYp9XBcagj7y7iA3MDzLJ2G+goXvMzN2Foplj+
         LG9SMKPIu8OVSLazy87htgsoSq41ismajhLpDKeqAGSo+rnrzfuiohAJyaZStOLQhUuU
         L9bAX+ZlwiXjGabic2YoGZzLNg212hxZMEMmRUovpI0c05rCqGEK7CnqPlcLN7ynZRke
         jCDsYBJSutcXQkdJ4TZNcBPtJKAmsRsOjTJbrNkbcpv7dWWUeuCkcxl/0kwyoGQ9Bzuq
         oTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EeSX0lFa/oWQhAGW849cdExNIxrryOwO4I+9HOmWO70=;
        b=bqIYsW17mvZGvbwQGUqGxJMhWG5gZf/5vGR/00zdY7aVgUOCMpPw6CPQh9B1fKG/pT
         kTUqwz8ZNAtQ9trOEYG9uSV2d2EpGOrDKCkvQsAw6HFCn+N/8vTByUYBixJShC7HWYw3
         auPocHehbNIi36mHkpmUKWc7SjSY+pZAAdN243scxAm3YXCORHPR/SHqSYz/XtozM1+M
         ix/DXmxMSnn+YOVTSteDdD1C7Tp7R0xhAk09YJPp4I4EmggslNoPiXMymOoA5rWnatqj
         mGviYJbX17fo44wwq2DDHY31Hm/eYqxfTODQlooHN6P+z/3lLFSAEwpgdcTW/SFDHmL6
         6diA==
X-Gm-Message-State: APjAAAWmGq+CRdq0/PgVHKHVZLaXiJoUCeq+THEk5I9JmCQv1HD2ayI+
        gTFzvIrkl6Otm7gKPNQu/UnlsSII0wk=
X-Google-Smtp-Source: APXvYqyFICtx1pGBuw0O9Bto4G9A64UVBTHxl4vJibD/0cxp2v4FwEvMxb7nVFjxQWx11FPrpamZWQ==
X-Received: by 2002:adf:fe07:: with SMTP id n7mr9543400wrr.286.1579951031329;
        Sat, 25 Jan 2020 03:17:11 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o15sm11300057wra.83.2020.01.25.03.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 03:17:10 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, leon@kernel.org, tariqt@mellanox.com,
        ayal@mellanox.com, vladbu@mellanox.com, michaelgur@mellanox.com,
        moshe@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com
Subject: [patch net-next v2 0/4] net: allow per-net notifier to follow netdev into namespace
Date:   Sat, 25 Jan 2020 12:17:05 +0100
Message-Id: <20200125111709.14566-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently we have per-net notifier, which allows to get only
notifications relevant to particular network namespace. That is enough
for drivers that have netdevs local in a particular namespace (cannot
move elsewhere).

However if netdev can change namespace, per-net notifier cannot be used.
Introduce dev_net variant that is basically per-net notifier with an
extension that re-registers the per-net notifier upon netdev namespace
change. Basically the per-net notifier follows the netdev into
namespace.

Jiri Pirko (4):
  net: call call_netdevice_unregister_net_notifiers from unregister
  net: push code from net notifier reg/unreg into helpers
  net: introduce dev_net notifier register/unregister variants
  mlx5: Use dev_net netdevice notifier registrations

 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.h |   1 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +-
 include/linux/netdevice.h                     |  17 +++
 net/core/dev.c                                | 118 +++++++++++++-----
 10 files changed, 131 insertions(+), 42 deletions(-)

-- 
2.21.0

