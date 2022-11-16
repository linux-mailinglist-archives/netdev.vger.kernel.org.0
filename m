Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F05462C777
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiKPSRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239163AbiKPSRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:17:31 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1001063B98
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:17:29 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x11-20020a056a000bcb00b0056c6ec11eefso10218098pfu.14
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 10:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VMwPEFrt7ea3bvb3EzfSrD2jHVFJpV/Y0eShB9jO2zQ=;
        b=MpTpwQpKHZNiObi76Q0Ew9i3fVZRmBhvSQZrRRRx71pHCW7L3BHuOU4pvz+9CBohg9
         0K+HRu5ToVvmDtOdPnkUZn6d3tfZPXelsz6mWM0zeztgCHcpu3nLyNHwwHg6IFeyPZwG
         PMs9aIC1/Nm2Uem6AIJtAVGC1WMHLs/6CGNY0CNKfPTEXE8TjJY2gJVWeHr9UuTSNqZ/
         QC7g23ao2GnEcrY/1Awsai+MyWJ5RBMLpjVHKVJit0jaGcgO8SxgpOaV5zfnRRvoFFWL
         FmVL1tH/KyPh6l2dUncd+6UKu3ZsMg9PaCvTlkFjhqBKv0rbZb5EdAYwgfSDSJqZkJQL
         UGCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VMwPEFrt7ea3bvb3EzfSrD2jHVFJpV/Y0eShB9jO2zQ=;
        b=hSk116c5uK7lpBbMAAiZ/fBN26fbxYAKg05750AROm1eLfjZdYwh0ajHVNKhjN0BaW
         xaoIq1m9cXyKXQGretGLkavp2eHCgrHz/1zI8ceJg575QumCg+zlQJQE4YupATcXPoFe
         B62rs+3eq6q8t7vgfDLEmCdggiPtT1+pB5u4OzaPv8eke7/5+i/5m7DczNjeFx7hJnax
         +hlcDNlqSOLSzD2e0vAEOZFKHrmTIbLpPWa9L0tZNkbnbUJ4NiokOiB+yBir5rFZtJl6
         I0ibZynvGgj6cvPO+3uKhBtlUJhMZlbhXSFWJyCezJQPkzxJqi44DFECWH1jwoVNgGjr
         9aSA==
X-Gm-Message-State: ANoB5plvquX2zJYvuSqgSrb/Qcz0XcFa3hVY2x6KKE3W8QxLr+IOksLG
        S4C2cH8dI5laW9bD04G2mbgVHX1EFinsFxvfamPYCABKOhQPK65zIpfGnarJjziUqgWdjWe6ZVc
        OIqa2y0PVypJPWNnov2FgaMm4z/jh6r/8+/3M81JizstHIr0liq7QNT36BGvS4IguPDk=
X-Google-Smtp-Source: AA0mqf5ZJSe33U295TTh/uhDMUi9tld9Qvx1CSrxtQ6a14q5s2QbdT69XURCLed3nNN4ld8ieDe8Gdo4FC+i9w==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:131e:f4f:919b:71c5])
 (user=jeroendb job=sendgmr) by 2002:a05:6a00:15d2:b0:563:1231:1da with SMTP
 id o18-20020a056a0015d200b00563123101damr24812674pfu.5.1668622648448; Wed, 16
 Nov 2022 10:17:28 -0800 (PST)
Date:   Wed, 16 Nov 2022 10:17:23 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221116181725.2207544-1-jeroendb@google.com>
Subject: [PATCH net-next v4 0/2] Handle alternate miss-completions
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

The capability is announced uing a new AdminQ command that sends
driver information to the device. The device can refuse a driver
if it is lacking support for a capability, or it can adopt it's
behavior to work around it.

Changed in v4:
- Clarified new AdminQ command in cover letter
- Changed EOPNOTSUPP to ENOTSUPP to match device's response
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

