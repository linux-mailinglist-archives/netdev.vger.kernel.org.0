Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512A19520A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfHTAAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:00:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38012 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbfHTAAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:00:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so1008317wmm.3
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=UiPlS3Af6dra3Bg0L5vbzeqcMQw42VgcrruulFmRWAI=;
        b=esYPNm6JAI/9lFWvr1hJNKmILU/VvZCyG6OfQ17Rb34+iiPM3EmEe0BTkDo864wMcM
         vPw9PBJMPUneUWCKZWvOynxga6VN06Nm1TL7O8I+7YyOlWStpPiajO9Lw6sf8nWigguN
         7FWK0dnJpH2rmfdPbiH3bGYcunlCrxjTKmINpIU/CViGa8v4C0PwvwGJhDDGUGSdvBA6
         VNXqt9Ul5WGJNtaqhPgqX9et2Fzt2ez5QltctWDzZsUd9h1vmKwrAFYxrKwmd8e9Rb/K
         UseItAEYIpgwohsxXPVHmlZILoxOdFr7F+x94HIoOsxFPtrovuYZMiw7EwHgK6K6IqCj
         /Z8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UiPlS3Af6dra3Bg0L5vbzeqcMQw42VgcrruulFmRWAI=;
        b=jRrIl+B+A6idBQkNcOTH4tXa+qLK1gJe8yqG+PrPc96hL1wtCxyVEcP9KFyfssayIn
         BuouYuQMzGmsmYWx1S/aXPPNY5WaSkF+5CxVuX0jQ4641UJ3Q/MeFYJgxqm7udVYFO93
         D+zc+0Jwt2gYC4GYMrQLabc5QZ2O7F0RingzBzlGU1FCSNoyhfVjMoYO5mFoHKx7K9G4
         1LwGTCLfprnAH+my8tK0dG3xelsmKZ1UlmyGsZtzoFvusfbykOOLtKCWR1cXHmuBV+3D
         Zfj52PyX1gDzk4U1Cr9gptEoDtBvZA/M+3ZMbRX2Gt2t4FJ1fuj1F5Kh2goY3p+KI/mI
         LkAA==
X-Gm-Message-State: APjAAAX4ztfh1Lg5uCpihU0kQEKD2j7EKqf2UPXk34TGNvlfetvfgN31
        H4Hyxn/UMEtzSiT0Dm3vqSf7ZJKEtSs=
X-Google-Smtp-Source: APXvYqynoTOKPmoEEwmrvPWhMvQWlP+DpwW7ox7udIQpBeipB7DL8z3V4pQjhPJ1EW8zT+JM4rP0CQ==
X-Received: by 2002:a1c:1a56:: with SMTP id a83mr22308101wma.44.1566259207196;
        Mon, 19 Aug 2019 17:00:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id c9sm3814064wrv.40.2019.08.19.17.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 17:00:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/6] Dynamic toggling of vlan_filtering for SJA1105 DSA
Date:   Tue, 20 Aug 2019 02:59:56 +0300
Message-Id: <20190820000002.9776-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset addresses a few limitations in DSA and the bridge core
that made it impossible for this sequence of commands to work:

  ip link add name br0 type bridge
  ip link set dev swp2 master br0
  echo 1 > /sys/class/net/br0/bridge/vlan_filtering

Only this sequence was previously working:

  ip link add name br0 type bridge vlan_filtering 1
  ip link set dev swp2 master br0

On SJA1105, the situation is further complicated by the fact that
toggling vlan_filtering is causing a switch reset. However, the hardware
state restoration logic is already there in the driver. It is a matter
of the layers above which need a few fixups.

Also see this discussion thread:
https://www.spinics.net/lists/netdev/msg581042.html

Patch 1/6 is not functionally related but also related to dsa_8021q
handling of VLANs and this is a good opportunity to bring up the subject
for discussion.

Vladimir Oltean (6):
  net: dsa: tag_8021q: Future-proof the reserved fields in the custom
    VID
  net: bridge: Populate the pvid flag in br_vlan_get_info
  net: dsa: Delete the VID from the upstream port as well
  net: dsa: Don't program the VLAN as pvid on the upstream port
  net: dsa: Allow proper internal use of VLANs
  net: dsa: tag_8021q: Restore bridge pvid when enabling vlan_filtering

 net/bridge/br_vlan.c |  2 ++
 net/dsa/port.c       | 10 ++--------
 net/dsa/slave.c      |  8 ++++++++
 net/dsa/switch.c     | 25 +++++++++++++++++++++----
 net/dsa/tag_8021q.c  | 34 +++++++++++++++++++++++++++++++++-
 5 files changed, 66 insertions(+), 13 deletions(-)

-- 
2.17.1

