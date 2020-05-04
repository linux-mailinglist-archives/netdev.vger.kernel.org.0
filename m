Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C671C3D65
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 16:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbgEDOmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 10:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgEDOmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 10:42:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19074C061A0E;
        Mon,  4 May 2020 07:42:39 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l18so10521605wrn.6;
        Mon, 04 May 2020 07:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9FMwwNQtGFnr1eeDSstc6L1dxV0HnTklGu1OpkfvDCw=;
        b=EHoa2S5/zTC/wBYwfEWv98eTrPr34B1kgmKlx4BPOY2AQm5EBhIshVFi7QVcakAuSC
         M6SZTHli0jojNPfoi5yVB5zDpW+EGwKmTBEaBpKrQmH+HI2+f+/rrHh6B3o6/GsyIu1t
         bhhyJ9hfvEbYEgORPmmbvMQfZTJE/gw2RHJgXXsZrvu4k8cZRiWbUBjYzIMYDR4hRa5k
         Zb3bH2jO4e94rEe5ImVUBK91y+X8vi01gV7Bl86Dfl1NLJGbmT3rx74WSBMx2H2TrdO9
         Xdec8oELTWyHllrCZjT+kzK+gA9Rd86fcYUP9ubs8bbXr90fpWg782sV/z+ebwBOvqZN
         hswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9FMwwNQtGFnr1eeDSstc6L1dxV0HnTklGu1OpkfvDCw=;
        b=PWDxYwS6z6M6DwQ+p8DGt9MzW+JJ45Lj4WdgfbNNuCWurUt8hvtbCBedKtY45No5/7
         E9nclv4avUJA/Ln6Gn4tIxAcaFEreZyg4bqdeK7d/v8CwZ2RGpSA1DVUpDa7zX+n2usp
         WbVCj6dU90xtYGoAiac8UVILorZuAQCIt3W+qmf8BGeOJlbMdq63zcJiy+uJyLl4hVyw
         d90P4quBnfZMRWbGteZN8FCNHCRn18sKavb+TK1+OaVB5KycwRfhbEBXzc39X0WzLUEg
         6S00EHYTkUd56WRd9+SH8PCb5GHvu2xIoPUD/Gto9rzQY0lzPsI1iffFfvoyhYVMZ76I
         hJZg==
X-Gm-Message-State: AGi0PuZKCP4kTxuhw5Rme/8dyFUakehYAVuA3Ty7jTtPrHxW64xT0B+t
        IVXR+Hb3fYjYV88Rmj2Hkao=
X-Google-Smtp-Source: APiQypJRbQrLFhGZ3k3jfOD97WL6AD9Bq/GOdddDC18ZWCqOfyY+6vEJ8jnAAszB/q0rCbLg3k693w==
X-Received: by 2002:a5d:4241:: with SMTP id s1mr19110460wrr.250.1588603357853;
        Mon, 04 May 2020 07:42:37 -0700 (PDT)
Received: from localhost.localdomain (dynamic-adsl-78-12-12-93.clienti.tiscali.it. [78.12.12.93])
        by smtp.gmail.com with ESMTPSA id r15sm6566212wrq.93.2020.05.04.07.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:42:37 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dav.lebrun@gmail.com
Cc:     Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: [net] seg6: fix SRH processing to comply with RFC8754
Date:   Mon,  4 May 2020 14:42:11 +0000
Message-Id: <20200504144211.5613-1-ahabdels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Segment Routing Header (SRH) which defines the SRv6 dataplane is defined
in RFC8754.

RFC8754 (section 4.1) defines the SR source node behavior which encapsulates
packets into an outer IPv6 header and SRH. The SR source node encodes the
full list of Segments that defines the packet path in the SRH. Then, the
first segment from list of Segments is copied into the Destination address
of the outer IPv6 header and the packet is sent to the first hop in its path
towards the destination.

If the Segment list has only one segment, the SR source node can omit the SRH
as he only segment is added in the destination address.

RFC8754 (section 4.1.1) defines the Reduced SRH, when a source does not
require the entire SID list to be preserved in the SRH. A reduced SRH does
not contain the first segment of the related SR Policy (the first segment is
the one already in the DA of the IPv6 header), and the Last Entry field is
set to n-2, where n is the number of elements in the SR Policy.

RFC8754 (section 4.3.1.1) defines the SRH processing and the logic to
validate the SRH (S09, S10, S11) which works for both reduced and
non-reduced behaviors.

This patch updates seg6_validate_srh() to validate the SRH as per RFC8754.

Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
---
 net/ipv6/seg6.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 4c7e0a27fa9c..e37d2b34cacc 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -28,6 +28,7 @@
 bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
 {
 	int trailing;
+	int max_last_entry;
 	unsigned int tlv_offset;
 
 	if (srh->type != IPV6_SRCRT_TYPE_4)
@@ -36,7 +37,12 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
 	if (((srh->hdrlen + 1) << 3) != len)
 		return false;
 
-	if (srh->segments_left > srh->first_segment)
+	max_last_entry = (srh->hdrlen / 2) - 1;
+
+	if (srh->first_segment > max_last_entry)
+		return false;
+
+	if (srh->segments_left > srh->first_segment + 1)
 		return false;
 
 	tlv_offset = sizeof(*srh) + ((srh->first_segment + 1) << 4);
-- 
2.17.1

