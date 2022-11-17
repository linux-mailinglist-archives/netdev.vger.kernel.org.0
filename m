Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733A962E1BA
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbiKQQ1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240743AbiKQQ1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:27:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59192CE3E
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:27:08 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id q93-20020a17090a1b6600b0021311ab9082so1479819pjq.7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 08:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tv1ySBzFOYsMnZqqLBOtXPIcpiIWMGnVxO2M2U8u7+4=;
        b=HLin/C/QBLyBpCCXQ9hWBvdiY4az2kDOOWmVAvg7T4hvsRLS2LKitIBvnCU/NWG2Vh
         1uD/74+mEAzMpYVxzGcmjcMyoGq6rrrcR3xMOE+eohz81QUzbwpqxBcHDuqMnpqVrFXx
         rDCTvgRWrRO8H9567zUC2JhLUKsF43d7CLm9l5bxzhwx/Q3NOgzAgqCy6NQe8uZQ21ra
         6M6uySA9xNHNXI81RFwzpgAxMQug+pYGLiQ3VJA0Eb8ukbNZ54phhIY9pm4JwRmQQhLc
         12Hs4B9PyXM2Z/uEejaYx7j1DYwPL2MJvF8gqBbM/ky7LJjmna/6WZ6jfe3TGk/leWOw
         8D1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tv1ySBzFOYsMnZqqLBOtXPIcpiIWMGnVxO2M2U8u7+4=;
        b=wWBfaivEs2jcEujH+KNq+tJj+XurKDQg/awSBqSuSZVOAdr62TmnLJ8yRxR0nkcmvz
         DgTjWfMnuirwam04rVQUvRILJQTGa58WvXh1n74UVmOm+vMzLQ32htbCcBtj0CgmeA3E
         cdNVvPcSyEGAEqq6WMRhA8ZX8Dgt03dd0ARfWq6WwR6gS0w0hJ5H0NlEpBdE1osGxOYI
         K+//B3l/muPPDS6UbcfZcQPkrrRiGRW9glSb4+vNKFz3GQBpEBn1xb9fT9pxy2J3xvAj
         y2TZHoyvzns1H+JequWS8BbjfQKFeWHJrkUxqpH2xjAfYzW+4XM7B6MHuF2SirlU44xx
         ArAg==
X-Gm-Message-State: ANoB5pmbj+d3JglhpwPUcPl1BYPBJGdP8jZKfIi4QRy+xZS+53/3JOGe
        tSHsYR9KfRZU0kC/QVWwxV68bdFaXgZCQGQUDnIPlhgtUfV8xqJ5o9+mZSYF1zxlp8gHnCZRdB2
        qaOLaSe2YqpB45h1L3UBmlyvde8OIr4boQiBt8Pp4w7eG8fMCXXhYo5zQ+34c0BnBJBU=
X-Google-Smtp-Source: AA0mqf5zJRM8KrV92yloE9QP66I2WasYxstvHkHYE/IvPNBTNv79BFsBYMlIxpSwqFHOFVEUFh3SJFIwD3DoVQ==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:7ba7:146e:ec34:b926])
 (user=jeroendb job=sendgmr) by 2002:a17:90b:a17:b0:213:2708:8dc3 with SMTP id
 gg23-20020a17090b0a1700b0021327088dc3mr967683pjb.2.1668702428039; Thu, 17 Nov
 2022 08:27:08 -0800 (PST)
Date:   Thu, 17 Nov 2022 08:26:59 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117162701.2356849-1-jeroendb@google.com>
Subject: [PATCH net-next v5 0/2] Handle alternate miss-completions
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
behavior to work around OS specific issues.

Changed in v5:
- Removed comments in fucntion calls
- Switched ENOTSUPP back to EOPNOTSUPP and made sure it gets passed
Changed in v4:
- Clarified new AdminQ command in cover letter
- Changed EOPNOTSUPP to ENOTSUPP to match device's response
Changed in v3:
- Rewording cover letter
- Added 'Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>'
Changes in v2:
- Changed the subject to include 'gve:'

Jeroen de Borst (2):
  Adding a new AdminQ command to verify driver
  Handle alternate miss completions

 drivers/net/ethernet/google/gve/gve.h         |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c  | 21 +++++++-
 drivers/net/ethernet/google/gve/gve_adminq.h  | 51 ++++++++++++++++++
 .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++
 drivers/net/ethernet/google/gve/gve_main.c    | 52 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 20 ++++---
 6 files changed, 142 insertions(+), 8 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

