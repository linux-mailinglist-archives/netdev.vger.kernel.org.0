Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6CE231F01
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgG2NHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:07:06 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:52969 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbgG2NHG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 09:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        Message-ID:MIME-Version:Content-Type:Content-Disposition; bh=SiN
        pc9WM7eKH/lgSs7lDo7p4zip8qUWuXCdbE7O2qys=; b=BtJFvuLD7Nl26b9h+Vz
        DqK7Z4tkRSTjE3DhWtvmomrQVC0ef1iT+UIN5yg2y6lP7FzSAaKZheLbQGeDgzTd
        6GF83MTzjHiC74jC6G9gBrxA2GQJVGfd3ZSntbcYGwBFXIiHqgKqeIvPvcqkKF6J
        wy32NDPAOqoosj8iYPdHVfuo=
Received: from xin-virtual-machine (unknown [111.192.143.50])
        by app1 (Coremail) with SMTP id XAUFCgDHzd10dCFfM3FlAg--.212S3;
        Wed, 29 Jul 2020 21:07:02 +0800 (CST)
Date:   Wed, 29 Jul 2020 21:06:59 +0800
From:   Xin Xiong <xiongx18@fudan.edu.cn>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, yuanxzhang@fudan.edu.cn
Subject: [PATCH] atm: fix atm_dev refcnt leaks in atmtcp_remove_persistent
Message-ID: <20200729130659.GA7712@xin-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-CM-TRANSID: XAUFCgDHzd10dCFfM3FlAg--.212S3
X-Coremail-Antispam: 1UD129KBjvJXoW7urWDuFW7ZF4DWF1fJr1xAFb_yoW8Gr1kpr
        W7W3WFkr9YgF9rJwnrtwn29a45GFnrXry8K34Y9343Ar17Xa43Wr1YgFWjgasrZFWkKr1f
        Zw4qqFW5urWqkFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
        4I1lc2xSY4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI
        8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
        xVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI
        8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUjkhLUUUUUU==
X-CM-SenderInfo: arytiiqsuqiimz6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

atmtcp_remove_persistent() invokes atm_dev_lookup(), which returns a
reference of atm_dev with increased refcount or NULL if fails.

The refcount leaks issues occur in two error handling paths. If
dev_data->persist is zero or PRIV(dev)->vcc isn't NULL, the function
returns 0 without decreasing the refcount kept by a local variable,
resulting in refcount leaks.

Fix the issue by adding atm_dev_put() before returning 0 both when
dev_data->persist is zero or PRIV(dev)->vcc isn't NULL.

Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 drivers/atm/atmtcp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index d9fd70280482..7f814da3c2d0 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -433,9 +433,15 @@ static int atmtcp_remove_persistent(int itf)
 		return -EMEDIUMTYPE;
 	}
 	dev_data = PRIV(dev);
-	if (!dev_data->persist) return 0;
+	if (!dev_data->persist) {
+		atm_dev_put(dev);
+		return 0;
+	}
 	dev_data->persist = 0;
-	if (PRIV(dev)->vcc) return 0;
+	if (PRIV(dev)->vcc) {
+		atm_dev_put(dev);
+		return 0;
+	}
 	kfree(dev_data);
 	atm_dev_put(dev);
 	atm_dev_deregister(dev);
-- 
2.25.1

