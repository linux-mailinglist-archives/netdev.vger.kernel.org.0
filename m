Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57357606821
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJTSWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJTSWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:22:44 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124A713FDFE
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 11:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666290163; x=1697826163;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xFLGdH5cFd4lhQhKtEOFHVjv10JqP/HjVejXoWvWjh4=;
  b=b3Ilqu4qFhdSRTWm35k4FQ829nAaLSa6Ab1oHquk6f8nsuw/j5/jSGNU
   hm5o9pFgatuNVB2mXJ/5HHUGQeOhl3p/QqQRsdB2GFUgYC8uvN9os+SWh
   wn5CqF1SQpP0hilkrinH49Kasu8deuOaMMTHttM+RzsHgIIk0MfHHVKSo
   F/vHJQXGHukOUrY3Y9lcLGGraLXUPSlZtVsbY8ERxpOhD+lmR2icfuTIv
   EqFNM8eLWHgU+DuEs/7giu/jr/5FEPTnks+iirqe7y/vsnbXn5emFpdLz
   U25mNf6bmgDgh5+uOVKxSvU4RwwO14Eu8ULCz53dS5Ry5PyUXrQ2AZFuf
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,199,1661788800"; 
   d="scan'208";a="326465851"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2022 02:22:43 +0800
IronPort-SDR: u24P//KKBuDF5dnjVxNaSfxEesHKJHo77gR+UZ4B1fzdI/7/lmYJCX5CCE6zRGqXYDSIJ4WNpV
 KiCkkD0lGG1KdQ3lefbzt7DbkIIKKyrDNkXAk0GEeDy6Ued5phtVrX0aUGp91RWSjkx+m4rMTG
 NtcKmALvVeSBEb2PGvDk7/blLaEjYojCLGctLYeMjo2iAJZDHxHZ+R0HwSVp3tbR/Tn7aq187/
 yjHARK4Bz7OXzFL01rorOZIJk9U5Fx1Pku3nrOY3MfXM3H3TUwPUby3SqcoXJeq8f1w5fr6XDu
 78dHV+5GlVR0tsir/1SmIM59
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Oct 2022 10:36:32 -0700
IronPort-SDR: 86qERUXF4H8iC5vwEtvJLCD7+bBSBVfRld5Vmx/Dn5cbxAC4fZdCbcE/osdNMqkyt4jLtC/71t
 TV54ua6xHyATWVG4iXeyeh0tjoSg6lJxZx7lZZA7PfEV7COG5NZ2fj8/iwLrYKfzp0/tlg0IqQ
 yQNZagQSOpN2liD8wGqgZFia3fZH+V9927UtTCpifZ13Acx7kCLkXxmt1ee0od0ZuZyZsZ7hex
 zxMF33zKY/7G6j2hPyhFOJ/Nhmw1ECuTCddUtaimdIi+ObNRlUr2Jz4qThw3kWFy+hdjnYKaN5
 tFU=
WDCIronportException: Internal
Received: from ros-3.k2.wdc.com ([10.203.225.83])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Oct 2022 11:22:43 -0700
From:   Kamaljit Singh <kamaljit.singh1@wdc.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Niklas.Cassel@wdc.com,
        Damien.LeMoal@wdc.com, kamaljit.singh1@wdc.com
Subject: [PATCH v1 0/2] tcp bugs for window shrinking, OoO ACKs
Date:   Thu, 20 Oct 2022 11:22:40 -0700
Message-Id: <20221020182242.503107-1-kamaljit.singh1@wdc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have found significant performance impacts for 4K Writes to an NVMe/TCP
target under heavy congestion conditions due to improper SEQ-NUM number 
provided by the host TCP layer. In this case the target shrunk the window,
which seemed to cause the host to send a stale SEQ-NUM for a subsequent
ACK.

It was also observed that on occasions that a host sends ACKs out-of-order
it caused data retransmissions thus affecting performance for NVMe/TCP
Writes.

A network trace is available and can be provided for further reference.

Kamaljit Singh (2):
  tcp: Fix for stale host ACK when tgt window shrunk
  tcp: Ignore OOO handling for TCP ACKs

 net/ipv4/tcp_output.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.25.1

