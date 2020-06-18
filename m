Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332FD1FF4F6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgFROl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 10:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730842AbgFROl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 10:41:26 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94C320773;
        Thu, 18 Jun 2020 14:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592491286;
        bh=7gp9lAbSMGxCdwx2huG0GKPn1vcy2864xBqQ5wfvFgs=;
        h=Date:From:To:Cc:Subject:From;
        b=hrb8hB3NyEz9oREFqGGfYqRyu/IstUrpYQMlurWzN93I1vBLif5bnLGQhDPMuJESh
         +5cNtcEoyjUcQKGqItA+D5c9gK4jg+aqO+sil/vEMTng0QuRg1YpuoU5lV5yWV7csf
         QSyWYYJ3l6ASiQMKV2GTNXJotGjjOtMBS+0XA9ic=
Date:   Thu, 18 Jun 2020 09:46:48 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] taprio: Use struct_size() in kzalloc()
Message-ID: <20200618144648.GA11738@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes. Also, remove unnecessary
variable _size_.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sched/sch_taprio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b1eb12d33b9a..e981992634dd 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1108,11 +1108,10 @@ static void setup_txtime(struct taprio_sched *q,
 
 static struct tc_taprio_qopt_offload *taprio_offload_alloc(int num_entries)
 {
-	size_t size = sizeof(struct tc_taprio_sched_entry) * num_entries +
-		      sizeof(struct __tc_taprio_qopt_offload);
 	struct __tc_taprio_qopt_offload *__offload;
 
-	__offload = kzalloc(size, GFP_KERNEL);
+	__offload = kzalloc(struct_size(__offload, offload.entries, num_entries),
+			    GFP_KERNEL);
 	if (!__offload)
 		return NULL;
 
-- 
2.27.0

