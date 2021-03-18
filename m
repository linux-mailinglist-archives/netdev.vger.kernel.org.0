Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66832340DDA
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhCRTH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhCRTHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:07:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832F1C06174A;
        Thu, 18 Mar 2021 12:07:51 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id g10so1782295plt.8;
        Thu, 18 Mar 2021 12:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Fu6JikyYlZ618SKkUnTqBGhiDDGhC+oWvRchCQbz94=;
        b=vSmbs0l/jA/7uHxiCBD22P3prOaRzXFgXVLwiU3p0c7miN+j9ZY38Vxa4rkZfrGiEq
         MYG6EhPnqzwNbrpxsDxtKX5VisjuX2yYGHaoMIbQzM+hga1Zgl9cLcvVuea33N6LCQ9Q
         WOGiX2Z+cl9kYMCEd15zHozb91qVO2ijNlNq6qlcYaccBonMzwSX8VYeW+NbZCHalmOg
         f9vqvEQO0Ky1MKJvW3p/puyBWft4+xLA1bamYkOwPZiivfsAfJNh1JDiA9oWW0wKC1Hq
         G8yER7KWg97YJ7EIvySyip/PIlT3TqS4mtjZ6YlE6SGOh4x7NbBQFL6G8QSmSNuk/5BK
         4pyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4Fu6JikyYlZ618SKkUnTqBGhiDDGhC+oWvRchCQbz94=;
        b=eChpa6xH6jPJSUjk5m5RDgzJ3SwFuutoleB6IyE9jcfc2dCu50yQNijKuQJoGe1e9A
         lnEQLTvzpAa+Oq+4cG/6DKhyr5h5XdE3sIdyne94UEB4IfO+3d6Pm0qvL+IeJXW0q0jn
         dFkJz21sBFZqoQmwySCVfuxRJCc50Yd/Brp0KEsq5N+rDAhsPUu5HDWa+5V8TQr+IuwE
         qlwevquAt72E3XJlGebCRXCQ4DePvqem+0OvIKiF4iQ25jCjNLv9KQuSiTOTSOgQkL5Q
         O0X/7TeYCpfbJEfKcrl6KsaHllJ9SIZJ9REpPErO7t68CKIaiD5Naa9m4aCYoporVZH0
         hHww==
X-Gm-Message-State: AOAM532Vrk2xeqIcj+BIvqZrak+1PbsowlxVjRrDwbKtXlmdSPquMxtE
        4yKeBsxEUpHDHaPjJNJGtcM=
X-Google-Smtp-Source: ABdhPJymTpGeStIfpmaE0npjV7Alf30EW6aYAljX+vb/jog7jFrLS7SpqSxwbintc3QgRN3FtR/Dng==
X-Received: by 2002:a17:902:8a91:b029:e6:3e11:b252 with SMTP id p17-20020a1709028a91b02900e63e11b252mr10967770plo.7.1616094471032;
        Thu, 18 Mar 2021 12:07:51 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:3c4e:a68f:1a4e:cf63])
        by smtp.gmail.com with ESMTPSA id 23sm3519801pge.0.2021.03.18.12.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:07:50 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net: lapbether: Close the LAPB device before its underlying Ethernet device closes
Date:   Thu, 18 Mar 2021 12:07:47 -0700
Message-Id: <20210318190747.25705-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a virtual LAPB device's underlying Ethernet device closes, the LAPB
device is also closed.

However, currently the LAPB device is closed after the Ethernet device
closes. It would be better to close it before the Ethernet device closes.
This would allow the LAPB device to transmit a last frame to notify the
other side that it is disconnecting.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/lapbether.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 8fda0446ff71..45d74285265a 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -421,8 +421,8 @@ static int lapbeth_device_event(struct notifier_block *this,
 		if (lapbeth_get_x25_dev(dev) == NULL)
 			lapbeth_new_device(dev);
 		break;
-	case NETDEV_DOWN:	
-		/* ethernet device closed -> close LAPB interface */
+	case NETDEV_GOING_DOWN:
+		/* ethernet device closes -> close LAPB interface */
 		lapbeth = lapbeth_get_x25_dev(dev);
 		if (lapbeth) 
 			dev_close(lapbeth->axdev);
-- 
2.27.0

