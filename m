Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09EF27200
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfEVWAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:00:30 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41625 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbfEVWA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 18:00:29 -0400
Received: by mail-pg1-f201.google.com with SMTP id d7so2453545pgc.8
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 15:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1GTzpy/FZQxsC5bYMdAvs4BuwHs+K97cbD7Ji85DTcw=;
        b=nWCK9NL/De4TRiPhMipv2ncD/FvIBcZoxrB2ffe93OQ2R8bAn+WINf+wlx6x7SQU7z
         +MZcCJT6hKcmKtN9NpEzJJTzDFV1GyXCW922L5t8Ivh77f6Q/niRYvhkEeS4XmAEDE3X
         +0k+x6WwAmN7VkUaxv3Qhdkjk7tiG0JgyAmW038EnrFDxgYUR2Eu1hV6XXwu845/l5+j
         4JLpVQBNdkkNucx9qUg0x7epem4xbfol7TKWYaRNFUteOs8VbdP5oyKq3qqjupfm9dU3
         ibjVnseo6wtNI4jdO4w/TwkWSpRN8unJ1CLtW4830pfZJOyPhbHTFOxD625j1Hc2eRft
         6x1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1GTzpy/FZQxsC5bYMdAvs4BuwHs+K97cbD7Ji85DTcw=;
        b=PgXTTTTajsVItnGPXwyEfI3QIHiDeAnKSsNhf1F4szXf3BP5e5JpFUvnAq599/VHDp
         Om3GTTvsIwS5HJqf1RDstKD4m78ihgVPkXPD1lQ/efeUPdJ7K9El5ZxUffrnQQH2xWJA
         G+TkTsZAptBM5vJdttoomp1BDdODwAih4pIdEi16DjLSDWMA4U6TZ2HuRO8nLifC0Qxg
         bhKoCb98siAEZ209AK/OooEovJ2BZn+rzFSVxP12L+jwQEQCe3Wc0sSE3AuMaVohay2G
         6VsGLyxzFPVqgdEQA354j5OEamL56a+IYg+Z9dnBuH6vRRReDFt6SDpl0juUxo5Plhb1
         Jdqw==
X-Gm-Message-State: APjAAAXoB9qLDBQ5/IBwobR/3T3ivGn7DxyrjW3LopLwyU9yR8aKEJNe
        0uiefFCa2XPT3XH3m5cOfwgyFr91huZh0w==
X-Google-Smtp-Source: APXvYqwq6H6zjjK0gqvNcSw+A16bULNsuq9rhIBhJy9WATNLJw/ZdJsiyrH2O/pifMH/1JzRnQnSF2c2q70GXg==
X-Received: by 2002:a65:44cb:: with SMTP id g11mr92049086pgs.193.1558562428950;
 Wed, 22 May 2019 15:00:28 -0700 (PDT)
Date:   Wed, 22 May 2019 15:00:25 -0700
Message-Id: <20190522220025.78765-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net-next] ipv4/igmp: shrink struct ip_sf_list
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing two 4 bytes holes allows to use kmalloc-32
kmem cache instead of kmalloc-64 on 64bit kernels.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/igmp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index 9c94b2ea789ceb9a06d9da0d8b07d28801732930..6649cb78de4ae5c3973337f3c23a7c184df90932 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -65,8 +65,8 @@ struct ip_mc_socklist {
 
 struct ip_sf_list {
 	struct ip_sf_list	*sf_next;
-	__be32			sf_inaddr;
 	unsigned long		sf_count[2];	/* include/exclude counts */
+	__be32			sf_inaddr;
 	unsigned char		sf_gsresp;	/* include in g & s response? */
 	unsigned char		sf_oldin;	/* change state */
 	unsigned char		sf_crcount;	/* retrans. left to send */
-- 
2.21.0.1020.gf2820cf01a-goog

