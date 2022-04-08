Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF1694F984C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 16:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiDHOlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 10:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiDHOlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 10:41:22 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACECECB2B;
        Fri,  8 Apr 2022 07:39:18 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 238DXrgB004524;
        Fri, 8 Apr 2022 07:39:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=Cu2apFYpM5bPz1vZIij3a91tdWX8TyF7yQXIxmBRn8A=;
 b=JkqIg8J7iTWfWkKknajNn9WQ7LBxrJY2LmdOM+MxRgI2aq0DUHOJTxE3whhaKVuVy7HX
 6Nqlgnirns41njwbzwHIunCtXRcSMwMWUHRArGT+1fkE8/+1VkfWdo1ZEbQFFrUI7E6R
 mHuZLExck1iwKbNKY+9aDXSeGo/s3YoUESws2jiyH8M4Z0a+DxhWX6rKqb8mWyCS3Xfy
 TtHAxWhgeOd08izksdleIx9+tFsvXA+wOi+vGeofCtxcOuOz3B3bNItiKyoWjH4BF8rV
 vMrfgmS/6nEGkQsSbQ1BcWqyEBqUYs4t+2ADLcgBe5q+Yan2Xx5PB0ZQ0YtDjmmK510E Zg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3f9r7erhnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 07:39:03 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Apr
 2022 07:39:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Apr 2022 07:39:01 -0700
Received: from [10.193.34.141] (unknown [10.193.34.141])
        by maili.marvell.com (Postfix) with ESMTP id 9A67D3F704C;
        Fri,  8 Apr 2022 07:38:59 -0700 (PDT)
Message-ID: <bc8d25ed-e65f-83b9-e21c-25150f9b8884@marvell.com>
Date:   Fri, 8 Apr 2022 16:38:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [EXT] [PATCH v2] net: atlantic: Avoid out-of-bounds indexing
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220408022204.16815-1-kai.heng.feng@canonical.com>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <20220408022204.16815-1-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: mfWi2QzyKu_I-GBIafCg-kQQTJG2eqDb
X-Proofpoint-ORIG-GUID: mfWi2QzyKu_I-GBIafCg-kQQTJG2eqDb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> UBSAN warnings are observed on atlantic driver:
> [ 294.432996] UBSAN: array-index-out-of-bounds in
> /build/linux-Qow4fL/linux-5.15.0/drivers/net/ethernet/aquantia/atlantic/aq
> _nic.c:484:48
> [ 294.433695] index 8 is out of range for type 'aq_vec_s *[8]'
> 
> The ring is dereferenced right before breaking out the loop, to prevent
> that from happening, only use the index in the loop to fix the issue.

Thanks,

Reviewed-by: Igor Russkikh <irusskikh@marvell.com>

Igor
