Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF28528F93
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 05:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbfEXDYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 23:24:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46347 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729972AbfEXDYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 23:24:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id o11so4030172pgm.13;
        Thu, 23 May 2019 20:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=/3n9FVywoExtKHdkxZu9NrddyvBpvJrl+Pr5EEoKl20=;
        b=CcpG+Ue4Ng1l292fJ93tY8QlAkl2aWLXgmO6zSkeeRHEagqKsMNTlAtRP/FXRmwkVs
         sQQTI46f8MB+47ZgVveBNa/7toU7lKKrR1nbOLxQjMtZK5JF4Q2pBMNC0sXJZzSf5vyp
         F40SCXnp9cN0vJUczmjCiqvZ3UhSiBPfF1wehAeNaX8oxs8rp0X8/Tu+lkBVZg9cYEeQ
         MgeGTmq0Aqp442Knh6YtgOa8NFPklvr63lLmgqrXYvYbQccip/RDFF5I2SZCs4Sg8WP9
         fFL0EKno6ZurHxvMaiR1Oi6jjnD0t57yHXCverz9a3GwGFiYSDzIEdn2huwbLT/FCbSJ
         xR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/3n9FVywoExtKHdkxZu9NrddyvBpvJrl+Pr5EEoKl20=;
        b=UczkeOduvA7iCzvMmLosn8/efeHOBIGhvdqlOewDjPeHzzsyxpdQPtl8H366UKFzwU
         7rfEVNRs9TBGT4gH0yf6NKZMp028AFDkXXieCFiHBnTJdCbqH/SS2b9WwLndzlXpT2nz
         sB2H3sPla05U51S9lwEQXY5jnYho4aaz2y9H+c8EhKxyRPEFOo35H877jdPKUYpvpngA
         8Ml+bc6pqispLHgH3D5nrf/AtiF4gJQ78UjXtG4g2a5aqUwcRIUN9NBpVSsiuqWzVPkd
         bHViEd0AO6IFzDn2oWB/qJ//WAqb3B0zjwy1kwLO8bqQrEd3NZAAuz0HSFdDy95TvXKz
         Ix3w==
X-Gm-Message-State: APjAAAVjqDBW4KYca3VTQqUyw1lC6ny7LSp1Aiujj28gEa0XRRBpKVgK
        rWB6uzUIz+plfiDqKWsZJaY=
X-Google-Smtp-Source: APXvYqzZetGfZUTYWk7vL5KaitobRvOM3BuGxx0RvRGsV4ZBCnkhMgNMZWUUF5Plj4EA78qqHUbspg==
X-Received: by 2002:a62:75d8:: with SMTP id q207mr77026148pfc.35.1558668289353;
        Thu, 23 May 2019 20:24:49 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id a69sm999617pfa.81.2019.05.23.20.24.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:24:48 -0700 (PDT)
Date:   Fri, 24 May 2019 11:24:26 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] ip_sockglue: Fix missing-check bug in ip_ra_control()
Message-ID: <20190524032337.GA6513@zhanggen-UX430UQ>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In function ip_ra_control(), the pointer new_ra is allocated a memory 
space via kmalloc(). And it is used in the following codes. However, 
when  there is a memory allocation error, kmalloc() fails. Thus null 
pointer dereference may happen. And it will cause the kernel to crash. 
Therefore, we should check the return value and handle the error.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

---
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 82f341e..aa3fd61 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -343,6 +343,8 @@ int ip_ra_control(struct sock *sk, unsigned char on,
 		return -EINVAL;
 
 	new_ra = on ? kmalloc(sizeof(*new_ra), GFP_KERNEL) : NULL;
+	if (on && !new_ra)
+		return -ENOMEM;
 
 	mutex_lock(&net->ipv4.ra_mutex);
 	for (rap = &net->ipv4.ra_chain;
