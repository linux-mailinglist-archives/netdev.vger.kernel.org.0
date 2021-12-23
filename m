Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D9647DCF0
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbhLWBPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:15:14 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:27256 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346228AbhLWBOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=rJXQOqUi7Z+t6XaVH9q545zE1/vlk/+8IKkDxm7FsTA=;
        b=Jq09PeTp4tmdjzejIOn7GRnC8UQC9IhgNf/MfNPwBoqpbYRwFJtGIfqa6r2xAD0hyGmo
        qUeXV00uwMEkb+EBMYhzu7YgoYrmkruDeMJkoZxKeoTJcnboQeJrEw4B2M1FGAvlJkbiaU
        WB/+71VeYb3IykMHEHb2bcS8avWSq7PTbPWCksOS36o0zT7DhgudGZA6GnBiYrF1nLHWSV
        S9NhShvSMR9CQcj9crOZ/p8MSIUZ0tYtKwHEEcuosNiS7sJ0d5U+798B3MQZY/CZFmiBJ5
        YnsnbZCm1pOPWeRE86KFDMaJXU5nVe/TvRhIzIjDPQEtai2E4zUlIxm471YQNmEg==
Received: by filterdrecv-75ff7b5ffb-v6hzv with SMTP id filterdrecv-75ff7b5ffb-v6hzv-1-61C3CD5E-45
        2021-12-23 01:14:06.791119181 +0000 UTC m=+9687188.981580391
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-1 (SG)
        with ESMTP
        id W-w5aYJ6SZyvTvooy91cCw
        Thu, 23 Dec 2021 01:14:06.662 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id AB1DB70054A; Wed, 22 Dec 2021 18:14:05 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 33/50] wilc1000: move ac_desired_ratio calculation to where
 its needed
Date:   Thu, 23 Dec 2021 01:14:07 +0000 (UTC)
Message-Id: <20211223011358.4031459-34-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvO2CLe60Vy4lC9UTY?=
 =?us-ascii?Q?Ro5Pro2bUgGjRcBWEHwUu4+dWi6YKfFFjN5hIcG?=
 =?us-ascii?Q?IpVl0qlV=2FIHf4fP0BO1pHkp5BWIRRkjQIwhO3m=2F?=
 =?us-ascii?Q?gS6a20INkrr01aXHLlOLCM7GbpUpt+frc6OLCOa?=
 =?us-ascii?Q?n7gF591xldHT+yvFAI+91IcWRXESYGrm1xcBuN?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ac_desired_ratio calculation to fill_vmm_table() since that's the
only place that needs it.  Note that it is unnecessary to initialize
the array since ac_balance() is guaranteed to fill it in.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 5939ed5b2db68..64497754a36b1 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -643,8 +643,6 @@ static u32 vmm_table_entry(struct sk_buff *tqe, u32 vmm_sz)
 /**
  * fill_vmm_table() - Fill VMM table with packets to be sent
  * @wilc: Pointer to the wilc structure.
- * @ac_desired_ratio: First-round limit on number of packets to add from the
- *	respective queue.
  * @vmm_table: Pointer to the VMM table to fill.
  * @vmm_entries_ac: Pointer to the queue-number table to fill.
  *	For each packet added to the VMM table, this will be filled in
@@ -664,7 +662,6 @@ static u32 vmm_table_entry(struct sk_buff *tqe, u32 vmm_sz)
  *	so the returned number is at most WILC_VMM_TBL_SIZE-1.
  */
 static int fill_vmm_table(const struct wilc *wilc,
-			  u8 ac_desired_ratio[NQUEUES],
 			  u32 vmm_table[WILC_VMM_TBL_SIZE],
 			  u8 vmm_entries_ac[WILC_VMM_TBL_SIZE])
 {
@@ -672,6 +669,7 @@ static int fill_vmm_table(const struct wilc *wilc,
 	u8 k, ac;
 	u32 sum;
 	static const u8 ac_preserve_ratio[NQUEUES] = {1, 1, 1, 1};
+	u8 ac_desired_ratio[NQUEUES];
 	const u8 *num_pkts_to_add;
 	bool ac_exist = 0;
 	int vmm_sz = 0;
@@ -683,6 +681,8 @@ static int fill_vmm_table(const struct wilc *wilc,
 
 	i = 0;
 	sum = 0;
+
+	ac_balance(wilc, ac_desired_ratio);
 	num_pkts_to_add = ac_desired_ratio;
 	do {
 		ac_exist = 0;
@@ -909,7 +909,6 @@ static int send_packets(struct wilc *wilc, int len)
 int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 {
 	int vmm_table_len, entries, len;
-	u8 ac_desired_ratio[NQUEUES] = {0, 0, 0, 0};
 	u8 vmm_entries_ac[WILC_VMM_TBL_SIZE];
 	int ret = 0;
 	u32 vmm_table[WILC_VMM_TBL_SIZE];
@@ -919,8 +918,6 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	if (wilc->quit)
 		goto out_update_cnt;
 
-	ac_balance(wilc, ac_desired_ratio);
-
 	mutex_lock(&wilc->txq_add_to_head_cs);
 
 	srcu_idx = srcu_read_lock(&wilc->srcu);
@@ -928,7 +925,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		wilc_wlan_txq_filter_dup_tcp_ack(vif->ndev);
 	srcu_read_unlock(&wilc->srcu, srcu_idx);
 
-	vmm_table_len = fill_vmm_table(wilc, ac_desired_ratio, vmm_table, vmm_entries_ac);
+	vmm_table_len = fill_vmm_table(wilc, vmm_table, vmm_entries_ac);
 	if (vmm_table_len == 0)
 		goto out_unlock;
 
-- 
2.25.1

