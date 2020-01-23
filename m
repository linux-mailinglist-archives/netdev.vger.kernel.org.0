Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C6146905
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 14:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgAWN2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 08:28:17 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44255 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgAWN2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 08:28:17 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so2246214lfa.11
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 05:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lW472399iAATdZUH6brslOgK+ubydfGqN4ZbFSeA9SE=;
        b=LYDkLAitkc8jMhqsrjA/I9/1TucWGtQXhpZVkc+yfh8sywXR9dU9JnFjDA9RW82LSN
         9xtQ3jsSaLQ4UN/a7ho6Gtj8kitQIA6bdfmQHaFbXxj2DiMZgOcz9v69Oa0azfHKVO4B
         nyDB8+0P81BIZROb5p8Lcy34i/JcAH52mdnZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lW472399iAATdZUH6brslOgK+ubydfGqN4ZbFSeA9SE=;
        b=VZHsPXV7dwJwjyanKWvpujBDZhI17SxOAIbuQST/YW47Z7axrUtNppRQydKLzLLlTJ
         lIpzu5J1hRdj93RB++XTxx0/u4LC9zxBpCrVU0K9o3oP7Nsfk2cKMezaY7lN4HAdkZU2
         03wAZNrM4RBLS8tp2G5Q3z9+ZF9CXkh0z+iM7hLbQNkT/XeJz/kI9qZVNAzHplaH72as
         khGLJWDMTTC7TGhhZ2xm6CWnrMz732loqQv9d7kcUwaMAXJ0HjAmJBuUDTGflo5ZiARz
         p7nx31V82RQkv7wzuLLbl9YelP0WOTSxBJPy+tjGbI5goOQOXmrIUz4jX+jb4cCEUIiW
         dsMg==
X-Gm-Message-State: APjAAAVuWnYWUv+4DBkJmLEGVp5Kyw1+h/bZYWrlKQ2e1jCww20tQWNk
        f9fQx/4IRAn4A4VFjEhYYzXz9NNTwss=
X-Google-Smtp-Source: APXvYqyyZL6p7TqB1v8mg80ofb9yoPWpaLKaUXsFgwiPUdCf4gkixbCaPH7sHipLBYLhIRwG6Vyr9Q==
X-Received: by 2002:ac2:5ec3:: with SMTP id d3mr286789lfq.176.1579786095266;
        Thu, 23 Jan 2020 05:28:15 -0800 (PST)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id b20sm1238571ljp.20.2020.01.23.05.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 05:28:14 -0800 (PST)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/4] net: bridge: add per-vlan state option
Date:   Thu, 23 Jan 2020 15:28:03 +0200
Message-Id: <20200123132807.613-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This set adds the first per-vlan option - state, which uses the new vlan
infrastructure that was recently added. It gives us forwarding control on
per-vlan basis. The first 3 patches prepare the vlan code to support option
dumping and modification. We still compress vlan ranges which have equal
options, each new option will have to add its own equality check to
br_vlan_opts_eq(). The vlans are created in forwarding state by default to
be backwards compatible and vlan state is considered only when the port
state is forwarding (more info in patch 4).
I'll send the selftest for the vlan state with the iproute2 patch-set.

Thanks,
 Nik

Nikolay Aleksandrov (4):
  net: bridge: check port state before br_allowed_egress
  net: bridge: vlan: add basic option dumping support
  net: bridge: vlan: add basic option setting support
  net: bridge: vlan: add per-vlan state

 include/uapi/linux/if_bridge.h |   2 +
 net/bridge/Makefile            |   2 +-
 net/bridge/br_device.c         |   3 +-
 net/bridge/br_forward.c        |   2 +-
 net/bridge/br_input.c          |   7 +-
 net/bridge/br_private.h        |  58 +++++++++++++-
 net/bridge/br_vlan.c           |  99 ++++++++++++++++++-----
 net/bridge/br_vlan_options.c   | 142 +++++++++++++++++++++++++++++++++
 8 files changed, 287 insertions(+), 28 deletions(-)
 create mode 100644 net/bridge/br_vlan_options.c

-- 
2.21.0

