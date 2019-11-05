Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD93CF0849
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfKEV0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:26:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45384 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729829AbfKEV0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:26:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id n21so9968942ljg.12
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qtzzo4BaTQKZqLUrK8ToqmDazW9q4viwRFcXOXcndIo=;
        b=zKD4ItMlJRdX8ZZAR98XnGZdicoPKSPvZk6SQDxC81N2u8astBaF5IqsN/D67iDLDr
         ld89sINV5bp3oDel1VUNQTt51772xiS1vi2b4AujU/o8UhlBR1qrktSq0y8UHiSGCql1
         YiaSBUg5ntVYo1HP7rQjO/QTBm6/z3nFDMxJuMdNngz+MBg+DOR39XmxO1u1i9y84hyO
         +wVMe3hU6jE6fSB/d0JhTBoPtrb3qIWgbG/43rFWDToY7crl6/Jx/WiLAgOm7WW8luim
         Iow/rhmOGfQkMcSQ4cKQMGgfHhpAqjoMlnId52R9K4yY29YsQl+cqt7fIutlKfMEFB8T
         fDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qtzzo4BaTQKZqLUrK8ToqmDazW9q4viwRFcXOXcndIo=;
        b=OSuA4yiv45BoIz8peCzcR2T8uvZa59pJuNWpsvYXeTcUzI1v6hHkL/8b7zqTdMMxSE
         IrkEgFDzEE8wK+7Gn4/4FME0K4iFf7P66RkdRXk9GFDIIRymeAqWuakd8M8RIecKV4PC
         bTa4B3JSs5yWvP6xGVcmjrfy+fur6F4UzzHfSU6EKHon+5IrRGawO4GRzGcdpiTuuAJ6
         DlbRwIJkSGRG0PYJoTnJE4po1wCFqmaOs6ffMz60cGQGy19EqS6dwuk+PUtNxj7Gar7N
         T6lDVI7z1A3Xr2abIo0VmsgPGFEoJbsd16f+LDzuo/2bQGbN58s7MEssXSWgnAm9p+ac
         e/Dg==
X-Gm-Message-State: APjAAAU8d5laW+hg2UdV4l9C6rKo7md/TL1VQjygyXwB75j+k26mp+Hn
        j25Rv3J6Wzm/8Mb5HMZY/9GYJw==
X-Google-Smtp-Source: APXvYqxUgQTUGkHP3yscQIqFjWYwtsIgYVCaos50OSSFD0RTlsaUppZ17RBLaiCzzw7TwXy+zqYd9A==
X-Received: by 2002:a2e:9094:: with SMTP id l20mr23559404ljg.246.1572989187462;
        Tue, 05 Nov 2019 13:26:27 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v1sm9319601lji.89.2019.11.05.13.26.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:26:26 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/2] selftests: bpf: log direct file writes
Date:   Tue,  5 Nov 2019 13:26:12 -0800
Message-Id: <20191105212612.10737-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105212612.10737-1-jakub.kicinski@netronome.com>
References: <20191105212612.10737-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes to netdevsim moved creating and destroying
devices from netlink to sysfs. The sysfs writes have been
implemented as direct writes, without shelling out. This
is faster, but leaves no trace in the logs. Add explicit
logs to make debugging possible.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/testing/selftests/bpf/test_offload.py | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 1afa22c88e42..8294ae3ffb3c 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -335,13 +335,22 @@ def bpftool_prog_load(sample, file_name, maps=[], prog_type="xdp", dev=None,
     """
     Class for netdevsim bus device and its attributes.
     """
+    @staticmethod
+    def ctrl_write(path, val):
+        fullpath = os.path.join("/sys/bus/netdevsim/", path)
+        try:
+            with open(fullpath, "w") as f:
+                f.write(val)
+        except OSError as e:
+            log("WRITE %s: %r" % (fullpath, val), -e.errno)
+            raise e
+        log("WRITE %s: %r" % (fullpath, val), 0)
 
     def __init__(self, port_count=1):
         addr = 0
         while True:
             try:
-                with open("/sys/bus/netdevsim/new_device", "w") as f:
-                    f.write("%u %u" % (addr, port_count))
+                self.ctrl_write("new_device", "%u %u" % (addr, port_count))
             except OSError as e:
                 if e.errno == errno.ENOSPC:
                     addr += 1
@@ -403,14 +412,13 @@ def bpftool_prog_load(sample, file_name, maps=[], prog_type="xdp", dev=None,
         return progs
 
     def remove(self):
-        with open("/sys/bus/netdevsim/del_device", "w") as f:
-            f.write("%u" % self.addr)
+        self.ctrl_write("del_device", "%u" % (self.addr, ))
         devs.remove(self)
 
     def remove_nsim(self, nsim):
         self.nsims.remove(nsim)
-        with open("/sys/bus/netdevsim/devices/netdevsim%u/del_port" % self.addr ,"w") as f:
-            f.write("%u" % nsim.port_index)
+        self.ctrl_write("devices/netdevsim%u/del_port" % (self.addr, ),
+                        "%u" % (nsim.port_index, ))
 
 class NetdevSim:
     """
-- 
2.23.0

