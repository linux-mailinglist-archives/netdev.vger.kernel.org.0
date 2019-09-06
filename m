Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798D4ABD2F
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389006AbfIFQBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42595 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIFQBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id q14so7123817wrm.9
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=hIGu1XIP6vDks2Dg+hnXtHWINFCqxdZ2FZr7enmX1wE=;
        b=vAOIyDjZWDByE1eepEm0mM3cd/8GIBIUCfwwWP894V30VOtRIsNGiZ8swcC2ESIAVf
         fTZAz+IknHz7urmXAfLArXPvMDyOi3DZuuR9Xl9y2Ib+83fYgOKGX6ZIAqX01kKERiyo
         y1UPHEXYEzIy9ICvZLk2jGJsQjHpLIw056HzDgcNYBNqI4+N+yqu+dLP4LHXIdGj+40B
         6iD7ji2E+fkI6nlZdjC/p+DNKkbvLrzZQkVhXHPw7mqc/tERTOJCViB/2f6PY/L/q7U2
         nD9TP173eB9zxLqKmxGjKy/EZWGeBLuIlBHgPTqfuW5fagDU2who/EVZOiqO5QR4lPEY
         RSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hIGu1XIP6vDks2Dg+hnXtHWINFCqxdZ2FZr7enmX1wE=;
        b=gvj/cFAEttOIHa3+CC8+KwHG2RlSs+gLR32jSwfJ64rmW/EdYryIpapwtVtdhZdnDZ
         yfbYgy7lnwJ9pMrlhjJ0QGLAl+wszhBEWDVFroVGkJBuIq8IZnkmRCLDrYSpt+TylDN/
         BIvY/4318JQ0D8K7v0ll7Qk2edIAHvFVaxJtUmnmZBSrwNgBFvmn56JTvtcj3ZV/b2eT
         i3674gDQjiPycRQj+uYw7/Io4kpCxAdOkQNXQdvACX/u9e6tlgrVDUghG4ZxV187PNte
         2m9KoOjRBsiZKGY/wGAJI35aci2kgjxvn//WYa+glfoM7LAc6JG2owvLkA4vzwp957Au
         jZjw==
X-Gm-Message-State: APjAAAVze0lkqPXcr4PlX2s6eiIF5CpQYavP9+pFlKa+EywjGz57n3Yx
        lhEQL4RFy4fGp0c6GPV0+ljD8dboFDA=
X-Google-Smtp-Source: APXvYqxcVJgigZ4cXQGxkgDlgSpdqaHHp9B58y9q0cvTciLfnVX2/ofjW9i9Jgilfcp/Wv4+ay/hJA==
X-Received: by 2002:adf:f20f:: with SMTP id p15mr871243wro.17.1567785671560;
        Fri, 06 Sep 2019 09:01:11 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:10 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 00/11] nfp: implement firmware loading policy
Date:   Fri,  6 Sep 2019 18:00:50 +0200
Message-Id: <20190906160101.14866-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I am handling maintenance of the nfp diver in Jakub's absence while he is
on vacation this week and next, and I am sending this patchset in that
capacity.

Regarding the patches, Dirk says:

This series adds configuration capabilities to the firmware loading policy of
the NFP driver.

NFP firmware loading is controlled via three HWinfo keys which can be set per
device: 'abi_drv_reset', 'abi_drv_load_ifc' and 'app_fw_from_flash'.
Refer to patch #11 for more detail on how these control the firmware loading.

In order to configure the full extend of FW loading policy, a new devlink
parameter has been introduced, 'reset_dev_on_drv_probe', which controls if the
driver should reset the device when it's probed. This, inconjunction with the
existing 'fw_load_policy' (extended to include a 'disk' option) provides the
means to tweak the NFP HWinfo keys as required by users.

Patches 1 and 2 adds the devlink modifications and patches 3 through 9 adds the
support into the NFP driver. Furthermore, the last 2 patches are documentation
only.

Dirk van der Merwe (11):
  devlink: extend 'fw_load_policy' values
  devlink: add 'reset_dev_on_drv_probe' param
  nfp: nsp: add support for fw_loaded command
  nfp: nsp: add support for optional hwinfo lookup
  nfp: nsp: add support for hwinfo set operation
  nfp: honor FW reset and loading policies
  nfp: add devlink param infrastructure
  nfp: devlink: add 'fw_load_policy' support
  nfp: devlink: add 'reset_dev_on_drv_probe' support
  kdoc: fix nfp_fw_load documentation
  Documentation: nfp: add nfp driver specific notes

 .../networking/device_drivers/netronome/nfp.rst    | 133 +++++++++++
 Documentation/networking/devlink-params-nfp.txt    |   5 +
 Documentation/networking/devlink-params.txt        |  16 ++
 drivers/net/ethernet/netronome/nfp/Makefile        |   1 +
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 253 +++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_main.c      | 141 +++++++++---
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |   5 +
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |   7 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c   |  77 ++++++-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |  29 +++
 include/net/devlink.h                              |   4 +
 include/uapi/linux/devlink.h                       |   8 +
 net/core/devlink.c                                 |   5 +
 13 files changed, 654 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/netronome/nfp.rst
 create mode 100644 Documentation/networking/devlink-params-nfp.txt
 create mode 100644 drivers/net/ethernet/netronome/nfp/devlink_param.c

-- 
2.11.0

