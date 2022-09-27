Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAA65EC5FC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbiI0O1c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 10:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiI0O12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:27:28 -0400
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599CCE7E14;
        Tue, 27 Sep 2022 07:27:17 -0700 (PDT)
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F921120EB0;
        Tue, 27 Sep 2022 14:27:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf13.hostedemail.com (Postfix) with ESMTPA id D232220012;
        Tue, 27 Sep 2022 14:26:56 +0000 (UTC)
Message-ID: <5138b5a347b79a5f35b75d0babf5f41dbace879a.camel@perches.com>
Subject: Re: [PATCH 3/7] s390/qeth: Convert snprintf() to scnprintf()
From:   Joe Perches <joe@perches.com>
To:     Jules Irenge <jbi.octave@gmail.com>, borntraeger@linux.ibm.com
Cc:     svens@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        agordeev@linux.ibm.com
Date:   Tue, 27 Sep 2022 07:27:11 -0700
In-Reply-To: <YzHyniCyf+G/2xI8@fedora>
References: <YzHyniCyf+G/2xI8@fedora>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: D232220012
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: hfrsqr1aiuhwykc1jk9pd19i58j8h7zf
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/6MoNGsdYFiQboGBrqKwtQnwUUXPcFSwo=
X-HE-Tag: 1664288816-783624
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-26 at 19:42 +0100, Jules Irenge wrote:
> Coccinnelle reports a warning
> Warning: Use scnprintf or sprintf
> Adding to that, there has been a slow migration from snprintf to scnprintf.
> This LWN article explains the rationale for this change
> https: //lwn.net/Articles/69419/
> Ie. snprintf() returns what *would* be the resulting length,
> while scnprintf() returns the actual length.
[]
> diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
[]
> @@ -500,9 +500,9 @@ static ssize_t qeth_hw_trap_show(struct device *dev,
>  	struct qeth_card *card = dev_get_drvdata(dev);
>  
>  	if (card->info.hwtrap)
> -		return snprintf(buf, 5, "arm\n");
> +		return scnprintf(buf, 5, "arm\n");
>  	else
> -		return snprintf(buf, 8, "disarm\n");
> +		return scnprintf(buf, 8, "disarm\n");
>  }

Use sysfs_emit instead.

For the entire file, perhaps something like: (untested)
---
 drivers/s390/net/qeth_core_sys.c | 109 +++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/s390/net/qeth_core_sys.c b/drivers/s390/net/qeth_core_sys.c
index 406be169173ce..d7d6fd78129b3 100644
--- a/drivers/s390/net/qeth_core_sys.c
+++ b/drivers/s390/net/qeth_core_sys.c
@@ -20,19 +20,21 @@ static ssize_t qeth_dev_state_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
+	const char *type = "UNKNOWN";
 
 	switch (card->state) {
 	case CARD_STATE_DOWN:
-		return sprintf(buf, "DOWN\n");
+		type = "DOWN";
+		break;
 	case CARD_STATE_SOFTSETUP:
-		if (card->dev->flags & IFF_UP)
-			return sprintf(buf, "UP (LAN %s)\n",
-				       netif_carrier_ok(card->dev) ? "ONLINE" :
-								     "OFFLINE");
-		return sprintf(buf, "SOFTSETUP\n");
-	default:
-		return sprintf(buf, "UNKNOWN\n");
+		if (!(card->dev->flags & IFF_UP)) {
+			type = "SOFTSETUP";
+			break;
+		}
+		return sysfs_emit(buf, "UP (LAN %sLINE)\n",
+				  netif_carrier_ok(card->dev) ? "ON" : "OFF");
 	}
+	return sysfs_emit(buf, "%s\n", type);
 }
 
 static DEVICE_ATTR(state, 0444, qeth_dev_state_show, NULL);
@@ -42,7 +44,7 @@ static ssize_t qeth_dev_chpid_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%02X\n", card->info.chpid);
+	return sysfs_emit(buf, "%02X\n", card->info.chpid);
 }
 
 static DEVICE_ATTR(chpid, 0444, qeth_dev_chpid_show, NULL);
