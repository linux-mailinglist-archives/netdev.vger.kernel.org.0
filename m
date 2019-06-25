Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDD55C72
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFYXkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35734 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfFYXkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id f15so533235wrp.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dz2qMvtXU3sd/+w4L8cZDRYrvwV6vOz8GkDSuCxKfI8=;
        b=Mv2uu8kgWCZDoWbvFE2zbAUj73eYIIom65DYKluMDVsNXyrEoFgxvuSPJJJNI3/vV7
         viaVbyhipQiqp3b80Fkwa87sU7KKynqAuDplwZdzpjIYPWdRcgK/Ba1C8xM0Ia4qqoZ9
         p+hvIEabbTXYPktSspvbSvdITEuJBaPQsTKH5Y4NnTU5dn32TvP6Rtp3oakikyK3Oo5s
         HRDZVktPodLkSeYfR2hSig+Q3viMlZRlL8q9eX4N++r5r1jMFYNqFZf0BUbvaBD3ViYb
         eJn0vz4mKJJXRZMsUmh4iFDFzT12im4ybRJx0VIRSXJrEhgdWUdc9V4PQEx/o6sjILcM
         wADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dz2qMvtXU3sd/+w4L8cZDRYrvwV6vOz8GkDSuCxKfI8=;
        b=lHa3iOOL73QNKZIrnj1xzxZymdu+8pXJX9EECROq1lHNt2FxrCXsDBDivT8Jo372Sh
         /DJwLbHXPSVJWxiLL+xDxDM/H1i9SpZ/HsDMVeJGouPJlHNtwqk8PpB81/VqntiRWFSh
         WFHDKK7F1HDP9oZzNFZim+8BV/ygwORgKMmhaaFUTlHajInscUTEC2hoFiGkzg//QNXS
         F8Ys6KuivsoUHa+5qm1Rkx7fsXS6xm15TeBXUi450Qbg3zjrPRxGnqSuKwlMHOmNJ0oL
         EsJVXF65rqvGBd5k2nSXeIP8Sd7/3U4axIcMr4VDM7taTVCJ8o7g6qbBvlek+FWpSALD
         /HcQ==
X-Gm-Message-State: APjAAAV3sI4AJUlThwNPk0EtsoR1TTtw6T7GSuNQfW3oJIvD0w6XpT8D
        0dwliCtLZJ1HiUWcBfF2tCc5orkjzVCX9A==
X-Google-Smtp-Source: APXvYqyv6nMzVXWLvGKiRUSJi/ouMDCeTfGMeizpTzxEPhKSuF0DgAWC/CcQC1hkVurZiBCaLr9QWQ==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr455376wrv.327.1561506010229;
        Tue, 25 Jun 2019 16:40:10 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 07/10] net: dsa: sja1105: Add a high-level overview of the dynamic config interface
Date:   Wed, 26 Jun 2019 02:39:39 +0300
Message-Id: <20190625233942.1946-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When trying to add support for LOCKEDS (static FDB entries) on SJA1105
P/Q/R/S, at first I didn't remember how the abstraction I created
worked, and actually thought it works by mistake.

To avoid other people staring at the code and not making much sense out
of it, add some comments at the top of the file.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 56c83b9d52e4..3acd48615981 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -3,6 +3,98 @@
  */
 #include "sja1105.h"
 
