Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98765301318
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbhAWEyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbhAWEyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 23:54:10 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EABC0613D6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:30 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id y205so5172694pfc.5
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 20:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=h7VPruB668G7g5/SHWgIuv8gpm2uLDqUmzfEvcvvW90=;
        b=iG69MaHjvgRumTR94d6RYcAhIJ6aQV+bMIO2wNQAw9J7AOdXwvyKEVbtrrLT87O7zm
         GNSXlguoaF4IsPVCpGcn/2JWN5Yf7UZbednoHt7ego4nwLXR05jIw2DG3intLMTpk50P
         ZPF5J+cCDkdIDMT6pnn6zhqng02CAf6+o+Nao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=h7VPruB668G7g5/SHWgIuv8gpm2uLDqUmzfEvcvvW90=;
        b=YjR/ZxgWxtDrft1Q1rECkDdgH8I7KdaS3GL5RWmuu6oNO5agbsxx6RQ/ACTFaPdddM
         i1MAd/U2FBEO5lrOvn71st/AoejbyRUFZlCmLnoLz4yg0uYG9jvpViIC+RqDQSGnGsu1
         Gu6SozHTmFVc9CnLF29uEXpsH9eI239EPHAGi4JVfjUB/wzx0+5M3GlyRrglkK/sAsEi
         aBUkddF1g/p1bF/zwsKnT1/Rr1hvgdQBTK789vNWD4sqHyvKzXSNy/afulss9nbFBYIP
         mSx2T3Yzjmk/ieFSK0oAJb58WwnaYSjBz+2ukwW/vlJQW++goY46Pu6mWkAnPz66o662
         RJ+w==
X-Gm-Message-State: AOAM530iey/fW/aZZ4xxF8ugKys10sSrJ1T6taDfJkqVi8jFhH66wfDN
        7OjMkyXEj2v9vi6UvARlUlLCxtsbHN2/IvuUWFY4FcQnz4Bl4ACL0e+IORp99/6H4r3FJnvu7US
        FXegcwYrsXvJbEa59L3NC7RWSGMSwqmjY00c45gXxPjpQ5izckFwxL1gfZvbmeOSY0rDn1vbx
X-Google-Smtp-Source: ABdhPJw+4Yh1sHiUlRpUnv16S72bwaklF4sSmvr7Q90atuyIeCdGhyMj/4gL50mk//zzuJuE6leAjw==
X-Received: by 2002:a62:e30e:0:b029:1b9:3823:4b3a with SMTP id g14-20020a62e30e0000b02901b938234b3amr1994914pfh.15.1611377609441;
        Fri, 22 Jan 2021 20:53:29 -0800 (PST)
Received: from hex.swdvt.lab.broadcom.net ([2600:8802:d04:de02::77c])
        by smtp.gmail.com with ESMTPSA id d2sm10725832pjd.29.2021.01.22.20.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 20:53:28 -0800 (PST)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 1/4] netlink: truncate overlength attribute list in nla_nest_end()
Date:   Fri, 22 Jan 2021 20:53:18 -0800
Message-Id: <20210123045321.2797360-2-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123045321.2797360-1-edwin.peer@broadcom.com>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000a6c6705b98a16e0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000a6c6705b98a16e0
Content-Transfer-Encoding: 8bit

If a nested list of attributes is too long, then the length will
exceed the 16-bit nla_len of the parent nlattr. In such cases,
determine how many whole attributes can fit and truncate the
message to this length. This properly maintains the nesting
hierarchy, keeping the entire message valid, while fitting more
subelements inside the nest range than may result if the length
is wrapped modulo 64KB.

Marking truncated attributes, such that user space can determine
the precise attribute truncated, by means of an additional bit in
the nla_type was considered and rejected. The NLA_F_NESTED and
NLA_F_NET_BYTEORDER flags are supposed to be mutually exclusive.
So, in theory, the latter bit could have been redefined for nested
attributes in order to indicate truncation, but user space tools
(most notably iproute2) cannot be relied on to honor NLA_TYPE_MASK,
resulting in alteration of the perceived nla_type and subsequent
catastrophic failure.

Failing the entire message with a hard error must also be rejected,
as this would break existing user space functionality. The trigger
issue is evident for IFLA_VFINFO_LIST and a hard error here would
cause iproute2 to fail to render an entire interface list even if
only a single interface warranted a truncated VF list. Instead, set
NLM_F_NEST_TRUNCATED in the netlink header to inform user space
about the incomplete data. In this particular case, however, user
space can better ascertain which instance is truncated by consulting
the associated IFLA_NUM_VF to determine how many VFs were expected.

Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 include/net/netlink.h        | 11 +++++++++--
 include/uapi/linux/netlink.h |  1 +
 lib/nlattr.c                 | 27 +++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 1ceec518ab49..fc8c57dafb05 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1785,19 +1785,26 @@ static inline struct nlattr *nla_nest_start(struct sk_buff *skb, int attrtype)
 	return nla_nest_start_noflag(skb, attrtype | NLA_F_NESTED);
 }
 
