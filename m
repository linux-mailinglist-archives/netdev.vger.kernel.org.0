Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526811FA926
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 08:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgFPGwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 02:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgFPGwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 02:52:14 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BB0C05BD43;
        Mon, 15 Jun 2020 23:52:14 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r18so8781723pgk.11;
        Mon, 15 Jun 2020 23:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=TUMaHipN2b46YYtI2ONw0ZTI17Rwhgm3i19UCKbwehw=;
        b=ccOxejJJv9IDLGnzsv5M8N5OgBzu9iEhKZoxuMUUrC6EtFKJXyme/XLo1Nmw4on6mQ
         +DAo1I59WfvZe16h8b9fZ+uOKuI9k5DqeFlpqxGOvvo3U1nt9Ogidr1Y2GVF3fSm4XPs
         ZAY89uzqPO8CLQ+Yn4rZw6IrFZYs0bhejDAFYDKXGysHRFWPcT+Jmqf2nBbUVqP3twRE
         BslgjR8kuzF2cmYy0En7Bh2czYJyJiOSGxs4Agw9bgAnrhUn/AYjpdkJjQVKaSZ4r581
         tvAK1Zwjdd1cCV7U5Au8oB7LMpSsa5+lc+ikfY0FSxqPQkXpy0HECHGnDtYx9qeTnZxP
         wgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=TUMaHipN2b46YYtI2ONw0ZTI17Rwhgm3i19UCKbwehw=;
        b=DP6IuKCXdqFfbQGNmt/65t+0K3ohBwBFQzaosyfr/qONAbSjKQeb3tz0yel7CAjn+v
         zcakqOVg69u8TFJfKwJqCR5YUj1LaMspt+iS1eXIxKZbW6k886sLY90IOr5oXLlZYVCD
         0zzySSMCLZmYyOyuWmTPI8IznDRdiRB1NRdkwM9xXnERke5IVKp4lMcEjebEgThMLbXP
         S2IeRDHFcxjLdeD2tz3Wem7WNVeG2w5sygZ9QzSIBUTOEhUmPHKmoYbIbp6vCqUkllpL
         48QcpFb/c6vBnmdgjWJlaxo73GrnnJVNvWmGEtEjG7AgcaP1x47eh48cWkq/lHe0/pzu
         Y0NQ==
X-Gm-Message-State: AOAM532ndabgUPw1pmdRQ+rBntb/EfRhXwksv9gV27GhV/CbBvYUqW/W
        4u5S4PmyIoSatPNaHN8qDiV95Li+ECFJdg==
X-Google-Smtp-Source: ABdhPJxu4sz+eH9d/XahKEH+uVUbo1CljA4RgYFyEWkTKmD4z6rW0v/jt6qGmmkifqfGnab73a42aA==
X-Received: by 2002:aa7:859a:: with SMTP id w26mr820123pfn.10.1592290333937;
        Mon, 15 Jun 2020 23:52:13 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id u24sm164378pga.47.2020.06.15.23.52.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 23:52:13 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] mptcp: add MP_PRIO suboption handling
Date:   Tue, 16 Jun 2020 14:47:36 +0800
Message-Id: <f86a2f6f241b7f7a49fec17b3428ae5a0fadc93e.1592289629.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1592289629.git.geliangtang@gmail.com>
References: <cover.1592289629.git.geliangtang@gmail.com>
In-Reply-To: <cover.1592289629.git.geliangtang@gmail.com>
References: <cover.1592289629.git.geliangtang@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add handling for sending and receiving MP_PRIO suboption.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c  | 14 ++++++++++++++
 net/mptcp/protocol.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 490b92534afc..cc3039f0ac43 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -280,6 +280,14 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		pr_debug("RM_ADDR: id=%d", mp_opt->rm_id);
 		break;
 
+	case MPTCPOPT_MP_PRIO:
+		if (opsize != TCPOLEN_MPTCP_PRIO)
+			break;
+
+		mp_opt->backup = (*ptr++) & MPTCP_PRIO_BACKUP;
+		pr_debug("MP_PRIO: backup=%d", mp_opt->backup);
+		break;
+
 	default:
 		break;
 	}
@@ -961,6 +969,12 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 				      0, opts->rm_id);
 	}
 
+	if (OPTION_MPTCP_PRIO & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_PRIO,
+				      TCPOLEN_MPTCP_PRIO,
+				      opts->backup, 0);
+	}
+
 	if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
 		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
 				      TCPOLEN_MPTCP_MPJ_SYN,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index db56535dfc29..623c9a1c4343 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -23,6 +23,7 @@
 #define OPTION_MPTCP_ADD_ADDR	BIT(6)
 #define OPTION_MPTCP_ADD_ADDR6	BIT(7)
 #define OPTION_MPTCP_RM_ADDR	BIT(8)
+#define OPTION_MPTCP_PRIO	BIT(9)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -58,6 +59,7 @@
 #define TCPOLEN_MPTCP_ADD_ADDR6_BASE_PORT	22
 #define TCPOLEN_MPTCP_PORT_LEN		2
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
+#define TCPOLEN_MPTCP_PRIO		3
 
 /* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
@@ -84,6 +86,9 @@
 #define MPTCP_ADDR_IPVERSION_4	4
 #define MPTCP_ADDR_IPVERSION_6	6
 
+/* MPTCP MP_PRIO flags */
+#define MPTCP_PRIO_BACKUP	BIT(0)
+
 /* MPTCP socket flags */
 #define MPTCP_DATA_READY	0
 #define MPTCP_SEND_SPACE	1
-- 
2.17.1

