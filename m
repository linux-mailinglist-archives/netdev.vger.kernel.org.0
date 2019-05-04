Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64D413B42
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfEDQs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:48:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35855 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:48:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id o4so11712046wra.3
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 09:48:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++iKIJb/OpxP1KOvzw7ibOLWNdoks43aj3bOwc9srJ4=;
        b=XJxRkWzYVPRFmmTx3iM2rZNcaFsFpOqFdD0SuNOW8mZvbV1i1hRl+Tc/rWvDFCh3XE
         dB4XAqDB5cPfhYllJs3B72gvT2LW8JuV9QiWK2Q6nzQ92+LAy2RZfu1KNOSIAtniLFwC
         GgmMyXnMDRf7a2OZayY7XdYrb+2/Sol4hPzxyeu00yUPOQ7AqYh/Qx4QElUxw0m9LHxQ
         FK5+CTwGqPzLhP288C0/RtmmsDxjsT12IVSwz5Q0yl5EDT5mW1HrPrcjqnYpjkrSbRWH
         LPBFOgZMumVJ3/FL++lFAe9hjyCcdDtHIxrzBTN/WTqp4sz5l03YfRHbzgBOqkwQr5mC
         Hh7g==
X-Gm-Message-State: APjAAAV3QLVTl+E0+N/sIkDusXaZ3q2CD9Ao5avZfnC5GO+u5B1wOHUT
        T/Th3Ucs5fcfkRGUMOStx8A/kh2Or00=
X-Google-Smtp-Source: APXvYqyLNV6yCyrjoN6DQcEEHZ16fEaInTODTl3UIRvl5htB+kcRAzoHleY1OY3RidWYtRqKm5d30Q==
X-Received: by 2002:adf:80c3:: with SMTP id 61mr11964811wrl.123.1556988535372;
        Sat, 04 May 2019 09:48:55 -0700 (PDT)
Received: from turbo.teknoraver.net (net-93-70-69-135.cust.vodafonedsl.it. [93.70.69.135])
        by smtp.gmail.com with ESMTPSA id k206sm11039904wmk.16.2019.05.04.09.48.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 09:48:54 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paul Mackerras <paulus@ozlabs.org>, Jo-Philipp Wich <jo@mein.io>
Subject: [PATCH pppd v4] pppoe: custom host-uniq tag
Date:   Sat,  4 May 2019 18:48:53 +0200
Message-Id: <20190504164853.4736-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pppoe 'host-uniq' option to set an arbitrary
host-uniq tag instead of the pppd pid.
Some ISPs use such tag to authenticate the CPE,
so it must be set to a proper value to connect.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Jo-Philipp Wich <jo@mein.io>
---
 pppd/plugins/rp-pppoe/common.c          | 14 +++----
 pppd/plugins/rp-pppoe/discovery.c       | 52 ++++++++++---------------
 pppd/plugins/rp-pppoe/plugin.c          | 15 ++++++-
 pppd/plugins/rp-pppoe/pppoe-discovery.c | 41 ++++++++++++-------
 pppd/plugins/rp-pppoe/pppoe.h           | 30 +++++++++++++-
 5 files changed, 96 insertions(+), 56 deletions(-)

diff --git a/pppd/plugins/rp-pppoe/common.c b/pppd/plugins/rp-pppoe/common.c
index 89c633c..8f175ec 100644
--- a/pppd/plugins/rp-pppoe/common.c
+++ b/pppd/plugins/rp-pppoe/common.c
@@ -119,15 +119,11 @@ sendPADT(PPPoEConnection *conn, char const *msg)
     conn->session = 0;
 
     /* If we're using Host-Uniq, copy it over */