+int __nla_nest_trunc_msg(struct sk_buff *skb, const struct nlattr *start);
+
 /**
  * nla_nest_end - Finalize nesting of attributes
  * @skb: socket buffer the attributes are stored in
  * @start: container attribute
  *
  * Corrects the container attribute header to include the all
- * appeneded attributes.
+ * appeneded attributes. The list of attributes will be truncated
+ * if too long to fit within the parent attribute's maximum reach.
  *
  * Returns the total data length of the skb.
  */
 static inline int nla_nest_end(struct sk_buff *skb, struct nlattr *start)
 {
-	start->nla_len = skb_tail_pointer(skb) - (unsigned char *)start;
+	int len = skb_tail_pointer(skb) - (unsigned char *)start;
+
+	if (len > 0xffff)
+		len = __nla_nest_trunc_msg(skb, start);
+	start->nla_len = len;
 	return skb->len;
 }
 
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 3d94269bbfa8..44a250825c30 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -57,6 +57,7 @@ struct nlmsghdr {
 #define NLM_F_ECHO		0x08	/* Echo this request 		*/
 #define NLM_F_DUMP_INTR		0x10	/* Dump was inconsistent due to sequence change */
 #define NLM_F_DUMP_FILTERED	0x20	/* Dump was filtered as requested */
+#define NLM_F_NEST_TRUNCATED	0x40	/* Message contains truncated nested attribute */
 
 /* Modifiers to GET request */
 #define NLM_F_ROOT	0x100	/* specify tree	root	*/
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 5b6116e81f9f..2a267c0d3e16 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -1119,4 +1119,31 @@ int nla_append(struct sk_buff *skb, int attrlen, const void *data)
 	return 0;
 }
 EXPORT_SYMBOL(nla_append);
+
+/**
+ * __nla_nest_trunc_msg - Truncate list of nested netlink attributes to max len
+ * @skb: socket buffer with tail pointer positioned after end of nested list
+ * @start: container attribute designating the beginning of the list
+ *
+ * Trims the skb to fit only the attributes which are within the range of the
+ * containing nest attribute. This is a helper for nla_nest_end, to prevent
+ * adding unduly to the length of what is an inline function. It is not
+ * intended to be called from anywhere else.
+ *
+ * Returns the truncated length of the enclosing nest attribute in accordance
+ * with the number of whole attributes that can fit.
+ */
+int __nla_nest_trunc_msg(struct sk_buff *skb, const struct nlattr *start)
+{
+	struct nlattr *attr = nla_data(start);
+	int rem = 0xffff - NLA_HDRLEN;
+
+	while (nla_ok(attr, rem))
+		attr = nla_next(attr, &rem);
+	nlmsg_trim(skb, attr);
+	nlmsg_hdr(skb)->nlmsg_flags |= NLM_F_NEST_TRUNCATED;
+	return (unsigned char *)attr - (unsigned char *)start;
+}
+EXPORT_SYMBOL(__nla_nest_trunc_msg);
+
 #endif
-- 
2.30.0


--0000000000000a6c6705b98a16e0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
mbo++PCnVfHaIk6rK1M0CPodEV0uUttmi6Mp/Ha7XmNgWQeQE3qkFIwAlb/kPNmJAMECAwEAAaOC
Ac4wggHKMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUHMAKGQWh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNoYTJnM29j
c3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25h
bHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1UdHwQ9MDsw
OaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hhMmczLmNy
bDAiBgNVHREEGzAZgRdlZHdpbi5wZWVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcD
BDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU9IOrXBkaTFAmOmjl
0nu9X2Lzo+0wDQYJKoZIhvcNAQELBQADggEBADL+5FenxoguXoMm8ZG+bsMvN0LibFO75wee8cJI
3K8dcJ8y6rPc6yvMRqI7CNwjWV5kBT3aQPZCdqOlNLl/HnKJxBt3WJRWGePcE1s/ljK4Kg1rUQAo
e3Fx6cKh9/q3gqElSPU5pBOsCEy8cbi6UGA+IVifQ2Mrm5tsvYqWSaZ1mKTGz8/z8vxG2kGJZI6W
wL3owFiCmLmw5R8OH22wqf/7sQFMRpH5IQFLRYdU9uCUy5FlUAgiCEXegph8ytxvo8MgYyQcCOeg
BMfFgFEHuM2IgsDQyFC6XUViX6BQny67nlrO8pqwNRJ9Bdd7ykLCzCLOuR1znBAc2wAL9OKQe0cx
ggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMw
MQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDCXgDAeB
YW0HGKjSdzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgfRKa5pR7EXKrm5O/J+YV
FV0SXtQy1lyAiNIqsuB7GZ0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjEwMTIzMDQ1MzI5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQME
ARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJ
YIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAd3aVXg5qZWTlGoD14nrPno4NKljsyn3KUqs4Nr
Wt/43LMCxWCF3oAQUPiYtin1G4/ZPIRyBrZFdoCUycg75lEubKz8W2miOrF3W4+5ELLI3ZBbZoSz
ToRbYWYgfKfivWnU4uFvkosJwSmq7c9qpO8V5g2GOG2VvNIc6A9dCBLoh6nne14O37hrW6rTROsG
a4ha+ZOZzBKpa+fD1LbdCwipFQtqWCf9fWunL06YyulVOpq8z7/QboJx9GEsaAXraf4cnAumLvx4
e4FBvK/Ru4TePfU86I84SOO+CFHnyaKVK3WboqIrFr+GYXdZT+KhEP/FJ2np++ZvwAUV4VG+czc=
--0000000000000a6c6705b98a16e0--
