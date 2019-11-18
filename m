Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 481B21005D2
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 13:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfKRMq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 07:46:27 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37215 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbfKRMq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 07:46:27 -0500
Received: by mail-qk1-f194.google.com with SMTP id e187so14241103qkf.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 04:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6whF2lfeMqdxlf5HPwEBDT4sjDJgnLZozuAncdYJILE=;
        b=o+jhTJk/5agBdegvz7WJjChBX86hqdXE76ZaV27plwEcSGreYEW79XxdRp4yWQyirE
         cBqwztaqZS+fzdGRrDdGBW9TTZN3lc2Xi4avkcZfgD3bvnq2wmHotq8OBrQwH6IAUxg8
         +ntkhdM/oEh2xtXuqzUMXOMlofzwosW5ufF6+ux5x/3P5MUVVdbzs7KXv52s+txM8Ldd
         IOJBued6Mayoel4Kt2Fkm4TjrbwisruRVLmPcxFJSHEpcKUfDjTT/6J2QaU6G6Gx/9+P
         rRdylYvwxvINwbvyTmEjlleXA9/P/AUz5MdzAlBXjITuWqRVDqzJTTvg2TaQVoiUV5+u
         LgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6whF2lfeMqdxlf5HPwEBDT4sjDJgnLZozuAncdYJILE=;
        b=f158uFAhzIHSIwVlGtvVt/803C0JVMHwg4VdrauZFCn+Z/XJcTjm2MHhGDW13s4t5C
         X4Ji7P1MMmxzqwxoDUt/Wm4/Pr2AyN3Q1jcjrbUig51vLF/OYVRwlX8hZKvXgSSv3J6H
         hL5Sx1I0QPYaPoq1xvNLgcQfFcdGEPsK3faJCw19sfIbrCcyYyR4u9+bzqyyvbHOPbmA
         Lxbl8KnmzTDIhmWTPEl1XHHakPs9xJtzjICD9lXut4Drxli4cQmAd4n4WVyprxa7UeFw
         7Nf9ZQ+QF6d6EKx3iWePSWx31fgiY9qgUCwgzrIIXc3/oOmn+j3sI7h7VsNeK5gDYtu5
         pamQ==
X-Gm-Message-State: APjAAAVXnGCqopkbxknOCw2CdKzl/u7ue2d8s/QQgKLyVMxvWBopylwr
        5hHwQcTiYlNjjOdTCju7TmM=
X-Google-Smtp-Source: APXvYqwp91e19vSrwJAv9gtL1rdFUqlzBlQg08AgpLfkXBce6r3Gb20ge1syP9gaIeIi25DC9STa2Q==
X-Received: by 2002:ae9:ec01:: with SMTP id h1mr23724441qkg.377.1574081186280;
        Mon, 18 Nov 2019 04:46:26 -0800 (PST)
Received: from localhost.localdomain ([138.204.25.234])
        by smtp.gmail.com with ESMTPSA id v54sm10181042qtc.77.2019.11.18.04.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 04:46:25 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 74AF2C4B42; Mon, 18 Nov 2019 09:46:22 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Matteo Croce <mcroce@redhat.com>
Subject: [PATCH net] net/ipv4: fix sysctl max for fib_multipath_hash_policy
Date:   Mon, 18 Nov 2019 09:46:09 -0300
Message-Id: <9b97a07518c119e531de8ab012d95a8f3feea038.1574080178.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit eec4844fae7c ("proc/sysctl: add shared variables for range
check") did:
-               .extra2         = &two,
+               .extra2         = SYSCTL_ONE,
here, which doesn't seem to be intentional, given the changelog.
This patch restores it to the previous, as the value of 2 still makes
sense (used in fib_multipath_hash()).

Fixes: eec4844fae7c ("proc/sysctl: add shared variables for range check")
Cc: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/ipv4/sysctl_net_ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 59ded25acd045d90573eb144381df4381ecba837..0902cb32bbad69f77b93f5c4175f37ad706d1cde 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1037,7 +1037,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 #endif
 	{
-- 
2.23.0

