Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB246DF0B5
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjDLJnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjDLJnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:43:19 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A115AD;
        Wed, 12 Apr 2023 02:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681292593; x=1712828593;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jPs+CdsG5on+mgZJH/qHDWHeHVfbVe0iJzdrJeUiuEo=;
  b=Q4srKryqt9x8Xfi43IgKVj58SLGvVdp8XBfym17yN9WabCarhhpPrdp+
   fEIhePpLhG60Y9n8m5qWZJ3SWR3+vBQ80+krs8E0/oRqKh3Jz4arINf1g
   t/GjACnaNcRdJtmbPm2AjDyokB6ZgQqWlyfJw7D0619jQimEDg0GF+yNC
   sXl+9znUyEjCmumsNNrFTvmu6y8gJYF7lDemyMUkF/UrtSRXPitmp529u
   wPBLSb7LfGAFPs8d2ShqwrBJP9vBrN+B0osPUJI6Yfet6Qbz+aBkIx2YY
   0Fdf+KkpjBSNYKO3Ajlsf6SBLx30xRuMhkVUXB2mzv6FhUe1+14qW5L+Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346526307"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="346526307"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 02:43:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="682430883"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="682430883"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by orsmga007.jf.intel.com with ESMTP; 12 Apr 2023 02:43:06 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next v3 0/4] XDP Rx HWTS metadata for stmmac driver
Date:   Wed, 12 Apr 2023 17:42:31 +0800
Message-Id: <20230412094235.589089-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implemented XDP receive hardware timestamp metadata for stmmac driver.

This patchset is tested with tools/testing/selftests/bpf/xdp_hw_metadata.
Below are the test steps and results.

Command on DUT:
	sudo ./xdp_hw_metadata <interface name>

Command on Link Partner:
	echo -n xdp | nc -u -q1 <destination IPv4 addr> 9091
	echo -n skb | nc -u -q1 <destination IPv4 addr> 9092

Result for port 9091:
	0x55fdb5f006d0: rx_desc[3]->addr=1000000003bd000 addr=3bd100 comp_addr=3bd000
	rx_timestamp: 1677762474360150047
	rx_hash: 0
	0x55fdb5f006d0: complete idx=515 addr=3bd000

Result for port 9092:
	found skb hwtstamp = 1677762476.320146161

Changes since v2:
 * To reduce packet processing cost, get the Rx HWTS only when xmo_rx_timestamp() is called

Changes since v1:
 * Add static to stmmac_xdp_metadata_ops declaration

---

Ong Boon Leong (1):
  net: stmmac: restructure Rx hardware timestamping function

Song Yoong Siang (3):
  net: stmmac: introduce wrapper for struct xdp_buff
  net: stmmac: add Rx HWTS metadata to XDP receive pkt
  net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt

 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  7 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 87 +++++++++++++++----
 2 files changed, 76 insertions(+), 18 deletions(-)

-- 
2.34.1

