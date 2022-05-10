Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D64D520EA5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 09:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbiEJHhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 03:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbiEJHJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 03:09:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A6E28FE9F;
        Tue, 10 May 2022 00:05:24 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24A5socp029970;
        Tue, 10 May 2022 07:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=x8CaSPvWwFk6fta/2emMw0Wwu+Xc0DZl9wpjs3XPSM4=;
 b=QJe2euZcLryjJj+2k1ODWa3bc3juBq1sRZJT5W4KQLrjxPNrxyyMs6YMBT67xnytMT80
 Cr54kjbWNkSnnsx9PnHIVV09/kA7SgGB/D9iSYx2vfuxDHOAKVCky6HyiVNduauH6wyL
 0TSNXGqmZyDcu3kB+Yw3p2uUcUOxd4BDYLAZkfy9ILR0bpA9nTZ73dZhpj/QE6iqsHbt
 HNOEWexMfjg6zEyqAr2EVt48OtGJW6P7YlJirfhJy8T2sPdPI1XbZto4rXMU3LvFbaob
 JgpG2DKrQrpW5DKAm8jwmxaqQwPoJdyNQ7Pc3taZTb1oHcmmPTJ5dYX80GPSbxwszEwt mw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyjaqh730-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:05:20 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24A737Vj010628;
        Tue, 10 May 2022 07:05:18 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8ts7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 07:05:18 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24A75EK925100728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 07:05:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBEE75204F;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id CB45E5204E;
        Tue, 10 May 2022 07:05:14 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55271)
        id 99C42E1367; Tue, 10 May 2022 09:05:14 +0200 (CEST)
From:   Alexandra Winter <wintera@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net 2/3] s390/ctcm: fix potential memory leak
Date:   Tue, 10 May 2022 09:05:07 +0200
Message-Id: <20220510070508.334726-3-wintera@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510070508.334726-1-wintera@linux.ibm.com>
References: <20220510070508.334726-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xhLu01Ulv2056YFJ48jwAm65F1Yo-_bs
X-Proofpoint-GUID: xhLu01Ulv2056YFJ48jwAm65F1Yo-_bs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_06,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205100028
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

smatch complains about
drivers/s390/net/ctcm_mpc.c:1210 ctcmpc_unpack_skb() warn: possible memory leak of 'mpcginfo'

mpc_action_discontact() did not free mpcginfo. Consolidate the freeing in
ctcmpc_unpack_skb().

Fixes: 293d984f0e36 ("ctcm: infrastructure for replaced ctc driver")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
---
 drivers/s390/net/ctcm_mpc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index 88abfb5e8045..8ac213a55141 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -626,8 +626,6 @@ static void mpc_rcvd_sweep_resp(struct mpcg_info *mpcginfo)
 		ctcm_clear_busy_do(dev);
 	}
 
-	kfree(mpcginfo);
-
 	return;
 
 }
@@ -1192,10 +1190,10 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 						CTCM_FUNTAIL, dev->name);
 			priv->stats.rx_dropped++;
 			/* mpcginfo only used for non-data transfers */
-			kfree(mpcginfo);
 			if (do_debug_data)
 				ctcmpc_dump_skb(pskb, -8);
 		}
+		kfree(mpcginfo);
 	}
 done:
 
@@ -1977,7 +1975,6 @@ static void mpc_action_rcvd_xid0(fsm_instance *fsm, int event, void *arg)
 		}
 		break;
 	}
-	kfree(mpcginfo);
 
 	CTCM_PR_DEBUG("ctcmpc:%s() %s xid2:%i xid7:%i xidt_p2:%i \n",
 		__func__, ch->id, grp->outstanding_xid2,
@@ -2038,7 +2035,6 @@ static void mpc_action_rcvd_xid7(fsm_instance *fsm, int event, void *arg)
 		mpc_validate_xid(mpcginfo);
 		break;
 	}
-	kfree(mpcginfo);
 	return;
 }
 
-- 
2.32.0

