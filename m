Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692D722D5F4
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 10:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgGYILF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 04:11:05 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:47129 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbgGYILE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 04:11:04 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2020 04:11:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=Bmmdc9TdbNDoanpb/xc0KWb2EO1V4Pol3FKa645b28M=; b=z
        9j/phfFLzDq96MMao2Hgly1H6lxHJPceSKaL0ryuAAR8BAyi4N1tzn+w16XSrUjX
        vLj/343S8/6vPaSgPvsNZsxY5SmsMK8GUunwiTfXrQJrTvJ1Ow53fNL3nUDCEwni
        BoBefddlefeb99QWsNH02h3mighjvORaNunjiDB23I=
Received: from localhost.localdomain (unknown [202.120.224.53])
        by app1 (Coremail) with SMTP id XAUFCgBX2EFe5xtfDEgvAg--.23318S3;
        Sat, 25 Jul 2020 16:03:43 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>, Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] ipv6: Fix nexthop refcnt leak when creating ipv6 route info
Date:   Sat, 25 Jul 2020 16:02:18 +0800
Message-Id: <1595664139-40703-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgBX2EFe5xtfDEgvAg--.23318S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr45uFyrXFWxWF15AryrJFb_yoW8XryfpF
        WfKrZ8Xr1rCa4UGas5ta1xtF13Jw48G3WkWFy3Ca93Kr98Z34vyr1jgrWjvrW7XrWxG34a
        qFWjvr1jkF9xCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwCY02Avz4vE14v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUjn2atUUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip6_route_info_create() invokes nexthop_get(), which increases the
refcount of the "nh".

When ip6_route_info_create() returns, local variable "nh" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
ip6_route_info_create(). When nexthops can not be used with source
routing, the function forgets to decrease the refcnt increased by
nexthop_get(), causing a refcnt leak.

Fix this issue by pulling up the error source routing handling when
nexthops can not be used with source routing.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/ipv6/route.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 82cbb46a2a4f..427ecd7032bd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3682,14 +3682,14 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	rt->fib6_src.plen = cfg->fc_src_len;
 #endif
 	if (nh) {
-		if (!nexthop_get(nh)) {
-			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
-			goto out;
-		}
 		if (rt->fib6_src.plen) {
 			NL_SET_ERR_MSG(extack, "Nexthops can not be used with source routing");
 			goto out;
 		}
+		if (!nexthop_get(nh)) {
+			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+			goto out;
+		}
 		rt->nh = nh;
 		fib6_nh = nexthop_fib6_nh(rt->nh);
 	} else {
-- 
2.7.4

