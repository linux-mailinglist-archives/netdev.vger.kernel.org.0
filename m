Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD786E1BA7
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjDNF1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDNF1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:27:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C9D1BE8;
        Thu, 13 Apr 2023 22:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681450055; x=1712986055;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5n/0mu42zjwQFiX1Bk2YBnMsraHX2+ZdlcxSeNpwlQA=;
  b=GDQODF+IB4c7PWaOy+wICacgxDdbDCvHTt6rIp6ykLNf421zZ8bamOvF
   CGk3iM5Co5+PYe82SMHF5HAwzKEbLOehSoYeuHdIirTA221DyO2wGB1AI
   0DXF30Ddg5agvCjTim2KKL5Ep+a4gFCJkJsv4b31owHxvZBV1T82uy6ah
   8c2TXYGASSUpd0jNDIdoyqe5qJI0wNqcVkm9L7Q0mLcDH2msTv3rtrI1h
   +zUYp++fMKbAKcLxhKj9TYsvUIMLffisLzhkTOsYPlBAMFd/BD+v/FU6K
   fPmXkgJztjgCSAp07hDTlcanh2GtgdCnY40w7YWnZ5pgc0k97+Y7OFtJn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="333152648"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="333152648"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 22:27:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="692234132"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="692234132"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga007.fm.intel.com with ESMTP; 13 Apr 2023 22:27:28 -0700
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next v5 0/3] XDP Rx HWTS metadata for stmmac driver
Date:   Fri, 14 Apr 2023 13:26:48 +0800
Message-Id: <20230414052651.1871424-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

changelog:
v4 -> v5: remove zeroing operation on ctx variable

v3 -> v4: directly retrieve Rx HWTS in stmmac_xdp_rx_timestamp(), instead
	  of reuse stmmac_get_rx_hwtstamp()

v2 -> v3: To reduce packet processing cost, get the Rx HWTS only when
	  xmo_rx_timestamp() is called

v1 -> v2: Add static to stmmac_xdp_metadata_ops declaration

---

Song Yoong Siang (3):
  net: stmmac: introduce wrapper for struct xdp_buff
  net: stmmac: add Rx HWTS metadata to XDP receive pkt
  net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt

 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  7 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 80 ++++++++++++++++---
 2 files changed, 77 insertions(+), 10 deletions(-)

-- 
2.34.1

