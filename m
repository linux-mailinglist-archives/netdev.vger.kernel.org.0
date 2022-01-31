Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDFF4A4ADB
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379795AbiAaPrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359646AbiAaPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:47:06 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97091C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:05 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f10so1216577lfu.8
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=6M2X69Hd7uZi6fdki1j3o9xgw/QMymlrIfHzRngcXRc=;
        b=dYU7bbOX70JlaAur732Yln/Nv66hZCgzcNXOfUnoabTktpj81j3p2A2kVmYS6UXurJ
         8w/4CJNWKDwHBdwzS/N1HD+RwlFqjkB8Jeov0jZvyHvXvVlS3Fr4h90Op/d4/4OFypDR
         0Xpq/jHjKz68yHDXHFTnz3m+7AoL4pO7IGqDsZUeMYHVJQKxaD3OBVTbLiegc5HS+MX5
         UfuXXLsbsKkBv07ipbShDwKna72dvAG/fNwfxaIyPDdwUP2BY/3sar7s3kw6D0RMYSYl
         zeErevO4ZAOVK2m245KhHIhfSeZ+pb9GpNV8RrOy0/G7MvY9p7neYr/Dq65ADgjHz8D+
         DGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=6M2X69Hd7uZi6fdki1j3o9xgw/QMymlrIfHzRngcXRc=;
        b=LfULsFa0A33+zOz/ABbD+5M9By4hpEewbrAW9UFFe1VElGmfpmODobLpSO9W9G4a34
         YWCOscFYtiFORiOno5uwg2/eNwSQ7RssQPaf2aJBH71O3knoPsIRpSycHXiLiTloCs1B
         ovk+58dwV3rWQ6XrRsnYOMzMvHll5+fWj4NmmRoKaLsZBTqRR3/+pWFtN1ELSOJsEw8V
         DCYShv40Ac5IhLDm7BTmZorp7h5FIIP55fviTwUt6SesaCTTM+A9zuVP4gw7hwJGwsxx
         XBunNbOvtGdk2sciKy6LVL37ro2fvS16DFbHlFbK6z7b4n5KOq35IjwDjbIXOGiWVFhR
         +RlA==
X-Gm-Message-State: AOAM531WuEYSal5ULElbW/ncxCrS7YvBMzKapBSdI9XXMHR+zw4a7pTz
        DnYTfoooe/59exA0nbkRwGq7yv8T+3HttQ==
X-Google-Smtp-Source: ABdhPJwLqsOXjkBCBsjQkcBoHE+lpuDUr23KW+vsDQHb2AySR8l5Ygf85BKF864XJhEi/JFxDEl9JA==
X-Received: by 2002:a05:6512:c09:: with SMTP id z9mr15828223lfu.147.1643644023592;
        Mon, 31 Jan 2022 07:47:03 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y36sm3374769lfa.82.2022.01.31.07.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:47:03 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/5] net: dsa: mv88e6xxx: Improve standalone port isolation
Date:   Mon, 31 Jan 2022 16:46:50 +0100
Message-Id: <20220131154655.1614770-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ideal isolation between standalone ports satisfies two properties:
1. Packets from one standalone port must not be forwarded to any other
   port.
2. Packets from a standalone port must be sent to the CPU port.

mv88e6xxx solves (1) by isolating standalone ports using the PVT. Up
to this point though, (2) has not guaranteed; as the ATU is still
consulted, there is a chance that incoming packets never reach the CPU
if its DA has previously been used as the SA of an earlier packet (see
1/5 for more details). This is typically not a problem, except for one
very useful setup in which switch ports are looped in order to run the
bridge kselftests in tools/testing/selftests/net/forwarding. This
series attempts to solve (2).

Ideally, we could simply use the "ForceMap" bit of more modern chips
(Agate and newer) to classify all incoming packets as MGMT. This is
not available on older silicon that is still widely used (Opal Plus
chips like the 6097 for example).

Instead, this series takes a two pronged approach:

1/5: Always clear MapDA on standalone ports to make sure that no ATU
     entry can lead packets astray. This solves (2) for single-chip
     systems.

2/5: Trivial prep work for 4/5.
3/5: Trivial prep work for 4/5.

4/5: On multi-chip systems though, this is not enough. On the incoming
     chip, the packet will be forced out towards the CPU thanks to
     1/5, but on any intermediate chips the ATU is still consulted. We
     override this behavior by marking the reserved standalone VID (0)
     as a policy VID, the DSA ports' VID policy is set to TRAP. This
     will cause the packet to be reclassified as MGMT on the first
     intermediate chip, after which it's a straight shot towards the
     CPU.

Finally, we allow more tests to be run on mv88e6xxx:

5/5: The bridge_vlan{,un}aware suites sets an ageing_time of 10s on
     the bridge it creates, but mv88e6xxx has a minimum supported time
     of 15s. Allow this time to be overridden in forwarding.config.

With this series in place, mv88e6xxx passes the following kselftest
suites:

- bridge_port_isolation.sh
- bridge_sticky_fdb.sh
- bridge_vlan_aware.sh
- bridge_vlan_unaware.sh

Tobias Waldekranz (5):
  net: dsa: mv88e6xxx: Improve isolation of standalone ports
  net: dsa: mv88e6xxx: Support policy entries in the VTU
  net: dsa: mv88e6xxx: Enable port policy support on 6097
  net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
  selftests: net: bridge: Parameterize ageing timeout

 drivers/net/dsa/mv88e6xxx/chip.c              | 96 ++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/chip.h              |  1 +
 drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c       |  5 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  7 +-
 drivers/net/dsa/mv88e6xxx/port.h              |  2 +-
 include/net/dsa.h                             | 12 +++
 .../net/forwarding/bridge_vlan_aware.sh       |  5 +-
 .../net/forwarding/bridge_vlan_unaware.sh     |  5 +-
 .../net/forwarding/forwarding.config.sample   |  2 +
 tools/testing/selftests/net/forwarding/lib.sh |  1 +
 11 files changed, 103 insertions(+), 34 deletions(-)

-- 
2.25.1