@@ -52,7 +54,7 @@ static ssize_t qeth_dev_if_name_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", netdev_name(card->dev));
+	return sysfs_emit(buf, "%s\n", netdev_name(card->dev));
 }
 
 static DEVICE_ATTR(if_name, 0444, qeth_dev_if_name_show, NULL);
@@ -62,7 +64,7 @@ static ssize_t qeth_dev_card_type_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", qeth_get_cardname_short(card));
+	return sysfs_emit(buf, "%s\n", qeth_get_cardname_short(card));
 }
 
 static DEVICE_ATTR(card_type, 0444, qeth_dev_card_type_show, NULL);
@@ -86,7 +88,7 @@ static ssize_t qeth_dev_inbuf_size_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", qeth_get_bufsize_str(card));
+	return sysfs_emit(buf, "%s\n", qeth_get_bufsize_str(card));
 }
 
 static DEVICE_ATTR(inbuf_size, 0444, qeth_dev_inbuf_size_show, NULL);
@@ -96,7 +98,7 @@ static ssize_t qeth_dev_portno_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->dev->dev_port);
+	return sysfs_emit(buf, "%i\n", card->dev->dev_port);
 }
 
 static ssize_t qeth_dev_portno_store(struct device *dev,
@@ -134,7 +136,7 @@ static DEVICE_ATTR(portno, 0644, qeth_dev_portno_show, qeth_dev_portno_store);
 static ssize_t qeth_dev_portname_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "no portname required\n");
+	return sysfs_emit(buf, "no portname required\n");
 }
 
 static ssize_t qeth_dev_portname_store(struct device *dev,
@@ -154,22 +156,27 @@ static ssize_t qeth_dev_prioqing_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
+	const char *type = "disabled";
 
 	switch (card->qdio.do_prio_queueing) {
 	case QETH_PRIO_Q_ING_PREC:
-		return sprintf(buf, "%s\n", "by precedence");
+		type = "by precedence";
+		break;
 	case QETH_PRIO_Q_ING_TOS:
-		return sprintf(buf, "%s\n", "by type of service");
+		type = "by type of service";
+		break;
 	case QETH_PRIO_Q_ING_SKB:
-		return sprintf(buf, "%s\n", "by skb-priority");
+		type = "by skb-priority";
+		break;
 	case QETH_PRIO_Q_ING_VLAN:
-		return sprintf(buf, "%s\n", "by VLAN headers");
+		type = "by VLAN headers";
+		break;
 	case QETH_PRIO_Q_ING_FIXED:
-		return sprintf(buf, "always queue %i\n",
-			       card->qdio.default_out_queue);
-	default:
-		return sprintf(buf, "disabled\n");
+		return sysfs_emit(buf, "always queue %i\n",
+				  card->qdio.default_out_queue);
 	}
+
+	return sysfs_emit(buf, "%s\n", type);
 }
 
 static ssize_t qeth_dev_prioqing_store(struct device *dev,
@@ -242,7 +249,7 @@ static ssize_t qeth_dev_bufcnt_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->qdio.in_buf_pool.buf_count);
+	return sysfs_emit(buf, "%i\n", card->qdio.in_buf_pool.buf_count);
 }
 
 static ssize_t qeth_dev_bufcnt_store(struct device *dev,
@@ -298,7 +305,7 @@ static DEVICE_ATTR(recover, 0200, NULL, qeth_dev_recover_store);
 static ssize_t qeth_dev_performance_stats_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "1\n");
