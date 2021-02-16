Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9130631D10B
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBPTjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:39:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBPTjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:39:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11GJT0ZQ056776;
        Tue, 16 Feb 2021 19:38:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=20SQMB9x5QPouRX/X14gXKQDWzde0lyKl3DjPdES2BA=;
 b=Wr90R//xpe836aAyvRHCEeB04UnimCTdiOAb9zBp90hTw7y9OreNeCITo6MJgGXOBIXk
 twS8jR1BDJiiPqlzdQrfS3CQvrbl6Ha59gIMjCXpunhx0XRtXYG7977hIFiN5nHdEcao
 DjD0ELWVj13/JpmFmXq32pCNlI2stjZyWlET++tZuhjQyyrbEK+hFIn3xF7MlYpxi3v6
 UQBAlZP63hNB/ICZcjw9wKtb9DaZwj2hac5WIW/3qg6i4Z8SeJs08XpiX6q2S+iFGZfA
 onz2Q7v0vJj/nIP8VuLvLfSAl0PZoYMdtw+4IaAypdBmGitC0zX+8KT2jMJOdbb3QBh8 Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36p66r0390-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 19:38:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11GJbJP9162073;
        Tue, 16 Feb 2021 19:38:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 36prhryam0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Feb 2021 19:38:51 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11GJcoCb003035;
        Tue, 16 Feb 2021 19:38:51 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Feb 2021 11:38:49 -0800
Date:   Tue, 16 Feb 2021 22:38:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     cong.wang@bytedance.com
Cc:     netdev@vger.kernel.org
Subject: [bug report] net: fix dev_ifsioc_locked() race condition
Message-ID: <YCwfQn21MdZmE3CO@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=893 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102160162
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9897 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1011 spamscore=0 mlxscore=0
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=836
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102160162
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Cong Wang,

The patch 3b23a32a6321: "net: fix dev_ifsioc_locked() race condition"
from Feb 11, 2021, leads to the following static checker warning:

	drivers/net/tap.c:1095 tap_ioctl()
	warn: check that 'sa.sa_family' doesn't leak information

drivers/net/tap.c
  1084  
  1085          case SIOCGIFHWADDR:
  1086                  rtnl_lock();
  1087                  tap = tap_get_tap_dev(q);
  1088                  if (!tap) {
  1089                          rtnl_unlock();
  1090                          return -ENOLINK;
  1091                  }
  1092                  ret = 0;
  1093                  dev_get_mac_address(&sa, dev_net(tap->dev), tap->dev->name);

How do you want to handle errors from dev_get_mac_address()?

  1094                  if (copy_to_user(&ifr->ifr_name, tap->dev->name, IFNAMSIZ) ||
  1095                      copy_to_user(&ifr->ifr_hwaddr, &sa, sizeof(sa)))
  1096                          ret = -EFAULT;
  1097                  tap_put_tap_dev(tap);
  1098                  rtnl_unlock();
  1099                  return ret;
  1100  

regards,
dan carpenter
