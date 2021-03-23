Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D771A345F60
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhCWNRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhCWNQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 09:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91EE161878;
        Tue, 23 Mar 2021 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616505399;
        bh=O/rQ2Uay+6O9Uy3vFgj0EjC8Z3v/RQBV9pO5PVV2AFE=;
        h=From:To:Cc:Subject:Date:From;
        b=kaCW0lBhSK5xj/zqUrfcQ2hfYPGm59j9RLgJ5pli6cdjZEAB76f/GUj6mIBW6mQIr
         6hF6Y8Mpy43kjWB+6Z21ztHqJ/m391CCXxZrgkkkO1t76cCJSI1tsOAoRElb58bauk
         87ArEh3i4SLwV4nr10gvGJzpOe8OVUNKo++2/mByeT4YT46taxWXj2MXpqWP68452f
         CDA/HPjwz/Zv9K++iO6zlNrAlj+2McfmNMRhylJMwJWNdcMFdjO8Ba5F0SfvNv+UMh
         db7XkNDV1k0Pd+GsDaowcZfHiZS/y2pbc2QHgloDM91vpuP2bPi286HSKBDaMGNBRV
         38/CWU81QBQ6Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Lee Jones <lee.jones@linaro.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Tom Rix <trix@redhat.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] airo: work around stack usage warning
Date:   Tue, 23 Mar 2021 14:16:28 +0100
Message-Id: <20210323131634.2669455-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 with KASAN on 32-bit arm produces a warning about a function
that needs a lot of stack space:

drivers/net/wireless/cisco/airo.c: In function 'setup_card.constprop':
drivers/net/wireless/cisco/airo.c:3960:1: error: the frame size of 1512 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]

Most of this is from a single large structure that could be dynamically
allocated or moved into the per-device structure.  However, as the callers
all seem to have a fairly well bounded call chain, the easiest change
is to pull out the part of the function that needs the large variables
into a separate function and mark that as noinline_for_stack. This does
not reduce the total stack usage, but it gets rid of the warning and
requires minimal changes otherwise.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/cisco/airo.c | 117 +++++++++++++++++-------------
 1 file changed, 65 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index e35e1380ae43..540ba694899c 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -3818,6 +3818,68 @@ static inline void set_auth_type(struct airo_info *local, int auth_type)
 		local->last_auth = auth_type;
 }
 
+static int noinline_for_stack airo_readconfig(struct airo_info *ai, u8 *mac, int lock)
+{
+	int i, status;
+	/* large variables, so don't inline this function,
+	 * maybe change to kmalloc
+	 */
+	tdsRssiRid rssi_rid;
+	CapabilityRid cap_rid;
+
+	kfree(ai->SSID);
+	ai->SSID = NULL;
+	// general configuration (read/modify/write)
+	status = readConfigRid(ai, lock);
+	if (status != SUCCESS) return ERROR;
+
+	status = readCapabilityRid(ai, &cap_rid, lock);
+	if (status != SUCCESS) return ERROR;
+
+	status = PC4500_readrid(ai, RID_RSSI, &rssi_rid, sizeof(rssi_rid), lock);
+	if (status == SUCCESS) {
+		if (ai->rssi || (ai->rssi = kmalloc(512, GFP_KERNEL)) != NULL)
+			memcpy(ai->rssi, (u8*)&rssi_rid + 2, 512); /* Skip RID length member */
+	}
+	else {
+		kfree(ai->rssi);
+		ai->rssi = NULL;
+		if (cap_rid.softCap & cpu_to_le16(8))
+			ai->config.rmode |= RXMODE_NORMALIZED_RSSI;
+		else
+			airo_print_warn(ai->dev->name, "unknown received signal "
+					"level scale");
+	}
+	ai->config.opmode = adhoc ? MODE_STA_IBSS : MODE_STA_ESS;
+	set_auth_type(ai, AUTH_OPEN);
+	ai->config.modulation = MOD_CCK;
+
+	if (le16_to_cpu(cap_rid.len) >= sizeof(cap_rid) &&
+	    (cap_rid.extSoftCap & cpu_to_le16(1)) &&
+	    micsetup(ai) == SUCCESS) {
+		ai->config.opmode |= MODE_MIC;
+		set_bit(FLAG_MIC_CAPABLE, &ai->flags);
+	}
+
+	/* Save off the MAC */
+	for (i = 0; i < ETH_ALEN; i++) {
+		mac[i] = ai->config.macAddr[i];
+	}
+
+	/* Check to see if there are any insmod configured
+	   rates to add */
+	if (rates[0]) {
+		memset(ai->config.rates, 0, sizeof(ai->config.rates));
+		for (i = 0; i < 8 && rates[i]; i++) {
+			ai->config.rates[i] = rates[i];
+		}
+	}
+	set_bit (FLAG_COMMIT, &ai->flags);
+
+	return SUCCESS;
+}
+
+
 static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 {
 	Cmd cmd;
@@ -3864,58 +3926,9 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 	if (lock)
 		up(&ai->sem);
 	if (ai->config.len == 0) {
-		int i;
-		tdsRssiRid rssi_rid;
-		CapabilityRid cap_rid;
-
-		kfree(ai->SSID);
-		ai->SSID = NULL;
-		// general configuration (read/modify/write)
-		status = readConfigRid(ai, lock);
-		if (status != SUCCESS) return ERROR;
-
-		status = readCapabilityRid(ai, &cap_rid, lock);
-		if (status != SUCCESS) return ERROR;
-
-		status = PC4500_readrid(ai, RID_RSSI,&rssi_rid, sizeof(rssi_rid), lock);
-		if (status == SUCCESS) {
-			if (ai->rssi || (ai->rssi = kmalloc(512, GFP_KERNEL)) != NULL)
-				memcpy(ai->rssi, (u8*)&rssi_rid + 2, 512); /* Skip RID length member */
-		}
-		else {
-			kfree(ai->rssi);
-			ai->rssi = NULL;
-			if (cap_rid.softCap & cpu_to_le16(8))
-				ai->config.rmode |= RXMODE_NORMALIZED_RSSI;
-			else
-				airo_print_warn(ai->dev->name, "unknown received signal "
-						"level scale");
-		}
-		ai->config.opmode = adhoc ? MODE_STA_IBSS : MODE_STA_ESS;
-		set_auth_type(ai, AUTH_OPEN);
-		ai->config.modulation = MOD_CCK;
-
-		if (le16_to_cpu(cap_rid.len) >= sizeof(cap_rid) &&
-		    (cap_rid.extSoftCap & cpu_to_le16(1)) &&
-		    micsetup(ai) == SUCCESS) {
-			ai->config.opmode |= MODE_MIC;
-			set_bit(FLAG_MIC_CAPABLE, &ai->flags);
-		}
-
-		/* Save off the MAC */
-		for (i = 0; i < ETH_ALEN; i++) {
-			mac[i] = ai->config.macAddr[i];
-		}
-
-		/* Check to see if there are any insmod configured
-		   rates to add */
-		if (rates[0]) {
-			memset(ai->config.rates, 0, sizeof(ai->config.rates));
-			for (i = 0; i < 8 && rates[i]; i++) {
-				ai->config.rates[i] = rates[i];
-			}
-		}
-		set_bit (FLAG_COMMIT, &ai->flags);
+		status = airo_readconfig(ai, mac, lock);
+		if (status != SUCCESS)
+			return ERROR;
 	}
 
 	/* Setup the SSIDs if present */
-- 
2.29.2

