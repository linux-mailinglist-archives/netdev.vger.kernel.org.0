Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D351711BA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgB0Huh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:37 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:33713 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgB0Hug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:36 -0500
Received: by mail-wr1-f54.google.com with SMTP id u6so2090590wrt.0
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=62h2Qos0JkyPEG/91qBl9dxXB+sEaV/Z7evYm+mnSu8=;
        b=JyTmGhB0X0aTrBtDHUqWRIgEJLgTf5gnqOXGxcjYknxAPyWeFDJac/NloggsJz5w93
         evsIrzdGLNvtBtbZgC/6CmDh7FeoBq8InVsd912k32jCskAHywHODI5rl7pyrr7I/fan
         p0WueKFqe7Q5msG2sbytUQ3dj8KX27IdxeatXYIt2pQYONPWW37Xeh1Z3sCg4YSB9+fs
         cOgtv3VM1N4BTn9F5YaRO/bGTVDnv9g+nV5yaTbavseUs504DPirbDxtL0DFpJ66hBba
         38YqY5xAupwE78p9x4WnPy2esH234sOjEaDl0vvdl3ie62dJ942rxnQMcN9Of8rxEnYs
         GEhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=62h2Qos0JkyPEG/91qBl9dxXB+sEaV/Z7evYm+mnSu8=;
        b=aN1l2/7USyfJ/GbXKmAzWrxITMD0AhjRQew8E/Q3xciMMPjQ8IWpmtb+LNR6D7MHw/
         cd/LhTaIx21PkQWx2hXZp8EVlONfWTrXe14ULZjSuhwzyjNUGOfdTatdkpB4rKk9GdRq
         PjynaNWdQEjPyZVQumFL+s/Zo/q1DHT0lodPdVpv7b69RNBcnC8jWtLg6cdv3UF0NY4u
         lbBHB/QL2Rk46NaVZAhic0h4S7OgHW3puiKf+uyTEW3XjZy7ihEMAUSHlGxEyKXOa5jh
         ++x0HcoI2/Qk1g9wWCfNk6IKrXW05GgmgXzvZQDE+q/xEHIu04xNofTu+0WIlbFnZxkI
         1jDw==
X-Gm-Message-State: APjAAAVBJgk8CmaUim5ZwzNBpf3obQCCGhNcf9651eK7BlWRd8Paw9UM
        sh0Y727KBhJB/tBjmIRL75h7m8Vv8/Y=
X-Google-Smtp-Source: APXvYqweias65DZmyOhFRMTDFT6B8dS2z7Vye5xqNj6mBJAFGI2dzzsEr2ouQJlTyoUN76tnnZODPw==
X-Received: by 2002:adf:aa0e:: with SMTP id p14mr3347726wrd.399.1582789833301;
        Wed, 26 Feb 2020 23:50:33 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id q3sm6524618wmj.38.2020.02.26.23.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:32 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 09/16] selftests: mlxsw: Add shared buffer configuration test
Date:   Thu, 27 Feb 2020 08:50:14 +0100
Message-Id: <20200227075021.3472-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Test physical ports' shared buffer configuration options using random
values related to a specific configuration option. There are 3
configuration options: pool, TC bind and portpool.

