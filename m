Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1237959C48C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbiHVRC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiHVRCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:02:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3C341D28
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:50 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gb36so22455473ejc.10
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=WacKXTgILaj0m9KISmSC0R/8U9HsNtE9F1CqWnch96o=;
        b=vOHTpzWiKen4sQCEVa5AzWTzknXxO86QNNVLIzdq3uScB+KNoI+w8CwcfPi/D7scPi
         ShI8SaYhrCbhvMpMuvauCGmYGi93Y3rlFOaI0TJEn28JsIYgLYs8eEAvr5GVUgJq3ROK
         IONAQuyyUOn2djIr9Q8QspkqKv+yNDCw132hunzT+YT9uxGEm8BMZcNrPVQyNfPMO28q
         Jl8AB1IJZRLOWbP3sG6K3cdc48YSoBo58jaI35zyiD6+lrnOTIv//O5r2m58MfkJg9TG
         Znx5yda28o56nEDzXVdpy2/Xz7KpisPNP2ziIh58b4Y+5ONbpp/TBKvh5s0cYT+jqktY
         ge7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=WacKXTgILaj0m9KISmSC0R/8U9HsNtE9F1CqWnch96o=;
        b=MR/06Z3r8qUW8EKW8+klV//lnOrE7gfGLWHX0EFex1LwiCiPz6Dpj5kuC03NgUP94U
         d9AZXT/dTigSI7Z8kz0smJqA+9VtKjoYWy1wbchkKqQovg/owhTcImlullzYL7y3UCI/
         fR41r7RLV6EPRQWAE/lM83fMOThFPkR7o3i9mqrM2AAGuktEGzjvdcrqKoWZQherWDE8
         6zTDtCV8tNCg0vMBtyuH5Fc3bTEHLaqp854P8XAlqSxSzSwr8F5BrergKSGySNDSxNmL
         K79WEAN22w4ELjDE9s5z7zeDszY8WYsrMCxgusWuGszjfCdfIoDanRqvPUqxUATiuyol
         c98g==
X-Gm-Message-State: ACgBeo0fdx5vVKe2MS19Zq7aSjfWaKh+0Wx+6rm3XKvnNr2ICBiHlsIF
        KCFn9uG+0pb2e7s2Evh81CLnC3zha2jm83RD
X-Google-Smtp-Source: AA6agR4lyFTzuBDAYzz2eWfFGl7VC66N4JTmunTHOG5enwmlzXCY3jhCGJJBfOhS9ZG0sEUvmqJb8Q==
X-Received: by 2002:a17:906:5d04:b0:722:f46c:b891 with SMTP id g4-20020a1709065d0400b00722f46cb891mr13695282ejt.4.1661187768678;
        Mon, 22 Aug 2022 10:02:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f19-20020a17090631d300b0073d05a03347sm5111152ejf.89.2022.08.22.10.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 10:02:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v2 0/4] net: devlink: sync flash and dev info commands
Date:   Mon, 22 Aug 2022 19:02:43 +0200
Message-Id: <20220822170247.974743-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Purpose of this patchset is to introduce consistency between two devlink
commands:
  devlink dev info
    Shows versions of running default flash target and components.
  devlink dev flash
    Flashes default flash target or component name (if specified
    on cmdline).

Currently it is up to the driver what versions to expose and what flash
update component names to accept. This is inconsistent. Thankfully, only
netdevsim currently using components so it is still time
to sanitize this.

This patchset makes sure, that devlink.c calls into driver for
component flash update only in case the driver exposes the same version
name.

Also there a new flag exposed to the use over netlink for versions.
If driver considers the version represents flashable component,
DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT is set. This provides a list of
component names for the user.

Example:
$ devlink dev info
netdevsim/netdevsim10:
  driver netdevsim
  versions:
      running:
        fw.mgmt 10.20.30
        fw 11.22.33
      flash_components:
        fw.mgmt
$ devlink dev flash netdevsim/netdevsim10 file somefile.bin
[fw.mgmt] Preparing to flash
[fw.mgmt] Flashing 100%
[fw.mgmt] Flash select
[fw.mgmt] Flashing done
$ devlink dev flash netdevsim/netdevsim10 file somefile.bin component fw.mgmt
[fw.mgmt] Preparing to flash
[fw.mgmt] Flashing 100%
[fw.mgmt] Flash select
[fw.mgmt] Flashing done
$ devlink dev flash netdevsim/netdevsim10 file somefile.bin component dummy
Error: selected component is not supported by this device.

---
v1->v2:
- see changelog of individual patches, no code changes, just split patch
- removed patches that exposed "default flash target"

Jiri Pirko (4):
  net: devlink: extend info_get() version put to indicate a flash
    component
  netdevsim: add version fw.mgmt info info_get() and mark as a component
  net: devlink: limit flash component name to match version returned by
    info_get()
  net: devlink: expose the info about version representing a component

 drivers/net/netdevsim/dev.c  |  12 +++-
 include/net/devlink.h        |  15 +++-
 include/uapi/linux/devlink.h |   2 +
 net/core/devlink.c           | 133 +++++++++++++++++++++++++++++------
 4 files changed, 136 insertions(+), 26 deletions(-)

-- 
2.37.1

