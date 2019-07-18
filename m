Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10A06CA47
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfGRHtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:49:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfGRHtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 03:49:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6I7mb2w102309;
        Thu, 18 Jul 2019 07:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=mN2mIE/oJ69bc8M1rgU2Tj5hVTpsF7br/LSsq5VFIpk=;
 b=fSfKeDnxppWtDOvXK7ZtziIYqtdOSjUo0dejULXxwqY6hcia63rDyOX/pHAjoEorC6Mq
 xmNBRNJ1Jd41MLsML/XGl/55Sl+sqzm28+ylxTuux2l76NkhXlNr6ulRiiXiFML71FNb
 xrLKWbkPcYkbmKRCN4wzU95jnGvBN02OrBx7bgSGeT8q4NFLYcxWVuumWd+G705lqNEF
 QwVN6WvXsMvu/ZukwdIUcDinpkksxkSX3t+hsmI8HJyCG1z1nwpBcfDVPdXXGkFp19qg
 clBRuMbuVE3utriYp3KnS3uO/mmLFs8kWShWzuMGD2LmrWhDFk04tClv+wDD5aFngDjv 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tq7xr7592-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jul 2019 07:49:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6I7lhcv184496;
        Thu, 18 Jul 2019 07:49:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tsctxvda9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jul 2019 07:49:13 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6I7nBii010771;
        Thu, 18 Jul 2019 07:49:11 GMT
Received: from [10.191.21.146] (/10.191.21.146)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jul 2019 07:49:11 +0000
To:     netdev@vger.kernel.org
Cc:     herbert@gondor.apana.org.au
From:   Jacob Wen <jian.w.wen@oracle.com>
Subject: IP GRO verifies csum again?
Message-ID: <6cc12686-a13d-81a8-ad3c-4601397c900e@oracle.com>
Date:   Thu, 18 Jul 2019 15:49:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9321 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=975
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907180090
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9321 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907180090
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

inet_gro_receive verifies IP csum but a NIC already did so and set 
CHECKSUM_UNNECESSARY.


https://github.com/torvalds/linux/blob/v5.2/net/ipv4/af_inet.c#L1432-L1433

if (unlikely(ip_fast_csum((u8 *)iph, 5)))

         goto out_unlock;


Is this a bug?

