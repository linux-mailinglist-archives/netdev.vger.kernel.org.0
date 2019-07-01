Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2C5BFAB
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfGAPXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:23:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43714 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbfGAPXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:23:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id cl9so7511603plb.10
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 08:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vo5JVl/0iUs0czPYtgeWaa8Uzyp8tFbop9NRDH9nJIk=;
        b=x/wSF7a4XlMkJmrWRnXL+B9kljSXAaelnHyp019g0prUMw10URvvge0KyeNmPGf9VW
         mb1HlfxR7nAIU6xru8zk6q+jIodHybQKeFTJk19VAiJ51UozCEJViOyFcGchZoFB8T8b
         zjcUwKD4XWBGOlacZwKlDsHPqKLDqGCj0HvW/ABdy1OJ6JTU9DWZdcQh5iWXYJNCUA+n
         EKjWwt9k0pLxbNV6+PIdQicBBjQiXl8dE7RwwNN1JRn8h78B5jvesXYMxeqY4LPh4T93
         H/KJNj6b8eGTdujgyrZsDf5OOQcdsMuzMsjzSjq11SrPo8fK0ICaE+aG9ibwtU9I+/rs
         83rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vo5JVl/0iUs0czPYtgeWaa8Uzyp8tFbop9NRDH9nJIk=;
        b=acsTFbk4TE8GLOmDLRICp+OBMjnv3wVPG/pX8Xudmu4o7INxQJnpvyZBvXu9itFIde
         ABTnqTrRBbV6RWdqtJn65VB3PN8HNcwCno7s95/mWlmCTs0KhDLW6x9DxiAL6RgFjiTZ
         R9+ZT+BdImhK2qvav2/HXPCivcy8xd2s9Vk022XdZPws439hqZxPCYVNiAPVjOAbJxmx
         hUylWpIgbsonyUOisl2ZgoKRJbWTWWvB+hE9dVo8cKFjZoSCYZ2DMBINMX61OEy40OZm
         jw33/lbGdmCgbZEruNYDqxzNxmgKS7gfufQW/i2kNZwCjTF2C3dwKBfmiHYoo2VOUgAj
         tUpg==
X-Gm-Message-State: APjAAAUWsnwinh/3CFKuB9+gcgnIhrk+Jd4AgM30gbspeDuuf+vp0vIf
        GpN7aJJ/IxapnzQRxPXrtMVsujQqtL4=
X-Google-Smtp-Source: APXvYqyfF62FxLBpnsbFeiNEAjvcJc3MJgvBAz4nP644mPfIfLpxPSBMXqOeYmkVbyGJ5pAvFtQEvw==
X-Received: by 2002:a17:902:583:: with SMTP id f3mr29391933plf.137.1561994586341;
        Mon, 01 Jul 2019 08:23:06 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n7sm12342353pff.59.2019.07.01.08.23.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 08:23:05 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net] net: don't warn in inet diag when IPV6 is disabled
Date:   Mon,  1 Jul 2019 08:23:03 -0700
Message-Id: <20190701152303.4031-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPV6 was disabled, then ss command would cause a kernel warning
because the command was attempting to dump IPV6 socke information.
This should not be a warning, instead just return a normal error
code.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202249
Fixes: 432490f9d455 ("net: ip, diag -- Add diag interface for raw sockets")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 net/ipv4/raw_diag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 899e34ceb560..045485d39f23 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -19,9 +19,11 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
 {
 	if (r->sdiag_family == AF_INET) {
 		return &raw_v4_hashinfo;
-#if IS_ENABLED(CONFIG_IPV6)
 	} else if (r->sdiag_family == AF_INET6) {
+#if IS_ENABLED(CONFIG_IPV6)
 		return &raw_v6_hashinfo;
+#else
+		return ERR_PTR(-EOPNOTSUPP);
 #endif
 	} else {
 		pr_warn_once("Unexpected inet family %d\n",
-- 
2.20.1

