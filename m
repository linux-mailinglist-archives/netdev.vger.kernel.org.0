Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D622749F4E7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347118AbiA1II0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:08:26 -0500
Received: from mga18.intel.com ([134.134.136.126]:11371 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbiA1IIY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 03:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643357304; x=1674893304;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pITGzVCbZRtpq2q1aOKadxl2UAcX3Welnaw3bRtitQo=;
  b=iBllToQDx84abThRyPqwKZrzGLa9jBnVY3ybO6LSilOHu7tErHBvc4v5
   Gm2o00DFv0vfsH6bTlVywTFORfOklGY6/+zWvaDU/t0g1J4ZlFjErcKBu
   /IQymy6ZQ86VBOgySpyZln2NIbXovFMbveqjnOkOikV+vA013981D+HhL
   9KUKf/TNlmkn7g1vRMiJy7MOHSSNEOgk3PUinyt1Y2grY/P1uljwzp0fa
   F2s90QZwbypiUPXvJjXf8T+AO2p0P8x1khtvXnZRDSfZsOIBy5XlZbusQ
   mJNxEKHRxWXUXs7p9v0Febh4a4QWcGZK+BDD7pyM5Rl5ESE88U4B/aULR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="230651803"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="230651803"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 00:08:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="536041501"
Received: from npg-dpdk-haiyue-1.sh.intel.com ([10.67.118.194])
  by orsmga008.jf.intel.com with ESMTP; 28 Jan 2022 00:08:08 -0800
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     netdev@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>,
        Shailend Chand <shailend@google.com>,
        Sagi Shahar <sagis@google.com>,
        Yangchun Fu <yangchun@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] gve: fix the wrong AdminQ buffer queue index check
Date:   Fri, 28 Jan 2022 15:38:22 +0800
Message-Id: <20220128073824.7209-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.35.0
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

