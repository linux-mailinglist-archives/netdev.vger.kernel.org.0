Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D1612E9BE
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgABSJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:09:55 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44930 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgABSJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:09:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I4KpQ106456;
        Thu, 2 Jan 2020 18:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=XsUI/x0iISalOwHxyzvImUw1zJeV7hwLGtPbtmy9lVI=;
 b=EiwjUT06o8kYbRAB1FQCbzEvVf0WVjRtNxWQiXMkn+oIhBxk3CmyRIlnE1cBCv6UxoCf
 4m6+M2SeUeNTBLEEitW/zYAXMYUdDQTp/J4JApznD4YoZDQ1MTvxB5fy8Qj6C1eVIuxh
 xQJt2ZuZjVLDolzTcMnrU3XwnyGHU+C55zAtc1NkHswYtsjYJJwxM6NRart1E1F2VwIr
 TnKTUgfsqg3Z6BP7/TrwfU6wVzP74jy0Fu8dqg1UNnDdU7vdL0aBniVAGx06c4Ou9ulj
 NAZL/2h3SqMYj5dh7xo5IjJRO2+pwMaG55vli4JZgDBj+zs5nZKzEwNHr8+RMOxfAC61 bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqrmqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:09:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002I3bPA091764;
        Thu, 2 Jan 2020 18:09:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2x8gjauup3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 18:09:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 002I9agf009555;
        Thu, 2 Jan 2020 18:09:36 GMT
Received: from Lirans-MBP.Home (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 10:09:35 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     netanel@amazon.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     saeedb@amazon.com, zorik@amazon.com, sameehj@amazon.com,
        igorch@amazon.com, akiyano@amazon.com, evgenys@amazon.com,
        gtzalik@amazon.com, ndagan@amazon.com, matua@amazon.com,
        galpress@amazon.com
Subject: [PATCH 0/2] net: AWS ENA: Fix memory barrier usage when using LLQ
Date:   Thu,  2 Jan 2020 20:08:28 +0200
Message-Id: <20200102180830.66676-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=771
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=829 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020151
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This simple patch-series address 2 issues found during code-review of AWS ENA NIC driver
related to how it use memory barriers when NIC is running in "low-latency queue" mode (LLQ).

1st patch removes an unnecessary wmb().

2nd patch fix a bug of not flushing write-combined buffers holding LLQ transmit descriptors
and first packet bytes before writing new SQ tail to device. This bug is introduced because
of a weird behaviour of x86 AMD CPU that it doesn't flush write-combined buffers when CPU
writes to UC memory as x86 Intel CPU does. Which makes writeX() insufficient in order to
guarantee write-combined buffers are flushed.
This patch makes sure to just fix AWS ENA to handle this case properly, but a future patch-series
should be submitted to probably introduce a new flush_wc_writeX() macro that handles this case
properly for all CPU archs and vendors. For more info, see patch commit message itself.

Regards,
-Liran

