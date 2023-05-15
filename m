Return-Path: <netdev+bounces-2555-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02055702800
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 084D11C20AB8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75348BFC;
	Mon, 15 May 2023 09:12:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D5C6FC9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:12:55 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741173C0D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684141955; x=1715677955;
  h=date:from:to:subject:message-id:mime-version;
  bh=lrc0pTEAddZiQ2vCBiYrg9JTYezqRYmprkyNEGo2zgI=;
  b=b5Txa3/TADahvdq9gMlhNYGaQSu38wBweDuync3XUQYvN4mYE1uJYdrq
   XaSvXsNmdkbeypOpg2oBqhwG8R5UGn5zpeB4DhzLR7Hc2AhBxNfSJnCYj
   TimokSepr2Bs8J355csqJo3vnf7UxRJ9h2w2Q/+sDGgZEuWy2OiPgRedy
   KDMLWlIC3uCilBjm68sdLsid2eyFxQAV0DJJINB3ACHEt0YZt84QvHuEh
   QtsZMfNG7W3Bo/MlRoV9nomQIOTbCnnS3AJCsNhQRZc8b/wTLG6uDQS10
   rXXli3SSLOYYxNlYodvOaVsoQJIBrPgq8VQErgURLjfz0YuPcOgEwfhOm
   w==;
X-IronPort-AV: E=Sophos;i="5.99,276,1677567600"; 
   d="scan'208";a="211263610"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 May 2023 02:12:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 15 May 2023 02:12:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 15 May 2023 02:12:27 -0700
Date: Mon, 15 May 2023 11:12:26 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <edumazet@google.com>, <netdev@vger.kernel.org>
Subject: Performance regression on lan966x when extracting frames
Message-ID: <20230515091226.sd2sidyjll64jjay@soft-dev3-1>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I have noticed that on the HEAD of net-next[0] there is a performance drop
for lan966x when extracting frames towards the CPU. Lan966x has a Cortex
A7 CPU. All the tests are done using iperf3 command like this:
'iperf3 -c 10.97.10.1 -R'

So on net-next, I can see the following:
[  5]   0.00-10.01  sec   473 MBytes   396 Mbits/sec  456 sender
And it gets around ~97000 interrupts.

While going back to the commit[1], I can see the following:
[  5]   0.00-10.02  sec   632 MBytes   529 Mbits/sec   11 sender
And it gets around ~1000 interrupts.

I have done a little bit of searching and I have noticed that this
commit [2] introduce the regression.
I have tried to revert this commit on net-next and tried again, then I
can see much better results but not exactly the same:
[  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec    0 sender
And it gets around ~700 interrupts.

So my question is, was I supposed to change something in lan966x driver?
or is there a bug in lan966x driver that pop up because of this change?

Any advice will be great. Thanks!

[0] befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_record_encap_match()")
[1] d4671cb96fa3 ("Merge branch 'lan966x-tx-rx-improve'")
[2] 8b43fd3d1d7d ("net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ")

-- 
/Horatiu

