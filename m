Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FE9263CF1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgIJGEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgIJGEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:04:23 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5476DC0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:04:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u13so3680809pgh.1
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uk2jhSlsyW0uEicGAMvJSDRERxJgCUtBRzjLszfNMEM=;
        b=ogGgIj8KanMA8t16REBPMJqN3hNG+13+3sebCcyTt+DetY1CQsREBYjwwl9/aoCJ+B
         rLLdYxsaBCtFoV5xtQAQvk0YgtUunOYQlh/9uZi2h4aS7VXxHS40Miif6HgcVgncgW09
         Ffl52LwJX72tEZzV/pKa9OP6Yp5WLTcvef/ds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk2jhSlsyW0uEicGAMvJSDRERxJgCUtBRzjLszfNMEM=;
        b=P5/4Q8TGfRtHjr9hNx0TvsiogN7BaQFjtb3kcSkoCKR3brVzwtvaHJWUmQ46WUkgDk
         wAr8CsGKoFNmQq3WqISHyGEY3wTjMGT4aDinQoCBiL0enMixc1nocvERib5l56/A2ZFu
         SROOQ0V4Jk9nAcnch/1lw2HqCy+1Oi9P+m1L56Z/57GQeB84HIjL8KcGP1qqk+r8QN/c
         O1e3nPR6cUWPKzPiIF9v1pHwg4JDc5skAl11XcuorZZ2FeNMmWtBrh88wZu34Fm0XGpq
         IS5iendpGj/TZeton/m//lkYoluOgBKfcFNzaEW9d6S5bmk6KPhKlpjGspSFiPKq2LAu
         gAKw==
X-Gm-Message-State: AOAM533N59jNPxpKPVLoOjoy/93xN4J/LsFhv6IDKyl65seF5kPzwm/B
        r3YL4Yw8/ANTyFojSkyIMGJ4iw==
X-Google-Smtp-Source: ABdhPJwe0+uwzDRgDCuX9b8VJcjpJiSEscjJ/j45LhdykkKdSMSbbDczNEseCea386az0fz/SY3oCw==
X-Received: by 2002:aa7:9edb:0:b029:13e:d13d:a059 with SMTP id r27-20020aa79edb0000b029013ed13da059mr4077835pfq.31.1599717858904;
        Wed, 09 Sep 2020 23:04:18 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:de4a:3eff:fe7d:ff5f])
        by smtp.gmail.com with ESMTPSA id j14sm893236pjz.21.2020.09.09.23.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:04:18 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 2/2] Bluetooth: sco: new getsockopt options BT_SNDMTU/BT_RCVMTU
Date:   Thu, 10 Sep 2020 14:04:02 +0800
Message-Id: <20200910140342.v3.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200910060403.144524-1-josephsih@chromium.org>
References: <20200910060403.144524-1-josephsih@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch defines new getsockopt options BT_SNDMTU/BT_RCVMTU
for SCO socket to be compatible with other bluetooth sockets.
These new options return the same value as option SCO_OPTIONS
which is already present on existing kernels.

Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Joseph Hwang <josephsih@chromium.org>
---

Changes in v3:
- Fixed the commit message.

Changes in v2:
- Used BT_SNDMTU/BT_RCVMTU instead of creating a new opt name.
- Used the existing conn->mtu instead of creating a new member
  in struct sco_pinfo.
- Noted that the old SCO_OPTIONS in sco_sock_getsockopt_old()
  would just work as it uses sco_pi(sk)->conn->mtu.

 net/bluetooth/sco.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index dcf7f96ff417e6..79ffcdef0b7ad5 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1001,6 +1001,12 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
 			err = -EFAULT;
 		break;
 
+	case BT_SNDMTU:
+	case BT_RCVMTU:
+		if (put_user(sco_pi(sk)->conn->mtu, (u32 __user *)optval))
+			err = -EFAULT;
+		break;
+
 	default:
 		err = -ENOPROTOOPT;
 		break;
-- 
2.28.0.618.gf4bc123cb7-goog

