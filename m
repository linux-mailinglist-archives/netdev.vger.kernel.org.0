Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FFD8A002
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfHLNrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:47:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50949 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfHLNry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:47:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so12237155wml.0
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 06:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QAjMgeKnz+SgYJrFd3pOMZnf4efao7w8cysFaM8Pc2s=;
        b=Z/4Fztyko9fNblVdE4NaOoSEMuW7BpxyEk146ppmzKtCiG19QwAy+0p8OxpZbZRXti
         g5h0sKdZgNHa9D8BJWqqFGzsMQUuqdw7ohjhgPt1LxOuzJstr5NG9UnbseFJQg0CM8UR
         Ay2COqrz4q0LdzhbhhYLrph9IJOgAss6dKt3WJ7G1fP1GV6+CDHcQbRa0jn95HXjKj4C
         3dI88WvT76wgMp8r/zy07b7MyJct/0tcoCT6QMa9R5G9e4XbqltigUDpv0R+vOZldFvL
         J5E8oPOd60tLcZ/f30qnOnlZpQZIZCSwy7pX5swb7evz2rv8Iy5aTbvvZeewp6Q7c49e
         u2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QAjMgeKnz+SgYJrFd3pOMZnf4efao7w8cysFaM8Pc2s=;
        b=egNmaNuagC07oYuTVknzkdJPGlASvlde4UjmAJrfchcUzmbKFOsriWMkIQ6cjRYFEa
         y+zyIFtTKZz63e4yjbDMIIEh6LJaHpNIu0QWiFbENW+kk1Q3VB74OV0eGXBLpb4JC6gt
         yH68iNGeO00TmvTAmTmfTzAPDSmoV8yGlWrBAOQeVrvjKIlGRyFp3eBXKQYeHMWJPWDn
         r83ZYPktZ7K/sGQj1qlQCYhQoWPMMlBgfnko3c3jxXyNN8WZoTQXKH4QhHibjAdTpvh+
         AQn/gJIvsvRigw8XrcQQr9YHjUy42nNJ51QCcI5gUNE0fLO/hIfl2KXDXgDPCP7hiGZF
         wmMw==
X-Gm-Message-State: APjAAAXYfmJgiKwxHUZeIR8A0XPs3//EV17zltU5sUXk+ic/xieWN6lO
        fnjvEYFjYuiZOreljXuiEKDtbvoYS+I=
X-Google-Smtp-Source: APXvYqxv+gNdnelqivipKut83jpxZpA4rOYFWEgQbfQ9RO+dCVso9oQEDgiYr/JHHhf7VtRhYdY8mw==
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr27566532wmh.100.1565617672573;
        Mon, 12 Aug 2019 06:47:52 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id a17sm8444275wmm.47.2019.08.12.06.47.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:47:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v3 0/3] net: devlink: Finish network namespace support
Date:   Mon, 12 Aug 2019 15:47:48 +0200
Message-Id: <20190812134751.30838-1-jiri@resnulli.us>
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
 drivers/net/netdevsim/dev.c       |  17 ++-
 drivers/net/netdevsim/netdev.c    |   4 +-
 drivers/net/netdevsim/netdevsim.h |   8 +-
 include/net/devlink.h             |   3 +
 include/uapi/linux/devlink.h      |   4 +
 net/core/devlink.c                | 182 +++++++++++++++++++++++++++++-
 7 files changed, 205 insertions(+), 14 deletions(-)

-- 
2.21.0

