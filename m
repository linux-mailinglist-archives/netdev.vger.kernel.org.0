Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491746984FB
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBOTx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBOTx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:53:58 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9C861BB
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:53:57 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id r6so7568621ioj.5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sT4ClNB23fZFU4XjrijJ0dWtSiTxl6Nd7yW2gogV88A=;
        b=kOoXHaENCqaveZbRVos/KoMjQEYUTTe+cDvD6aZOVB4UUm+9O4E2ELQjImfT8ouZ0J
         iELDS2mImUI4RYworlFqM7oaHyim/HvO25dDpiSyr7dtNtV+o8xuJalkoo5wJWQ5rTUg
         +oDPdVMW56ZFzB1vW6+zCXGc+1wVSE96+kk52Q3f59Nf2L77oqW0yzuiC3HydTBOqKIc
         MT7Qd14E5trSIKIU7J1kY2G2PdW2y4BYh+4O/dZPIz49zPNJmWGCH8JBD7pne/j3bIiB
         OLQH70fIPNS+3xkyvdwHrUz4SUmR57AeqVf91aJC2bVurGUT0evfT6K4C6eFkgZu/Cnu
         RAuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sT4ClNB23fZFU4XjrijJ0dWtSiTxl6Nd7yW2gogV88A=;
        b=AIVaLIScQIbqB3lnpHZJWJ27JvhU3/LN2JmIizvUYTsImGr8hGVsbp9Evre68Uvkh1
         7LTIZV6i7vPGWOyKZGqd/7IaZMghE41db/rkWRh0hMMjy9HmUtRXTXv0FQ17F8eC3TkQ
         CrswXbmkm8cQEzzHhUzuNfr3ksgqy7I4hK4puLuLABtWv4cC1IsTZ9CNb+YCVbN1qOO1
         6Pk7fe8VGCdM+whxYTjfeeEUW8FFeLCe5ZwGyYTRFAzHBbT7eUJk2754CnsjamkJGSKm
         c4QMSvj6XQHAHWuCmUGydyVs3qvtQIq9ftyfnGiMqK0Y8qMA/s15v/3QzWfRS8vzNPEm
         rz7A==
X-Gm-Message-State: AO0yUKVxR6uDC7e37KB65D/90ECGk0ZqO6+yqAMtSNikXlG1Xapgrklf
        x+vvyO/3C6KRSwu3H9qdpS7WOw==
X-Google-Smtp-Source: AK7set8XLttl8lPSv2+iEOKoX0074zNwcBjXiQgyM56kXujYOubNht4kSI2UhSZzQoeaE5M2qpr1/g==
X-Received: by 2002:a05:6602:370a:b0:734:ac8a:65d6 with SMTP id bh10-20020a056602370a00b00734ac8a65d6mr348465iob.10.1676490836388;
        Wed, 15 Feb 2023 11:53:56 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n10-20020a5ed90a000000b0073a312aaae5sm6291847iop.36.2023.02.15.11.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:53:55 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: final GSI register updates
Date:   Wed, 15 Feb 2023 13:53:46 -0600
Message-Id: <20230215195352.755744-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe this is the last set of changes required to allow IPA v5.0
to be supported.  There is a little cleanup work remaining, but that
can happen in the next Linux release cycle.  Otherwise we just need
config data and register definitions for IPA v5.0 (and DTS updates).
These are ready but won't be posted without further testing.

The first patch in this series fixes a minor bug in a patch just
posted, which I found too late.  The second eliminates the GSI
memory "adjustment"; this was done previously to avoid/delay the
need to implement a more general way to define GSI register offsets.
Note that this patch causes "checkpatch" warnings due to indentation
that aligns with an open parenthesis.

The third patch makes use of the newly-defined register offsets, to
eliminate the need for a function that hid a few details.  The next
modifies a different helper function to work properly for IPA v5.0+.
The fifth patch changes the way the event ring size is specified
based on how it's now done for IPA v5.0+.  And the last defines a
new register required for IPA v5.0+.

					-Alex

Alex Elder (6):
  net: ipa: fix an incorrect assignment
  net: ipa: kill gsi->virt_raw
  net: ipa: kill ev_ch_e_cntxt_1_length_encode()
  net: ipa: avoid setting an undefined field
  net: ipa: support different event ring encoding
  net: ipa: add HW_PARAM_4 GSI register

 drivers/net/ipa/gsi.c                |  36 ++++-----
 drivers/net/ipa/gsi.h                |   3 +-
 drivers/net/ipa/gsi_reg.c            |  35 ++------
 drivers/net/ipa/gsi_reg.h            |  23 ++++--
 drivers/net/ipa/reg/gsi_reg-v3.1.c   |  22 ++---
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c |  22 ++---
 drivers/net/ipa/reg/gsi_reg-v4.0.c   |  22 ++---
 drivers/net/ipa/reg/gsi_reg-v4.11.c  | 116 ++++++++++++++-------------
 drivers/net/ipa/reg/gsi_reg-v4.5.c   |  64 ++++++++-------
 drivers/net/ipa/reg/gsi_reg-v4.9.c   |  74 ++++++++---------
 10 files changed, 205 insertions(+), 212 deletions(-)

-- 
2.34.1

