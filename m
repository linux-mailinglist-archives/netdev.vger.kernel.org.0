Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B492F7716
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbhAOLAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728616AbhAOLAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:00:14 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F1AC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:58:58 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id x23so9889817lji.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 02:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=dBopyuit1/9f7gM1qIr4yJubu99ST/J/D6ltK0kj05M=;
        b=wQPZNy98UiqaPuh8FFLOiQy6lPc+lcgqsiK3TMKmQUl4ValTNUCejJ/r44lRpY3Ybb
         rlnLAJCWN4lCzSolLWrgj2u1n98G05IQzMlL4yr5qkbs9kdbmXDENf2GwUWcRGexyhEa
         jLdN476CXerhsw/uguR8qEtYvs+d7GUmWFXyI7jPTdozyQ9i9BPv/GZWUKJyL7QokVyD
         kekOIRXUa+aD6/2nHtUn2SepQYsN8JnNFWuCpPddbhSmgDZ9lyskcysKC1Xad9MOub8z
         U/KPtCoi/5oLTpo+yXywsZ7rUeuQhhiXMIHZelMulMBoeBG4wq3O1Q+V5tjgvsxIFWfM
         eKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=dBopyuit1/9f7gM1qIr4yJubu99ST/J/D6ltK0kj05M=;
        b=kwr5z5rvqI6fW/elReAyhoL7rTNyDMJe4F+sO4SM6VZ5T2eMGU7qi4XNGID+kiyAnL
         ygIz3GJ4eMO67UQVhmYsXhtAcMjDPX/hrNhF1HovDyWnwfLTdg1ga1po9p1JZ+755nvR
         hSBdLlRXVBmwUEse/d3vOMytVpcOjS+Mg+UW2SygUXlAT5TuNfSW49bhpy3Fq2T5nCaI
         PGVCqWzBxczoSgxjiNXsSB5BUz8kpKMen7nHZxqMc8MW9OttkJ+PHgEbk9jjQOfdAXOy
         goJmmZ2Cyt/z/SIZp/CpoX8mcSfOrObP1fTwqukPuJsbS2pf/Swj1zGbS0FhMBxH+FsO
         4nJw==
X-Gm-Message-State: AOAM5322XI9Rk/j/Wan7Dg82mSFIB4R4ukhNlSJ+IXY2sCY9+/sgBjkM
        E1llaQdc0O9EO7Zq06mdwhh4hg==
X-Google-Smtp-Source: ABdhPJz/99yStvURWaDKSRDQq9iKYDyQtjxLGQ+zw1lPJCYFbh6lpD/FA6pYCaWlsbPerckdNI/IDw==
X-Received: by 2002:a2e:b0d3:: with SMTP id g19mr5253627ljl.279.1610708336797;
        Fri, 15 Jan 2021 02:58:56 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p3sm756510lfu.271.2021.01.15.02.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 02:58:55 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: dsa: mv88e6xxx: LAG fixes
Date:   Fri, 15 Jan 2021 11:58:32 +0100
Message-Id: <20210115105834.559-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot kindly pointed out that Global 2 support in
mv88e6xxx is optional.

This also made me realize that we should verify that the driver and
hardware actually supports LAG offloading before trying to configure
it.

Tobias Waldekranz (2):
  net: dsa: mv88e6xxx: Provide dummy implementations for trunk setters
  net: dsa: mv88e6xxx: Only allow LAG offload on supported hardware

 drivers/net/dsa/mv88e6xxx/chip.c    |  4 ++++
 drivers/net/dsa/mv88e6xxx/chip.h    |  9 +++++++++
 drivers/net/dsa/mv88e6xxx/global2.h | 12 ++++++++++++
 3 files changed, 25 insertions(+)

-- 
2.17.1