+/* In the dynamic configuration interface, the switch exposes a register-like
+ * view of some of the static configuration tables.
+ * Many times the field organization of the dynamic tables is abbreviated (not
+ * all fields are dynamically reconfigurable) and different from the static
+ * ones, but the key reason for having it is that we can spare a switch reset
+ * for settings that can be changed dynamically.
+ *
+ * This file creates a per-switch-family abstraction called
+ * struct sja1105_dynamic_table_ops and two operations that work with it:
+ * - sja1105_dynamic_config_write
+ * - sja1105_dynamic_config_read
+ *
+ * Compared to the struct sja1105_table_ops from sja1105_static_config.c,
+ * the dynamic accessors work with a compound buffer:
+ *
+ * packed_buf
+ *
+ * |
+ * V
+ * +-----------------------------------------+------------------+
+ * |              ENTRY BUFFER               |  COMMAND BUFFER  |
+ * +-----------------------------------------+------------------+
+ *
+ * <----------------------- packed_size ------------------------>
+ *
+ * The ENTRY BUFFER may or may not have the same layout, or size, as its static
+ * configuration table entry counterpart. When it does, the same packing
+ * function is reused (bar exceptional cases - see
+ * sja1105pqrs_dyn_l2_lookup_entry_packing).
+ *
+ * The reason for the COMMAND BUFFER being at the end is to be able to send
+ * a dynamic write command through a single SPI burst. By the time the switch
+ * reacts to the command, the ENTRY BUFFER is already populated with the data
+ * sent by the core.
+ *
+ * The COMMAND BUFFER is always SJA1105_SIZE_DYN_CMD bytes (one 32-bit word) in
+ * size.
+ *
+ * Sometimes the ENTRY BUFFER does not really exist (when the number of fields
+ * that can be reconfigured is small), then the switch repurposes some of the
+ * unused 32 bits of the COMMAND BUFFER to hold ENTRY data.
+ *
+ * The key members of struct sja1105_dynamic_table_ops are:
+ * - .entry_packing: A function that deals with packing an ENTRY structure
+ *		     into an SPI buffer, or retrieving an ENTRY structure
+ *		     from one.
+ *		     The @packed_buf pointer it's given does always point to
+ *		     the ENTRY portion of the buffer.
+ * - .cmd_packing: A function that deals with packing/unpacking the COMMAND
+ *		   structure to/from the SPI buffer.
+ *		   It is given the same @packed_buf pointer as .entry_packing,
+ *		   so most of the time, the @packed_buf points *behind* the
+ *		   COMMAND offset inside the buffer.
+ *		   To access the COMMAND portion of the buffer, the function
+ *		   knows its correct offset.
+ *		   Giving both functions the same pointer is handy because in
+ *		   extreme cases (see sja1105pqrs_dyn_l2_lookup_entry_packing)
+ *		   the .entry_packing is able to jump to the COMMAND portion,
+ *		   or vice-versa (sja1105pqrs_l2_lookup_cmd_packing).
+ * - .access: A bitmap of:
+ *	OP_READ: Set if the hardware manual marks the ENTRY portion of the
+ *		 dynamic configuration table buffer as R (readable) after
+ *		 an SPI read command (the switch will populate the buffer).
+ *	OP_WRITE: Set if the manual marks the ENTRY portion of the dynamic
+ *		  table buffer as W (writable) after an SPI write command
+ *		  (the switch will read the fields provided in the buffer).
+ *	OP_DEL: Set if the manual says the VALIDENT bit is supported in the
+ *		COMMAND portion of this dynamic config buffer (i.e. the
+ *		specified entry can be invalidated through a SPI write
+ *		command).
+ *	OP_SEARCH: Set if the manual says that the index of an entry can
+ *		   be retrieved in the COMMAND portion of the buffer based
+ *		   on its ENTRY portion, as a result of a SPI write command.
+ *		   Only the TCAM-based FDB table on SJA1105 P/Q/R/S supports
+ *		   this.
+ * - .max_entry_count: The number of entries, counting from zero, that can be
+ *		       reconfigured through the dynamic interface. If a static
+ *		       table can be reconfigured at all dynamically, this
+ *		       number always matches the maximum number of supported
+ *		       static entries.
+ * - .packed_size: The length in bytes of the compound ENTRY + COMMAND BUFFER.
+ *		   Note that sometimes the compound buffer may contain holes in
+ *		   it (see sja1105_vlan_lookup_cmd_packing). The @packed_buf is
+ *		   contiguous however, so @packed_size includes any unused
+ *		   bytes.
+ * - .addr: The base SPI address at which the buffer must be written to the
+ *	    switch's memory. When looking at the hardware manual, this must
+ *	    always match the lowest documented address for the ENTRY, and not
+ *	    that of the COMMAND, since the other 32-bit words will follow along
+ *	    at the correct addresses.
+ */
+
 #define SJA1105_SIZE_DYN_CMD					4
 
 #define SJA1105ET_SIZE_MAC_CONFIG_DYN_ENTRY			\
-- 
2.17.1

