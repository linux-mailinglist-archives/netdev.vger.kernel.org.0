Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0057FAC94C
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406240AbfIGUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:54:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46345 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfIGUyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:54:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id h7so9887900wrt.13
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPqHMrarnj/eqlovwm4Ti2RJQ9+Z2LObwoWgr5fDQsE=;
        b=FVEVSk1YUPv2LcjEFQZEpp8THYPwHXwr7LVDrXoC0b+dCeco/jtgtUKjPERkii8zk1
         EtQ3fi3J/Ev4M6cuzen/YaxYrDYeJbcnlK38MT1zIfTG83UXCNvRRTWFT17RcbGswFTF
         l3YAm6E0wQ40rpzjKmBZBFo4WGO7xPz6wzLA/4cnjRNpa+VOVvPPVmk7DZY2t+ias6Qz
         wJvd5YHyD3B5qhvurpaAvU/JP88vJDrs9GCZl89nDYfQVjwZ6lWI7hSyJhqaxw4IWiU9
         7Qrq+0BsGVu16FvxjdsaMSHfjlYsi//TO/XwAWtgQjVkEsHtW/eV+VIAdz6d71phrY6U
         lYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPqHMrarnj/eqlovwm4Ti2RJQ9+Z2LObwoWgr5fDQsE=;
        b=a8U3TaK4oxAkrNKcR70/Fp/+14vzWvvE6SnLkHy3y7C81M6RrEJU+zaLq8eUN8qXoJ
         eNVILBEr3fsq0PxiZqzckrwK2jjaHQ5pkRePkLe8W+XCVlrp/bKBH1w/jqsh8UVrAwjh
         1S3WrW9ozhvbt9c8qIDp2254YtATQ2xyVWvdExnYwFzGmpAkGXf4gsR6bilBxEATa6L4
         TTAkND4z2Ro9IlLILyTtsU/uM1/fLtpIujTCKS5Qx/MdN0eH4mJDAqCtp0xMi6kWXyh5
         dazL/WrhyOT6L07oLploamJSIOB9vobBarcnJ260xbi3H26KvKqWhUScDNrYHZqRmDKL
         hKkw==
X-Gm-Message-State: APjAAAWOwf1MmDycLxhcJUI7hODnAHamL0NFhVSZBkULAKx3LP8+5yC7
        Vr5fkma7uuB50+1SUsF61LkMeYFsgjA=
X-Google-Smtp-Source: APXvYqxDpHDxs7n7h8BKjdrh8ZwCDmLn9Y5ijtV3nD6Dt1wYdJ5euPS+BPQPSy3k15m8HiK5j1a8EA==
X-Received: by 2002:adf:f151:: with SMTP id y17mr12131506wro.244.1567889641587;
        Sat, 07 Sep 2019 13:54:01 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t123sm15236662wma.40.2019.09.07.13.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:54:01 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 0/3] net: devlink: move reload fail indication to devlink core and expose to user
Date:   Sat,  7 Sep 2019 22:53:57 +0200
Message-Id: <20190907205400.14589-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

First two patches are dependencies of the last one. That moves devlink
reload failure indication to the devlink code, so the drivers do not
have to track it themselves. Currently it is only mlxsw, but I will send
a follow-up patchset that introduces this in netdevsim too.

Jiri Pirko (3):
  mlx4: Split restart_one into two functions
  net: devlink: split reload op into two
  net: devlink: move reload fail indication to devlink core and expose
    to user

 drivers/net/ethernet/mellanox/mlx4/catas.c |  2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c  | 44 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h  |  3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c | 30 +++++++++------
 drivers/net/netdevsim/dev.c                | 13 +++++--
 include/net/devlink.h                      |  8 +++-
 include/uapi/linux/devlink.h               |  2 +
 net/core/devlink.c                         | 35 +++++++++++++++--
 8 files changed, 106 insertions(+), 31 deletions(-)

-- 
2.21.0

