Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3EA56566B1
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 03:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiL0CZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 21:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiL0CZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 21:25:38 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328762707
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:37 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gv5-20020a17090b11c500b00223f01c73c3so13400961pjb.0
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 18:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XVIHb2xUd8sujupspgAGNpJyN016wzYVPc2YpZ2bDag=;
        b=R7ffvjAvcrMZ1p1LMq+Euj4OlP/yRK1ztz7vAX2mfWZWhLy4PKsT3r/kZpWE/KmBW8
         maRBuG+idbhR+rPlrNYg6m/KIUBBeIiRdWAHBURPpw5pUMX91PKiIOQccdwuVyH4q+Ml
         6ASi7GlNpP43gmoUHjJI4V3NFPlkslPkD5Cz6UBuNwjvUlQ1G/K4L9ZLvq52lMix9WkY
         OUcgrLgcnRiUM6cAiL4n7VLLFeWFn9MOVo/8H6PJgYat7bIGpdd/wOgkYPMUh8g/DxgQ
         MU2sirbyrMZeyH88qpXiYAtSh7EzDwFJwE7Y/TVUcS1n5+wW7Y7jddzCrcvUAU1l7nl/
         KtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVIHb2xUd8sujupspgAGNpJyN016wzYVPc2YpZ2bDag=;
        b=i1bTxL7Phr6NVz8rkkJTrdTWpmoTEKPtBM1u6OnM0lHWDn8l+XHayg2GqSvy/PfAcJ
         ETUzcn2JJA8zmlBFpfertWzHOOBRQyFuTLSeERHWNQb7C8Igo4atM30e0hy/fXyUtADQ
         LNV+lr4rbrEn5i3QTp0UUD/5fs9HZIwcCzzg7nO7f2CrCouYefV/w5mEjVDX64Y0lmYT
         TMSK7ogL6usk42OtB7UXkoue54SlaJjt10BX1xZlHDQz372AQxJzB5/YLTQgI0rsiZ7M
         HoelunkOC1vxx++Sdgs1GzFXNbLNOcIQbCUGnmQamBT1yfVPxoFud+co5PkuoErLRK8l
         XpvA==
X-Gm-Message-State: AFqh2ko0A2csRp6k6++7hhu/Ass1u6iccMWEV4ZczGADw0FDNiEypl+L
        0GDRCsaRJLPK2OCFru1yGxHgcsS3a2oU/Jq9tHc=
X-Google-Smtp-Source: AMrXdXuKZS1Ph/IY6Bb5WWpBVaf6Yu1Vdz30CYa7Nf5FAmFaa4UtKH4qrnegeQAYBuEW0rq2BEA3bg==
X-Received: by 2002:a17:902:b418:b0:191:1fc4:5c14 with SMTP id x24-20020a170902b41800b001911fc45c14mr20844566plr.49.1672107936658;
        Mon, 26 Dec 2022 18:25:36 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b001870dc3b4c0sm2465014plk.74.2022.12.26.18.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 18:25:36 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH 0/6] Introduce a vringh accessor for IO memory
Date:   Tue, 27 Dec 2022 11:25:22 +0900
Message-Id: <20221227022528.609839-1-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vringh is a host-side implementation of virtio rings, and supports the
vring located on three kinds of memories, userspace, kernel space and a
space translated iotlb.

The goal of this patchset is to refactor vringh and introduce a new vringh
accessor for the vring located on the io memory region. The io memory
accessor (iomem) is used by a driver that is not published yet, but I'm
planning to publish it. Drivers affected by these changes are not included
in this patchset. e.g. caif_virtio and vdpa (sim_net, sim_blk and net/mlx5)
drivers.

This patchset can separate into 3 parts:
1. Fix and prepare some code related vringh [1, 2, 3/6]
2. Unify the vringh APIs and change related [4, 5/6]
3. Support IOMEM to vringh [6/6]

This first part is preparation for the second part which has a little fix
and changes. A test code for vringh named vringh_test is also updated along
with the changes. In the second part, unify the vringh API for each
accessors that are user, kern and iotlb. The main point is struct
vringh_ops that fill the gap between all accessors. The final part
introduces an iomem support to vringh according to the unified API in the
second part.

Those changes are tested for the user accessor using vringh_test and kern
and iomem using a non published driver, but I think I can add a link to a
patchset for the driver in the next version of this patchset.

Shunsuke Mie (6):
  vringh: fix a typo in comments for vringh_kiov
  vringh: remove vringh_iov and unite to vringh_kiov
  tools/virtio: convert to new vringh user APIs
  vringh: unify the APIs for all accessors
  tools/virtio: convert to use new unified vringh APIs
  vringh: IOMEM support

 drivers/vhost/Kconfig      |   6 +
 drivers/vhost/vringh.c     | 721 ++++++++++++-------------------------
 include/linux/vringh.h     | 147 +++-----
 tools/virtio/vringh_test.c | 123 ++++---
 4 files changed, 356 insertions(+), 641 deletions(-)

--
2.25.1