-    if (conn->useHostUniq) {
-	PPPoETag hostUniq;
-	pid_t pid = getpid();
-	hostUniq.type = htons(TAG_HOST_UNIQ);
-	hostUniq.length = htons(sizeof(pid));
-	memcpy(hostUniq.payload, &pid, sizeof(pid));
-	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
-	cursor += sizeof(pid) + TAG_HDR_SIZE;
-	plen += sizeof(pid) + TAG_HDR_SIZE;
+    if (conn->hostUniq.length) {
+	int len = ntohs(conn->hostUniq.length);
+	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
+	cursor += len + TAG_HDR_SIZE;
+	plen += len + TAG_HDR_SIZE;
     }
 
     /* Copy error message */
diff --git a/pppd/plugins/rp-pppoe/discovery.c b/pppd/plugins/rp-pppoe/discovery.c
index 04877cb..16a59f7 100644
--- a/pppd/plugins/rp-pppoe/discovery.c
+++ b/pppd/plugins/rp-pppoe/discovery.c
@@ -80,14 +80,10 @@ static void
 parseForHostUniq(UINT16_t type, UINT16_t len, unsigned char *data,
 		 void *extra)
 {
-    int *val = (int *) extra;
-    if (type == TAG_HOST_UNIQ && len == sizeof(pid_t)) {
-	pid_t tmp;
-	memcpy(&tmp, data, len);
-	if (tmp == getpid()) {
-	    *val = 1;
-	}
-    }
+    PPPoETag *tag = extra;
+
+    if (type == TAG_HOST_UNIQ && len == ntohs(tag->length))
+	tag->length = memcmp(data, tag->payload, len);
 }
 
 /**********************************************************************
@@ -104,16 +100,16 @@ parseForHostUniq(UINT16_t type, UINT16_t len, unsigned char *data,
 static int
 packetIsForMe(PPPoEConnection *conn, PPPoEPacket *packet)
 {
-    int forMe = 0;
+    PPPoETag hostUniq = conn->hostUniq;
 
     /* If packet is not directed to our MAC address, forget it */
     if (memcmp(packet->ethHdr.h_dest, conn->myEth, ETH_ALEN)) return 0;
 
     /* If we're not using the Host-Unique tag, then accept the packet */
-    if (!conn->useHostUniq) return 1;
+    if (!conn->hostUniq.length) return 1;
 
-    parsePacket(packet, parseForHostUniq, &forMe);
-    return forMe;
+    parsePacket(packet, parseForHostUniq, &hostUniq);
+    return !hostUniq.length;
 }
 
 /**********************************************************************
@@ -301,16 +297,12 @@ sendPADI(PPPoEConnection *conn)
     }
 
     /* If we're using Host-Uniq, copy it over */
