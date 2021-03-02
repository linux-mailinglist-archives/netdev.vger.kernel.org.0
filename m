Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AC332B37C
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352650AbhCCD73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 22:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241088AbhCBK6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 05:58:12 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F23C061756
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 02:57:28 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id g4so13619158pgj.0
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 02:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hYj3GVf2GPOHptsVgB9F7fXPBzzvrcZU/22s5yQBMro=;
        b=ZCWKLorE/WPSpPGyQ0YE6zPXlW4zfD32A/1SMVa0A395ibWC0ZK3PQyDNxH7Z75dxw
         ZJsV2RW1U2FDgArt1DqeER4aKqJUf0Ilfvzq6X3wL1P2NyiNqeH4t3DcJt9tmqMGzSyr
         ukNYiStROrhfySMZw4m9EXlhcWdODkc6jKs3S2dWWgdenJERVI530l78yFURzqMKlwOS
         2RwMoEbdtrZiOJrjoPQ1FktJvMM+1qFJro+0hiHr7IY1HLrH+Yj+xboZYh3ZeTThOTiS
         VtJ52ZQhCA/BICp5DqDt4mXi7TSgf8N2UASI4sFT1zGLeNYEzwUAyVPVibu5eYG6zsr+
         8YOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hYj3GVf2GPOHptsVgB9F7fXPBzzvrcZU/22s5yQBMro=;
        b=nbZooHYxmbm29lOmp6sYFr3gb/3COOe3WKTEqdNoUF852EaNWrKXfNFcDdEPZJ3+MT
         DLWcaY5aR42/1hmRPP0I9q4UajWI27WkT7CTaiv13mbf+myqQbGkrFy/TnHvVt7n+HlM
         DXIoE7O1HRLnJ1e8nK0Eyt6eDVo/HspzK/I+luvgcPOPrlw2lPOAkFMkV5zfJAtHpg6L
         X9kTrgx2Yd9xfO2aWlA6Ec05ryTnl2qi7Tg9xUk5n3dkPiybfXSLZh7DJG8LrUIsmcwK
         A4pc+XgHB0GHXJ46pBywlCAbi6j+CFZP16akOmVn8v5SHZ1FFt96yad2/soWvIGM/eE8
         1XZA==
X-Gm-Message-State: AOAM5333B34R0PBWfRoDGtaX9vVtmMiQyuM7QMDtO42BaHNv08bqcRXe
        CXkhvamr/aWlnJIhL3h4CYYA6sl/ipW1RmkkNfImppFxl65cXw==
X-Google-Smtp-Source: ABdhPJzb7twexornaVe2siO3ykjGT96ad0UcT0+8qH/HeyfQcvSRcWJWmK29qq5bMGQ4yKgKrAK4ZARVia0CcyGnan0=
X-Received: by 2002:a63:fa52:: with SMTP id g18mr17617289pgk.193.1614682647710;
 Tue, 02 Mar 2021 02:57:27 -0800 (PST)
MIME-Version: 1.0
From:   Greesha Mikhalkin <grigoriymikhalkin@gmail.com>
Date:   Tue, 2 Mar 2021 11:57:16 +0100
Message-ID: <CADbyt64e2cmQzZTEg3VoY6py=1pAqkLDRw+mniRdr9Rua5XtgQ@mail.gmail.com>
Subject: VRF leaking doesn't work
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi. I need a help to understand why VRF leaking doesn=E2=80=99t work in my =
situation.
I want to set up leaking between 2 VRFs, that are set up by following comma=
nds:

      # Setup bridge
      sudo ip link add bridge type bridge

      # Setup VLANs
      ip link add link bridge name vlan1 type vlan id 1
      ip link add link bridge name vlan2 type vlan id 2
      ip addr add 10.0.0.31/32 dev vlan1
      ip addr add 10.0.0.32/32 dev vlan2
      ip link set vlan1 up
      ip link set vlan2 up

      # Setup VXLANs
      ip link add vni1 type vxlan id 1 local 10.1.0.1 dev lan1 srcport
0 0 dstport 4789 nolearning
      ip link add vni2 type vxlan id 2 local 10.1.0.1 dev lan1 srcport
0 0 dstport 4789 nolearning
      ip link set vni1 master bridge
      ip link set vni2 master bridge
      bridge vlan add dev vni1 vid 1 pvid untagged
      bridge vlan add dev vni2 vid 2 pvid untagged
      ip link set vni1 up
      ip link set vni2 up

      # Setup VRFs
      ip link add vrf1 type vrf table 1000
      ip link set dev vrf1 up
      ip link add vrf2 type vrf table 1001
      ip link set dev vrf2 up

    Setting routes:

      # Unreachable default routes
      ip route add table 1000 unreachable default metric 4278198272
      ip route add table 1001 unreachable default metric 4278198272

      # Nexthop
      ip route add table 1000 100.255.254.3 proto bgp metric 20
nexthop via 10.0.0.11 dev vlan1 weight 1 onlink

I'm trying to setup VRF leaking in following way:

      ip r a vrf vrf2 100.255.254.3/32 dev vrf1
      ip r a vrf vrf2 10.0.0.31/32 dev vrf1
      ip r a vrf vrf1 10.0.0.32/32 dev vrf2

Main goal is that 100.255.254.3 should be reachable from vrf2. But
after this setup it doesn=E2=80=99t work. When i run `ping -I vrf2
100.255.254.3` it sends packets from source address that belongs to
vlan1 enslaved by vrf1. I can see in tcpdump that ICMP packets are
sent and then returned to source address but they're not returned to
ping command for some reason. To be clear `ping -I vrf1 =E2=80=A6` works fi=
ne.
