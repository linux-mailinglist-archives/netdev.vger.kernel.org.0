Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B91497DF
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgAYVBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 16:01:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37039 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbgAYVBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 16:01:16 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so2914508wmf.2
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 13:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M9IPfs5j3ZDkDpdM61Uw72fBZuLjkHeNFMv8EJnnzwA=;
        b=FeNXEGEsCba0d8t0bPM2fJo+Vb87pqO7UNwilgMeL6I96Okyt/rBOPs0gHzDFoSnRM
         MXYtgc5HWZRjy18+Ab0HI4pUR/kTUumI1wDGGR6IYyNczDg0e+omLOaC6BDjPKp9o5uf
         PIxWJNDM6H980f3LrK5dviTPfAFVEwPK4u1cfQkUB4okzuhLL6jBMfsTv3fFUHuDOVsm
         g4hOraSbUJi9Sa47NoBIBAKNHMWVG81wuMHfdNIvSWQ3Pr11ceWIP+bHU/B/nuj+7ZH0
         UJJxVMz8zg8FrW2qzKN1bauG3dFLSxeA7mQ11wxpNTmczILOa5wRzR3lMDSsRjczXzlN
         T11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M9IPfs5j3ZDkDpdM61Uw72fBZuLjkHeNFMv8EJnnzwA=;
        b=OCVGBdUoKpF/pEnKZBrtU1gQLIHq/bW+CAAjCuBajsTGAdtdKgX/UnE0JsmAGIrzB/
         NW0r1XK1539wVQ8cw97vSDiaB70F5NgIFnP8PgDdI9RhbEivkORPyZpK8nEftdsxF1L0
         AgjftrZpWDOnddvwEw/ncyzoj/Z2oVdluW3SD5Xe5062TGrN4a1i5Wc7CJb72qXRebsl
         WpmhoCsjU+sEGrrqP+sZ2HFFrU4ypHha8ssp6/e847WkwJNrW5+OiEUbvbFUrbleJH3W
         Jr0O9equuMWhvzBTArH93u0yk4WeX30EQ5cjj5Qa1WsESUccesdzsh23zqYKEH6zcCyF
         anGQ==
X-Gm-Message-State: APjAAAXrMrZ4tWudtroRqp1gv/XwggPE3Uo6ucaGTGYCHjD5EXsN4K4p
        SDSDisjvYC6Tehr01kRC//8=
X-Google-Smtp-Source: APXvYqxT90OGr6Fiyku937kfHibgh24BTIY6xeTxquUq2zPN+JEWMY7WAHTw7f4V20RAWZZXLCRkCw==
X-Received: by 2002:a1c:b607:: with SMTP id g7mr5661232wmf.110.1579986073782;
        Sat, 25 Jan 2020 13:01:13 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id 25sm11667448wmi.32.2020.01.25.13.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 13:01:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: dsa: Fix use-after-free in probing of DSA switch tree
Date:   Sat, 25 Jan 2020 23:01:11 +0200
Message-Id: <20200125210111.22058-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA sets up a switch tree little by little. Every switch of the N
members of the tree calls dsa_register_switch, and (N - 1) will just
touch the dst->ports list with their ports and quickly exit. Only the
last switch that calls dsa_register_switch will find all DSA links
complete in dsa_tree_setup_routing_table, and not return zero as a
result but instead go ahead and set up the entire DSA switch tree
(practically on behalf of the other switches too).

The trouble is that the (N - 1) switches don't clean up after themselves
after they get an error such as EPROBE_DEFER. Their footprint left in
dst->ports by dsa_switch_touch_ports is still there. And switch N, the
one responsible with actually setting up the tree, is going to work with
those stale dp, dp->ds and dp->ds->dev pointers. In particular ds and
ds->dev might get freed by the device driver.

Be there a 2-switch tree and the following calling order:
- Switch 1 calls dsa_register_switch
  - Calls dsa_switch_touch_ports, populates dst->ports
  - Calls dsa_port_parse_cpu, gets -EPROBE_DEFER, exits.
- Switch 2 calls dsa_register_switch
  - Calls dsa_switch_touch_ports, populates dst->ports
  - Probe doesn't get deferred, so it goes ahead.
  - Calls dsa_tree_setup_routing_table, which returns "complete == true"
    due to Switch 1 having called dsa_switch_touch_ports before.
  - Because the DSA links are complete, it calls dsa_tree_setup_switches
    now.
  - dsa_tree_setup_switches iterates through dst->ports, initializing
    the Switch 1 ds structure (invalid) and the Switch 2 ds structure
    (valid).
  - Undefined behavior (use after free, sometimes NULL pointers, etc).

Real example below (debugging prints added by me, as well as guards
against NULL pointers):