Each sub-test, test a different configuration option and random the related
values as the follow:
 * For pools, pool's size will be randomized.
 * For TC bind, pool number and threshold will be randomized.
 * For portpools, threshold will be randomized.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/mlxsw/sharedbuffer_configuration.py   | 416 ++++++++++++++++++
 1 file changed, 416 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sharedbuffer_configuration.py

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer_configuration.py b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer_configuration.py
new file mode 100755
index 000000000000..0d4b9327c9b3
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer_configuration.py
@@ -0,0 +1,416 @@
+#!/usr/bin/python
+# SPDX-License-Identifier: GPL-2.0
+
+import subprocess
+import json as j
+import random
+
+
+class SkipTest(Exception):
+    pass
+
+
+class RandomValuePicker:
+    """
+    Class for storing shared buffer configuration. Can handle 3 different
+    objects, pool, tcbind and portpool. Provide an interface to get random
+    values for a specific object type as the follow:
+      1. Pool:
+         - random size
+
+      2. TcBind:
+         - random pool number
+         - random threshold
+
+      3. PortPool:
+         - random threshold
+    """
+    def __init__(self, pools):
+        self._pools = []
+        for pool in pools:
+            self._pools.append(pool)
+
+    def _cell_size(self):
+        return self._pools[0]["cell_size"]
+
+    def _get_static_size(self, th):
+        # For threshold of 16, this works out to be about 12MB on Spectrum-1,
+        # and about 17MB on Spectrum-2.
+        return th * 8000 * self._cell_size()
+
+    def _get_size(self):
+        return self._get_static_size(16)
+
+    def _get_thtype(self):
+        return "static"
+
+    def _get_th(self, pool):
+        # Threshold value could be any integer between 3 to 16
+        th = random.randint(3, 16)
+        if pool["thtype"] == "dynamic":
+            return th
+        else:
+            return self._get_static_size(th)
+
+    def _get_pool(self, direction):
+        ing_pools = []
+        egr_pools = []
+        for pool in self._pools:
+            if pool["type"] == "ingress":
+                ing_pools.append(pool)
+            else:
+                egr_pools.append(pool)
+        if direction == "ingress":
+            arr = ing_pools
+        else:
+            arr = egr_pools
+        return arr[random.randint(0, len(arr) - 1)]
+
+    def get_value(self, objid):
+        if isinstance(objid, Pool):
+            if objid["pool"] in [4, 8, 9, 10]:
+                # The threshold type of pools 4, 8, 9 and 10 cannot be changed
+                raise SkipTest()
+            else:
+                return (self._get_size(), self._get_thtype())
+        if isinstance(objid, TcBind):
+            if objid["tc"] >= 8:
+                # Multicast TCs cannot be changed
+                raise SkipTest()
+            else:
+                pool = self._get_pool(objid["type"])
+                th = self._get_th(pool)
+                pool_n = pool["pool"]
+                return (pool_n, th)
+        if isinstance(objid, PortPool):
+            pool_n = objid["pool"]
+            pool = self._pools[pool_n]
+            assert pool["pool"] == pool_n
+            th = self._get_th(pool)
+            return (th,)
+
+
+class RecordValuePickerException(Exception):
+    pass
+
+
+class RecordValuePicker:
+    """
+    Class for storing shared buffer configuration. Can handle 2 different
+    objects, pool and tcbind. Provide an interface to get the stored values per
+    object type.
+    """
+    def __init__(self, objlist):
+        self._recs = []
+        for item in objlist:
+            self._recs.append({"objid": item, "value": item.var_tuple()})
+
+    def get_value(self, objid):
+        if isinstance(objid, Pool) and objid["pool"] in [4, 8, 9, 10]:
+            # The threshold type of pools 4, 8, 9 and 10 cannot be changed
+            raise SkipTest()
+        if isinstance(objid, TcBind) and objid["tc"] >= 8:
+            # Multicast TCs cannot be changed
+            raise SkipTest()
+        for rec in self._recs:
+            if rec["objid"].weak_eq(objid):
+                return rec["value"]
+        raise RecordValuePickerException()
+
+
+def run_cmd(cmd, json=False):
+    out = subprocess.check_output(cmd, shell=True)
+    if json:
+        return j.loads(out)
+    return out
+
+
+def run_json_cmd(cmd):
+    return run_cmd(cmd, json=True)
+
+
+def log_test(test_name, err_msg=None):
+    if err_msg:
+        print("\t%s" % err_msg)
+        print("TEST: %-80s  [FAIL]" % test_name)
+    else:
+        print("TEST: %-80s  [ OK ]" % test_name)
+
+
+class CommonItem(dict):
+    varitems = []
+
+    def var_tuple(self):
+        ret = []
+        self.varitems.sort()
+        for key in self.varitems:
+            ret.append(self[key])
+        return tuple(ret)
+
+    def weak_eq(self, other):
+        for key in self:
+            if key in self.varitems:
+                continue
+            if self[key] != other[key]:
+                return False
+        return True
+
+
+class CommonList(list):
+    def get_by(self, by_obj):
+        for item in self:
+            if item.weak_eq(by_obj):
+                return item
+        return None
+
+    def del_by(self, by_obj):
+        for item in self:
+            if item.weak_eq(by_obj):
+                self.remove(item)
+
+
+class Pool(CommonItem):
+    varitems = ["size", "thtype"]
+
+    def dl_set(self, dlname, size, thtype):
+        run_cmd("devlink sb pool set {} sb {} pool {} size {} thtype {}".format(dlname, self["sb"],
+                                                                                self["pool"],
+                                                                                size, thtype))
+
+
+class PoolList(CommonList):
+    pass
+
+
+def get_pools(dlname, direction=None):
+    d = run_json_cmd("devlink sb pool show -j")
+    pools = PoolList()
+    for pooldict in d["pool"][dlname]:
+        if not direction or direction == pooldict["type"]:
+            pools.append(Pool(pooldict))
+    return pools
+
+
+def do_check_pools(dlname, pools, vp):
+    for pool in pools:
+        pre_pools = get_pools(dlname)
+        try:
+            (size, thtype) = vp.get_value(pool)
+        except SkipTest:
+            continue
+        pool.dl_set(dlname, size, thtype)
+        post_pools = get_pools(dlname)
+        pool = post_pools.get_by(pool)
+
+        err_msg = None
+        if pool["size"] != size:
+            err_msg = "Incorrect pool size (got {}, expected {})".format(pool["size"], size)
+        if pool["thtype"] != thtype:
+            err_msg = "Incorrect pool threshold type (got {}, expected {})".format(pool["thtype"], thtype)
+
+        pre_pools.del_by(pool)
+        post_pools.del_by(pool)
+        if pre_pools != post_pools:
+            err_msg = "Other pool setup changed as well"
+        log_test("pool {} of sb {} set verification".format(pool["pool"],
+                                                            pool["sb"]), err_msg)
+
+
+def check_pools(dlname, pools):
+    # Save defaults
+    record_vp = RecordValuePicker(pools)
+
+    # For each pool, set random size and static threshold type
+    do_check_pools(dlname, pools, RandomValuePicker(pools))
+
+    # Restore defaults
+    do_check_pools(dlname, pools, record_vp)
+
+
+class TcBind(CommonItem):
+    varitems = ["pool", "threshold"]
+
+    def __init__(self, port, d):
+        super(TcBind, self).__init__(d)
+        self["dlportname"] = port.name
+
+    def dl_set(self, pool, th):
+        run_cmd("devlink sb tc bind set {} sb {} tc {} type {} pool {} th {}".format(self["dlportname"],
+                                                                                     self["sb"],
+                                                                                     self["tc"],
+                                                                                     self["type"],
+                                                                                     pool, th))
+
+
+class TcBindList(CommonList):
+    pass
+
+
+def get_tcbinds(ports, verify_existence=False):
+    d = run_json_cmd("devlink sb tc bind show -j -n")
+    tcbinds = TcBindList()
+    for port in ports:
+        err_msg = None
+        if port.name not in d["tc_bind"] or len(d["tc_bind"][port.name]) == 0:
+            err_msg = "No tc bind for port"
+        else:
+            for tcbinddict in d["tc_bind"][port.name]:
+                tcbinds.append(TcBind(port, tcbinddict))
+        if verify_existence:
+            log_test("tc bind existence for port {} verification".format(port.name), err_msg)
+    return tcbinds
+
+
+def do_check_tcbind(ports, tcbinds, vp):
+    for tcbind in tcbinds:
+        pre_tcbinds = get_tcbinds(ports)
+        try:
+            (pool, th) = vp.get_value(tcbind)
+        except SkipTest:
+            continue
+        tcbind.dl_set(pool, th)
+        post_tcbinds = get_tcbinds(ports)
+        tcbind = post_tcbinds.get_by(tcbind)
+
+        err_msg = None
+        if tcbind["pool"] != pool:
+            err_msg = "Incorrect pool (got {}, expected {})".format(tcbind["pool"], pool)
+        if tcbind["threshold"] != th:
+            err_msg = "Incorrect threshold (got {}, expected {})".format(tcbind["threshold"], th)
+
+        pre_tcbinds.del_by(tcbind)
+        post_tcbinds.del_by(tcbind)
+        if pre_tcbinds != post_tcbinds:
+            err_msg = "Other tc bind setup changed as well"
+        log_test("tc bind {}-{} of sb {} set verification".format(tcbind["dlportname"],
+                                                                  tcbind["tc"],
+                                                                  tcbind["sb"]), err_msg)
+
+
+def check_tcbind(dlname, ports, pools):
+    tcbinds = get_tcbinds(ports, verify_existence=True)
+
+    # Save defaults
+    record_vp = RecordValuePicker(tcbinds)
+
+    # Bind each port and unicast TC (TCs < 8) to a random pool and a random
+    # threshold
+    do_check_tcbind(ports, tcbinds, RandomValuePicker(pools))
+
+    # Restore defaults
+    do_check_tcbind(ports, tcbinds, record_vp)
+
+
+class PortPool(CommonItem):
+    varitems = ["threshold"]
+
+    def __init__(self, port, d):
+        super(PortPool, self).__init__(d)
+        self["dlportname"] = port.name
+
+    def dl_set(self, th):
+        run_cmd("devlink sb port pool set {} sb {} pool {} th {}".format(self["dlportname"],
+                                                                         self["sb"],
+                                                                         self["pool"], th))
+
+
+class PortPoolList(CommonList):
+    pass
+
+
+def get_portpools(ports, verify_existence=False):
+    d = run_json_cmd("devlink sb port pool -j -n")
+    portpools = PortPoolList()
+    for port in ports:
+        err_msg = None
+        if port.name not in d["port_pool"] or len(d["port_pool"][port.name]) == 0:
+            err_msg = "No port pool for port"
+        else:
+            for portpooldict in d["port_pool"][port.name]:
+                portpools.append(PortPool(port, portpooldict))
+        if verify_existence:
+            log_test("port pool existence for port {} verification".format(port.name), err_msg)
+    return portpools
+
+
+def do_check_portpool(ports, portpools, vp):
+    for portpool in portpools:
+        pre_portpools = get_portpools(ports)
+        (th,) = vp.get_value(portpool)
+        portpool.dl_set(th)
+        post_portpools = get_portpools(ports)
+        portpool = post_portpools.get_by(portpool)
+
+        err_msg = None
+        if portpool["threshold"] != th:
+            err_msg = "Incorrect threshold (got {}, expected {})".format(portpool["threshold"], th)
+
+        pre_portpools.del_by(portpool)
+        post_portpools.del_by(portpool)
+        if pre_portpools != post_portpools:
+            err_msg = "Other port pool setup changed as well"
+        log_test("port pool {}-{} of sb {} set verification".format(portpool["dlportname"],
+                                                                    portpool["pool"],
+                                                                    portpool["sb"]), err_msg)
+
+
+def check_portpool(dlname, ports, pools):
+    portpools = get_portpools(ports, verify_existence=True)
+
+    # Save defaults
+    record_vp = RecordValuePicker(portpools)
+
+    # For each port pool, set a random threshold
+    do_check_portpool(ports, portpools, RandomValuePicker(pools))
+
+    # Restore defaults
+    do_check_portpool(ports, portpools, record_vp)
+
+
+class Port:
+    def __init__(self, name):
+        self.name = name
+
+
+class PortList(list):
+    pass
+
+
+def get_ports(dlname):
+    d = run_json_cmd("devlink port show -j")
+    ports = PortList()
+    for name in d["port"]:
+        if name.find(dlname) == 0 and d["port"][name]["flavour"] == "physical":
+            ports.append(Port(name))
+    return ports
+
+
+def get_device():
+    devices_info = run_json_cmd("devlink -j dev info")["info"]
+    for d in devices_info:
+        if "mlxsw_spectrum" in devices_info[d]["driver"]:
+            return d
+    return None
+
+
+class UnavailableDevlinkNameException(Exception):
+    pass
+
+
+def test_sb_configuration():
+    # Use static seed
+    random.seed(0)
+
+    dlname = get_device()
+    if not dlname:
+        raise UnavailableDevlinkNameException()
+
+    ports = get_ports(dlname)
+    pools = get_pools(dlname)
+
+    check_pools(dlname, pools)
+    check_tcbind(dlname, ports, pools)
+    check_portpool(dlname, ports, pools)
+
+
+test_sb_configuration()
-- 
2.21.1

