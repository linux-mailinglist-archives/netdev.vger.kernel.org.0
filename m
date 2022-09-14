Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D10A5B9018
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 23:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiINV2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 17:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiINV2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 17:28:47 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB046C763
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 14:28:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n8so4991283wmr.5
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 14:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Ub1TTjXUCJ5m4+dji3W1emSVf99Yb1sR6GG/zzLYCRM=;
        b=r/KPiJ7DWf6ixBfxxsTWaT6+j/ZrcHorLTniplrtQNcstxmg8MvzmReWIGJyrunJo0
         W5oMl7z3Enm87k++NoDgQScdmA2da1vFPnP4ja0nHxjmahuXZR5cKZwn9J0MTkCB/lQS
         BIB+9DkOWBLgMpRIcYpPfagqs7yKmgld/sgl2YQHagZ2JdUgz63XrVf/3hpQcusKo6Kt
         QK13+298zxGikcm8zfCXj6QYaBdoKipjuaZhh0Nxn+ayVlLgpygsXT9loxgRv4AKmOfS
         smqCsR4pC1mNqoE83TUX4UNXiSkvA14Fj4BX8zuRrMahCjw/93RTK1hlkKWzf+eOVL8a
         kgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Ub1TTjXUCJ5m4+dji3W1emSVf99Yb1sR6GG/zzLYCRM=;
        b=IPUKCThTk9iUgSmXZg0KVpOKpTIeEDWAvaluWs21sQsahSou1DbuJP4UY14WikUVpI
         3a+E0MO6yXmq8unfby+JnzcFnU1QbuPrlLSCRF/CZP45TVRLq/Oc0vhP/LQ9alTplb6O
         ROuKA78wSoybGgR4qZDEiTiWVuIdNktec67zcTecdbl96keZS+lJLqmdORRPJKcQFlkr
         pdAmESY9p/PqH7ayPI6ZHOm8M3iVMU7WftYblREjWefWrwa4YpU7R8HGPtrVhsFKG/e1
         DUb3Vk+1S+Xz7sVCNRJvPWRE17bbKAPor1j2+aquqOweU6KPWhfNkHmgOKMk2xuwU/oT
         jrKg==
X-Gm-Message-State: ACgBeo1NdlsfC3zg96eYu9UsZU5vWUYtxonZGaiACqVF8gZ92nYbuwVv
        YApZgQDLhN7t7+eSjIgr+a2xMQ==
X-Google-Smtp-Source: AA6agR5huPrPzpRpghYvUOAd3IDv141FmRUaDaRfIyNRZzgYOmaJngJHJ5xsqF50Dxqp/yZ2BPArmQ==
X-Received: by 2002:a7b:c016:0:b0:3a5:fff2:62f4 with SMTP id c22-20020a7bc016000000b003a5fff262f4mr4690909wmb.104.1663190924904;
        Wed, 14 Sep 2022 14:28:44 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id e28-20020adf9bdc000000b00228c375d81bsm350898wrc.2.2022.09.14.14.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 14:28:44 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     loic.poulain@linaro.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, bryan.odonoghue@linaro.org
Subject: [PATCH v2 0/1] wcn36xx: Use SNR as a source of system entropy
Date:   Wed, 14 Sep 2022 22:28:40 +0100
Message-Id: <20220914212841.1407497-1-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
- Pass sizeof(s8) not sizeof(int) as Loic pointed out only eight bits of data
  are relevant in the SNR.

- Reword the commit log. I didn't really like it on a second reading.
  It describes the theory a little better now I think.

Bryan O'Donoghue (1):
  wcn36xx: Add RX frame SNR as a source of system entropy

 drivers/net/wireless/ath/wcn36xx/txrx.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
2.37.3