[    5.477947] dsa_tree_setup_switches: Setting up port 0 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.313002] dsa_tree_setup_switches: Setting up port 1 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.319932] dsa_tree_setup_switches: Setting up port 2 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.329693] dsa_tree_setup_switches: Setting up port 3 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.339458] dsa_tree_setup_switches: Setting up port 4 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.349226] dsa_tree_setup_switches: Setting up port 5 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.358991] dsa_tree_setup_switches: Setting up port 6 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.368758] dsa_tree_setup_switches: Setting up port 7 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.378524] dsa_tree_setup_switches: Setting up port 8 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.388291] dsa_tree_setup_switches: Setting up port 9 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.398057] dsa_tree_setup_switches: Setting up port 10 of switch ffffff803df0b980 (dev ffffff803f775c00)
[    6.407912] dsa_tree_setup_switches: Setting up port 0 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.417682] dsa_tree_setup_switches: Setting up port 1 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.427446] dsa_tree_setup_switches: Setting up port 2 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.437212] dsa_tree_setup_switches: Setting up port 3 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.446979] dsa_tree_setup_switches: Setting up port 4 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.456744] dsa_tree_setup_switches: Setting up port 5 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.466512] dsa_tree_setup_switches: Setting up port 6 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.476277] dsa_tree_setup_switches: Setting up port 7 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.486043] dsa_tree_setup_switches: Setting up port 8 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.495810] dsa_tree_setup_switches: Setting up port 9 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.505577] dsa_tree_setup_switches: Setting up port 10 of switch ffffff803da02f80 (dev 0000000000000000)
[    6.515433] dsa_tree_setup_switches: Setting up port 0 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.354120] dsa_tree_setup_switches: Setting up port 1 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.361045] dsa_tree_setup_switches: Setting up port 2 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.370805] dsa_tree_setup_switches: Setting up port 3 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.380571] dsa_tree_setup_switches: Setting up port 4 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.390337] dsa_tree_setup_switches: Setting up port 5 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.400104] dsa_tree_setup_switches: Setting up port 6 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.409872] dsa_tree_setup_switches: Setting up port 7 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.419637] dsa_tree_setup_switches: Setting up port 8 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.429403] dsa_tree_setup_switches: Setting up port 9 of switch ffffff803db15b80 (dev ffffff803d8e4800)
[    7.439169] dsa_tree_setup_switches: Setting up port 10 of switch ffffff803db15b80 (dev ffffff803d8e4800)

The solution is to recognize that the functions that call
dsa_switch_touch_ports (dsa_switch_parse_of, dsa_switch_parse) have side
effects, and therefore one should clean up their side effects on error
path. The cleanup of dst->ports was taken from dsa_switch_remove and
moved into a dedicated dsa_switch_release_ports function, which should
really be per-switch (free only the members of dst->ports that are also
members of ds, instead of all switch ports).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Sadly I really have no clue how/if this was supposed to work, and I
can't provide a meaningful Fixes: tag. The board I have doesn't appear
to boot on older versions of the kernel if I try to bisect this.

 net/dsa/dsa2.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c6d81f2baf4e..e7c30b472034 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -849,6 +849,19 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 	return dsa_switch_parse_ports(ds, cd);
 }
 
+static void dsa_switch_release_ports(struct dsa_switch *ds)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp, *next;
+
+	list_for_each_entry_safe(dp, next, &dst->ports, list) {
+		if (dp->ds != ds)
+			continue;
+		list_del(&dp->list);
+		kfree(dp);
+	}
+}
+
 static int dsa_switch_probe(struct dsa_switch *ds)
 {
 	struct dsa_switch_tree *dst;
@@ -865,12 +878,17 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 	if (!ds->num_ports)
 		return -EINVAL;
 
-	if (np)
+	if (np) {
 		err = dsa_switch_parse_of(ds, np);
-	else if (pdata)
+		if (err)
+			dsa_switch_release_ports(ds);
+	} else if (pdata) {
 		err = dsa_switch_parse(ds, pdata);
-	else
+		if (err)
+			dsa_switch_release_ports(ds);
+	} else {
 		err = -ENODEV;
+	}
 
 	if (err)
 		return err;
@@ -878,8 +896,10 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 	dst = ds->dst;
 	dsa_tree_get(dst);
 	err = dsa_tree_setup(dst);
-	if (err)
+	if (err) {
+		dsa_switch_release_ports(ds);
 		dsa_tree_put(dst);
+	}
 
 	return err;
 }
@@ -900,15 +920,9 @@ EXPORT_SYMBOL_GPL(dsa_register_switch);
 static void dsa_switch_remove(struct dsa_switch *ds)
 {
 	struct dsa_switch_tree *dst = ds->dst;
-	struct dsa_port *dp, *next;
 
 	dsa_tree_teardown(dst);
-
-	list_for_each_entry_safe(dp, next, &dst->ports, list) {
-		list_del(&dp->list);
-		kfree(dp);
-	}
-
+	dsa_switch_release_ports(ds);
 	dsa_tree_put(dst);
 }
 
-- 
2.17.1

