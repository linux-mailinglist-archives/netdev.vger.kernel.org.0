Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59252124635
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLRLx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:53:58 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39216 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLRLx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:53:58 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so1155803pga.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lt4EJq4unEZjPiC9PsP6hXjOGyoEw3R1RCPTJikrzIk=;
        b=QVzjlN7Kl1nvJxIg06p130wL/PLq8dbfvoSMMhxYF62p7nbqOHCj0cCd0WIqylyWTD
         aCcWb1wLisHn9KMeRYurL18PGnm09oP7AIC7TVcH9GPRzGm6h8zSbOg6sEYNm7VZaZpI
         HsvgW1dkfrmXnqD/i++wLtxojHm43YMW7rXWyu5DIm6zNlYIaDf8KX8VDt4TzCUeQJcf
         TuCnDyQTr22Ou6DSAErRN/9fS++GKpx8jp8v9xlxH1pT3UapJG1BKgIm2kkEtd33g18X
         TTGfcGFJrEokVSaxhbij0ZwQTTKXTOUSo3fm8aoqIRbHeTsKusMLqcfO/2xj0pXjbEhA
         BVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lt4EJq4unEZjPiC9PsP6hXjOGyoEw3R1RCPTJikrzIk=;
        b=nQ50avfI2R4u6ZQMSEezfo16G9kfsUxegrQa8ZBH+u14pfOG15+4ZPWiL4OlULXloF
         DAdjWdVWf4EHjFDA3u01Mm/+M1bGJ0dxZfgEcwzlW9QY73fHE0F4r2Puryxxpl89u04t
         wbmAkqDQRZ6yYXudfKGSecg9y2QHRvg+8MpScSKgWWoW4xxLgAzef5AWAvSFOxqb0Tpd
         wHQXhbuVT1nURaZn5Gigf5maO2X9GZoKxp9AliJxCK3QSeE+0zBO0Iar4Vg3twcVpBEg
         Z0yH8T5ZBiCYEsFq6fhrPxeJEUCo7lwQ5/TBPCv2LwSlg9jCU8gK7Ym21jgAmSrk66qB
         +jjA==
X-Gm-Message-State: APjAAAWwJSP13tg3PqV8iO4oL/0vaw/wqJu2usBvtlwws6vimj7lQFJp
        aDEgupNMXUwdAdT6cW3tTPBfRTGqXTzygg==
X-Google-Smtp-Source: APXvYqxsdyW+qg5iiPK/tCviVPby8JpLisrJHfEasaA88yVhymYMiI+fxo21WPIpmNE1ECDCzAhi/Q==
X-Received: by 2002:a63:ff20:: with SMTP id k32mr2548552pgi.448.1576670037292;
        Wed, 18 Dec 2019 03:53:57 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:53:56 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 4/8] net/dst: add new function skb_dst_update_pmtu_no_confirm
Date:   Wed, 18 Dec 2019 19:53:09 +0800
Message-Id: <20191218115313.19352-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new function skb_dst_update_pmtu_no_confirm() for callers who need
update pmtu but should not do neighbor confirm.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/dst.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/dst.h b/include/net/dst.h
index 0739e84152e4..208e7c0c89d8 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -519,6 +519,15 @@ static inline void skb_dst_update_pmtu(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, true);
 }
 
+/* update dst pmtu but not do neighbor confirm */
+static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
+{
+	struct dst_entry *dst = skb_dst(skb);
+
+	if (dst && dst->ops->update_pmtu)
+		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
+}
+
 static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
 					 struct dst_entry *encap_dst,
 					 int headroom)
-- 
2.19.2

