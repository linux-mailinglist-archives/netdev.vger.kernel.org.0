Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCA3628D7F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiKNXf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiKNXf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:35:27 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7C7B488
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:35:25 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-36ba0287319so118352477b3.3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P1rE+d/0JJ1awuHy2qdYntlXVatZIcarxF1REXrHe74=;
        b=WUXTLih+TRlEkDR/eW4NFqzJbwI6MJsa8pu+57Wk/33DDmcxUT2sSuCCERtv8gnaEz
         ohlvVCmywW99T7BsraCTv8QfwwOznYPzr7hC0JOdGGtSQHdOr5/3cpB9bkG09eUi4wlR
         Zj760v9WZtW6E6Fz2ighM8dNq18q/qAxOpLjLbpKcjJWIK5UbAZ/UI3TMjc3fo/HaQQ4
         +LZa7xS/KxVbElUwH0899y7NZOO0etOTJKNRqF6zy45X7RMOzHHQjEKhB6z5+Owmca8v
         Mc3D5P+B9uc9ziaV1JgNkrm068Rg+U4IzKujpnwrBo0ml+GgMr8Tf0mLfulbe2PaNI9I
         do3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P1rE+d/0JJ1awuHy2qdYntlXVatZIcarxF1REXrHe74=;
        b=7FjoMTdI2vDwRbvUOm6fKcvPkAvEPVVTClywQJsMLS4/eusLCZjzPlLtez/47Y5bAg
         utSM5+lz1DoV8rVukDg6q7VBAfsMJFbUs9+1ccYBKn37fk5bFjiZ/rPuNg3BzTdRof1Q
         HGqlYv3pz4Crq5ZuwwFmFh4UBHJrb/hzwz1Cjoy6vSYgsy4mTuWCV7WDvcFEgYyu/u8b
         SNtbwEH/TJ8wYaCzc0ukX158pGfC2GvLOBgtCm2T5vCa6tgWJD4d5xiEOLyegdEWOFpM
         zbBZYm/SvSyzq7yBh3YU0nPMzvj9tS6pRNubota4S9BENAjKwusFT40RUUVPkEVRLzxh
         RhHA==
X-Gm-Message-State: ANoB5pkXC8Lji1AEwy6dVAJB/JAl+TUSakLrLPy48IS6Tq5noZQV94lR
        m8nDGLNB+Y5AL/aPqc1RblKsX8bxv0GyQJ+4L40y8OyZDmHR3vg7EyoiN7HPBh74vZnKhTIqT1f
        JwVdY/kQwOWj/fCXYzdLWMjh04S3TkpuUYxcJc47CvEUwSSLwkaE7OkNBzTLOmzCNBw4=
X-Google-Smtp-Source: AA0mqf7UUhDvLVyzqwZsAAnNIKTH/Ca86VIuldiUpSx6mhA5OEHmUMqaiNZ4/Z+jyV0yRctootIoPvF0TeGOTQ==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a25:8681:0:b0:6d0:1874:5dbe with SMTP id
 z1-20020a258681000000b006d018745dbemr14100372ybk.46.1668468924992; Mon, 14
 Nov 2022 15:35:24 -0800 (PST)
Date:   Mon, 14 Nov 2022 15:35:12 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221114233514.1913116-1-jeroendb@google.com>
Subject: [PATCH net-next v3 0/2] gve: Handle alternate miss-completions
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some versions of the virtual NIC present miss-completions in
an alternative way. Let the diver handle these alternate completions
and announce this capability to the device.

Changed in v3:
- Rewording cover letter
- Added 'Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>'
Changes in v2:
- Changed the subject to include 'gve:'


Jeroen de Borst (2):
  gve: Adding a new AdminQ command to verify driver
  gve: Handle alternate miss completions

 drivers/net/ethernet/google/gve/gve.h         |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c  | 19 +++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  | 51 ++++++++++++++++++
 .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++
 drivers/net/ethernet/google/gve/gve_main.c    | 52 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 18 ++++---
 6 files changed, 140 insertions(+), 6 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

