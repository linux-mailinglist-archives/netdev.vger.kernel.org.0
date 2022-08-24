Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DF959F9B3
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbiHXMUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbiHXMUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:20:17 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4287B17599
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:14 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s11so21771440edd.13
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=as/DBDyPSp38EsQ46bVyfleo5TGvITeND6lX4+LND8M=;
        b=SUI24Bs5PCYa+W26BU/5ayAk1p8dQnoBch2fiTA7g+CqOgwoII3Jo+E3lzRwLi0kHu
         s5CoqK9SEADxcZ4Th5bR3TbDWk5PCxOoSwZPAH9vWJ+vyyQXNnMIbmJd5IAxxp7F59Np
         mbrOszjLI0gCFK7pQxrlJrhSc9+JPA42bH095kBO4P8gEjaGFwU92VcPdPxlWAdrAn9L
         sKV5tswdR/aQnTxDwBFe07R7xk1iG70wGHPAbobC6Dls3zcfCNszfXFjCYPL+AlHRR3f
         dK4+wFkMn4nwQz2pGKsRgF4XeXTPy33T3/1scUi577AE11f2SykI/eLZ2IkWR7Whf+AN
         +11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=as/DBDyPSp38EsQ46bVyfleo5TGvITeND6lX4+LND8M=;
        b=WOI0KVhmNaAFiGEU+GXp59lBJiGjaZba4ey3rlcXMdizgHELvyt/u9eoA0aFMBorsm
         1Cw23Yvi0xNftTvE5aZqKH11Uqz1gxSj/ZvqDLapUXFF2/u5qgsk63KLoa0kJqXwu/1J
         4cNaJ+k6RBLPFkT8mgcA6nLSFyvGT5Cn1z8E+ZiqupZqBGwgTpi54ovTB6Bq2y7Z9qx9
         lbNPC/fCdBQ+qkaJ3KWdhkmDAZYxWUBFP3kUX2itm6zuwrW8XZhBNsGjdcPd9CQ6O/hb
         +P7ZIhD+1AxQAoQvQJbybWfhnqRE1YP6kDGNO0oCIK78ZyJVd5AnMCjf9e4LPpMbZCXU
         LKQA==
X-Gm-Message-State: ACgBeo3URj5BM7iy4B+8TRay85LVojx2B2rO5yT82imMT8DXST7Xt0Rm
        DVtyich+0rhSCqdIHcP6LcJbhIcEjoWlfEQM
X-Google-Smtp-Source: AA6agR7vV6nkWOcIdh8MEIp0lOxE5gr5FLD3MS+foceXuMEQlBF2Vau2lg3gQ/ZRMBQiYiciLRiP9Q==
X-Received: by 2002:aa7:dc10:0:b0:440:b446:c0cc with SMTP id b16-20020aa7dc10000000b00440b446c0ccmr7345671edu.34.1661343612857;
        Wed, 24 Aug 2022 05:20:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g21-20020a50ec15000000b0043ba7df7a42sm2978486edr.26.2022.08.24.05.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:20:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next v3 0/3] net: devlink: sync flash and dev info commands
Date:   Wed, 24 Aug 2022 14:20:08 +0200
Message-Id: <20220824122011.1204330-1-jiri@resnulli.us>
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

Example:
$ devlink dev info
netdevsim/netdevsim10:
  driver netdevsim
  versions:
      running:
        fw.mgmt 10.20.30
      stored:
        fw.mgmt 10.20.30
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
v2->v3:
- see changelog of individual patches
- dropped patch to expose if version represents a component over netlink
v1->v2:
- see changelog of individual patches, no code changes, just split patch
- removed patches that exposed "default flash target"

Jiri Pirko (3):
  net: devlink: extend info_get() version put to indicate a flash
    component
  netdevsim: add version fw.mgmt info info_get() and mark as a component
  net: devlink: limit flash component name to match version returned by
    info_get()

 drivers/net/netdevsim/dev.c |  15 +++-
 include/net/devlink.h       |  19 ++++-
 net/core/devlink.c          | 139 ++++++++++++++++++++++++++++++------
 3 files changed, 147 insertions(+), 26 deletions(-)

-- 
2.37.1

