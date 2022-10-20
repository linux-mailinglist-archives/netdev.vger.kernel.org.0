Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FB3605A56
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 10:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJTI4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 04:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJTI4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 04:56:10 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33EB18C439
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 01:56:09 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K6Q8Rk009159;
        Thu, 20 Oct 2022 01:55:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=axocrftwap9y+ZJCsoRHYWOyESLCAY3EFMkMfgOiIQc=;
 b=e0+cB00f5JTObgvClaIn8tfupVSx2qCMY4O5LGLJZuy+3jLNXbdnkfqF1CGeroSSs0r3
 CLU9KKY8T21dja0aA3CsXwrCpeGPu94+48kJxQrwgnNBigAkFgu8thA4zdHv6ZhhBle4
 eTHqirzKQelgUj8PMaZFW4SXOjFTBzhNPqTk3RPJGkyDCrM0jllPgWCHAvyBXiUY2o5z
 n8xzIbobk9vLxv8OJKL+ZbnGikf9TDD5dj5fyFDgfmPZZQNy/Qty5MgsSoUB/bV7Nazh
 tfA5qj+PnXbN3ijo9j8aPHwYWcVBt+cH4yjMfGAK0/kumLNmXg1l2BvniX/tOCumGAJS gg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3kb1258fhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 01:55:42 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Oct
 2022 01:55:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 20 Oct 2022 01:55:40 -0700
Received: from [10.9.118.29] (EL-LT0043.marvell.com [10.9.118.29])
        by maili.marvell.com (Postfix) with ESMTP id 1A1893F704A;
        Thu, 20 Oct 2022 01:55:18 -0700 (PDT)
Message-ID: <2945b16a-87b2-9489-cb4f-f578c368f814@marvell.com>
Date:   Thu, 20 Oct 2022 10:55:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101
 Thunderbird/106.0
Subject: Re: [PATCH v2 net] atlantic: fix deadlock at aq_nic_stop
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        <kuba@kernel.org>, <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <mstarovo@pm.me>, <netdev@vger.kernel.org>,
        Li Liang <liali@redhat.com>
References: <20221014103443.138574-1-ihuguet@redhat.com>
 <20221020075310.15226-1-ihuguet@redhat.com>
Content-Language: en-US
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20221020075310.15226-1-ihuguet@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Jw2FJismqX6C_OLFM0v9yhq5Cx1x8w_F
X-Proofpoint-ORIG-GUID: Jw2FJismqX6C_OLFM0v9yhq5Cx1x8w_F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/20/2022 9:53 AM, Íñigo Huguet wrote:
> NIC is stopped with rtnl_lock held, and during the stop it cancels the
> 'service_task' work and free irqs.

Hi Íñigo, thanks for taking care of this.

Just reviewed, overall looks reasonable for me. Unfortunately I don't recall
now why RTNL lock was used originally, most probably we've tried to secure
parallel "ip macsec configure something" commands execution.

But the model with internal mutex looks safe for me.

Unfortunately I now have no ability to verify your patch, edge usecase here
would be to try stress running in parallel:
"ethtool -S <iface>"
"ip macsec show"
"ip macsec <change something>"
Plus ideal would be link flipping.

Have you tried something like that?

Reviewed-by: Igor Russkikh <irusskikh@marvell.com>

Regards,
  Igor
