Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5617D23A092
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgHCICh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgHCICh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 04:02:37 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712A9C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 01:02:37 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d188so11672858pfd.2
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 01:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=opN96iAr4vvu6LcPzkHIbk7cQ+LqOHGzWP9skcQO174=;
        b=aH+9s1Z5qXSkCwBmFf0XMVvuEVYqXTxVAHJ2I/SAFsg/IJkmDx3qv4668OaK+hJO8c
         yOwKi04IHS/dGb4KayOW8LkZko202kHidzuTNJ/396A2/rxwS4UYh5nxe62ZNWZGbYVK
         tFWb+Ahc9gi7ymSFgnIvQdXS8YTNMafS5p/+9/0FTvJDZo0HDNl1dV/tPgus3BaO6n0f
         tmGZgd7zGRbpERKyguvRRBZPLhxvodjwfbONtuSqzbrtNs/hU001sFnB432zyW5uZblK
         JZJJ4aJabL3DBaEU0Dr1y5z5+nGKQbbZbhl/qucgaLM5HiF0DDuAsWyEIxDPTdD2GWnw
         5OgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=opN96iAr4vvu6LcPzkHIbk7cQ+LqOHGzWP9skcQO174=;
        b=kB6fwOpcPyutfmXoNz/QPsmVRw0BXfJplB17JWI0PSq7sa/MINjWoHZrZ+mluyhS2Y
         cQ6v+7uu35vG6q8tqflfZ4kCpJ8vJfkSU/Za3wVGPlAG9MTb+8hWKXZuRZHB3DRi6VZ0
         by4xtlBNwbD5BVkS0leHVr0dlJJInSa7hyT/oZIn0m7PCWfwiAgBdpaQOdDw+ydcFc7j
         mj7glPVoFqtDEtFZjeMA+OAroGP4xt3aqN/xLEofvgwzcNsxOi4SKcAqPB1Pk2fb4UAt
         tBvibEjRPKKiVmFAE9KEJSGSj/ZTFZ4ddjLAIAqdrBAPAsFdt095fytxuKN1NRmvMolk
         AkIQ==
X-Gm-Message-State: AOAM532632enxK2cLm6OdebcFQwOVtXrAbnZTxqIipunvhCypRy5yFS4
        EIMFxmpELcAHJeH0j3/LoK2yjz9nKter4A==
X-Google-Smtp-Source: ABdhPJx9PJGRLd0SoaoYT/0FdASPBRpg++CKjdYlTblTYtRUnGHFPW9mVS/2vKxmEW8LYWJCYmAXBQ==
X-Received: by 2002:a62:2c48:: with SMTP id s69mr14422593pfs.63.1596441756779;
        Mon, 03 Aug 2020 01:02:36 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a24sm18651674pfg.113.2020.08.03.01.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 01:02:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 0/2] Add IP_DSCP_MASK and fix vxlan tos value before xmit
Date:   Mon,  3 Aug 2020 16:02:15 +0800
Message-Id: <20200803080217.391850-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is aim to update the old IP_TOS_MASK to new IP_DSCP_MASK
as tos value has been obsoleted for a long time. But to make sure we don't
break any existing behaviour, we can't just replease all IP_TOS_MASK
to new IP_DSCP_MASK.

So let's update it case by case. The first issue we will fix is that vxlan
is unable to take the first 3 bits from DSCP field before xmit. Use the
new RT_DSCP() would resolve this.

Hangbin Liu (2):
  net: add IP_DSCP_MASK
  vxlan: fix getting tos value from DSCP field

 drivers/net/vxlan.c           | 4 ++--
 include/uapi/linux/in_route.h | 1 +
 include/uapi/linux/ip.h       | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.25.4

