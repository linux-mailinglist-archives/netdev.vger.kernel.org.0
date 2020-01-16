Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743E113F043
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395466AbgAPSTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:19:42 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36853 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392559AbgAPSTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:19:41 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so4860422wma.1
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8hP/ZnEytlpTg7uD0ldItOM5tGvfzEs/xB75kxWcqeg=;
        b=hjG6EDVrnMsOn1hWfladegr+l/8SAijuzQo2mNo9hiWCzbt8vhwu+e5GhVEobqMkRr
         uywauHW82B6IZfIZJNFoYnRqdwnJ8iwCq2qrDks7qBEkbOqDUnDDS01RH8+TFz9hl/rQ
         Xj93PB7TWxuDRV9qCX8QJibsSpzL72tnd+5a5bpW/ZN2HWvk8sHaTWiTwrHqrO78A9hu
         lpLrwM3LSeXndDQFbG+W1bbCTeYciIM1BU3uOxJOzfffpmQmzhNP3oQMpmAEBO8YQ8kA
         UwSP/bOuc0I2dd1a0CGXfnQjlqxB6WW3jrpntj8kNPwNSTeFUcEzcNyV7HN+znj5biYg
         hpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8hP/ZnEytlpTg7uD0ldItOM5tGvfzEs/xB75kxWcqeg=;
        b=HEQ5Syv1FTGyeHatU75W4iNRBgra94u57J//aZQ8Xjgfdk9Ji89AnamKsJc8UEkhwe
         yMvCZ1taWD42YwavNXCkql+xCPFBbDo/F5VyCvMLCwA25uOWZjfgYx4QkwiXGp/vXfdV
         nk8UAu0hJhErjH3JNEk/rCGksdgITLVatPQQZJpFgQ78ho71rDfKErcOIAIuDepmjonc
         Hs9wW+WtX0/VHF1qdtZNEIfytEHetOEr7pm6Lr3+2Srr3cWssJqo5IREfybCDO2HWBf5
         87Qi0XQh0DYZTQk9ZRQlnZ+JJpuQECjfUSJEbjMoe98Jm7GxBW2QqiO1YmP52hxgttnR
         ktGQ==
X-Gm-Message-State: APjAAAVm/dyb6VFd4C5CLtBT3TC8ah+U5vTwgxobeMMxwQqUpGTrGcLg
        YUEVQEGRP+nrkj9WfPezhIU=
X-Google-Smtp-Source: APXvYqyHNTYNkymdjw+YJ8Pabdai+4rRJdABOu1ZSzcws6FFOgI17cJ9/GfdGHry2GBRockUDujG0w==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr293623wmb.155.1579198779229;
        Thu, 16 Jan 2020 10:19:39 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id g25sm1038148wmh.3.2020.01.16.10.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:19:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] Rate adaptation for Felix DSA switch
Date:   Thu, 16 Jan 2020 20:19:31 +0200
Message-Id: <20200116181933.32765-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When operating the MAC at 2.5Gbps (2500Base-X and USXGMII/QSXGMII) and
in combination with certain PHYs, it is possible that the copper side
may operate at lower link speeds. In this case, it is the PHY who has a
MAC inside of it that emits pause frames towards the switch's MAC,
telling it to slow down so that the transmission is lossless.

These patches are the support needed for the switch side of things to
work.

Alex Marginean (2):
  net: dsa: felix: Handle PAUSE RX regardless of AN result
  net: dsa: felix: Allow PHY to AN 10/100/1000 with 2500 serdes link

 drivers/net/dsa/ocelot/felix.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

-- 
2.17.1

