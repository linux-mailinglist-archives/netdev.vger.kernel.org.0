Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7749B7F9C2
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394908AbfHBN3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:29:31 -0400
Received: from correo.us.es ([193.147.175.20]:41444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388448AbfHBN3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:29:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA9E5FB44E
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 15:29:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C87721150CE
        for <netdev@vger.kernel.org>; Fri,  2 Aug 2019 15:29:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B5A1064499; Fri,  2 Aug 2019 15:29:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2F1F6E7A0;
        Fri,  2 Aug 2019 15:29:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 02 Aug 2019 15:29:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.181.192])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0C9944265A31;
        Fri,  2 Aug 2019 15:29:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com, wenxu@ucloud.cn,
        gerlitz.or@gmail.com, paulb@mellanox.com
Subject: [PATCH net-next 0/3,v2] flow_offload hardware priority fixes
Date:   Fri,  2 Aug 2019 15:28:43 +0200
Message-Id: <20190802132846.3067-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset contains three updates for the flow_offload users:

1) Pass major tc priority to drivers so they do not have to
   lshift it. This is a preparation patch for the fix coming in
   patch 3/3.

2) Add a new structure to basechain objects to wrap the offload
   data. This is another preparation patch for the fix coming in
   patch 3/3.

3) Allocate priority field per rule from the commit path and
   pass it on to drivers. Currently this is set to zero and
   some drivers bail out with it, start by priority number 1
   and allocate new priority from there on. The priority field
   is limited to 8-bits at this stage for simplicity.

v2: address Jakub comments to not use the netfilter basechain
    priority for this mapping.

Please, apply, thank you.

Pablo Neira Ayuso (3):
  net: sched: use major priority number as hardware priority
  netfilter: nf_tables_offload: add offload field to basechain
  filter: nf_tables_offload: set priority field for rules

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          | 12 ++------
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  2 +-
 include/net/netfilter/nf_tables.h                  | 14 ++++++---
 include/net/netfilter/nf_tables_offload.h          |  6 ++++
 include/net/pkt_cls.h                              |  2 +-
 net/netfilter/nf_tables_api.c                      |  2 +-
 net/netfilter/nf_tables_offload.c                  | 34 +++++++++++++++++-----
 10 files changed, 51 insertions(+), 27 deletions(-)

-- 
2.11.0