+	return sysfs_emit(buf, "1\n");
 }
 
 static ssize_t qeth_dev_performance_stats_store(struct device *dev,
@@ -335,7 +342,7 @@ static ssize_t qeth_dev_layer2_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->options.layer);
+	return sysfs_emit(buf, "%i\n", card->options.layer);
 }
 
 static ssize_t qeth_dev_layer2_store(struct device *dev,
@@ -407,17 +414,21 @@ static ssize_t qeth_dev_isolation_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
+	const char *type = "N/A";
 
 	switch (card->options.isolation) {
 	case ISOLATION_MODE_NONE:
-		return snprintf(buf, 6, "%s\n", ATTR_QETH_ISOLATION_NONE);
+		type = ATTR_QETH_ISOLATION_NONE;
+		break;
 	case ISOLATION_MODE_FWD:
-		return snprintf(buf, 9, "%s\n", ATTR_QETH_ISOLATION_FWD);
+		type = ATTR_QETH_ISOLATION_FWD;
+		break;
 	case ISOLATION_MODE_DROP:
-		return snprintf(buf, 6, "%s\n", ATTR_QETH_ISOLATION_DROP);
-	default:
-		return snprintf(buf, 5, "%s\n", "N/A");
+		type = ATTR_QETH_ISOLATION_DROP;
+		break;
 	}
+
+	return sysfs_emit("%s\n", type);
 }
 
 static ssize_t qeth_dev_isolation_store(struct device *dev,
@@ -467,28 +478,31 @@ static ssize_t qeth_dev_switch_attrs_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 	struct qeth_switch_info sw_info;
-	int	rc = 0;
+	int len = 0;
+	int rc;
 
 	if (!qeth_card_hw_is_reachable(card))
-		return sprintf(buf, "n/a\n");
+		return sysfs_emit(buf, "n/a\n");
 
 	rc = qeth_query_switch_attributes(card, &sw_info);
 	if (rc)
 		return rc;
 
 	if (!sw_info.capabilities)
-		rc = sprintf(buf, "unknown");
+		return sysfs_emit(buf, "unknown\n");
 
 	if (sw_info.capabilities & QETH_SWITCH_FORW_802_1)
-		rc = sprintf(buf, (sw_info.settings & QETH_SWITCH_FORW_802_1 ?
-							"[802.1]" : "802.1"));
-	if (sw_info.capabilities & QETH_SWITCH_FORW_REFL_RELAY)
-		rc += sprintf(buf + rc,
-			(sw_info.settings & QETH_SWITCH_FORW_REFL_RELAY ?
-							" [rr]" : " rr"));
-	rc += sprintf(buf + rc, "\n");
-
-	return rc;
+		len += sysfs_emit_at(buf, len,
+				     sw_info.settings & QETH_SWITCH_FORW_802_1 ?
+				     "[802.1]" : "802.1");
+	if (sw_info.capabilities & QETH_SWITCH_FORW_REFL_RELAY) {
+		if (len)
+			len += sysfs_emit_at(buf, len, " ");
+		len += sysfs_emit_at(buf, len,
+				     sw_info.settings & QETH_SWITCH_FORW_REFL_RELAY ?
+				     "[rr]" : "rr");
+	}
+	return sysfs_emit_at(buf, len, "\n");
 }
 
 static DEVICE_ATTR(switch_attrs, 0444,
@@ -499,10 +513,7 @@ static ssize_t qeth_hw_trap_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	if (card->info.hwtrap)
-		return snprintf(buf, 5, "arm\n");
-	else
-		return snprintf(buf, 8, "disarm\n");
+	return sysfs_emit(buf, "%s\n", card->info.hwtrap ? "arm" : "disarm");
 }
 
 static ssize_t qeth_hw_trap_store(struct device *dev,
@@ -573,7 +584,7 @@ static ssize_t qeth_dev_blkt_total_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->info.blkt.time_total);
+	return sysfs_emit(buf, "%i\n", card->info.blkt.time_total);
 }
 
 static ssize_t qeth_dev_blkt_total_store(struct device *dev,
@@ -593,7 +604,7 @@ static ssize_t qeth_dev_blkt_inter_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->info.blkt.inter_packet);
+	return sysfs_emit(buf, "%i\n", card->info.blkt.inter_packet);
 }
 
 static ssize_t qeth_dev_blkt_inter_store(struct device *dev,
@@ -613,7 +624,7 @@ static ssize_t qeth_dev_blkt_inter_jumbo_show(struct device *dev,
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%i\n", card->info.blkt.inter_packet_jumbo);
+	return sysfs_emit(buf, "%i\n", card->info.blkt.inter_packet_jumbo);
 }
 
 static ssize_t qeth_dev_blkt_inter_jumbo_store(struct device *dev,

