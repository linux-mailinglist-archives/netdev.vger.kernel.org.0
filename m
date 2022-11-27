Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72357639ACE
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 14:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiK0NJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 08:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiK0NJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 08:09:51 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC701026;
        Sun, 27 Nov 2022 05:09:49 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso11580283pjt.0;
        Sun, 27 Nov 2022 05:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/nDh8TpKOaetZNm9H4kb5l3sJZ9fC/4skJvrnTVrPc=;
        b=A8rJC78DONtVFCjU8YfRzhf/A8tTYx/cYxKJfHXanN+ASW+iocYY9tOWjvpvel5RhW
         3jaaIhkLhABrzSdU7E5HbzW7UBKWAdKF7IIt/9Tnx+1E9D10jAxxLm6Gai74ho8jaaXy
         GQctii9VVE6lnI81Re32iQwHAmQbE2RBWEYLg0WA4YtbtGFDCuiFcDbcdKGrbMpU49I8
         cGq3VeOTvV/WzhcBpIrNhEq7Ubm2CgZ4EXa63sp2VL5+0hRvLSnzrC8PFLvlzfvLQPj9
         d3NFvD3/bpMOm84VwowrqAGhp+8qGy36vlM6vANwOHdS55la639OnFUJlYE0igne4Oqe
         nLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X/nDh8TpKOaetZNm9H4kb5l3sJZ9fC/4skJvrnTVrPc=;
        b=gIex8LvPPhy93oWXINIw06wrG+Zqepe0GykPBedENsoPjJ6vRp2TU/txH3C8XUJgbK
         htLuqNLz2KjpohRCDpMbYLYMFvPBWJh2+jR4ZWmsnYzGoQ65hM7vaJoqZGCQkgRhf5Va
         4uMC9velzoHYE8DvIHOKxJgvo2HnlFn4ZBZsxQecUhTBT+UQT3qrgm7m3MIKNp0r0Wsf
         5V6UuicisVsSSKn38w4Juk+gfS7jEkI9tk0Puqac2lzUXaIVXqV07hgCb3YjpcNKxT8e
         ceXsiHrCIvbokoNFRO51x7L96DbvIueOCB/INo3/weh/HVKYXa7quJAAPxATl33E2y8f
         bfnA==
X-Gm-Message-State: ANoB5pnDxdP+2+BFJR9gCjrLmzsCaooeT36gmWYFRHQN8dVEFCXNjK+c
        mPGZ+oEXG7S0IRGsD9zGYmFB33szZyWlyw==
X-Google-Smtp-Source: AA0mqf5LGLBzcqBZLh3aW85dV52JRwMwpCZdcwvop4vED2pFz+/wO3soofsqEh6DgkBBe9WvJRHdeQ==
X-Received: by 2002:a17:902:e886:b0:188:fb19:5f39 with SMTP id w6-20020a170902e88600b00188fb195f39mr30684526plg.21.1669554588631;
        Sun, 27 Nov 2022 05:09:48 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902eb9100b00188a908cbddsm6710225plg.302.2022.11.27.05.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 05:09:48 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH net-next v3 0/5] net: devlink: return the driver name in devlink_nl_info_fill
Date:   Sun, 27 Nov 2022 22:09:14 +0900
Message-Id: <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver name is available in device_driver::name. Right now,
drivers still have to report this piece of information themselves in
their devlink_ops::info_get callback function.

The goal of this series is to have the devlink core to report this
information instead of the drivers.

The first two patches clean up the mlxsw driver for both the ethtool
and the devlink (both are supposed to return the same information so
the ethtool got included as well). This is split in two patches
because of the different Fixes tag.

The third patch fulfills the actual goal of this series: modify
devlink core to report the driver name and clean-up all drivers. Both
as to be done in an atomic change to avoid attribute duplication.

The fourth patch removes the devlink_info_driver_name_put() function
to prevent future drivers from reporting the driver name themselves.

Finally, the fifth and last patch allows the core to call
devlink_nl_info_fill() even if the devlink_ops::info_get() callback is
NULL. This allows to do further more clean up in the drivers.
---
* Changelog *

v2 -> v3

  * [PATCH 3/5] remove the call to devlink_info_driver_name_put() in
    mlxsw driver as well (this was missing in v2, making the build
    fail... sorry for the noise).

  * add additional people in CC as pointed by netdev patchwork CI:
    https://patchwork.kernel.org/project/netdevbpf/list/?series=699451

  * Use the "Link:" prefix before URL to silence checkpatch's line
    length warning.

RFC v1 -> v2

  * drop the RFC tag

  * big rework following the discussion on RFC:
    https://lore.kernel.org/netdev/20221122154934.13937-1-mailhol.vincent@wanadoo.fr/
    Went from one patch to a series of five patches:

  * drop the idea to report the USB serial number following Greg's
    comment:
    https://lore.kernel.org/linux-usb/Y3+VfNdt%2FK7UtRcw@kroah.com/

Vincent Mailhol (5):
  mlxsw: minimal: fix mlxsw_m_module_get_drvinfo() to correctly report
    driver name
  mlxsw: core: fix mlxsw_devlink_info_get() to correctly report driver
    name
  net: devlink: let the core report the driver name instead of the
    drivers
  net: devlink: remove devlink_info_driver_name_put()
  net: devlink: make the devlink_ops::info_get() callback optional

 .../marvell/octeontx2/otx2_cpt_devlink.c      |  4 ---
 drivers/net/dsa/hirschmann/hellcreek.c        |  5 ---
 drivers/net/dsa/mv88e6xxx/devlink.c           |  5 ---
 drivers/net/dsa/sja1105/sja1105_devlink.c     | 12 ++-----
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |  4 ---
 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 11 +-----
 .../ethernet/fungible/funeth/funeth_devlink.c |  7 ----
 .../hisilicon/hns3/hns3pf/hclge_devlink.c     |  5 ---
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |  5 ---
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  6 ----
 .../marvell/octeontx2/af/rvu_devlink.c        |  7 ----
 .../marvell/octeontx2/nic/otx2_devlink.c      | 15 --------
 .../marvell/prestera/prestera_devlink.c       |  5 ---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 ---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  5 ---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  2 +-
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  4 ---
 .../ethernet/pensando/ionic/ionic_devlink.c   |  4 ---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c |  4 ---
 drivers/net/netdevsim/dev.c                   |  3 --
 drivers/ptp/ptp_ocp.c                         |  4 ---
 include/net/devlink.h                         |  2 --
 net/core/devlink.c                            | 35 ++++++++++++-------
 23 files changed, 27 insertions(+), 131 deletions(-)

-- 
2.37.4

