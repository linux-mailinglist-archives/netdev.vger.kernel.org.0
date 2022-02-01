Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3F44A6040
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240451AbiBAPhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240447AbiBAPhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:37:42 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1443C06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:37:42 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id c188so21671327iof.6
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 07:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lRyqMkpZrgsbzkNWeJA/GuP+4ZC47s1fLnf+f3MFBI4=;
        b=ToM98c4qhIxo4dxOmKMcxs+ZtEg4xS9QB6fVlMEXjQXTYSiAIpFkHzjVREFgqBfM1A
         y9tX402wRVe8pstTz0dQRix/kEKcSCee8xC5MByWLJaj7KEd5ZrJGtBnmHVnfQGDjBZp
         kAnCKNcxPklMOqeG98913OlRnpO+vlXrbZmLkgjnlUlLj4aYicjBer1xxGKWfmX+cyse
         /8Me7StKd5YbivnDxB2taBo8W2QpifdVTMJHz5tDsI4cJVVZfCBy4r3R03g2BwtDrcDl
         hiEWlLMp1QjZ/xmi7FaZXjwWefFIhfgnQVWmNmJMZW3oJEsGQZKxhdn7OFugnXjYBX5c
         K2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lRyqMkpZrgsbzkNWeJA/GuP+4ZC47s1fLnf+f3MFBI4=;
        b=Y7llM0LYFfRHUAMByIaRhdi1Iwy0r5ju0Ef7MqLw53l0X5lYsz5pSn4UR/uZdnli3t
         tLtvh2opIxX1MtNqZ4UFkIIV3WUbFlUDMz0PtppOjwUxm1A1rbnHqOCFiQ3eJtBB1uTc
         Ri019rUhAreQ8S//0j+OIe7jILIrfPGUnBNxxwJCee9MqdSvxZEdU40YwWhiS55HhUAW
         Fjtxauo5cXs6hccxLIZH07+sQqshhr1Fxoq2RzXFjmWgVrEy43XKCirqfi4h9FThQ9Pm
         YdRm2le/5f5jCQqd50kDHu/ti5QO4BjZjuIKrME4x4+9w3aT1p844PPMtaWTiLFHDOzz
         b1vg==
X-Gm-Message-State: AOAM530mYerx7YhVGVs/d8qGgIKwmrLuzFLHpC/XXRFgQQPcFa4rPKGc
        tMR+H+SGG9Bh1BPaYOezGcBDrw==
X-Google-Smtp-Source: ABdhPJyvx5o4ehW4aMYvXVi+PtIcrVqeNiUt+ICR8RhmSxS8ffTpRsEE39mFMOjzdUhlfwhMX7YlIQ==
X-Received: by 2002:a02:9606:: with SMTP id c6mr12713173jai.169.1643729861919;
        Tue, 01 Feb 2022 07:37:41 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n12sm1234583ili.69.2022.02.01.07.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:37:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: ipa: support variable RX buffer size
Date:   Tue,  1 Feb 2022 09:37:35 -0600
Message-Id: <20220201153737.601149-1-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Specify the size of receive buffers used for RX endpoints in the
configuration data, rather than using 8192 bytes for all of them.
Increase the size of the AP receive buffer for the modem to 32KB.

					-Alex

Alex Elder (2):
  net: ipa: define per-endpoint receive buffer size
  net: ipa: set IPA v4.11 AP<-modem RX buffer size to 32KB

 drivers/net/ipa/ipa_data-v3.1.c   |   2 +
 drivers/net/ipa/ipa_data-v3.5.1.c |   2 +
 drivers/net/ipa/ipa_data-v4.11.c  |   2 +
 drivers/net/ipa/ipa_data-v4.2.c   |   2 +
 drivers/net/ipa/ipa_data-v4.5.c   |   2 +
 drivers/net/ipa/ipa_data-v4.9.c   |   2 +
 drivers/net/ipa/ipa_data.h        |   2 +
 drivers/net/ipa/ipa_endpoint.c    | 107 ++++++++++++++++++------------
 8 files changed, 79 insertions(+), 42 deletions(-)

-- 
2.32.0

