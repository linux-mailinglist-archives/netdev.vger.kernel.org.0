Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029FE2F4F01
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbhAMPm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbhAMPm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:42:28 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F78C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:41:47 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id g12so3690694ejf.8
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 07:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwPoBENGTIOUt4djT6wQBWQTrsifQfkCG/nrigO6xts=;
        b=r+ms100SCrHCFbyj6EkRXLrpnTDv4qAzOkHPvEZw8tvK8QBE/2nB7OkYmVmp6kXJbD
         tVzldJ5AOcr+SqS6qdk046on+3P5DikTQ3v+LKOWmKK8sk4Av9PPcEApj8alY0AybSHx
         9eW4nZYuJ+rS+HK3ew/J1oLFs9q0t9Vyw7ykbU/1ABehCyhjd/jd/yIfaKzYI11LENF9
         eAT8dJIikqAyYqHPigtPPnCQ5oijzYqVWnnCTtPMXEC7uCe/dxRSpdoudpDSfQAkPsbH
         2nhHJFEXYsD0yvIIq9j1U7EKD1J9U3cSruj9nz8jzUk2d+GAhkEf1Sowo2DUckDxGLwC
         O/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lwPoBENGTIOUt4djT6wQBWQTrsifQfkCG/nrigO6xts=;
        b=MXzLAiMh7pNgtaCHHymaYmZ6DqFAcAbvFgPpQScnPQ4w8ez7lNq9q0357Rj65si/8L
         R7dPzl+wABrOBGi9qvmkq+ssf7EzOljupfC3bXHZ+yofAPdMUlE3uYuNQodRuYQDKH1F
         UPslho0KFd8jFz2EOzEXPa99DKE79cVbq40GYIK3vnhVaf58roMTMja+6wYwYM6Rst/z
         mIvig/E+WHdeC86E2mVMxxedWkPBEuj/lkXnIgDMLpK+N+vcQ2EMYVAe06Bk8vlVl8ZM
         MXMVUb8k05qQK5nTOY37khpx7A1KhrJqSw+tprrtV+6e23GWGHkm3uGqAZaktNRDvIRb
         azdg==
X-Gm-Message-State: AOAM533RIuetKUj9jA5BNU2yIz7fgin3TlxSmh3wuXiT4C23JbLHPhwK
        gfJ0U9Roo6uSfVW5rxXJkWM=
X-Google-Smtp-Source: ABdhPJzHXTElAbQnRRCDCWbi3WWXted7GBfL6HOReojvWBYOXIbOelKqrliLiBmTBQUxpuwXC3gicQ==
X-Received: by 2002:a17:906:338b:: with SMTP id v11mr2121315eja.74.1610552506658;
        Wed, 13 Jan 2021 07:41:46 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id bn21sm852499ejb.47.2021.01.13.07.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 07:41:45 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [RFC PATCH net-next 0/2] Port-based priority on DSA switches using tc-matchall
Date:   Wed, 13 Jan 2021 17:41:37 +0200
Message-Id: <20210113154139.1803705-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is a proposal for configuring the port-based default priority on
switch ports using tc-matchall and skbedit priority. Comments welcome.

Vladimir Oltean (2):
  net: dsa: allow setting port-based QoS priority using tc matchall
    skbedit
  net: dsa: felix: offload port priority

 drivers/net/dsa/ocelot/felix.c | 15 +++++++
 include/net/dsa.h              |  8 ++++
 net/dsa/slave.c                | 72 ++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)

-- 
2.25.1

