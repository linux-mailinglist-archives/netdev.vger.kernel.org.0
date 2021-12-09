Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6AE46E104
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhLICye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:54:34 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:39870 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230401AbhLICyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 21:54:33 -0500
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowADHlpEAb7FhZk63AQ--.18135S2;
        Thu, 09 Dec 2021 10:50:41 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     idryomov@gmail.com, jlayton@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] libceph, ceph: potential dereference of null pointer
Date:   Thu,  9 Dec 2021 10:50:38 +0800
Message-Id: <20211209025038.2028112-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowADHlpEAb7FhZk63AQ--.18135S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4xtrW8Cw18uw4DCF43GFg_yoW3Arg_Ca
        n2vrnIvr13ZF10kanrurWrWrZ2v347Wr4rZw13KF93Cr9ruFn8Aa4xX345AF13uFyxCFyD
        CrZ8Cry3JwnFkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUO_MaUU
        UUU
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of kzalloc() needs to be checked.
To avoid use of null pointer in case of the failure of alloc.

Fixes: 3d14c5d2b6e1 ("ceph: factor out libceph from Ceph file system")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 net/ceph/osd_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ff8624a7c964..3203e8a34370 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1234,6 +1234,8 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 	WARN_ON(onum == CEPH_HOMELESS_OSD);
 
 	osd = kzalloc(sizeof(*osd), GFP_NOIO | __GFP_NOFAIL);
+	if (!osd)
+		return NULL;
 	osd_init(osd);
 	osd->o_osdc = osdc;
 	osd->o_osd = onum;
-- 
2.25.1

