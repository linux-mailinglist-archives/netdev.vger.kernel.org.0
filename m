Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E446344E65
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhCVSVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhCVSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:21:23 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864DEC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 11:21:22 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r12so22880037ejr.5
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 11:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bAKm4lOGYaNlnuE1ZmImv7GP9oc+Qs5InjcvoRmOmxI=;
        b=N1DCjsQPD7s4miSn3AeCdoTCZdE4HUw5Bx6ljZm0zXAxZLvjtp6tx5OKtvnbvaZACG
         MhzfOhm1eLnEgVfgVminLVua/ygDxz1Ya3pJGJ+7/BPZgeXgKJorgvvTXN+2WD/qQCDC
         HS9oagNzzsGGs7yD3CBABYTwfZuvjdEthySaPINEFk6O1WZnnQr1xBpB60zMVUKA9Tu9
         D3odUhZB/P4TbChM1y0fhF5FFS3ci2xUErBQvw+IeyCVwrxmLuKPxeyx08ihbz7itX4Q
         i+D6AetQwZT68UFQL9Qk6xRprz2EkzyKAFLtwi0q0mUaNfmWxQFkde2N1ST6INQH8osb
         vY/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bAKm4lOGYaNlnuE1ZmImv7GP9oc+Qs5InjcvoRmOmxI=;
        b=HvEQCeMFIWA3u7QHr2M/bW+Dk51gFZn+bAM0Bcf5oo+jnbofzEuQGvcnHKTQsNhdAs
         p/IcO8OPh8a86FITJJVfyF5XAogO3TuZaNaFy/KOQDRs6jsBMXcIKbNrVVeCTrqsDUxt
         61Nz0g+MfzdhH3wLyYiNVapE2txIbObWjEMNPk/rbPTZ+PKZFmEqzU1TiuvDSoVoFfhA
         7MvzQcCxy3MA/TC6wc7Ijky0q/hAj8EY46WCFV0VasAF5ovGpZu3zJFD/lCUwY3wIZ82
         SBNwhZ8bpA05zG961I1Qm7v6kznwXJG/bTgM9Qw9NS/ONWT44b5WeI6J5wJBSrbahjVS
         ZkXQ==
X-Gm-Message-State: AOAM531cpyAZ7/JtJ0ZbW5s57vvc6Uk0u2yKYZEIn1ZETYF5140+oanq
        nwTb1RZCAji1L9CMCKRWfZI=
X-Google-Smtp-Source: ABdhPJwZcwSwexbvaNaqvHOEUPXHH6xNmVaMbvUlaHO36q8ZEpNf7FFuKPQKErK1J7gLHHsSFz8Nqw==
X-Received: by 2002:a17:907:20b7:: with SMTP id pw23mr1141895ejb.168.1616437281306;
        Mon, 22 Mar 2021 11:21:21 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id hd37sm9624587ejc.114.2021.03.22.11.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:21:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: bridge: don't notify switchdev for local FDB addresses
Date:   Mon, 22 Mar 2021 20:21:08 +0200
Message-Id: <20210322182108.4121827-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As explained in this discussion:
https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/

the switchdev notifiers for FDB entries managed to have a zero-day bug.
The bridge would not say that this entry is local:

ip link add br0 type bridge
ip link set swp0 master br0
bridge fdb add dev swp0 00:01:02:03:04:05 master local

and the switchdev driver would be more than happy to offload it as a
normal static FDB entry. This is despite the fact that 'local' and
non-'local' entries have completely opposite directions: a local entry
is locally terminated and not forwarded, whereas a static entry is
forwarded and not locally terminated. So, for example, DSA would install
this entry on swp0 instead of installing it on the CPU port as it should.

There is an even sadder part, which is that the 'local' flag is implicit
if 'static' is not specified, meaning that this command produces the
same result of adding a 'local' entry:

bridge fdb add dev swp0 00:01:02:03:04:05 master

I've updated the man pages for 'bridge', and after reading it now, it
should be pretty clear to any user that the commands above were broken
and should have never resulted in the 00:01:02:03:04:05 address being
forwarded (this behavior is coherent with non-switchdev interfaces):
https://patchwork.kernel.org/project/netdevbpf/cover/20210211104502.2081443-1-olteanv@gmail.com/
If you're a user reading this and this is what you want, just use:

bridge fdb add dev swp0 00:01:02:03:04:05 master static

Because switchdev should have given drivers the means from day one to
classify FDB entries as local/non-local, but didn't, it means that all
drivers are currently broken. So we can just as well omit the switchdev
notifications for local FDB entries, which is exactly what this patch
does to close the bug in stable trees. For further development work
where drivers might want to trap the local FDB entries to the host, we
can add a 'bool is_local' to br_switchdev_fdb_call_notifiers(), and
selectively make drivers act upon that bit, while all the others ignore
those entries if the 'is_local' bit is set.

Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index b89503832fcc..1e24d9a2c9a7 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -128,6 +128,8 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 {
 	if (!fdb->dst)
 		return;
+	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
+		return;
 
 	switch (type) {
 	case RTM_DELNEIGH:
-- 
2.25.1

