Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B3168DDAC
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 17:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjBGQNA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Feb 2023 11:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjBGQMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 11:12:24 -0500
X-Greylist: delayed 360 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Feb 2023 08:12:23 PST
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13508B7;
        Tue,  7 Feb 2023 08:12:22 -0800 (PST)
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay04.hostedemail.com (Postfix) with ESMTP id C551A1A0359;
        Tue,  7 Feb 2023 16:06:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id C3F8220024;
        Tue,  7 Feb 2023 16:06:17 +0000 (UTC)
Message-ID: <c6dc6cf574379a937fdc7718c0516fbdcd82a729.camel@perches.com>
Subject: Re: [PATCH net-next 3/4] s390/qeth: Convert sysfs sprintf to
 sysfs_emit
From:   Joe Perches <joe@perches.com>
To:     Alexandra Winter <wintera@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Jules Irenge <jbi.octave@gmail.com>
Date:   Tue, 07 Feb 2023 08:06:16 -0800
In-Reply-To: <20230206172754.980062-4-wintera@linux.ibm.com>
References: <20230206172754.980062-1-wintera@linux.ibm.com>
         <20230206172754.980062-4-wintera@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: C3F8220024
X-Stat-Signature: dpz89qnzgqgway6nn6chmrabenizgji6
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+qUpqSgxPyAZTfuwEVr9Q5vbDNdEUOpm0=
X-HE-Tag: 1675785977-246594
X-HE-Meta: U2FsdGVkX193cEdlwmSkcm9qsol7wTLH4IzRgitz20IpAvW9inBMsKfTbEOgc41uNWiO5blfubkshSMbR81obg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-06 at 18:27 +0100, Alexandra Winter wrote:
> From: Thorsten Winkler <twinkler@linux.ibm.com>
> 
> Following the advice of the Documentation/filesystems/sysfs.rst.
> All sysfs related show()-functions should only use sysfs_emit() or
> sysfs_emit_at() when formatting the value to be returned to user space.
[]
> diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
[]
> @@ -607,14 +606,12 @@ static ssize_t qeth_l3_dev_ip_add_show(struct device *dev, char *buf,
>  		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
>  			break;
>  
> -		entry_len = scnprintf(buf, PAGE_SIZE - str_len, "%s\n",
> -				      addr_str);
> +		entry_len = sysfs_emit_at(buf, str_len, "%s\n", addr_str);
>  		str_len += entry_len;
> -		buf += entry_len;
>  	}
>  	mutex_unlock(&card->ip_lock);
>  
> -	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
> +	return str_len ? str_len : sysfs_emit(buf, "\n");
>  }
>  
>  static ssize_t qeth_l3_dev_vipa_add4_show(struct device *dev,

One of the intended uses of sysfs_emit is to not require the
knowlege of buf as PAGE_SIZE so it could possibly be
extended/changed.

So perhaps the use of entry_len is useless and the PAGE_SIZE use
above should be removed.

The below though could emit a partial line, dunno if that's a
good thing or not but sysfs is not supposed to emit multiple
lines anyway.
---
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 1082380b21f85..a2a332f29f5c4 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -367,35 +367,24 @@ static ssize_t qeth_l3_dev_ipato_add_show(char *buf, struct qeth_card *card,
 			enum qeth_prot_versions proto)
 {
 	struct qeth_ipato_entry *ipatoe;
-	int str_len = 0;
+	int len = 0;
 
 	mutex_lock(&card->ip_lock);
 	list_for_each_entry(ipatoe, &card->ipato.entries, entry) {
 		char addr_str[40];
-		int entry_len;
 
 		if (ipatoe->proto != proto)
 			continue;
 
-		entry_len = qeth_l3_ipaddr_to_string(proto, ipatoe->addr,
-						     addr_str);
-		if (entry_len < 0)
+		if (qeth_l3_ipaddr_to_string(proto, ipatoe->addr, addr_str) < 0)
 			continue;
 
-		/* Append /%mask to the entry: */
-		entry_len += 1 + ((proto == QETH_PROT_IPV4) ? 2 : 3);
-		/* Enough room to format %entry\n into null terminated page? */
-		if (entry_len + 1 > PAGE_SIZE - str_len - 1)
-			break;
-
-		entry_len = scnprintf(buf, PAGE_SIZE - str_len,
-				      "%s/%i\n", addr_str, ipatoe->mask_bits);
-		str_len += entry_len;
-		buf += entry_len;
+		len += sysfs_emit_at(buf, len, "%s/%i\n",
+				     addr_str, ipatoe->mask_bits);
 	}
 	mutex_unlock(&card->ip_lock);
 
-	return str_len ? str_len : scnprintf(buf, PAGE_SIZE, "\n");
+	return len ?: sysfs_emit(buf, "\n");
 }
 
 static ssize_t qeth_l3_dev_ipato_add4_show(struct device *dev,