-    if (conn->useHostUniq) {
-	PPPoETag hostUniq;
-	pid_t pid = getpid();
-	hostUniq.type = htons(TAG_HOST_UNIQ);
-	hostUniq.length = htons(sizeof(pid));
-	memcpy(hostUniq.payload, &pid, sizeof(pid));
-	CHECK_ROOM(cursor, packet.payload, sizeof(pid) + TAG_HDR_SIZE);
-	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
-	cursor += sizeof(pid) + TAG_HDR_SIZE;
-	plen += sizeof(pid) + TAG_HDR_SIZE;
+    if (conn->hostUniq.length) {
+	int len = ntohs(conn->hostUniq.length);
+	CHECK_ROOM(cursor, packet.payload, len + TAG_HDR_SIZE);
+	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
+	cursor += len + TAG_HDR_SIZE;
+	plen += len + TAG_HDR_SIZE;
     }
 
     /* Add our maximum MTU/MRU */
@@ -478,16 +470,12 @@ sendPADR(PPPoEConnection *conn)
     cursor += namelen + TAG_HDR_SIZE;
 
     /* If we're using Host-Uniq, copy it over */
-    if (conn->useHostUniq) {
-	PPPoETag hostUniq;
-	pid_t pid = getpid();
-	hostUniq.type = htons(TAG_HOST_UNIQ);
-	hostUniq.length = htons(sizeof(pid));
-	memcpy(hostUniq.payload, &pid, sizeof(pid));
-	CHECK_ROOM(cursor, packet.payload, sizeof(pid)+TAG_HDR_SIZE);
-	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
-	cursor += sizeof(pid) + TAG_HDR_SIZE;
-	plen += sizeof(pid) + TAG_HDR_SIZE;
+    if (conn->hostUniq.length) {
+	int len = ntohs(conn->hostUniq.length);
+	CHECK_ROOM(cursor, packet.payload, len+TAG_HDR_SIZE);
+	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
+	cursor += len + TAG_HDR_SIZE;
+	plen += len + TAG_HDR_SIZE;
     }
 
     /* Add our maximum MTU/MRU */
diff --git a/pppd/plugins/rp-pppoe/plugin.c b/pppd/plugins/rp-pppoe/plugin.c
index c89be94..966be15 100644
--- a/pppd/plugins/rp-pppoe/plugin.c
+++ b/pppd/plugins/rp-pppoe/plugin.c
@@ -68,6 +68,7 @@ static char *existingSession = NULL;
 static int printACNames = 0;
 static char *pppoe_reqd_mac = NULL;
 unsigned char pppoe_reqd_mac_addr[6];
+static char *host_uniq;
 
 static int PPPoEDevnameHook(char *cmd, char **argv, int doit);
 static option_t Options[] = {
@@ -85,6 +86,8 @@ static option_t Options[] = {
       "Be verbose about discovered access concentrators"},
     { "pppoe-mac", o_string, &pppoe_reqd_mac,
       "Only connect to specified MAC address" },
+    { "host-uniq", o_string, &host_uniq,
+      "Set the Host-Uniq to the supplied hex string" },
     { NULL }
 };
 int (*OldDevnameHook)(char *cmd, char **argv, int doit) = NULL;
@@ -110,7 +113,6 @@ PPPOEInitDevice(void)
     conn->ifName = devnam;
     conn->discoverySocket = -1;
     conn->sessionSocket = -1;
-    conn->useHostUniq = 1;
     conn->printACNames = printACNames;
     conn->discoveryTimeout = PADI_TIMEOUT;
     return 1;
@@ -166,6 +168,17 @@ PPPOEConnectDevice(void)
     if (lcp_wantoptions[0].mru > ifr.ifr_mtu - TOTAL_OVERHEAD)
 	lcp_wantoptions[0].mru = ifr.ifr_mtu - TOTAL_OVERHEAD;
 
+    if (host_uniq) {
+	if (!parseHostUniq(host_uniq, &conn->hostUniq))
+	    fatal("Illegal value for host-uniq option");
+    } else {
+	/* if a custom host-uniq is not supplied, use our PID */
+	pid_t pid = getpid();
+	conn->hostUniq.type = htons(TAG_HOST_UNIQ);
+	conn->hostUniq.length = htons(sizeof(pid));
+	memcpy(conn->hostUniq.payload, &pid, sizeof(pid));
+    }
+
     conn->acName = acName;
     conn->serviceName = pppd_pppoe_service;
     strlcpy(ppp_devnam, devnam, sizeof(ppp_devnam));
diff --git a/pppd/plugins/rp-pppoe/pppoe-discovery.c b/pppd/plugins/rp-pppoe/pppoe-discovery.c
index bce71fc..f71aec8 100644
--- a/pppd/plugins/rp-pppoe/pppoe-discovery.c
+++ b/pppd/plugins/rp-pppoe/pppoe-discovery.c
@@ -356,7 +356,7 @@ packetIsForMe(PPPoEConnection *conn, PPPoEPacket *packet)
     if (memcmp(packet->ethHdr.h_dest, conn->myEth, ETH_ALEN)) return 0;
 
     /* If we're not using the Host-Unique tag, then accept the packet */
-    if (!conn->useHostUniq) return 1;
+    if (!conn->hostUniq.length) return 1;
 
     parsePacket(packet, parseForHostUniq, &forMe);
     return forMe;
@@ -494,16 +494,12 @@ sendPADI(PPPoEConnection *conn)
     cursor += namelen + TAG_HDR_SIZE;
 
     /* If we're using Host-Uniq, copy it over */
-    if (conn->useHostUniq) {
-	PPPoETag hostUniq;
-	pid_t pid = getpid();
-	hostUniq.type = htons(TAG_HOST_UNIQ);
-	hostUniq.length = htons(sizeof(pid));
-	memcpy(hostUniq.payload, &pid, sizeof(pid));
-	CHECK_ROOM(cursor, packet.payload, sizeof(pid) + TAG_HDR_SIZE);
-	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
-	cursor += sizeof(pid) + TAG_HDR_SIZE;
-	plen += sizeof(pid) + TAG_HDR_SIZE;
+    if (conn->hostUniq.length) {
+	int len = ntohs(conn->hostUniq.length);
+	CHECK_ROOM(cursor, packet.payload, len + TAG_HDR_SIZE);
+	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
+	cursor += len + TAG_HDR_SIZE;
+	plen += len + TAG_HDR_SIZE;
     }
 
     packet.length = htons(plen);
@@ -669,7 +665,7 @@ int main(int argc, char *argv[])
     conn->discoveryTimeout = PADI_TIMEOUT;
     conn->discoveryAttempts = MAX_PADI_ATTEMPTS;
 
-    while ((opt = getopt(argc, argv, "I:D:VUQS:C:t:a:h")) > 0) {
+    while ((opt = getopt(argc, argv, "I:D:VUQS:C:W:t:a:h")) > 0) {
 	switch(opt) {
 	case 'S':
 	    conn->serviceName = xstrdup(optarg);
@@ -696,7 +692,25 @@ int main(int argc, char *argv[])
 	    }
 	    break;
 	case 'U':
-	    conn->useHostUniq = 1;
+	    if(conn->hostUniq.length) {
+		fprintf(stderr, "-U and -W are mutually exclusive\n");
+		exit(EXIT_FAILURE);
+	    } else {
+		pid_t pid = getpid();
+		conn->hostUniq.type = htons(TAG_HOST_UNIQ);
+		conn->hostUniq.length = htons(sizeof(pid));
+		memcpy(conn->hostUniq.payload, &pid, sizeof(pid));
+	    }
+	    break;
+	case 'W':
+	    if(conn->hostUniq.length) {
+		fprintf(stderr, "-U and -W are mutually exclusive\n");
+		exit(EXIT_FAILURE);
+	    }
+	    if (!parseHostUniq(optarg, &conn->hostUniq)) {
+		fprintf(stderr, "Invalid host-uniq argument: %s\n", optarg);
+		exit(EXIT_FAILURE);
+            }
 	    break;
 	case 'D':
 	    conn->debugFile = fopen(optarg, "w");
@@ -777,6 +791,7 @@ void usage(void)
 	    "   -S name        -- Set desired service name.\n"
 	    "   -C name        -- Set desired access concentrator name.\n"
 	    "   -U             -- Use Host-Unique to allow multiple PPPoE sessions.\n"
+	    "   -W hexvalue    -- Set the Host-Unique to the supplied hex string.\n"
 	    "   -h             -- Print usage information.\n");
     fprintf(stderr, "\nVersion " RP_VERSION "\n");
 }
diff --git a/pppd/plugins/rp-pppoe/pppoe.h b/pppd/plugins/rp-pppoe/pppoe.h
index 813dcf3..2ea153f 100644
--- a/pppd/plugins/rp-pppoe/pppoe.h
+++ b/pppd/plugins/rp-pppoe/pppoe.h
@@ -21,6 +21,8 @@
 
 #include <stdio.h>		/* For FILE */
 #include <sys/types.h>		/* For pid_t */
+#include <ctype.h>
+#include <string.h>
 
 /* How do we access raw Ethernet devices? */
 #undef USE_LINUX_PACKET
@@ -236,7 +238,7 @@ typedef struct PPPoEConnectionStruct {
     char *serviceName;		/* Desired service name, if any */
     char *acName;		/* Desired AC name, if any */
     int synchronous;		/* Use synchronous PPP */
-    int useHostUniq;		/* Use Host-Uniq tag */
+    PPPoETag hostUniq;		/* Use Host-Uniq tag */
     int printACNames;		/* Just print AC names */
     FILE *debugFile;		/* Debug file for dumping packets */
     int numPADOs;		/* Number of PADO packets received */
@@ -293,6 +295,32 @@ void pppoe_printpkt(PPPoEPacket *packet,
 		    void (*printer)(void *, char *, ...), void *arg);
 void pppoe_log_packet(const char *prefix, PPPoEPacket *packet);
 
+static inline int parseHostUniq(const char *uniq, PPPoETag *tag)
+{
+    unsigned i, len = strlen(uniq);
+
+#define hex(x) \
+    (((x) <= '9') ? ((x) - '0') : \
+        (((x) <= 'F') ? ((x) - 'A' + 10) : \
+            ((x) - 'a' + 10)))
+
+    if (!len || len % 2 || len / 2 > sizeof(tag->payload))
+        return 0;
+
+    for (i = 0; i < len; i += 2) {
+        if (!isxdigit(uniq[i]) || !isxdigit(uniq[i+1]))
+            return 0;
+
+        tag->payload[i / 2] = (char)(hex(uniq[i]) << 4 | hex(uniq[i+1]));
+    }
+
+#undef hex
+
+    tag->type = htons(TAG_HOST_UNIQ);
+    tag->length = htons(len / 2);
+    return 1;
+}
+
 #define SET_STRING(var, val) do { if (var) free(var); var = strDup(val); } while(0);
 
 #define CHECK_ROOM(cursor, start, len) \
-- 
2.21.0

