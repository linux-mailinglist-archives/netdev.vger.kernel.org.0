Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317B413FBC8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 22:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387539AbgAPV5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 16:57:05 -0500
Received: from gateway23.websitewelcome.com ([192.185.50.108]:46962 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729153AbgAPV5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 16:57:04 -0500
X-Greylist: delayed 1235 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jan 2020 16:57:03 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id A142794C7
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 15:36:27 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id sCoVij1MnHiO0sCoVigbF7; Thu, 16 Jan 2020 15:36:27 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eAKpUW4Y8qknkzN4AAowy2Wed9URe9xaFrVdLf7t/EI=; b=vX6fievFaA18QZ1ClygheHbXNM
        QdTnvyNZ4p1+AAUymuJXsaetAMLpJB8ixy5m3U0VlDqut8iQMCzL8rPbI14J7rDedsJF487gyKOj4
        jDyiwHjZrCBdOxcPnTHVCjFDY4vyIlXO2roP85bEE1YXax1uR42+DJx6PiGUom0n52ZJNG4CEJnsd
        pPp/l7A4aiYhaJTzeSVwfqx93xWolfSwpGYZcZTpe7XhWRY/9EIZVkgHSGNMzNXEsklY8O8DniIkS
        g31CZl/IUyXR3TQI9/4s+pAPu0Ai0SMgYtHWX11Tkw81aViB9LcTi0RAihyoHqbLD2qskeLuZ/CUN
        lOLKjSnA==;
Received: from 187-162-252-62.static.axtel.net ([187.162.252.62]:43810 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1isCoT-000Pu6-Im; Thu, 16 Jan 2020 15:36:25 -0600
Date:   Thu, 16 Jan 2020 15:36:25 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: sched: cls_u32: Use flexible-array member
Message-ID: <20200116213625.GA9294@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.252.62
X-Source-L: No
X-Exim-ID: 1isCoT-000Pu6-Im
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-252-62.static.axtel.net (embeddedor) [187.162.252.62]:43810
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Old code in the kernel uses 1-byte and 0-byte arrays to indicate the
presence of a "variable length array":

struct something {
    int length;
    u8 data[1];
};

struct something *instance;

instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
instance->length = size;
memcpy(instance->data, source, size);

There is also 0-byte arrays. Both cases pose confusion for things like
sizeof(), CONFIG_FORTIFY_SOURCE, etc.[1] Instead, the preferred mechanism
to declare variable-length types such as the one above is a flexible array
member[2] which need to be the last member of a structure and empty-sized:

struct something {
        int stuff;
        u8 data[];
};

Also, by making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
unadvertenly introduced[3] to the codebase from now on.

[1] https://github.com/KSPP/linux/issues/21
[2] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/sched/cls_u32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index a0e6fac613de..5537b5b72ad5 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -79,7 +79,7 @@ struct tc_u_hnode {
 	/* The 'ht' field MUST be the last field in structure to allow for
 	 * more entries allocated at end of structure.
 	 */
-	struct tc_u_knode __rcu	*ht[1];
+	struct tc_u_knode __rcu	*ht[];
 };
 
 struct tc_u_common {
-- 
2.23.0

