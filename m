Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38340398954
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFBMXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBMXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:23:11 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76209C061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 05:21:27 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id c10so3493406eja.11
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 05:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fcDzTslxj+cvGmntBW1QFCzMgK7SZvbjCDyh1xhxIeA=;
        b=Cm8V0Ow2n1GMuctyfLGMaskZvst51Jah7hnWEAL3iUxzxEm5ETFyS47JlmWCgwoFg/
         lTC9yROT1ulKxtTjepUxE0aO1sm3d9kWuab5aGmkBOnktBr3195et7y/HDr9G1DAQ2p0
         EI6bshC0Yo3/ZIAD9nYi+j7bSZXiImL8wtJuB3O+/Uffm0W4yUlWcazz/35jHBJb5u9a
         66EeLbKVvkKOH20oXgk8MooiGjI3VdtD92JI1UyMax49SwFIHTs0Q0nWDiUs8UzCZtVT
         4LDO3IPnAikxKg4LUvMRNEr1tihEPM0tHa6kc7J4gTEfATP2lW0/T+R5EpweymIvbt33
         ALkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fcDzTslxj+cvGmntBW1QFCzMgK7SZvbjCDyh1xhxIeA=;
        b=ZZX1WU8Zd2/qqivpoD5Ry3zZ/WFEvnvoeS65W2TGan2bybrTC2YKtLxCt/S4lMsKYl
         UGdHlBwJjd+yExjHxwBqbqR6dT7Lxrl5CTs+CEdm72LWB06KaNyVJubFSQ3vo9ymX5rY
         5b2RyGQL+9pkV9IIkpJLkJEFbNbsnRHnKsTX+vhcz4WihM1s1KwyueSXrsShK7qYpC7C
         qHVFbuQZLDQNgrIoa1XBv/iLzppXvbI7sRSV7tZwAOEkC0w2vM9oTaCp0EEGUtswM+U1
         E+RwJOTFcHOGWXhZuAvsQeyTvy6rEnuDkNG5TPv9BKjFp05omSNgC2p0OQ119Z6L5aW9
         /S4Q==
X-Gm-Message-State: AOAM530WAYnpPMDsdFtleNSLjkIlG4J8TF4o+WyAw26SFbr3C58sMDb6
        U6Av/l0sJaaoZrOKB+fzhj8=
X-Google-Smtp-Source: ABdhPJzV6IvI4Y5kzyyjDvUi4d1XRGrv/Fu6/C3mlkNdzk8Au7eYL3sxri1jBq/kStueCPQ/62S2rg==
X-Received: by 2002:a17:906:2988:: with SMTP id x8mr12322592eje.122.1622636486095;
        Wed, 02 Jun 2021 05:21:26 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gw7sm1448745ejb.5.2021.06.02.05.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 05:21:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>, Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/2] Report tc-taprio window drops in NXP ENETC driver
Date:   Wed,  2 Jun 2021 15:21:12 +0300
Message-Id: <20210602122114.2082344-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds an ethtool statistics counter to the enetc driver which
tracks the number of packets dropped due to insufficient transmit time
in the tc-taprio schedule compared to the required time it takes the MAC
to send that packet at the current link speed.

Po Liu (1):
  net: enetc: count the tc-taprio window drops

Vladimir Oltean (1):
  net: enetc: manage ENETC_F_QBV in priv->active_offloads only when
    enabled

 drivers/net/ethernet/freescale/enetc/enetc.c        | 13 +++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h        |  2 ++
 .../net/ethernet/freescale/enetc/enetc_ethtool.c    |  2 ++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h     |  1 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c     |  6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c    |  6 ++++++
 6 files changed, 24 insertions(+), 6 deletions(-)

-- 
2.25.1

