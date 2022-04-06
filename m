Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DB84F691C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 20:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbiDFSTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 14:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241268AbiDFSSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 14:18:32 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D58D1877E5;
        Wed,  6 Apr 2022 10:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1649264554; x=1680800554;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zCm35dqJeIsDGwuyLVEnPyr0Q2EEi3+4jjs5g8wcZjU=;
  b=a9yGXzAXrrEvTK3brLkFa/vFFy1K1VLtfMW+E4W5rxFQY5cHkDARwA09
   SLnp/h7nXqMMCYfGrvnzSAO2qo9s0jG/y5pSND6cJnyJzv/y8/RabKSRx
   Hg/FHpK//3P5Hgc2Lzj3bbg4qyetQgWOCYBPJ4RDTjdfh71eogOAX7Gvw
   I=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 06 Apr 2022 10:02:34 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 10:02:33 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 6 Apr 2022 10:02:33 -0700
Received: from [10.110.72.142] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 10:02:32 -0700
Message-ID: <fb02ab86-4c7f-8303-621d-349ac8c25546@quicinc.com>
Date:   Wed, 6 Apr 2022 10:02:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] cw1200: fix incorrect check to determine if no element
 is found in list
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
CC:     <pizza@shaftnet.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jakobkoschel@gmail.com>
References: <20220320035436.11293-1-xiam0nd.tong@gmail.com>
 <164924475461.19026.8095141212129340061.kvalo@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <164924475461.19026.8095141212129340061.kvalo@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/2022 4:32 AM, Kalle Valo wrote:
> Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> 
>> The bug is here: "} else if (item) {".
>>
>> The list iterator value will *always* be set and non-NULL by
>> list_for_each_entry(), so it is incorrect to assume that the iterator
>> value will be NULL if the list is empty or no element is found in list.
>>
>> Use a new value 'iter' as the list iterator, while use the old value
>> 'item' as a dedicated pointer to point to the found element, which
>> 1. can fix this bug, due to now 'item' is NULL only if it's not found.
>> 2. do not need to change all the uses of 'item' after the loop.
>> 3. can also limit the scope of the list iterator 'iter' *only inside*
>>     the traversal loop by simply declaring 'iter' inside the loop in the
>>     future, as usage of the iterator outside of the list_for_each_entry
>>     is considered harmful. https://lkml.org/lkml/2022/2/17/1032
>>
>> Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
>> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> 
> Can someone review this, please?
> 

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

