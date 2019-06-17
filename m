Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EF547A49
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 08:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfFQG4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 02:56:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46062 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfFQG4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 02:56:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so5113246pfq.12;
        Sun, 16 Jun 2019 23:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=QNjAimqYETJrQ2TQbFTWoOubQzT+2nG9itcAL9Hoj+M=;
        b=riwHpDTPyrJoTf8HVQfOsZoeWP75I5emiFn9tpaJQvj4AhvoJEEFcJTvV8KXLUY7SA
         R/b4snMsGn1QeiMQ5sugmesIpSbbtGWa/OBfaJ45akbqu4D/Aw6GAPlCdwRS7DHUJHP8
         HSyBsC3XkZEKpkHbLAn5ChxiPQtxQq1zPVFLhdMkP2PdOdC5+T32MBBQSgenTtonVDCu
         SmNt7kNm5hMrMgtT4ovEolctDEUFkFf38ckyIdzfQZHmDvQYA6wzwvb1B9DuWXSe5SXY
         ra1D8We7mcOjBrr9ZesnRqeTJ3bH3o1Ck7SpYFCMOVcKk87LiL1Z0A/d72lFsCPUyC8b
         LBZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=QNjAimqYETJrQ2TQbFTWoOubQzT+2nG9itcAL9Hoj+M=;
        b=AemOHa2GkVJ1ZHsybc/5NotTA4Vuh/jARnHK2hOq9+ojpZwpnTCHK0Hi84iAWSQzak
         Tm/bUsFsaeH8g+LmU5eksVkN9QI8b4GVZPELPt6scfHXPPjOy+aUl5kuhrkFXD8dQP5F
         Uyv89NqBteRhwUFT/pnRLLQfbEhYmxR6AZSk8NBYSTNhrt/90IdSxkXRCY1Jiu2IzmJ8
         LG1sn9lAMUPAnIvZgi7KOKir5I6TitdmVceX+ZbanWrt0ImiYjtrEb3BVyAEJa8WKYHd
         Oxbg6XCiPmaEI3Y8VkUvEIFO1NOkVJUAUIcqv5Vd7BOBezupQqhUthEMz8VbVBvTWRVP
         HXTw==
X-Gm-Message-State: APjAAAV8GB7vSGtuO3i8PUh+fE3v+R7KqXl0XYiZoil0diHoNEf7SCdT
        MVIyKV3FIAMoSreW6UlatBO6e3qE5w4HJg==
X-Google-Smtp-Source: APXvYqy+htIhb0RboG5wzl8Vm9I/9MrSYYRmIKXomipGELL46I0I48r4qD2ECvMwU5BrEM4gd0fmbQ==
X-Received: by 2002:a63:e001:: with SMTP id e1mr892000pgh.306.1560754572129;
        Sun, 16 Jun 2019 23:56:12 -0700 (PDT)
Received: from hjy-HP-Notebook ([2409:8900:2500:7501:45ca:ff9c:a1f5:5b9b])
        by smtp.gmail.com with ESMTPSA id a22sm11427741pfn.173.2019.06.16.23.56.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 16 Jun 2019 23:56:11 -0700 (PDT)
Date:   Mon, 17 Jun 2019 14:56:05 +0800
From:   JingYi Hou <houjingyi647@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: remove duplicate fetch in sock_getsockopt
Message-ID: <20190617065605.GA5924@hjy-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sock_getsockopt(), 'optlen' is fetched the first time from userspace.
'len < 0' is then checked. Then in condition 'SO_MEMINFO', 'optlen' is
fetched the second time from userspace.

If change it between two fetches may cause security problems or unexpected
behaivor, and there is no reason to fetch it a second time.

To fix this, we need to remove the second fetch.

Signed-off-by: JingYi Hou <houjingyi647@gmail.com>
---
 net/core/sock.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 2b3701958486..932bcbf2d565 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1477,9 +1477,6 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 	{
 		u32 meminfo[SK_MEMINFO_VARS];
 
-		if (get_user(len, optlen))
-			return -EFAULT;
-
 		sk_get_meminfo(sk, meminfo);
 
 		len = min_t(unsigned int, len, sizeof(meminfo));
-- 
2.20.1

