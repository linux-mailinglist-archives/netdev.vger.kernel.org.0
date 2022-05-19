Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447AA52D937
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiESPun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241699AbiESPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:50:14 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED42996A6;
        Thu, 19 May 2022 08:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1652975329; x=1684511329;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K+X0c3bbcUNzQpy8lCHb3Na26UYRbDdUTe8o7LeQPZA=;
  b=V8uDYyxR/Hz5Y3L+gArcDCfPsIqLl6KXIWpxLThumOR1iatnwoJ/TW2b
   75N4m+bntLF18H3/OC5IoSIadDMx/gnjRFV5G3ZElA6ZkMpwIfcoeKnAH
   ET/K6AOVxcrmMyFQBc+c96EGQHJDS9NzFi3Ef+jW2/lSlReDoSsTcHXZJ
   k=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 19 May 2022 08:48:47 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 08:48:47 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 19 May 2022 08:48:46 -0700
Received: from [10.110.66.23] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 19 May
 2022 08:48:45 -0700
Message-ID: <18852332-ee42-ef7e-67a3-bbd91a6694ba@quicinc.com>
Date:   Thu, 19 May 2022 08:48:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net v2] net: wireless: marvell: mwifiex: fix sleep in
 atomic context bugs
Content-Language: en-US
To:     <duoming@zju.edu.cn>, Kalle Valo <kvalo@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <amitkarwar@gmail.com>,
        <ganapathi017@gmail.com>, <sharvari.harisangam@nxp.com>,
        <huxinming820@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20220519135345.109936-1-duoming@zju.edu.cn>
 <87zgjd1sd4.fsf@kernel.org>
 <699e56d5.22006.180dce26e02.Coremail.duoming@zju.edu.cn>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <699e56d5.22006.180dce26e02.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/2022 8:14 AM, duoming@zju.edu.cn wrote:
> Hello,
> 
> On Thu, 19 May 2022 17:58:47 +0300 Kalle Valo wrote:
> 
>>> There are sleep in atomic context bugs when uploading device dump
>>> data on usb interface. The root cause is that the operations that
>>> may sleep are called in fw_dump_timer_fn which is a timer handler.
>>> The call tree shows the execution paths that could lead to bugs:
>>>
>>>     (Interrupt context)
>>> fw_dump_timer_fn
>>>    mwifiex_upload_device_dump
>>>      dev_coredumpv(..., GFP_KERNEL)

just looking at this description, why isn't the simple fix just to 
change this call to use GFP_ATOMIC?
