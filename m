Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A53301D57
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 16:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbhAXPyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 10:54:40 -0500
Received: from mail-ej1-f51.google.com ([209.85.218.51]:39375 "EHLO
        mail-ej1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbhAXPyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 10:54:38 -0500
Received: by mail-ej1-f51.google.com with SMTP id g3so14452873ejb.6
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 07:54:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=loR5Y08cN0+SN3qUJF0b65g7awhFY8aB5IT5wNL71y8=;
        b=FdvqWTtsKpM1A0o0ifcOD/6abpjAGwYFMmcObdV256LPxDBh+aQrOb46f/cC0oeTb2
         xziG55Cb8e01BI83QlQuana9V0pcsB2KTjGTBpwlxQoWrpdMQK68YX+z/xbrbmAryrMR
         Y4hU124OKy4rUkeEhk1IQpf0u6ZhN2OZe5ERIfGzb/eHoDGTbpGmfl0Ty5n1h2A7HssD
         ++8rVkpqo5Iv7WiYo5Qmew8Kov98f1T7qh+Ggu3tJMEKELQBOZXreJPl1WjnD/1r963Z
         2GHyHRrCNQfwantSj3AaeyULs8z81hXjDPTzTUNDW7UJHILtszZW5sCv5uaM2gJ6AvX+
         psmA==
X-Gm-Message-State: AOAM532hIlULK2LmMBn21O+W0caGaB2s0ww2aV+f1FFIu7R5+Sa+aq2d
        kOWiyOb5yg3Ubh+KsIggbGqbEsMonFC+bQ==
X-Google-Smtp-Source: ABdhPJwxccGRLNAKZURWGF8ikce2FgsxjhJswcZA1/6/XpAYBwAtHtEbDv3fTgO9PRT9TPjzp0sDDA==
X-Received: by 2002:a17:907:1119:: with SMTP id qu25mr617252ejb.268.1611503635934;
        Sun, 24 Jan 2021 07:53:55 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id lg21sm6727009ejb.91.2021.01.24.07.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 07:53:55 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] iproute get: force rtm_dst_len to 32/128
Date:   Sun, 24 Jan 2021 15:53:47 +0000
Message-Id: <20210124155347.61959-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
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
the command line.

Bug-Debian: https://bugs.debian.org/944730
Reported-By: Clément 'wxcafé' Hertling <wxcafe@wxcafe.net>
Signed-off-by: Luca Boccassi <bluca@debian.org>
---
As mentioned by David on:

https://www.spinics.net/lists/netdev/msg624125.html

 ip/iproute.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index ebb5f160..3646d531 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -2069,7 +2069,12 @@ static int iproute_get(int argc, char **argv)
 			if (addr.bytelen)
 				addattr_l(&req.n, sizeof(req),
 					  RTA_DST, &addr.data, addr.bytelen);
-			req.r.rtm_dst_len = addr.bitlen;
+			if (req.r.rtm_family == AF_INET)
+				req.r.rtm_dst_len = 32;
+			else if (req.r.rtm_family == AF_INET6)
+				req.r.rtm_dst_len = 128;
+			else
+				req.r.rtm_dst_len = addr.bitlen;
 			address_found = true;
 		}
 		argc--; argv++;
-- 
2.29.2

