Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A659322A77
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 05:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730280AbfETDqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 23:46:30 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:32936 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730272AbfETDq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 23:46:29 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8AAA48365B;
        Mon, 20 May 2019 15:46:24 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1558323984;
        bh=Mc4litiz+eviFEgR440Fcubu8b/SJu7ZJd7zHMM0+7c=;
        h=From:To:Cc:Subject:Date;
        b=RC6FAw528RK69BdiaJepOf6T3tvImMC263l2jP2Pw3S8Xv4nu/eDehrfL+oRf+RwX
         ysYrOumxSBfQw079gibiWFwtgPRfluesXn5tPVaNW/MvEz+280Hutl4K2RjZrJOEmW
         wbp8v4HG4tpdVhg7kT9fwdBPtGY+rfL9bt8PDZbrLw3AkCUQv7h2Xr3qekSvISNQqh
         c9gARELJdjM/s7FtIazkpKkn7ycfgdHaaHmzbd8Xj+HF98IcqQ7GCRvGDOHeg0NBX2
         36yApvd8khXBoGgwMt5hJF87Zt1uWQrh5nHJE5BT4SSnvhKpr5w/BIeQej8jJw9HiS
         giG8JazR2F8mw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5ce222f60000>; Mon, 20 May 2019 15:46:03 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by smtp (Postfix) with ESMTP id 0BD0913ED45;
        Mon, 20 May 2019 15:45:59 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 610801E1E39; Mon, 20 May 2019 15:45:57 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com,
        davem@davemloft.net, niveditas98@gmail.com
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2] tipc: Avoid copying bytes beyond the supplied data
Date:   Mon, 20 May 2019 15:45:36 +1200
Message-Id: <20190520034536.22782-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLV_SET is called with a data pointer and a len parameter that tells us
how many bytes are pointed to by data. When invoking memcpy() we need
to careful to only copy len bytes.

Previously we would copy TLV_LENGTH(len) bytes which would copy an extra
4 bytes past the end of the data pointer which newer GCC versions
complain about.

 In file included from test.c:17:
 In function 'TLV_SET',
     inlined from 'test' at test.c:186:5:
 /usr/include/linux/tipc_config.h:317:3:
 warning: 'memcpy' forming offset [33, 36] is out of the bounds [0, 32]
 of object 'bearer_name' with type 'char[32]' [-Warray-bounds]
     memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 test.c: In function 'test':
 test.c::161:10: note:
 'bearer_name' declared here
     char bearer_name[TIPC_MAX_BEARER_NAME];
          ^~~~~~~~~~~

We still want to ensure any padding bytes at the end are initialised, do
this with a explicit memset() rather than copy bytes past the end of
data. Apply the same logic to TCM_SET.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---

Changes in v2:
- Ensure padding bytes are initialised in both TLV_SET and TCM_SET

 include/uapi/linux/tipc_config.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_c=
onfig.h
index 4b2c93b1934c..4955e1a9f1bc 100644
--- a/include/uapi/linux/tipc_config.h
+++ b/include/uapi/linux/tipc_config.h
@@ -307,8 +307,10 @@ static inline int TLV_SET(void *tlv, __u16 type, voi=
d *data, __u16 len)
 	tlv_ptr =3D (struct tlv_desc *)tlv;
 	tlv_ptr->tlv_type =3D htons(type);
 	tlv_ptr->tlv_len  =3D htons(tlv_len);
-	if (len && data)
-		memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
+	if (len && data) {
+		memcpy(TLV_DATA(tlv_ptr), data, len);
+		memset(TLV_DATA(tlv_ptr) + len, 0, TLV_SPACE(len) - tlv_len);
+	}
 	return TLV_SPACE(len);
 }
=20
@@ -405,8 +407,10 @@ static inline int TCM_SET(void *msg, __u16 cmd, __u1=
6 flags,
 	tcm_hdr->tcm_len   =3D htonl(msg_len);
 	tcm_hdr->tcm_type  =3D htons(cmd);
 	tcm_hdr->tcm_flags =3D htons(flags);
-	if (data_len && data)
+	if (data_len && data) {
 		memcpy(TCM_DATA(msg), data, data_len);
+		memset(TCM_DATA(msg) + data_len, 0, TCM_SPACE(data_len) - msg_len);
+	}
 	return TCM_SPACE(data_len);
 }
=20
--=20
2.21.0

