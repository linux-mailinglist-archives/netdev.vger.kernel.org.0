Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC3C42162
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437711AbfFLJuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:50:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38803 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437621AbfFLJuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:50:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so16150740wrs.5
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 02:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PAvGFOoYzPS61be8d0hDk59IdKm5jv+M0Lyik/mzoSE=;
        b=Rr/KIs9lPwlJesrR6GQkd149RGH61TYZmdKT0UsWVBRxnd6CoIGhe2Txnflv/ghMTS
         mf6yeJNtcoraTIEhRvZ3Iz+pKrHlAAZ2zrUaECpHsMz6YaHW1CAPaeOPEvcaBnm/jtzZ
         JUqxD4mhKwxRxMHiOXWYXp2VAyPnanfn4ucz0AfR7js/dJ8bRRURdioVYTQRy5mRkj3b
         AYZp0fOtdRoI8k1QXiJsjvL+JzbMXnpg7TGUkDmVqJT8CvvE3NWGT9jxfqMaU1hKXP87
         ECH1sFiHbvm6dPB2x8ow82GGfPYs77G3u/thBkofrWJRMqQIzy/iHWyB1eS3nAFavwfp
         svKA==
X-Gm-Message-State: APjAAAUbvyCE/RtQdj9rjRCe1eUv/SXUYSGzivblglmBI9S8fqsshhvU
        zBz1hZBhIstLhBh1APpooY3Guz8GZig=
X-Google-Smtp-Source: APXvYqxWCtXFIT7WAXyNcyUz59E7fx+sMjOkrh9/IR0cbl66vKkr0afl6Z0nTISHKI7+dI3deUDvpw==
X-Received: by 2002:a5d:51cb:: with SMTP id n11mr14633941wrv.143.1560333050210;
        Wed, 12 Jun 2019 02:50:50 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q20sm44919103wra.36.2019.06.12.02.50.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 02:50:49 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH net] mpls: fix af_mpls dependencies for real
Date:   Wed, 12 Jun 2019 11:50:37 +0200
Message-Id: <20190612095037.6472-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy reported that selecting MPLS_ROUTING without PROC_FS breaks
the build, because since commit c1a9d65954c6 ("mpls: fix af_mpls
dependencies"), MPLS_ROUTING selects PROC_SYSCTL, but Kconfig's select
doesn't recursively handle dependencies.
Change the select into a dependency.

Fixes: c1a9d65954c6 ("mpls: fix af_mpls dependencies")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/mpls/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/Kconfig b/net/mpls/Kconfig
index 2b802a48d5a6..d1ad69b7942a 100644
--- a/net/mpls/Kconfig
+++ b/net/mpls/Kconfig
@@ -26,7 +26,7 @@ config NET_MPLS_GSO
 config MPLS_ROUTING
 	tristate "MPLS: routing support"
 	depends on NET_IP_TUNNEL || NET_IP_TUNNEL=n
-	select PROC_SYSCTL
+	depends on PROC_SYSCTL
 	---help---
 	 Add support for forwarding of mpls packets.
 
-- 
2.21.0

