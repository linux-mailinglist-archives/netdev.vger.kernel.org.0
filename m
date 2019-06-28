Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2259138
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF1Chp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:37:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33582 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfF1Chp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:37:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so2359428plo.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 19:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roaztKtTkRu8pn3yWaNhfvLdHNSmDj0YJDhL6E5EN+0=;
        b=rukbDA3CpnhMC7Q3iFXSeQ2HtDS7nCRUjmzI73bUUVB22U1aRiyRjlQ9Zh9EDbi/V6
         U4nUJWUK3Xh6Y54+Rkfas3b5KPNZvIxPiAhdgV2OIj+WJMHyXoPqJSU83OaUclWn90Zi
         PZjEXxHlwrWFKhfq0Qk49+IaZcw6ssGei44MrIbwlLKRPkOwkzkv0jM9rEnCw+vOeIMs
         EITDkhfRKI28nKKknobZm+0zSIMv9Y0taN+4zXHhKeq4bxbPJ5A1d+mGh3ZDq75As6oV
         1TeJtBZJKbzU+16ItZURdexunhMxEY1sMlyuc5o8w5rmUK/A6mh1iNBSsYsz0dh8QW0J
         TRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roaztKtTkRu8pn3yWaNhfvLdHNSmDj0YJDhL6E5EN+0=;
        b=EL10jOgyVKstyEnZGc6T0f3/52NnQILaIOq5Qm2pWBu7tMFO4pYiW4Fs87+ZGGpPZe
         WsTuzSJ3CanM7orApH2AZHKqydNFnDQu/AtlkahGlh61yOUPJaqBNbiT+ROMlTLuPQkp
         4G57g8zpitpDSvPRfbS7B445/MEXBPYUVfw/n6RXOYY6+u5AoqvzJCuxupOO6tdkTabB
         Zwtv/wlu25OoABOCxqV/hpMGwH0wzuX3n2IjsWI0lte3WMts3hQiykaCyxTeMEZr32/4
         KuV89W0z+04tnwWzRdXcMI1pvj2/Ln6svad8vOUzaGTLoLk32F5LDky1yxmOF3bRsTd6
         ECSA==
X-Gm-Message-State: APjAAAXn6yU8A6K+rgItV0HtW1ziAgwibFSZlqsoElxSJHxkWnSDphBB
        SdfupNSX6ZiA07Pltaks9XqHLA==
X-Google-Smtp-Source: APXvYqzYqfCBc3iTV+51i6xo/8yVdkZVszMsUp8lcRHzgFH+naQmZdFlCFa4RWgCh79DR5QAEdb9+g==
X-Received: by 2002:a17:902:8f93:: with SMTP id z19mr8245017plo.97.1561689465143;
        Thu, 27 Jun 2019 19:37:45 -0700 (PDT)
Received: from localhost.localdomain (p2517222-ipngn21701marunouchi.tokyo.ocn.ne.jp. [118.7.246.222])
        by smtp.gmail.com with ESMTPSA id i3sm368206pgq.40.2019.06.27.19.37.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 19:37:44 -0700 (PDT)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     davem@davemloft.net, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH net-next] net/ipv6: Fix misuse of proc_dointvec "flowlabel_reflect"
Date:   Fri, 28 Jun 2019 11:37:14 +0900
Message-Id: <20190628023714.1923-1-devel@etsukata.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/sys/net/ipv6/flowlabel_reflect assumes written value to be in the
range of 0 to 3. Use proc_dointvec_minmax instead of proc_dointvec.

Fixes: 323a53c41292 ("ipv6: tcp: enable flowlabel reflection in some RST packets")
Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
---
 net/ipv6/sysctl_net_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 6d86fac472e7..831573461e19 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -114,7 +114,7 @@ static struct ctl_table ipv6_table_template[] = {
 		.data		= &init_net.ipv6.sysctl.flowlabel_reflect,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &three,
 	},
-- 
2.21.0

