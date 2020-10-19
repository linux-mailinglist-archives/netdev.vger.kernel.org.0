Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91AC29274C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgJSM10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgJSM10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:27:26 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888E9C0613CE;
        Mon, 19 Oct 2020 05:27:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c20so5919389pfr.8;
        Mon, 19 Oct 2020 05:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=wT/TsOhKuL5HL67D4xz7aT44ptac/zTxHCX64c9ov/Y=;
        b=JeWGO7IdSQyHt3ifgiJyIjhZ/BEE9PeB59hozeF8xmMkgITVsDeFXj7VhqkfpQD1FR
         k2Od6nIU32a83IQQJQnBWI5/gh3zTUTnpBE2otDgm7/sMbRBJgFnMpuudzu9oB7GaxLe
         O8Yv2lPkk/u7AxH7KqImNIPNBmTg/t5DFAJoRzH24SjlNdPcW5qMH8a6b/goTdZwi5Tz
         Pz61Mqc+8eObLxXQxFRny69H4rvQb5ERfV1hjirLo481a6zrx+8f5CjDnCMqbbtBv4IK
         9phhnF+4wGs2zVmflrBLRIFMABG84sPU64OBZOoj8Je7q53mWyqWvjYkQU33AbzDiKF5
         H4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=wT/TsOhKuL5HL67D4xz7aT44ptac/zTxHCX64c9ov/Y=;
        b=tR0dmQSnPtsqt2xN3KAIsUsLLEsq9cGheL5rw50I2pUd0iOuMCu8foQmbfCkbFq6DI
         H2YcB+1xYrU7as3uH8QXkGmyPxFKt718Nfagb3w19IyUR/cKf/bnt66P3uy4a+Q91Jp+
         UX6x0jQ9ko4nQKYkK7JJyAyRm2r8NYhN9lEbxjCymz1IEAvdoix4C1RsGY1VFkUUPrIw
         NfcSFQWgru1Uu22Q3q+uO+4VnmVqG8hSlUYSxiRmqcKX3ZCbPUeOvJNs5tqqfRx1YuDm
         w9N2CKa2j1xLBWNJxa7IduTsXKmIDp+TGaAmTqP5spV3e3K7A0sx51xQf6IWTANMN3hE
         ePug==
X-Gm-Message-State: AOAM531O1LJdnnlX86CyiXYkWZxRlQXeXvPJlN0zfIWu62zYcWS2LN8V
        RxLP5GOBPTdC4CxpRIGQ4KY6+FNnJps=
X-Google-Smtp-Source: ABdhPJzQagKRhuIt1tEEq2qxlhb/fNFxitM7uMN787n4Ya3mGodXQwnI9aqJ36qo86FMAHq9s9ib9w==
X-Received: by 2002:a63:c70c:: with SMTP id n12mr13719923pgg.102.1603110444798;
        Mon, 19 Oct 2020 05:27:24 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w187sm11609954pfb.93.2020.10.19.05.27.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:27:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 14/16] sctp: add the error cause for new encapsulation port restart
Date:   Mon, 19 Oct 2020 20:25:31 +0800
Message-Id: <37b49f3c6eb568d25d7e46fa3f55a1c580867bb2.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
 <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
 <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
 <15f6150aa59acd248129723df647d55ea1169d85.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the function to make the abort chunk with
the error cause for new encapsulation port restart, defined
on Section 4.4 in draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.

v1->v2:
  - no change.
v2->v3:
  - no need to call htons() when setting nep.cur_port/new_port.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/sctp.h     | 20 ++++++++++++++++++++
 include/net/sctp/sm.h    |  3 +++
 net/sctp/sm_make_chunk.c | 20 ++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/include/linux/sctp.h b/include/linux/sctp.h
index 7673123..bb19265 100644
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -482,11 +482,13 @@ enum sctp_error {
 	 *  11  Restart of an association with new addresses
 	 *  12  User Initiated Abort
 	 *  13  Protocol Violation
+	 *  14  Restart of an Association with New Encapsulation Port
 	 */
 
 	SCTP_ERROR_RESTART         = cpu_to_be16(0x0b),
 	SCTP_ERROR_USER_ABORT      = cpu_to_be16(0x0c),
 	SCTP_ERROR_PROTO_VIOLATION = cpu_to_be16(0x0d),
+	SCTP_ERROR_NEW_ENCAP_PORT  = cpu_to_be16(0x0e),
 
 	/* ADDIP Section 3.3  New Error Causes
 	 *
@@ -793,4 +795,22 @@ enum {
 	SCTP_FLOWLABEL_VAL_MASK = 0xfffff
 };
 
+/* UDP Encapsulation
+ * draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.html#section-4-4
+ *
+ *   The error cause indicating an "Restart of an Association with
+ *   New Encapsulation Port"
+ *
+ * 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |        Cause Code = 14        |       Cause Length = 8        |
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * |   Current Encapsulation Port  |     New Encapsulation Port    |
+ * +-------------------------------+-------------------------------+
+ */
+struct sctp_new_encap_port_hdr {
+	__be16 cur_port;
+	__be16 new_port;
+};
+
 #endif /* __LINUX_SCTP_H__ */
diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index a499341..fd223c9 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -221,6 +221,9 @@ struct sctp_chunk *sctp_make_violation_paramlen(
 struct sctp_chunk *sctp_make_violation_max_retrans(
 					const struct sctp_association *asoc,
 					const struct sctp_chunk *chunk);
+struct sctp_chunk *sctp_make_new_encap_port(
+					const struct sctp_association *asoc,
+					const struct sctp_chunk *chunk);
 struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
 				       const struct sctp_transport *transport);
 struct sctp_chunk *sctp_make_heartbeat_ack(const struct sctp_association *asoc,
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 21d0ff1..f77484d 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1142,6 +1142,26 @@ struct sctp_chunk *sctp_make_violation_max_retrans(
 	return retval;
 }
 
+struct sctp_chunk *sctp_make_new_encap_port(const struct sctp_association *asoc,
+					    const struct sctp_chunk *chunk)
+{
+	struct sctp_new_encap_port_hdr nep;
+	struct sctp_chunk *retval;
+
+	retval = sctp_make_abort(asoc, chunk,
+				 sizeof(struct sctp_errhdr) + sizeof(nep));
+	if (!retval)
+		goto nodata;
+
+	sctp_init_cause(retval, SCTP_ERROR_NEW_ENCAP_PORT, sizeof(nep));
+	nep.cur_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
+	nep.new_port = chunk->transport->encap_port;
+	sctp_addto_chunk(retval, sizeof(nep), &nep);
+
+nodata:
+	return retval;
+}
+
 /* Make a HEARTBEAT chunk.  */
 struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
 				       const struct sctp_transport *transport)
-- 
2.1.0

