Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A42301DEF
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbhAXRhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:37:46 -0500
Received: from mail-ej1-f43.google.com ([209.85.218.43]:40811 "EHLO
        mail-ej1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbhAXRhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:37:45 -0500
Received: by mail-ej1-f43.google.com with SMTP id gx5so14689252ejb.7
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SAXJszXgtv7TGSnosZ//gygmSv2PxUFIdJ6sy0mrvFg=;
        b=nU6NPivj3LbT5Ti7jPEASiP+2220mUqMnJu080S9AZIqmKLk8PEwY8FDAYswu7bzJS
         xycbhTOqWQ1Yz9VzTs/1A1/s/uZEoVxE7VkHEfgmBwFTerki6v7VUHeifU4tpfewPBGu
         oWd3HitI3mih5E1hmE53cDQncKEk7VYT1ZL4xL5i7gSEjUTjuKpZ2hWyqYsL9za/Z829
         Ctp7cHfQCEDMLDnP37OVclLun11Rbc2L31YczaYT7Y4CbSPWnhTZszNZy29GvsxIZMID
         JACPBw2RplnDmGPhwq1D7ASkg1Hk21wBAmWz+lMVH76xxJOf3n1o3kvhjTYbRJSBHSGm
         f6Xw==
X-Gm-Message-State: AOAM531O7hdN7jI1yV+KkK9WakzsaiQ/3Fz3aFt/BlIv8gyz0Q5FPK4q
        tbrsKS3OsG4k71cJpkKXGr37K5KW5q9m+6GD
X-Google-Smtp-Source: ABdhPJxefZuw7aR8Fu+F59EJbikKv5Tgoj2FV5qebu+ttIxC3c/nMBZQSZKDfxwnjrUTN83cyDaMOA==
X-Received: by 2002:a17:906:2695:: with SMTP id t21mr1127472ejc.287.1611509822927;
        Sun, 24 Jan 2021 09:37:02 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id lz27sm7124313ejb.50.2021.01.24.09.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 09:37:02 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 v2] iproute: force rtm_dst_len to 32/128
Date:   Sun, 24 Jan 2021 17:36:58 +0000
Message-Id: <20210124173658.97203-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124155347.61959-1-bluca@debian.org>
References: <20210124155347.61959-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since NETLINK_GET_STRICT_CHK was enabled, the kernel rejects commands
that pass a prefix length, eg:

 ip route get `1.0.0.0/1
  Error: ipv4: Invalid values in header for route get request.
 ip route get 0.0.0.0/0
  Error: ipv4: rtm_src_len and rtm_dst_len must be 32 for IPv4

Since there's no point in setting a rtm_dst_len that we know is going
to be rejected, just force it to the right value if it's passed on
the command line. Print a warning to stderr to notify users.

Bug-Debian: https://bugs.debian.org/944730
Reported-By: Clément 'wxcafé' Hertling <wxcafe@wxcafe.net>
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
v2: added a warning

 ip/iproute.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index ebb5f160..8d4d2ff8 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -2069,7 +2069,18 @@ static int iproute_get(int argc, char **argv)
 			if (addr.bytelen)
 				addattr_l(&req.n, sizeof(req),
 					  RTA_DST, &addr.data, addr.bytelen);
-			req.r.rtm_dst_len = addr.bitlen;
+			if (req.r.rtm_family == AF_INET && addr.bitlen != 32) {
+				fprintf(stderr,
+					"Warning: /%u as prefix is invalid, only /32 (or none) is supported.\n",
+					addr.bitlen);
+				req.r.rtm_dst_len = 32;
+			} else if (req.r.rtm_family == AF_INET6 && addr.bitlen != 128) {
+				fprintf(stderr,
+					"Warning: /%u as prefix is invalid, only /128 (or none) is supported.\n",
+					addr.bitlen);
+				req.r.rtm_dst_len = 128;
+			} else
+				req.r.rtm_dst_len = addr.bitlen;
 			address_found = true;
 		}
 		argc--; argv++;
-- 
2.29.2

