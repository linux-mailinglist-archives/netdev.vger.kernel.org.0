Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA20D1B61
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbfJIWGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:06:18 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:63040 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730809AbfJIWGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:06:18 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99M2J7L031592;
        Wed, 9 Oct 2019 23:06:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=oHJgA0Bt4FD4Vsikw6ti8Q1w9dyc77rmhnTqSsJlBMg=;
 b=kbITNSO+yPd9fOJv297fPTvL+xzAsP0avcOdLHjC1S21ERQI0kFOmbXrn6O+WdGCfDzr
 S5XlI+dF6bi3HjuoQ1DyQpOtwUlKAW6XZWpTbqe3LcjBqRp1U+PZaCSdZaF1LRCPxflo
 2b9LVvMuwJWdlC0dvduNSouv5fNTcFTpYipe137opq7YEl3GHWenp/a9l9zC47Ka0l+C
 FYVWODNFO46NKyelm5NXYuE2uZvno5h0FoqMOmzBuCuJd9yKlgaq1RMHj1RsTYHFPbUs
 IlSWRSs3Z03o3pR+QaPZWnlrqOk4j9ZvsgnZJkLzMPKkeG4nhxlxq1xlT7q6lXMpY6VN kQ== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2vek7jg655-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Oct 2019 23:06:11 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x99M2JL9027248;
        Wed, 9 Oct 2019 15:06:10 -0700
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint5.akamai.com with ESMTP id 2ves59nke8-1;
        Wed, 09 Oct 2019 15:06:09 -0700
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 825A22006A;
        Wed,  9 Oct 2019 22:06:09 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iIK6Q-0003z1-Ea; Wed, 09 Oct 2019 18:06:38 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     netdev@vger.kernel.org, willemb@google.com,
        intel-wired-lan@lists.osuosl.org
Cc:     Josh Hunt <johunt@akamai.com>
Subject: [PATCH 0/3] igb, ixgbe, i40e UDP segmentation offload support
Date:   Wed,  9 Oct 2019 18:06:14 -0400
Message-Id: <1570658777-13459-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=721
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090173
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_10:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=748 adultscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910090173
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

All #s below were run with:
udpgso_bench_tx -C 1 -4 -D 172.25.43.133 -z -l 30 -u -S 0 -s $pkt_size

igb::

SW GSO (ethtool -K eth0 tx-udp-segmentation off):
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		120143.64	113	81263	81263	83.55	1.35
2944		120160.09	114	40638	40638	62.88	1.81
5888		120160.64	114	20319	20319	43.59	2.61
11776		120160.76	114	10160	10160	37.52	3.03
23552		120159.25	114	5080	5080	34.75	3.28
47104		120160.55	114	2540	2540	32.83	3.47
61824		120160.56	114	1935	1935	32.09	3.55

HW GSO offload (ethtool -K eth0 tx-udp-segmentation on):
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		120144.65	113	81264	81264	83.03	1.36
2944		120161.56	114	40638	40638	41	2.78
5888		120160.23	114	20319	20319	23.76	4.79
11776		120161.16	114	10160	10160	15.82	7.20
23552		120156.45	114	5079	5079	12.8	8.90
47104		120159.33	114	2540	2540	8.82	12.92
61824		120158.43	114	1935	1935	8.24	13.83

ixgbe::
SW GSO:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		1070565.90	1015	724112	724112	100	10.15
2944		1201579.19	1140	406342	406342	95.69	11.91
5888		1201217.55	1140	203185	203185	55.38	20.58
11776		1201613.49	1140	101588	101588	42.15	27.04
23552		1201631.32	1140	50795	50795	35.97	31.69
47104		1201626.38	1140	25397	25397	33.51	34.01
61824		1201625.52	1140	19350	19350	32.83	34.72

HW GSO Offload:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		1058681.25	1004	715954	715954	100	10.04
2944		1201730.86	1134	404254	404254	61.28	18.50
5888		1201776.61	1131	201608	201608	30.25	37.38
11776		1201795.90	1130	100676	100676	16.63	67.94
23552		1201807.90	1129	50304	50304	10.07	112.11
47104		1201748.35	1128	25143	25143	6.8	165.88
61824		1200770.45	1128	19140	19140	5.38	209.66

i40e::
SW GSO:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		650122.83	616	439362	439362	100	6.16
2944		943993.53	895	319042	319042	100	8.95
5888		1199751.90	1138	202857	202857	82.51	13.79
11776		1200288.08	1139	101477	101477	64.34	17.70
23552		1201596.56	1140	50793	50793	59.74	19.08
47104		1201597.98	1140	25396	25396	56.31	20.24
61824		1201610.43	1140	19350	19350	55.48	20.54

HW GSO offload:
$pkt_size	kB/s(sar)	MB/s	Calls/s	Msg/s	CPU	MB2CPU
========================================================================
1472		657424.83	623	444653	444653	100	6.23
2944		1201242.87	1139	406226	406226	91.45	12.45
5888		1201739.95	1140	203199	203199	57.46	19.83
11776		1201557.36	1140	101584	101584	36.83	30.95
23552		1201525.17	1140	50790	50790	23.86	47.77
47104		1201514.54	1140	25394	25394	17.45	65.32
61824		1201478.91	1140	19348	19348	14.79	77.07

I was not sure how to proper attribute Alexander on the ixgbe patch so
please adjust this as necessary.

Thanks!

Josh Hunt (3):
  igb: Add UDP segmentation offload support
  ixgbe: Add UDP segmentation offload support
  i40e: Add UDP segmentation offload support

 drivers/net/ethernet/intel/i40e/i40e_main.c   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 12 +++++++++---
 drivers/net/ethernet/intel/igb/e1000_82575.h  |  1 +
 drivers/net/ethernet/intel/igb/igb_main.c     | 23 +++++++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 +++++++++++++++++++-----
 5 files changed, 47 insertions(+), 14 deletions(-)

-- 
2.7.4

