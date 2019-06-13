Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA62543BFD
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfFMPdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:33:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42622 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfFMKpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 06:45:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so11576882pff.9;
        Thu, 13 Jun 2019 03:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=xTm8k6po7bjp3Ha8AosDhse0S/jiEFLFTIo5UOLT5jg=;
        b=qMKJ1Nu0C1R8lwpK0IQ9vBQMP6/MGgzUZrbQqi8zl8uAjAjOSTpBUrS0ostsbDH2Nn
         FoCnkKfzbCaQd5zNxOWhfwWwFJaSY1kc6OPZsIxrCzhYNXjdgeWIRshLbi+1gZki1WQC
         tdXUazIntJ4w+8FKx6SOf3Jh9EkFJ8HoWzDXakbL5oTgiO0CvjCFx9JjHeOFYlHbzmWt
         c3PKW23lGhSRwnnLw4M+ogCQvH4X/ZkGFtwGW12moRmVROJzkF5leihb8djdaIKJgm2i
         x/K2+wUFVlOIiqzP6oUuRQRwoHyN42EKBIDCFER59PUSs49nA3SyFoo4DgdCMpdJrRv6
         q5sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=xTm8k6po7bjp3Ha8AosDhse0S/jiEFLFTIo5UOLT5jg=;
        b=s9Y+Y2FFYvie7FZfFw5D9WuvOTpsSrBb/ZRD7uP0j5TSJ3BwvUI2jg6chpdVh89HET
         sX45oF1g9ZqF7sqx+dp9wtBUSlrPbojBjx8ls7GZ3ZpirIclxJh64cutZ+VwWg91trQ1
         ZpnDmCaQAS7/IPZnxk4SPM2pYdKl7oWfmQlH6HNruNV4C9GxKNB6O6NYFHvVf+OUxhhw
         GNPks7pGuTV33A2ZZZboVbyM/2Pld8blvc8IXBV5v/0F98sXmUeXYg5D1KZLCjhBrluO
         9VbEs12hCIzS2smD0K753tuy1EqYn8Src7NlpatuKZjShhtc/VNHDvzb+JhQl80WVPtn
         sQkA==
X-Gm-Message-State: APjAAAWqC4eb6GnBd8OkQMa+4JmTfmwRZ48z4RxwTjoDcbAgrBFdek7r
        QtTT+AIsbBE6F/8ssgEbjKKICoAeJe/C5g==
X-Google-Smtp-Source: APXvYqyoFTjHlG0lG+mwUb84qwW3ZXILCiRfHcDzlhE9hUfa7FT3F5ONsJ527thEIuo3Y9HEf5dmBg==
X-Received: by 2002:a63:5207:: with SMTP id g7mr29149456pgb.356.1560422703319;
        Thu, 13 Jun 2019 03:45:03 -0700 (PDT)
Received: from hjy-HP-Notebook ([2409:8900:2650:d5a2:b9ff:4ab3:d77c:10b3])
        by smtp.gmail.com with ESMTPSA id m24sm2161452pgh.75.2019.06.13.03.45.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:45:02 -0700 (PDT)
Date:   Thu, 13 Jun 2019 18:44:57 +0800
From:   JingYi Hou <houjingyi647@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix double-fetch bug in sock_getsockopt()
Message-ID: <20190613104457.GA6296@hjy-HP-Notebook>
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
fetched the second time from userspace without check.

if a malicious user can change it between two fetches may cause security
problems or unexpected behaivor.

To fix this, we need to recheck it in the second fetch.

Signed-off-by: JingYi Hou <houjingyi647@gmail.com>
---
 net/core/sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 2b3701958486..577780c935ee 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1479,6 +1479,8 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 
 		if (get_user(len, optlen))
 			return -EFAULT;
+		if (len < 0)
+			return -EINVAL;
 
 		sk_get_meminfo(sk, meminfo);
 
-- 
2.20.1

