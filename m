Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0868E396F5
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 22:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbfFGUl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 16:41:27 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37684 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbfFGUl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 16:41:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14so3382130wrr.4
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 13:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UnlyDePu560kbne+lUDYycrXlYiNdNAPebjnhQUdBwc=;
        b=fRCj+RulYgTcrWyph5QDr1w0n4SEEvNcf2VWms8ik0B0wZOzpLKk+gzmmWlsjMnldr
         17W1AkS6GcOhW3qOHAioMbD792MZjQF1JmWy59vs+UxsHv2X24e+Cfaw91fscTDZDqww
         Zxh/dTNdYNOiKNAIkQVSebH3LX+maOI8qa1XuROJo2OraA9rIu5kJOjU/d9KtucUHDeC
         YYw4S2oM+gBvZcykFfcriMsyLIL3bJ83fKat47H80MC6+lVl3MyGc8DCGS4q//tPJ/Xq
         /eKs/vgu3wegNQRBes2BB4JcSsLfBy8aYEO2b7ePR5TAg5BZIoXCfeUAqDsWre6yPnGT
         vWHQ==
X-Gm-Message-State: APjAAAW0dL7YIPf99P1ft53aj9QV9XnasSG1Yq/jv8704jCSVHox24DL
        CX2sXYF9yIZY9r5MJcs4OOuy4BD5ZnE=
X-Google-Smtp-Source: APXvYqwggVtduSQVHVEbq8ehgfWbRy1iJbFKG2iECdyhOj2ldWb8U4phmCAVf878AlMJQpVBmtc1ag==
X-Received: by 2002:a5d:4a46:: with SMTP id v6mr34784533wrs.105.1559940084131;
        Fri, 07 Jun 2019 13:41:24 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-144-152-91.cust.vodafonedsl.it. [93.144.152.91])
        by smtp.gmail.com with ESMTPSA id g17sm3034961wrm.7.2019.06.07.13.41.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 13:41:23 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Andrea Claudi <aclaudi@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Subject: [PATCH iproute2 v2] ip: reset netns after each command in batch mode
Date:   Fri,  7 Jun 2019 22:41:22 +0200
Message-Id: <20190607204122.2985-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a new netns or executing a program into an existing one,
the unshare() or setns() calls will change the current netns.
In batch mode, this can run commands on the wrong interfaces, as the
ifindex value is meaningful only in the current netns. For example, this
command fails because veth-c doesn't exists in the init netns:

    # ip -b - <<-'EOF'
        netns add client
        link add name veth-c type veth peer veth-s netns client
        addr add 192.168.2.1/24 dev veth-c
    EOF
    Cannot find device "veth-c"
    Command failed -:7

But if there are two devices with the same name in the init and new netns,
ip will build a wrong ll_map with indexes belonging to the new netns,
and will execute actions in the init netns using this wrong mapping.
This script will flush all eth0 addresses and bring it down, as it has
the same ifindex of veth0 in the new netns:

    # ip addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
        link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
        inet 192.168.122.76/24 brd 192.168.122.255 scope global dynamic eth0
           valid_lft 3598sec preferred_lft 3598sec

    # ip -b - <<-'EOF'
        netns add client
        link add name veth0 type veth peer name veth1
        link add name veth-ns type veth peer name veth0 netns client
        link set veth0 down
        address flush veth0
    EOF

    # ip addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN group default qlen 1000
        link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff
    3: veth1@veth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether c2:db:d0:34:13:4a brd ff:ff:ff:ff:ff:ff
    4: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether ca:9d:6b:5f:5f:8f brd ff:ff:ff:ff:ff:ff
    5: veth-ns@if2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether 32:ef:22:df:51:0a brd ff:ff:ff:ff:ff:ff link-netns client

The same issue can be triggered by the netns exec subcommand with a
sligthy different script:

    # ip netns add client
    # ip -b - <<-'EOF'
        netns exec client true
        link add name veth0 type veth peer name veth1
        link add name veth-ns type veth peer name veth0 netns client
        link set veth0 down
        address flush veth0
    EOF

Fix this by adding two netns_{save,reset} functions, which are used
to get a file descriptor for the init netns, and restore it after
each batch command.
netns_save() is called before the unshare() or setns(),
while netns_restore() is called after each command.

Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support")
Reviewed-and-tested-by: Andrea Claudi <aclaudi@redhat.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
v1 -> v2:
 - exit on netns error
 - refactor to reduce indentation

 include/namespace.h |  2 ++
 ip/ip.c             |  1 +
 ip/ipnetns.c        |  1 +
 lib/namespace.c     | 31 +++++++++++++++++++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/include/namespace.h b/include/namespace.h
index e47f9b5d..89cdda11 100644
--- a/include/namespace.h
+++ b/include/namespace.h
@@ -49,6 +49,8 @@ static inline int setns(int fd, int nstype)
 }
 #endif /* HAVE_SETNS */
 
+void netns_save(void);
+void netns_restore(void);
 int netns_switch(char *netns);
 int netns_get_fd(const char *netns);
 int netns_foreach(int (*func)(char *nsname, void *arg), void *arg);
diff --git a/ip/ip.c b/ip/ip.c
index b71ae816..49b3aa49 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -158,6 +158,7 @@ static int batch(const char *name)
 			if (!force)
 				break;
 		}
+		netns_restore();
 	}
 	if (line)
 		free(line);
diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index db11fdb2..8ead0c4c 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -708,6 +708,7 @@ static int netns_add(int argc, char **argv, bool create)
 	close(fd);
 
 	if (create) {
+		netns_save();
 		if (unshare(CLONE_NEWNET) < 0) {
 			fprintf(stderr, "Failed to create a new network namespace \"%s\": %s\n",
 				name, strerror(errno));
diff --git a/lib/namespace.c b/lib/namespace.c
index 06ae0a48..a2aea57a 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -15,6 +15,35 @@
 #include "utils.h"
 #include "namespace.h"
 
+static int saved_netns = -1;
+
+/* Obtain a FD for the current namespace, so we can reenter it later */
+void netns_save(void)
+{
+	if (saved_netns != -1)
+		return;
+
+	saved_netns = open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC);
+	if (saved_netns == -1) {
+		perror("Cannot open init namespace");
+		exit(1);
+	}
+}
+
+void netns_restore(void)
+{
+	if (saved_netns == -1)
+		return;
+
+	if (setns(saved_netns, CLONE_NEWNET)) {
+		perror("setns");
+		exit(1);
+	}
+
+	close(saved_netns);
+	saved_netns = -1;
+}
+
 static void bind_etc(const char *name)
 {
 	char etc_netns_path[sizeof(NETNS_ETC_DIR) + NAME_MAX];
@@ -61,6 +90,8 @@ int netns_switch(char *name)
 		return -1;
 	}
 
+	netns_save();
+
 	if (setns(netns, CLONE_NEWNET) < 0) {
 		fprintf(stderr, "setting the network namespace \"%s\" failed: %s\n",
 			name, strerror(errno));
-- 
2.21.0

