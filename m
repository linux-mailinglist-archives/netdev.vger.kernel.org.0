Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80A91C9A9D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbgEGTOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEGTOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 15:14:10 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F4BC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 12:14:10 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h26so464547qtu.8
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 12:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nIiwVFpw4ZhZjwUQ6twbeuIA8JamFmPyOdxqKvsHNzw=;
        b=i6h3fRoK431NaGcWuZSoiubFhXGK4ascXHQ81NTAzyKnO1veaUBwv31Lnx87SCzFsj
         EFJbIdZluGhNvnZ3GRpFsmn0MFqxMkqMvMzZifYQ7O0MdGVsjQR25EqQs53wBYlGNq7Y
         Jv//aZOfa9zuoMFSXaCBOmPfG+qAap5Jz+KjxrEkpn6s/xL0qJQKvldi/z/6vw74tAQt
         JA7mF7WIywRS/FGyhElTrSXA9FfuQkcjih/ARA7MDApK6AGqziN9mx9fBZidhoA44Xm8
         HBlzTTk7xav1f835DSM/2RcyAIL2bSfTmeLgvhh3X6RI36+6Q8fQIZRYRXd3CIX9adkD
         O5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nIiwVFpw4ZhZjwUQ6twbeuIA8JamFmPyOdxqKvsHNzw=;
        b=YHpzTXJAtcght6W8q4Xqc+es5Tkh1sOsScwmOjsLx84VeFi6mvKL7m5Qn99LIB+pzN
         dr0lIaNeALAion56oQZ3FeQfiHjMOxFMHqYZFw010WVqxacwQ0YSMxzCCjelGqJ9193H
         jmsjEW5CzpunoPY5ZAillTq6fWxqxrKy3S2d5GtCFT9rQZAnPTgznblZ3qRBLKxcavnC
         y0pXkT7RCiy+8/XPrfyTYSHqVylWC4SHMYW6L2/b8SPFGXhRHF99lqvljzjBMcFubm5q
         0OAts9By5ZYqvGQcGSgzq5GkFicwHXUO0kqQSVr+gFuDVfZp3Z57CWI9xfQY+FDyAovB
         yjgw==
X-Gm-Message-State: AGi0PuZGk3JjrXtJfNY7TFuQfafu/OlxAz/5f5aQiRlVGRmWeBlJEhKS
        9CfzNHyB1xUHXTPaAImIrFULjg==
X-Google-Smtp-Source: APiQypLJj9gJVm+wPLLoPXnfggd+adXxW0v+bEwlFIia6pFfvUorxPaafp+9n1kJvQH7IrC7JMDeBg==
X-Received: by 2002:ac8:1b58:: with SMTP id p24mr5639914qtk.29.1588878849189;
        Thu, 07 May 2020 12:14:09 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j8sm5094236qtk.85.2020.05.07.12.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 12:14:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: ipa: fix cleanup after modem crash
Date:   Thu,  7 May 2020 14:14:02 -0500
Message-Id: <20200507191404.31626-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch in this series fixes a bug where the size of a data
transfer request was never set, meaning it was 0.  The consequence
of this was that such a transfer request would never complete if
attempted, and led to a hung task timeout.

This data transfer is required for cleaning up IPA hardware state
when recovering from a modem crash.  The code to implement this
cleanup is already present, but its use was commented out because
it hit the bug described above.  So the second patch in this series
enables the use of that "tag process" cleanup code.

					-Alex

Alex Elder (2):
  net: ipa: set DMA length in gsi_trans_cmd_add()
  net: ipa: use tag process on modem crash

 drivers/net/ipa/gsi_trans.c |  5 +++--
 drivers/net/ipa/ipa_cmd.c   | 14 +++-----------
 2 files changed, 6 insertions(+), 13 deletions(-)

-- 
2.20.1

