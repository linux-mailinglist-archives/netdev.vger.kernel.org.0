Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A4E49F808
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348098AbiA1LRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:17:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:58694 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231681AbiA1LRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 06:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643368620; x=1674904620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7/urSxgK5M61VAwFxn/ZreTPy7aGvuUCzsahFXwQz7U=;
  b=g5V52OSHzo1497dg4XXytKjEoysNAVkbXV+csr/2XI1imLrbr22Nz/EG
   lDtCbtGgsh0zU3c/k3qqLGeokIAS3O6xbWQiY8zp2p4vVcgIHcCnX/1yQ
   ENbegv46oPhsubTC/O0+uPpZA60KcKvQ3J3xtQFp+5r99vE+R0BZVr5nG
   JxxlMQok/Y6WzpElh/snLfCYGsUhzkyglSEb+AhDJYLj/EN8khzwBEMMk
   bmo6A918DE0MeRQAqKXTvmziBVfWjk1qzn41OnGKe9K58RtMMllxA98Kv
   FWjtmuqkx5d2Bka6YRmnKeV3C8GEqhwwyilxMLP0/+Uas5acUsF0GRveg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="244703777"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="244703777"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 03:17:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="480705558"
Received: from npg-dpdk-haiyue-1.sh.intel.com ([10.67.118.194])
  by orsmga006.jf.intel.com with ESMTP; 28 Jan 2022 03:16:57 -0800
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     netdev@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bailey Forrest <bcf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Shailend Chand <shailend@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Sagi Shahar <sagis@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] gve: fix the wrong AdminQ buffer queue index check
Date:   Fri, 28 Jan 2022 18:47:14 +0800
Message-Id: <20220128104716.9020-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220128073824.7209-1-haiyue.wang@intel.com>
References: <20220128073824.7209-1-haiyue.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'tail' and 'head' are 'unsigned int' type free-running count, when
'head' is overflow, the 'int i (= tail) < u32 head' will be false:

Only '- loop 0: idx = 63' result is shown, so it needs to use 'int' type
to compare, it can handle the overflow correctly.

typedef uint32_t u32;

int main()
{
        u32 tail, head;
        int stail, shead;
        int i, loop;

        tail = 0xffffffff;
        head = 0x00000000;

        for (i = tail, loop = 0; i < head; i++) {
                unsigned int idx = i & 63;

                printf("+ loop %d: idx = %u\n", loop++, idx);
        }

        stail = tail;
        shead = head;
        for (i = stail, loop = 0; i < shead; i++) {
                unsigned int idx = i & 63;

                printf("- loop %d: idx = %u\n", loop++, idx);
        }

        return 0;
}

Fixes: 5cdad90de62c ("gve: Batch AQ commands for creating and destroying queues.")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
v2: Fix empty lines surround the Fixes tag
---
 drivers/net/ethernet/google/gve/gve_adminq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 2ad7f57f7e5b..f7621ab672b9 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -301,7 +301,7 @@ static int gve_adminq_parse_err(struct gve_priv *priv, u32 status)
  */
 static int gve_adminq_kick_and_wait(struct gve_priv *priv)
 {
-	u32 tail, head;
+	int tail, head;
 	int i;
 
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
-- 
2.35.0

