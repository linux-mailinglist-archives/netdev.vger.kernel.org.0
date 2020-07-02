Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F96211723
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgGBA1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:27:47 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47362 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgGBA1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:27:47 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 538508011F;
        Thu,  2 Jul 2020 12:27:43 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593649663;
        bh=YdM9YF2EcbZTi6gnnTTQZixLrf4289RQU1kl1CHLDAI=;
        h=From:To:Cc:Subject:Date;
        b=P2zFwDBl3e3FfSCZjosAgsZFKPcn2JRS4SFPYqutyDvPIyHnzYP/HlReJQoewHHp3
         bdUkbX+DybCaTVfrAxGhS52T5/U8tQuGHjC55bKNUwq/moEgwJ9bxPUELmvhygpoHJ
         8r/6T2ApLbDXLyNk2nhEuNnr5qd9x51/WKcwIwT7tTmb9PT9r9KEHjqxNNZer5aWrv
         mZfR7wxb9QAwk4zYFk+rjmG9xd563pIKtDRLkH8ykMU2rBHvfckGBpin6FXjDl0BQm
         +aojR9sMhht+VoMB3MggJvgtherskd+ssNAmewt80ADc93SbAyVi8py7z82QzrxOnj
         MNemXZnyn7OpQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5efd29fc0000>; Thu, 02 Jul 2020 12:27:43 +1200
Received: from mattb-dl.ws.atlnz.lc (mattb-dl.ws.atlnz.lc [10.33.25.34])
        by smtp (Postfix) with ESMTP id 9DBBA13EDDC;
        Thu,  2 Jul 2020 12:27:38 +1200 (NZST)
Received: by mattb-dl.ws.atlnz.lc (Postfix, from userid 1672)
        id 2599F4A02A3; Thu,  2 Jul 2020 12:27:40 +1200 (NZST)
From:   Matt Bennett <matt.bennett@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     zbr@ioremap.net, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org,
        Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Subject: [PATCH 0/5] RFC: connector: Add network namespace awareness
Date:   Thu,  2 Jul 2020 12:26:30 +1200
Message-Id: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously the connector functionality could only be used by processes ru=
nning in the
default network namespace. This meant that any process that uses the conn=
ector functionality
could not operate correctly when run inside a container. This is a draft =
patch series that
attempts to now allow this functionality outside of the default network n=
amespace.

I see this has been discussed previously [1], but am not sure how my chan=
ges relate to all
of the topics discussed there and/or if there are any unintended side eff=
ects from my draft
changes.

Thanks.

[1] https://marc.info/?l=3Dlinux-kernel&m=3D150806196728365&w=3D2

Matt Bennett (5):
  connector: Use task pid helpers
  connector: Use 'current_user_ns' function
  connector: Ensure callback entry is released
  connector: Prepare for supporting multiple namespaces
  connector: Create connector per namespace

 Documentation/driver-api/connector.rst |   6 +-
 drivers/connector/cn_proc.c            | 110 +++++++-------
 drivers/connector/cn_queue.c           |   9 +-
 drivers/connector/connector.c          | 192 ++++++++++++++++++++-----
 drivers/hv/hv_fcopy.c                  |   1 +
 drivers/hv/hv_utils_transport.c        |   6 +-
 drivers/md/dm-log-userspace-transfer.c |   6 +-
 drivers/video/fbdev/uvesafb.c          |   8 +-
 drivers/w1/w1_netlink.c                |  19 +--
 include/linux/connector.h              |  38 +++--
 include/net/net_namespace.h            |   4 +
 kernel/exit.c                          |   2 +-
 samples/connector/cn_test.c            |   6 +-
 13 files changed, 286 insertions(+), 121 deletions(-)

--=20
2.27.0

