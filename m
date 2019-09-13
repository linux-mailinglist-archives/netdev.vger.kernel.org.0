Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C22B1790
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 06:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfIMEXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 00:23:53 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45946 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfIMEXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 00:23:52 -0400
Received: by mail-io1-f68.google.com with SMTP id f12so60098265iog.12;
        Thu, 12 Sep 2019 21:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=77SoApYkFt3isyCsrY6dkIW1UAAJ7m+Z3V3KK6V4A70=;
        b=GUvypkaofnmPrAjAlwJgfb58Ko6ovCWLN6QjacOFu3EVClbgTUSWhpCXaM5EcVFzAg
         BErq8qd7bkhjY7mTPChVqjsDmtC4PB6jxnIkSlhK2JwaNp8AeMjcecEFYCKNzsmRfud5
         ZylbApopgg3GlcmVF9BgvrSreKyfzHH/QAq2QGFL606b0m47uWEws44Efu9LRchvT3BJ
         TRq4Xrc3glOHgp0hm+F+7bhr68Js8K23WgpOrK3VenDovjcv/2VZZhTmT6H4TAbYNo6z
         uevqos7dR0m/q7LZMf06b6vjkC7uHESAh25zI5Z6DVr6qgZe9COXBlfeOIOmRgI9l0Wr
         HCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=77SoApYkFt3isyCsrY6dkIW1UAAJ7m+Z3V3KK6V4A70=;
        b=RzV+eoeXQmqNBYmaN9LDEGIWtN0CRbXVnzQlfdDUYrRdSys5huH3ff7eocR4rGQJjN
         k8I6fWyDvGAvTiI8Da+iuoIqpCqw2ygQwAEALJRCCrJBo+lJcXDV7cotY9uy0AFnmAgi
         34iIn71Dh3iHaA8OSkodTQ7/i3HyrMYSBg3yzMSfQvAsJE3d7hZ544djxcv1j75zjPa2
         3pgUVVr9zRQGYA2Mqa6mg5bA/cgpkhdyppPnY6ThEs/vc1/s5lADjeRN+sV0cLk2xrPz
         YravDqjAMvfqMy8W30r5jUaFveUGpr2i/yJhUFZgxWYMcSJvzq4iUstr/+zHVR0iSnot
         VM7Q==
X-Gm-Message-State: APjAAAUUBlEKkOqOvs4gB+SqDExo7PuiXZ3GAXCkj53ia4+/H4O9yMx6
        szmeLZ3ykEzsuGeuM2Ubxng=
X-Google-Smtp-Source: APXvYqyjtqbjM8GW5BGGtDVrVHCMFNfYy9E21J1r8qxh2yoZM0mKIHECdUHQjAqJo77wkoR4we5xOA==
X-Received: by 2002:a5d:91c8:: with SMTP id k8mr9465769ior.232.1568348631660;
        Thu, 12 Sep 2019 21:23:51 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id z11sm23474759ioi.88.2019.09.12.21.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 21:23:50 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: dbg_ini: fix memory leak in alloc_sgtable
Date:   Thu, 12 Sep 2019 23:23:27 -0500
Message-Id: <20190913042331.27080-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In alloc_sgtable if alloc_page fails, the alocated table should be
released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 4d81776f576d..db41abb3361d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -643,6 +643,7 @@ static struct scatterlist *alloc_sgtable(int size)
 				if (new_page)
 					__free_page(new_page);
 			}
+			kfree(table);
 			return NULL;
 		}
 		alloc_size = min_t(int, size, PAGE_SIZE);
-- 
2.17.1

