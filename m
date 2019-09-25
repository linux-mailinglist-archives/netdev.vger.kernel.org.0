Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAB4BE19A
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 17:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391665AbfIYPsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 11:48:42 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35907 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387474AbfIYPsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 11:48:42 -0400
Received: by mail-io1-f65.google.com with SMTP id b136so48871iof.3;
        Wed, 25 Sep 2019 08:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0qNPhmzg0s6OFq2ccQPYykHxxawuEd3L1JQLHES3r0g=;
        b=cHf6huUlTWlzSqUYeFN7nGGNH5PJP3fVdkz3pnOy9JHNHUhc+QFH9H5e1xYZuFqdRh
         ebdJm+U2KFIp6ezUQpy/YeMH/OY/KaDEjkVY+jnbiV9Z8xIFoP4oyvl0U8bfUgm5UZ8e
         nncdukJygpJBBLssXuUymb4O30H1SzDB/693ikWJ8mNgssw6R6pG4Vo7Ci4WniCtVpo1
         YOZ0tdewOquYyIldUDHqWAz08ja84xrGBPzVNJ66KOMoyD8HGfLXrcQFfimxD58O0H79
         0Kjeqr8OCXpCU8UbHWyMBOym9EozF7rJOqy20JOKXyYW0hIbCt/8jFgBF6J4LJMogM/C
         K5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0qNPhmzg0s6OFq2ccQPYykHxxawuEd3L1JQLHES3r0g=;
        b=ktj2y5TQxrUdHOdOflIGG3EQJNSujMksQybLaOlCpNeECFtfpOW1evvIZnhwFpS1s+
         zF/ynseRyDrBAWLxIXV0fBvx1TsGhFX4rdE6X909Y38sguyX8VcGQTOOKJj8+W8UF4Si
         YyWlbtHt8arPv387Ht0DuNzjmftbL0fwXos/E75hwN4SfvTspS9sebvKg0cNdUL8nDUi
         beT0CoidzznvJBuMnJ//Yf5t8rU7wUr8/ouVSRjozs5frQ6gS1nGldKYnNtFTLdnogYK
         l35agW5SNImoeacHrLKdRgHbVEzuwY4GmhBdEKUNU8ml1iE1F8tE+HEDTqbwvmBDSTRD
         W03w==
X-Gm-Message-State: APjAAAVbKkE8kab5a2QiXX6mLbJyDIvxSNqnJh3C6yFlrQRwPlSDHeY1
        NMhG4Q1U9nBtQf6lchaq/lQ=
X-Google-Smtp-Source: APXvYqwJa//G1r4JosGXA6Zumx9x1lKwX8oaD3AKo4F/VYtA+SHvy+v2iygM8W2pIilz3wF1N6m6OA==
X-Received: by 2002:a5e:aa09:: with SMTP id s9mr49347ioe.22.1569426521711;
        Wed, 25 Sep 2019 08:48:41 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id i67sm263019ilf.84.2019.09.25.08.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 08:48:41 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i40e: prevent memory leak in i40e_setup_macvlans
Date:   Wed, 25 Sep 2019 10:48:30 -0500
Message-Id: <20190925154831.19044-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In i40e_setup_macvlans if i40e_setup_channel fails the allocated memory
for ch should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6031223eafab..7d4a14c3fe58 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7168,6 +7168,7 @@ static int i40e_setup_macvlans(struct i40e_vsi *vsi, u16 macvlan_cnt, u16 qcnt,
 		ch->num_queue_pairs = qcnt;
 		if (!i40e_setup_channel(pf, vsi, ch)) {
 			ret = -EINVAL;
+			kfree(ch);
 			goto err_free;
 		}
 		ch->parent_vsi = vsi;
-- 
2.17.1

