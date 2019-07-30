Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61CD7A374
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbfG3I5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:57:37 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33593 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbfG3I5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:57:36 -0400
Received: by mail-wr1-f43.google.com with SMTP id n9so64949506wru.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 01:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ruq9jWSBqFF1Bm8YIiJHeKq1YuaeLx6T8l0d2YYEbrY=;
        b=M5kj1lhWzYbVeTlTPBDxrnsc9R13QtE5jyUkEJa/n4nXdgB8toMwdWhQL1Ew4qS7Rd
         d8T2ApilKz1k92wk3mvOX5kf8DYLftO9QHU94VlOlet2kixvRFvnwNfqKK85UIclGjG4
         ojcUcpzODjxFXb9ndFl9eMy+ulHDj3ZQVax+Jjzv8IKB4I+fChdgKiFyBpTHPqXUgMsC
         vvxT7T9HOOyfSIYfUzxU1LPfDNlcFV/WNX1G/u5j2VOmUetqOj6rWigLo7g6Foeq2fQQ
         ofsztS4eiJNehsWGQAJQaJpiGnkNWUd30THBaEm5iEtLSwfcaRv0nWyBYrbJiyeWJdO3
         g44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ruq9jWSBqFF1Bm8YIiJHeKq1YuaeLx6T8l0d2YYEbrY=;
        b=ioutU07dqkgz3UiYKZ1URSNx9iUyutyzssAfE0xqyRxDaP31/CGhyg8pI/wM2bFdVc
         82av9bc1YEbiz5GnEZzcl46UhoA2Y5q8AeAD10/pvzDuwBtf1JC/xpQfvQ6mMZz/ll5p
         kkYKmWghyQfnmiRLsk44eAAg8T0ObcP88WhFQ0IdyMijLvSSAfwSARscIFG9isUqoFZ7
         S8+YHYLOndYQOxtWX8dXYyFcZDy3E0PEkaOe/xgLYA9CWgBRRBRYcXyjAu30ExqtokIG
         KtV3TKRbrCYzAAH5vxbz/1Z8U5+1QylrVkwFoE2NjtdDvpQo5Ww/P3+2twt7z4+BHsfa
         CqvA==
X-Gm-Message-State: APjAAAW74/W9PNnN3K1YsGxqblgg8pvN+yWFCUVHVMLQZDjgo2WK234r
        UpoffIqGn4wuY4IiJe/hRJlK11ef
X-Google-Smtp-Source: APXvYqzu4rHOiEbqGLO0veQ4LqmSFLOEH8N7XUD4p0DKJCb4KiBoPRFxLuyIdV1d6+FrYMvn6/5xEw==
X-Received: by 2002:adf:df0f:: with SMTP id y15mr48058900wrl.155.1564477055348;
        Tue, 30 Jul 2019 01:57:35 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id x83sm70414059wmb.42.2019.07.30.01.57.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 01:57:34 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v2 0/3] net: devlink: Finish network namespace support
Date:   Tue, 30 Jul 2019 10:57:31 +0200
Message-Id: <20190730085734.31504-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Devlink from the beginning counts with network namespaces, but the
instances has been fixed to init_net. The first patch allows user
to move existing devlink instances into namespaces:

$ devlink dev
netdevsim/netdevsim1
$ ip netns add ns1
$ devlink dev set netdevsim/netdevsim1 netns ns1
$ devlink -N ns1 dev
netdevsim/netdevsim1

The last patch allows user to create new netdevsim instance directly
inside network namespace of a caller.

Jiri Pirko (3):
  net: devlink: allow to change namespaces
  net: devlink: export devlink net set/get helpers
  netdevsim: create devlink and netdev instances in namespace

 drivers/net/netdevsim/bus.c       |   1 +
 drivers/net/netdevsim/dev.c       |  17 ++--
 drivers/net/netdevsim/netdev.c    |   4 +-
 drivers/net/netdevsim/netdevsim.h |   8 +-
 include/net/devlink.h             |   3 +
 include/uapi/linux/devlink.h      |   4 +
 net/core/devlink.c                | 129 ++++++++++++++++++++++++++++--
 7 files changed, 152 insertions(+), 14 deletions(-)

-- 
2.21.0

