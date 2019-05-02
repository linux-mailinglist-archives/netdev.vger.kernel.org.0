Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09317111CB
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 05:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfEBDKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 23:10:16 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:35033 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfEBDKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 23:10:16 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id D24498364F;
        Thu,  2 May 2019 15:10:12 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1556766612;
        bh=Ex5ej4f1sUQRya9tx03pGqc9hcakoLpecGwtx4QpC6k=;
        h=From:To:Cc:Subject:Date;
        b=CINXXoyIQOuO15bXj17vGhtzx8gCaJTyZLFGCBbvfv4tH0a0Zl9Z2SkLX+/PZ+uZZ
         fZsaBD6q82EGVHJEpRaOuRhClB1Ah+eLzAHbT4QnVUZmpKlXrTuF2+TkXg4SEOKiWQ
         27RbdjP5O/gS6fFV7l6nqQY/kUNb2hREjUkSpCCD7agoZ3tUZFUvh/KV+r+OHscc4e
         aNCqaRLkFWtnp0/SnaQvBc7fRk4sxdnJqTM1oLFagYDfm6mLyT+iMeZVMlewPRL6gk
         HIJsmg3YsyBqPN+cJ5/O2jKY+zRKRlpT5SK9RZ8/F9gVzSnNkFLH0iNSvRUVXf6sQZ
         Z3A9KsukQSFgA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5cca5f950000>; Thu, 02 May 2019 15:10:13 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by smtp (Postfix) with ESMTP id 06F9F13EEA8;
        Thu,  2 May 2019 15:10:13 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 92C881E1D9E; Thu,  2 May 2019 15:10:12 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] tipc: Avoid copying bytes beyond the supplied data
Date:   Thu,  2 May 2019 15:10:04 +1200
Message-Id: <20190502031004.7125-1-chris.packham@alliedtelesis.co.nz>
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

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 include/uapi/linux/tipc_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_c=
onfig.h
index 4b2c93b1934c..f65c5b80ed33 100644
--- a/include/uapi/linux/tipc_config.h
+++ b/include/uapi/linux/tipc_config.h
@@ -308,7 +308,7 @@ static inline int TLV_SET(void *tlv, __u16 type, void=
 *data, __u16 len)
 	tlv_ptr->tlv_type =3D htons(type);
 	tlv_ptr->tlv_len  =3D htons(tlv_len);
 	if (len && data)
-		memcpy(TLV_DATA(tlv_ptr), data, tlv_len);
+		memcpy(TLV_DATA(tlv_ptr), data, len);
 	return TLV_SPACE(len);
 }
=20
--=20
2.21.0

