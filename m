Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0A322FC1
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 18:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233761AbhBWRiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 12:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhBWRij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 12:38:39 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD845C06174A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 09:37:57 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id d8so35842872ejc.4
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 09:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=9XbMkDjLSMbhbuxX/1NLnqQvYfoqxkyWgRlH5OwPMjM=;
        b=ZrqC+6hnA7uBmEAnSWelX4XEsuySwOwqYRq0qbrneFReGNT0g6Fa9b5zvxE/tPO3yG
         W42D0SuOhZ4KaoVToi19f0gPXX/ZrxWOy1xFZ85Xcl1NOzf5/gyRQAhwIWyllxc/bgQe
         YRSeEhpYhVrnNFYEOnSHObyz7OWbASPW+dEgouwrEj4cRAzfclzIAGUCeRpZYj3xpgXz
         I2KsC+qwkNXspBpiF2tdL792eUio+2+5HgUwMKPeEVoEeTtBa/aipbYy+2PSXMkttJIB
         4QgS/rAN+OdELsAfzSHqjlBc5BKhT+CSdNjsKfxwZrv9LUj2AKL8lZUHMGFRz4Yb7IvZ
         07/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9XbMkDjLSMbhbuxX/1NLnqQvYfoqxkyWgRlH5OwPMjM=;
        b=C8B9hGrWfIFnNTkl3NQRp10dZuW73J5pIERkilSFefjCZmpihCPdxZ3rGwPtpuQ3Jz
         wAZ3vhH906nUvK2JDS4eR+SolAkkKIsn55ZIVbdPmaMupln4c1dhHjw79pNuG3gKd53f
         cGdFtt2qQ8wqdPMXZnyaHrLXU0NGhvga+BKRBgoB54YqyhyS0fXOIReE342Y/a0oR+O4
         n+5nwTYD9+CJPD+9JETtyd6KDfs1FnX/rTZ5Cgr0E+RYgjPvcxBS0xVW5d4wI4SegsJd
         ofQQlo0qbdh3d9nCEn7qBgUdsWuaYX5yBleNL6HQcfXY2rWMGBFGesTIX7twjewduhtT
         inag==
X-Gm-Message-State: AOAM532HninJE6nnhbDyuLnUdUQDAOsa8Cq3AzPEUWZr4Ytg9xxLnNnh
        EvY1AL6OELWO4lv1qgUjtX0=
X-Google-Smtp-Source: ABdhPJwOlpr+nTQ+vj41qUXbBp3640cFPhnHt5X/iky1q/1LQQR3Rq5wSAR+NYEVUplBeEYberaqUg==
X-Received: by 2002:a17:906:750:: with SMTP id z16mr15779490ejb.53.1614101876630;
        Tue, 23 Feb 2021 09:37:56 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id t4sm11596553edw.24.2021.02.23.09.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 09:37:55 -0800 (PST)
Date:   Tue, 23 Feb 2021 19:37:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Timing of host-joined bridge multicast groups with switchdev
Message-ID: <20210223173753.vrlxhnj5rtvd6i6g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have udhcpcd in my system and this is configured to bring interfaces
up as soon as they are created.

I create a bridge as follows:

ip link add br0 type bridge

As soon as I create the bridge and udhcpcd brings it up, I have some
other crap (avahi) that starts sending some random IPv6 packets to
advertise some local services, and from there, the br0 bridge joins the
following IPv6 groups:

33:33:ff:6d:c1:9c vid 0
33:33:00:00:00:6a vid 0
33:33:00:00:00:fb vid 0

br_dev_xmit
-> br_multicast_rcv
   -> br_ip6_multicast_add_group
      -> __br_multicast_add_group
         -> br_multicast_host_join
            -> br_mdb_notify

This is all fine, but inside br_mdb_notify we have br_mdb_switchdev_host
hooked up, and switchdev will attempt to offload the host joined groups
to an empty list of ports. Of course nobody offloads them.

Then when we add a port to br0:

ip link set swp0 master br0

the bridge doesn't replay the host-joined MDB entries from br_add_if ->
new_nbp -> br_multicast_add_port (should it?), and eventually the host
joined addresses expire, and a switchdev notification for deleting it is
emitted, but surprise, the original addition was already completely missed.

What to do?

Thanks,
-Vladimir
