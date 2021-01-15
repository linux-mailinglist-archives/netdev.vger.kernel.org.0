Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63B62F7590
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbhAOJhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbhAOJhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:37:20 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF9FC061757;
        Fri, 15 Jan 2021 01:36:48 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id h10so5122750pfo.9;
        Fri, 15 Jan 2021 01:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oQuCRraIOONShH3gahP+F3g5+Izjro2CjckT3O7EKOk=;
        b=UTxOZnZ+Eu79NIc7PrSn+BlK+2312BNfCb/he0kwZyatS/4gLKczdAEepS5MnF+Nm7
         ol9RuFlQI30jyokX3lrFQNFHw4JgneB22pjGM/kA4XY85q2qL7lRPCQ1MvSZmmRSScr8
         d2ky8y2pL2Sdek0iSIZ11gxfyEHlArezKZETxKZ7G6gKfRrPqvqHQWFCGznJiG/PrIE9
         +EeNbejgIdK+usHGG0lSxx998CkjMQdFn8Ezegq9sRL5sNmBIM5SHApmqaWpQo901F7X
         BW2tFWQgl8bRQfB/iHpWbftjhWb6N87AIdmLdo2yGdkprijLbumGBHdvIafeHxh2SPj/
         +zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oQuCRraIOONShH3gahP+F3g5+Izjro2CjckT3O7EKOk=;
        b=F4EqxK4n7FzZp0mNzqME2pWHeJw980ItHiHtQD1Tb3+JG2Qtgl72k0tOgGYU7iD0eT
         ZKoS713jqc+3IYEZWTbc1lQe2e++4KSYZ4Fo+BNHF4PEXRY9tXQNJ/bAOQPAA3/aVt3S
         B6CK8kI4rDvswUFcbEmKUU33ri5IpWx531RyriF77JeatPH4wz7Zs9aDIdc4Ai0rY2w+
         sO4fW8vxfZpy+vYalskzVTqHvl2XOrGFFJUvPuk+rwtc0p3OI2MpWi/dpl/imb8Hgpso
         t1r4lI7HVkfIHSGJy8Cnl0NkOtVk1W9oz1uM4AKTirmTXlikFsh1z3yexdSSgRSuvg9+
         Yc4Q==
X-Gm-Message-State: AOAM530u1mEnP1wKloBFf9wLIdbVKophJjH++V01OTpucjnjVwUJgRH9
        WmZzqxQL1ARY7RkZdGJeETlrq6QOYdVsIg==
X-Google-Smtp-Source: ABdhPJyQ4bYoeVCq7tUu3FhK8vLK3g96Ji01h/Zii5PvzKXFb1KlgJVI/Lmne+dESvdGYDIcyIhxSA==
X-Received: by 2002:a63:752:: with SMTP id 79mr11611413pgh.272.1610703407210;
        Fri, 15 Jan 2021 01:36:47 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z15sm7331032pfn.34.2021.01.15.01.36.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 01:36:46 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv3 net-next 0/2] net: fix the features flag in sctp_gso_segment
Date:   Fri, 15 Jan 2021 17:36:37 +0800
Message-Id: <cover.1610703289.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1/2 is to improve the code in skb_segment(), and it is needed
by Patch 2/2.

v1->v2:
  - see Patch 1/2.
v2->v3:
  - change Patch 2/2 to the right patch.

Xin Long (2):
  net: move the hsize check to the else block in skb_segment
  sctp: remove the NETIF_F_SG flag before calling skb_segment

 net/core/skbuff.c  | 11 ++++++-----
 net/sctp/offload.c |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.1.0

