Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C283A66C2
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhFNMld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:41:33 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:43592 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhFNMlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:41:32 -0400
Received: by mail-ed1-f44.google.com with SMTP id s6so46269733edu.10
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2X0pkaXmlPL2fcju2F37eTZMomKkmNIx/UmjIixTq+4=;
        b=q9MQeudAUju1vj+hgo77gr3jNrHPz9ewCHaosuF+FVlyVbcQWITTMXFim1JGKmPFR0
         cBjTdkaYhjzxxbsxP0ak885dua2DM8h5CkZ3tZ7+u9tvGLWEfAshC/wyUgqa8yS5+f6K
         PY13pIkh2p8z3yu06YyTMpd3A49fCeSHpyDFY6qOOahKMNqIZo9TB6CbSn+xqgoeBfxs
         DWQ9XL8TyqkWHkfPsxKqXdA2VfFbMAYigJnJTyUxRnUDGs1pvzv9V+I0IoTvHxin1avn
         5eeLMjldN1qEk74mpFxNS7JqZHRft5PY9z/bUCYukngLMPbL1EH/wjTZbv5k1MlXs1HK
         /59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2X0pkaXmlPL2fcju2F37eTZMomKkmNIx/UmjIixTq+4=;
        b=VooWZXErEfzA3fKt2hqOb0KTa0HW7iNIue+ocX6azwNF9GntO7QdmqQh4LQztnwRPr
         2dpUnkfLz13teklkHhSFePGY+hlMJHIAIWQPQJVDYRXH8xwzQg9YG6JU81fRrfNN1giz
         +z4bInzHVeRl7yR0KFdW7w8TRS+NUD2xYJBuq7ZAjohPF1g5PlxywUE8f5Aubei3gymP
         kt5hvXtxGdqdHy2pK69gUNpgJQBUfH1dEZyGMwnhHdMf8DVY1NALuSvkrHbrIgz7tfXg
         QqakTlcU545tcfrtXKSRLQuNav981rUJEg9WpIcpEDaM/w99tqDgBPDpSvO4YKv+qpnw
         Md9A==
X-Gm-Message-State: AOAM530LFAhb+i980GUezFf/FEk5UVxqlQnkayYTUUU57gP2TXTF9ivX
        X+gxCnoZploPcDp65XvhpV4=
X-Google-Smtp-Source: ABdhPJw4EN3yquverrfC0WogPKF39rPz/HVBUnEy0pL36mdT1Ssj/M7woE2U3rqYptPyYSiSyzDRtQ==
X-Received: by 2002:aa7:d388:: with SMTP id x8mr16351216edq.338.1623674309547;
        Mon, 14 Jun 2021 05:38:29 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id f6sm7157965eja.108.2021.06.14.05.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:38:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 0/3] Fixes and improvements to TJA1103 PHY driver
Date:   Mon, 14 Jun 2021 15:38:12 +0300
Message-Id: <20210614123815.443467-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series contains:
- an erratum workaround for the TJA1103 PHY integrated in SJA1110
- an adaptation of the driver so it prints less unnecessary information
  when probing on SJA1110
- a PTP RX timestamping bug fix

Targeting net-next since the PHY support is currently in net-next only.

Changes in v2:
Added a comment to the hardware workaround procedure.

Vladimir Oltean (3):
  net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to
    debug
  net: phy: nxp-c45-tja11xx: fix potential RX timestamp wraparound
  net: phy: nxp-c45-tja11xx: enable MDIO write access to the
    master/slave registers

 drivers/net/phy/nxp-c45-tja11xx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.25.1

