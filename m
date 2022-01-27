Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A4149D722
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiA0BK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiA0BK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:10:28 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FC9C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:10:28 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id e16so869426pgn.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6qiXAcnfGaPwsYwFg8z9rb4/zWSRWUs8I0HD8VY0hYg=;
        b=Oztz6UMgBIGWhvj5XxcPYo7lDMUvYpAYC8KaiOoLMia8gcoMHrU+aX5kLDX1nvKwrR
         nfZ7H35PyLOKTaxJ03A+NtbXpZEK4bIdtsM19Iz0lm+jJWELiyjjU++m4XDLhBGLObx5
         X3mpEM9JjHpKTlPjJj2U/xLgqjsRTNx6X5GmhWar1LfcQ49HKTSUJqeRF6owvr/49VI1
         tlxkwnIJIFlNrTBqWfTzuibwiwaOedDH/PZYub0fD2A0gJIiWrMxui33uX6kw7notH6y
         lR0DAGhX8EzBkPPP+0+TQV2gZSPE+V/Q3fPtfJtYl/a30sZJ52dIF3zj6pX1+bOBoyDD
         scTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6qiXAcnfGaPwsYwFg8z9rb4/zWSRWUs8I0HD8VY0hYg=;
        b=xlMPQ9Il6JlHd/8iEOSQKwAciEqD+7fOBLVkP+SbQEUZuxvEHQ2sysfiGUDOlJaT/1
         z1po/jsWjLKzpnor6Z8FE3aqxX+ocSLtw/wJmxymITPIB/TqKdHm9PrfdmL20w47CdTj
         g6U4ep9l62mrxkMuo1sky5xADzzvS70T39CYuW+aVpEyZxK1pnCZHuA3jsvMZ8O6ePXP
         q/smgXs7yRYQ1+bonge1AGexqICv6zrhvkl2LCVCuGvBnn+aUx4k5I/rZDsw9f1BZOCN
         Qba6qTjoBqo9UbIS4l8pyz3MinNAvdH83upzQmyVNpB2I+leUi5FySvqwUwj7SNdkq54
         wlfg==
X-Gm-Message-State: AOAM531myPUX/jEGmFTTavCQaVKnpHb/e0GOBo+yGAnXi+6xThLyocub
        bl+xNQNRafrhmTRA1Li4RyA=
X-Google-Smtp-Source: ABdhPJzTAyqu8BwO9Jqz/uy/mEMeyQfwxLO+YJa3fbzqfIkElMEixXPw/VtESE7a8TnS1nm/F65ucA==
X-Received: by 2002:a65:6d89:: with SMTP id bc9mr1102494pgb.260.1643245827654;
        Wed, 26 Jan 2022 17:10:27 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id y42sm3563617pfa.5.2022.01.26.17.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 17:10:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net 0/2] ipv4: less uses of shared IP generator
Date:   Wed, 26 Jan 2022 17:10:20 -0800
Message-Id: <20220127011022.1274803-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We keep receiving research reports based on linux IPID generation.

Before breaking part of the Internet by switching to pure
random generator, this series reduces the need for the
shared IP generator for TCP sockets.

v2: fix sparse warning in the first patch.

Eric Dumazet (2):
  ipv4: tcp: send zero IPID in SYNACK messages
  ipv4: avoid using shared IP generator for connected sockets

 include/net/ip.h     | 21 ++++++++++-----------
 net/ipv4/ip_output.c | 11 +++++++++--
 2 files changed, 19 insertions(+), 13 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

