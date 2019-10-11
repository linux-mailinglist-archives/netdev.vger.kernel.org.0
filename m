Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43180D45D0
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 18:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfJKQxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 12:53:22 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:2216 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727984AbfJKQxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 12:53:22 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BGqCUK015053;
        Fri, 11 Oct 2019 17:53:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=8pSEexMQxWPX61135+mphsfh31vay03fJ7VPUmG4u7E=;
 b=oGT9RA0OekeB6ZE85otLWr6H+JEFLV3FIvr4H9S9qX76R+rzDIQ3slBaIlnYQjv92axx
 xHaIMFBZClTI/3JgAeBnQ54g/a1bMaub1ER5qTLdGkj99Ce0RXAXLbuWH33SR7XtOPu8
 TCgL3rH439c9Z7p4u83kDbEo02CBw1O0Np78tATdw8opIuabCa4eP8TIP7efmscLrfKa
 2desdQWnwRXOXPx126X37A6KuO5tYAmJh/FvrvJy2Xy0fsTHYMbalaBeSEdE60DynXRx
 boP0A5XlAB3MgsFyVjGztJePXECkbbPh6NZVobErRzUO44e+f0at7Waeb94kiCPoLlrI +g== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2vjt7us38t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 17:53:14 +0100
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9BGldL0019539;
        Fri, 11 Oct 2019 12:53:13 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint6.akamai.com with ESMTP id 2vepgwg2r1-1;
        Fri, 11 Oct 2019 12:53:13 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 0A5F51FC95;
        Fri, 11 Oct 2019 16:53:13 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iIyAg-0005EM-I7; Fri, 11 Oct 2019 12:53:42 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com
Cc:     willemb@google.com, sridhar.samudrala@intel.com,
        aaron.f.brown@intel.com, alexander.h.duyck@linux.intel.com,
        Josh Hunt <johunt@akamai.com>
Subject: [PATCH v3 0/3] igb, ixgbe, i40e UDP segmentation offload support
Date:   Fri, 11 Oct 2019 12:53:37 -0400
Message-Id: <1570812820-20052-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-11_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910110148
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_10:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910110149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Duyck posted a series in 2018 proposing adding UDP segmentation
offload support to ixgbe and ixgbevf, but those patches were never
accepted:

https://lore.kernel.org/netdev/20180504003556.4769.11407.stgit@localhost.localdomain/

This series is a repost of his ixgbe patch along with a similar
change to the igb and i40e drivers. Testing using the udpgso_bench_tx
benchmark shows a noticeable performance improvement with these changes
applied.

I've shared the benchmark script I've used to generate the #s in this mail:
https://lore.kernel.org/netdev/0e0e706c-4ce9-c27a-af55-339b4eb6d524@akamai.com/T/#mfe4c35c57a3860cda5306b63f61068f837242ee5

v3 change:
 * Change gso_type order check, suggested by Alex

v2 changes:
 * Added Alex's suggested-by tag to ixgbe patch
 * Checking for gso_type, suggested by Sridhar
 * Fixed bug in ixgbe patch where I accidentally left the old type_tucmd
   set to TCP
 * Updated perf #s below
   * includes changes above
   * fixed bad config on my igb machine
   * added chip used for testing next to driver name

All #s below were run with:
udpgso_bench_tx -C 1 -4 -D 172.25.43.133 -z -l 30 -S 0 -u -s $pkt_size

igb (i210)::
SW GSO (ethtool -K eth0 tx-udp-segmentation off):
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		120167.13	114	81278	81278	16.24	7.01
2944		120166.83	114	40641	40641	12.82	8.89
5888		120166.42	114	20320	20320	10.14	11.24
11776		120166.43	114	10160	10160	8.55	13.33
23552		120167.24	114	5080	5080	7.76	14.69
47104		120166.83	114	2540	2540	7.07	16.12
61824		120167.08	114	1935	1935	7.07	16.12

HW GSO offload (ethtool -K eth0 tx-udp-segmentation on):
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		120167.05	114	81276	81276	16.13	7.06
2944		120166.94	114	40640	40640	8.66	13.16
5888		120166.84	114	20320	20320	5.34	21.34
11776		120166.84	114	10160	10160	3.34	34.13
23552		120167.25	114	5080	5080	2.55	44.70
47104		120149.30	113	2539	2539	2.14	52.80
61824		120165.41	114	1935	1935	2.04	55.88

ixgbe (82599ES)::
SW GSO:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		1043972.83	990	706122	706122	100	9.90
2944		1201623.17	1140	406367	406367	95.97	11.87
5888		1201629.46	1140	203184	203184	56	20.35
11776		1201631.38	1140	101590	101590	42.72	26.68
23552		1201633.94	1140	50796	50796	36.31	31.39
47104		1201631.05	1140	25397	25397	33.91	33.61
61824		1201629.96	1140	19350	19350	33.38	34.15

HW GSO Offload:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		1053393.41	999	712679	712679	100	9.99
2944		1201631.19	1140	406357	406357	57.92	19.68
5888		1201622.51	1140	203178	203178	30.66	37.18
11776		1201626.60	1140	101590	101590	16.89	67.49
23552		1201617.19	1140	50795	50795	10.11	112.75
47104		1200218.72	1138	25368	25368	6.86	165.88
61824		1201619.66	1140	19350	19350	5.38	211.89

i40e (x710)::
SW GSO:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		642718.15	609	434585	434585	100	6.09
2944		957988.80	909	324029	324029	100	9.09
5888		1199207.69	1138	202845	202845	81.51	13.96
11776		1200767.60	1139	101517	101517	63.93	17.81
23552		1201197.22	1140	50794	50794	59.14	19.27
47104		1201410.91	1139	25393	25393	57.15	19.93
61824		1201609.48	1140	19350	19350	55.12	20.68

HW GSO offload:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		666626.15	632	450920	450920	100	6.32
2944		1200831.63	1139	406093	406093	89.68	12.70
5888		1201603.35	1140	203178	203178	56.38	20.21
11776		1201597.29	1140	101588	101588	36.9	30.89
23552		1201596.98	1140	50794	50794	24.23	47.04
47104		1201491.67	1139	25394	25394	17.14	66.45
61824		1201598.88	1140	19350	19350	15.11	75.44

Josh Hunt (3):
  igb: Add UDP segmentation offload support
  ixgbe: Add UDP segmentation offload support
  i40e: Add UDP segmentation offload support

 drivers/net/ethernet/intel/i40e/i40e_main.c   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 12 +++++++++---
 drivers/net/ethernet/intel/igb/e1000_82575.h  |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c     | 23 +++++++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 ++++++++++++++++++------
 5 files changed, 46 insertions(+), 15 deletions(-)

-- 
2.7.4
