Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5BD1E908F
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 12:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgE3KaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 06:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgE3KaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 06:30:12 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F74C08C5C9
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:30:11 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id ds18so537826ejc.7
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ub0Fbaldt2HNQx0+0zjX17tVGjFymNI3yLL4Mw2rs3g=;
        b=QHWIIPA8eI7jTe0lviVlUrrdu7mQfT7k5T1McPp+Ikb6FnLppAVre0lpMMcDTh7QjY
         akoKCC/cD31YSOSOPtY9k3Oj4XjpYqHXPwNv70w4KHcKd+iY7IXzfGewjObkd9/8615b
         IFURMYNQ966CHOQoafEt1l1EEt6d+UNBneON+nV3p1DYfhD0JaCaEpWuC0GpDjoOqlYf
         0InceAk7IezlovIBxwhxjg6wVXtrXKlRxSoMs4CG2Cv3HVwmN//LVMFWtoyge4Z7AGLQ
         M3cgr+FrNmRNbArxjqlW7lHyftgs1goAF+XbjrCaiMsfXXpGK8hW0h8At+Ze1f/dUYXP
         nhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ub0Fbaldt2HNQx0+0zjX17tVGjFymNI3yLL4Mw2rs3g=;
        b=SkYBEuHj6HgKLGfQg2BtjV/1fVq3iPNcZJjFioYdjmXUDBcvPWUFL2IG5cT4DyRQDd
         kTBf8K9P317nHbSOZTUdOW+HAeiwhqoA21OM+EJ68zuuUlT7k7nJfWbP4xIX7NMVAr4s
         RX/K26NYirzZI7ttJSjU45J9sJu5fFSduWTim/a7CT3k6hJs2M2rotLEB3M/pceXw3Pi
         0s3X9IRn3txdPfow55tDPyVMoa3a5i46SehpMWcIQM8DL24hJuyL1B4C/s6+uIt3ccZ4
         eSUDCKz60ArqqwVInUWG9vJHvpLtigSLh2DdwWNRGaWbSL9LdU8eMS6nEkOYwPwJ2GsI
         oK0A==
X-Gm-Message-State: AOAM533qjXoB68s218+liIiadxlLeu2rmEDFScuGuSPhBbI02lZpb+Ia
        qcQsw+w0vmPEvrYCVSE/1zI=
X-Google-Smtp-Source: ABdhPJw6hDdKHBXXot1TF+bLuDCkXTVMiPOQS4Tfvd0BkqSgBjEk/nYUUiVMWeo8+zV4RDLFW/86dA==
X-Received: by 2002:a17:906:481b:: with SMTP id w27mr1918221ejq.27.1590834610423;
        Sat, 30 May 2020 03:30:10 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id g21sm9511204edw.9.2020.05.30.03.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 03:30:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Fix 2 non-critical issues in SJA1105 DSA
Date:   Sat, 30 May 2020 13:29:51 +0300
Message-Id: <20200530102953.692780-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This small series suppresses the W=1 warnings in the sja1105 driver and
it corrects some register offsets. I would like to target it against
net-next since it would have non-trivial conflicts with net, and the
problems it solves are not that big of a deal.

Vladimir Oltean (2):
  net: dsa: sja1105: suppress -Wmissing-prototypes in
    sja1105_static_config.c
  net: dsa: sja1105: fix port mirroring for P/Q/R/S

 drivers/net/dsa/sja1105/sja1105.h             | 18 -------
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 50 +++++++++++++++----
 .../net/dsa/sja1105/sja1105_static_config.c   | 10 ++--
 .../net/dsa/sja1105/sja1105_static_config.h   | 22 ++++++++
 4 files changed, 66 insertions(+), 34 deletions(-)

-- 
2.25.1

