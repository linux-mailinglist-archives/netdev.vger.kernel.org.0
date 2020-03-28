Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F941965E2
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 12:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgC1L5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 07:57:05 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38867 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgC1L5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 07:57:05 -0400
Received: by mail-lf1-f67.google.com with SMTP id c5so10048030lfp.5;
        Sat, 28 Mar 2020 04:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=vohZ7RYylce7oG+qd7nKsIkPDOq6dSZqCFLWe4oqhRw=;
        b=Fx7tQ6Zx/Nr3LIGzvw0af6WO8UdeI9QkitOU1hB16V+V2SzaIGLvx6tTDUmrhBiB+D
         9nv/xcrIVkyNjaDWhL1IAyA6lyZP5vj/R7W9za40FiwFK5CB/lVUQcoyPLh9eOKNu9Zf
         6Sinv8vNfrvvDVDVpw/HFLap893Nmag8KmDF6MteX1L+SWSoFEDB8rY0B0m5grsCppZy
         qUFDFsQRqQczoishI/4T29L8Mll8dm4lC+a2v0lBdTDVhLFKgYpIUPqyntkgV0GhXQX6
         Y4azQoxaxeDUPxOO2rZZqwRUfXZbBoJx1/9OoZnSIhWLzEXbAKe46885zIg7RI9tkC7+
         cayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=vohZ7RYylce7oG+qd7nKsIkPDOq6dSZqCFLWe4oqhRw=;
        b=Zv3GYj/7lIgJH0YHWQAwUejjHyAa+ZvFGtZi6mmWF6wEF8gQG4F0vjqnWKrKoij6ct
         rKbGihBaacFfbvCm9/+UKtGHCDeTYPzDoAk8KF8VE0+FO2rI5/X7gF5bFxDpbFrdyl5u
         jR57ZovZ2rFjnNtEhL79iIRmnjS6SQJfv6MvBDq/bcJuIib1S3Ed743+xf2n8wxxax1i
         aKY3Ief0BEzZgM5mFPhfxYz3miuVM0Ku9Ry0awU26qRRxczZN+eQBm/unLcRYXiUPAzb
         RHCCe4yNLJdhda+5wL/v7HzOMV4aPRvxXd1qc36FZjcJHgfrKYqdEdQmrh1rqlog7VfH
         fKMg==
X-Gm-Message-State: AGi0PubUsD82PZ/Fzd+mF7WvQkMKflbdtpkCY4rk7FR2WCQ9Wof/ShVk
        G8wePtTHSXE4sN7/FOGDZD8=
X-Google-Smtp-Source: APiQypLZYuYBOJKIzNJJMdP/KVOg5d8z8nE1cQlOOst4rOmQHNithBgqa92wV4ZbvMgbxZGfEF6YLA==
X-Received: by 2002:ac2:4858:: with SMTP id 24mr2465051lfy.135.1585396622422;
        Sat, 28 Mar 2020 04:57:02 -0700 (PDT)
Received: from laptop ([178.209.50.173])
        by smtp.gmail.com with ESMTPSA id q1sm1247898lfc.92.2020.03.28.04.56.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Mar 2020 04:57:01 -0700 (PDT)
Date:   Sat, 28 Mar 2020 14:56:55 +0300
From:   Fedor Tokarev <ftokarev@gmail.com>
To:     bfields@fieldses.org, chuck.lever@oracle.com,
        anna.schumaker@netapp.com, trond.myklebust@hammerspace.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'
Message-ID: <20200328115650.GA27729@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix off-by-one issues in 'rpc_ntop6':
 - 'snprintf' returns the number of characters which would have been
   written if enough space had been available, excluding the terminating
   null byte. Thus, a return value of 'sizeof(scopebuf)' means that the
   last character was dropped.
 - 'strcat' adds a terminating null byte to the string, thus if len ==
   buflen, the null byte is written past the end of the buffer.

Signed-off-by: Fedor Tokarev <ftokarev@gmail.com>
---
 net/sunrpc/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/addr.c b/net/sunrpc/addr.c
index 8b4d72b..010dcb8 100644
--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -82,11 +82,11 @@ static size_t rpc_ntop6(const struct sockaddr *sap,
 
 	rc = snprintf(scopebuf, sizeof(scopebuf), "%c%u",
 			IPV6_SCOPE_DELIMITER, sin6->sin6_scope_id);
-	if (unlikely((size_t)rc > sizeof(scopebuf)))
+	if (unlikely((size_t)rc >= sizeof(scopebuf)))
 		return 0;
 
 	len += rc;
-	if (unlikely(len > buflen))
+	if (unlikely(len >= buflen))
 		return 0;
 
 	strcat(buf, scopebuf);
-- 
2.7.4

