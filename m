Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B246341432
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 05:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhCSE3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 00:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbhCSE31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 00:29:27 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCF4C06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 21:29:27 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id 19so6934284ilj.2
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 21:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KyKoa9bY/CBR39lN4qu6Iu2yiDNEigJRAyZ9cNvhCGw=;
        b=ockvKcT0cLCr7uhRFAJTSWyeXB02yRaH1D/rwIk2FPba5pHy0DfXCKMGJKLZUT2Ix2
         EPxIpt+bCsyreBzlBkagWUqedcEcGD54XLGwOF9w5Zj/7VKHsSW4WKR71ZbuEbiFNgfB
         L/B+tZZ01xbJxcNqheN7aQdi2yJW2jLrUxFuFeFl3mHWRImE0pvL/RcUPOgjFB8NBNlL
         N5H5p8GiFpWkYDVuPs6wnJtV3/ceYHEl2BEhYu80FWz/1bUaCXP0uNQrSc+Ulyms1YDT
         4kRQZKp6De48Kg594sTLATKg7EL4BhScYUdNIPAvr7jVBTzkMKjOg6jN2B2xQeG3njNR
         k53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KyKoa9bY/CBR39lN4qu6Iu2yiDNEigJRAyZ9cNvhCGw=;
        b=Qn3TezpYjmbhWnE8OZ1/HXcsAJqc/KaDRtq51z8Do4nEQ0tboYGqAlPp4UpuwMD7Gk
         aLIRLYzGf6EUDVWmdLtei1R+agAenCV4Q25VQ8qpiCBSyVUyX1KqRqSVJsSjyO2sB6sr
         1ySgpzgLYUYewOONezlVWkz4Bv+/ys2kRf5U0hvcjD6mUokWK9af4HfltDgu7wk5Nluz
         OETRZAancy+sRIZxRxs2pJu1wP9JrtGbgjq2dRDgj22Lmqm4Fwz67OlRbGeRIYuiFlBA
         IoQAt5suVx9aeC6q4stB2wFXi3S9CMaDkQX8nj4Q1gR/4baMcisXNssXwBtCMuzqgy6c
         YJ5Q==
X-Gm-Message-State: AOAM532QxNYGYGFWt3u6Sif9OC7F8Z2YK0naTm4gKa3AqrXm1kmeMUmY
        kXICvq2dS2X8LLL0Gsufc1hlDw==
X-Google-Smtp-Source: ABdhPJzkmj688MiPObFa4V8EfKl6XkAf24T6z1pjd1llocWaO6spDSyLV1d6P4+wSY8BA0HBDj5fqQ==
X-Received: by 2002:a05:6e02:1384:: with SMTP id d4mr1356304ilo.307.1616128167185;
        Thu, 18 Mar 2021 21:29:27 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k3sm1985940ioj.35.2021.03.18.21.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:29:26 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/4] net: ipa: fix validation
Date:   Thu, 18 Mar 2021 23:29:19 -0500
Message-Id: <20210319042923.1584593-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is sanity checking code in the IPA driver that's meant to be
enabled only during development.  This allows the driver to make
certain assumptions, but not have to verify those assumptions are
true at (operational) runtime.  This code is built conditional on
IPA_VALIDATION, set (if desired) inside the IPA makefile.

Unfortunately, this validation code has some errors.  First, there
are some mismatched arguments supplied to some dev_err() calls in
ipa_cmd_table_valid() and ipa_cmd_header_valid(), and these are
exposed if validation is enabled.  Second, the tag that enables
this conditional code isn't used consistently (it's IPA_VALIDATE
in some spots and IPA_VALIDATION in others).

This series fixes those two problems with the conditional validation
code.

In addition, this series introduces some new assertion macros.  I
have been meaning to add this for a long time.  There are comments
indicating places where assertions could be checked throughout the
code.

The macros are designed so that any asserted condition will be
checked at compile time if possible.  Otherwise, the condition
will be checked at runtime *only* if IPA_VALIDATION is enabled,
and ignored otherwise.

NOTE:  The third patch produces two bogus (but understandable)
warnings from checkpatch.pl.  It does not recognize that the "expr"
argument passed to those macros aren't actually evaluated more than
once.  In both cases, all but one reference is consumed by the
preprocessor or compiler.

A final patch converts a handful of commented assertions into
"real" ones.  Some existing validation code can done more simply
with assertions, so over time such cases will be converted.  For
now though, this series adds this assertion capability.

					-Alex

Alex Elder (4):
  net: ipa: fix init header command validation
  net: ipa: fix IPA validation
  net: ipa: introduce ipa_assert()
  net: ipa: activate some commented assertions

 drivers/net/ipa/Makefile       |  2 +-
 drivers/net/ipa/gsi_trans.c    |  8 ++---
 drivers/net/ipa/ipa_assert.h   | 50 ++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_cmd.c      | 53 ++++++++++++++++++++++------------
 drivers/net/ipa/ipa_cmd.h      |  6 ++--
 drivers/net/ipa/ipa_endpoint.c |  6 ++--
 drivers/net/ipa/ipa_main.c     |  6 ++--
 drivers/net/ipa/ipa_mem.c      |  6 ++--
 drivers/net/ipa/ipa_reg.h      |  7 +++--
 drivers/net/ipa/ipa_table.c    | 11 ++++---
 drivers/net/ipa/ipa_table.h    |  6 ++--
 11 files changed, 115 insertions(+), 46 deletions(-)
 create mode 100644 drivers/net/ipa/ipa_assert.h

-- 
2.27.0

