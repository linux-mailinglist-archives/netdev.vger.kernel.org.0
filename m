Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04804E3FB7
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 14:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiCVNmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 09:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiCVNmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 09:42:23 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D245BBE12;
        Tue, 22 Mar 2022 06:40:55 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 22MDemPm052496;
        Tue, 22 Mar 2022 08:40:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1647956448;
        bh=5hLLpwxsp52IRim8ibcb7alxLGLTEl2Qjp29Nl5HWSg=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=KynNgZ54UsEQ6DDAHePynTL+07QbRto5/QihoyMUiNd/b8hdSWd74yEZICZIDBGuH
         55T2HvH8FfTTZ4xW5NG1Wp2488CG1wX4cLzcW8gvjYAzdWFX2XbIpIXiY3W1NlE8J0
         dNAAuhZzXFnF7+DaY2OasDcv4PdKJnPbjhRCvpyw=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 22MDemEK116895
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Mar 2022 08:40:48 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 22
 Mar 2022 08:40:47 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 22 Mar 2022 08:40:48 -0500
Received: from [10.250.235.115] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 22MDejHO050865;
        Tue, 22 Mar 2022 08:40:46 -0500
Message-ID: <d1fab209-b215-d254-d98b-4ad0ab26b1b0@ti.com>
Date:   Tue, 22 Mar 2022 19:10:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: ethernet: cpsw: fix panic when interrupt
 coaleceing is set via ethtool
Content-Language: en-US
To:     =?UTF-8?Q?Sondhau=c3=9f=2c_Jan?= <Jan.Sondhauss@wago.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220322063221.28132-1-jan.sondhauss@wago.com>
 <d3fac0ae-6d5c-33d7-4e1e-da9058ef525f@ti.com>
 <dd897805-38a9-b1e7-b1cf-707aa3de1afb@wago.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
In-Reply-To: <dd897805-38a9-b1e7-b1cf-707aa3de1afb@wago.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/03/22 5:50 pm, Sondhauß, Jan wrote:
> Hi
> 
> On 22/03/2022 11:34, Vignesh Raghavendra wrote:
>> Hi, Adding netdev list and maintainers Please cc netdev ML and net 
>> maintainers ./scripts/get_maintainer.pl -f 
>> drivers/net/ethernet/ti/cpsw_ethtool.c On 22/03/22 12:02 pm, Sondhauß, 
>> Jan wrote: > cpsw_ethtool uses the power management in the 
>> ZjQcmQRYFpfptBannerStart
>> This Message Is From an External Sender
>> Please use caution when clicking on links or opening attachments!
>> ZjQcmQRYFpfptBannerEnd
>>
>> Hi,
>>
>> Adding netdev list and maintainers
>>
>> Please cc netdev ML and net maintainers
>>
>> ./scripts/get_maintainer.pl -f drivers/net/ethernet/ti/cpsw_ethtool.c
>>
>> On 22/03/22 12:02 pm, Sondhauß, Jan wrote:
>>> cpsw_ethtool uses the power management in the begin and complete
>>> functions of the ethtool_ops. The result of pm_runtime_get_sync was
>>> returned unconditionally, which results in problems since the ethtool-
>>> interface relies on 0 for success and negativ values for errors.
>>> d43c65b05b84 (ethtool: runtime-resume netdev parent in ethnl_ops_begin)
>>> introduced power management to the netlink implementation for the
>>> ethtool interface and does not explicitly check for negative return
>>> values.
>>>
>>> As a result the pm_runtime_suspend function is called one-too-many
>>> times in ethnl_ops_begin and that leads to an access violation when
>>> the cpsw hardware is accessed after using
>>> 'ethtool -C eth-of-cpsw rx-usecs 1234'. To fix this the call to
>>> pm_runtime_get_sync in cpsw_ethtool_op_begin is replaced with a call
>>> to pm_runtime_resume_and_get as it provides a returnable error-code.
>>>
>>
>> pm_runtime_resume_and_get() is just wrapper around pm_runtime_get_sync()
>> + error handling (as done in the below code) and both return 0 on
>> success and -ve error code on failure
> 
> pm_runtime_get_sync returns -ve error code on failure and 0 on success 
> and also 1 is returned if nothing has to be done besides increment of 
> the usage counter.
> So for active devices that don't need to be resumed a 1 is returned.
> pm_runtime_resume_and_get is a return-friendly wrapper that returns 
> -error code on failure but returns 0 on both other cases.
> 

I think this is a better explanation than the original commit message,
but see below

>>
>>
>>> Signed-off-by: Jan Sondhauss <jan.sondhauss@wago.com>
>>> ---
>>>  drivers/net/ethernet/ti/cpsw_ethtool.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
>>> index 158c8d3793f4..5eda20039cc1 100644
>>> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
>>> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
>>> @@ -364,7 +364,7 @@ int cpsw_ethtool_op_begin(struct net_device *ndev)
>>>  	struct cpsw_common *cpsw = priv->cpsw;
>>>  	int ret;
>>>  
>>> -	ret = pm_runtime_get_sync(cpsw->dev);
>>> +	ret = pm_runtime_resume_and_get(cpsw->dev)>  	if (ret < 0) {
>>>  		cpsw_err(priv, drv, "ethtool begin failed %d\n", ret);
>>>  		pm_runtime_put_noidle(cpsw->dev);
>>
>>
>> In fact code now ends up calling pm_runtime_put_noidle() twice in case
>> of failure, once inside pm_runtime_resume_and_get() and again here?
>>
>> So something looks fishy?
> 
> Sort of. There is no actual failure but pm_runtime_put is still called 
> twice. That is due to
> 	1. cpsw_ethtool_op_begin returning 1 when it should return 0
> 	2. ethnl_ops_begin treating values not equal to 0 as failure
> 	3. coalesce_prepare_data only treating negative values as failure
> 
> The patch addresses 1.
> 
> In net/ethtool/netlink.c:33 ethnl_ops_begin() the cpsw_ethtool_op_begin 
> is called (returning 1) and in the error path of ethnl_ops_begin a 
> pm_runtime_put is called. The function calling ethnl_ops_begin only 
> checks for negative values: net/ethtool/coalesce.c:60 
> coalesce_prepare_data and continues the sucess path calling 
> ethnl_ops_complete. ethnl_ops_complete also calls pm_runtime_put. So the 
> success path of coalesce_prepare_data and the error path of 
> ethnl_ops_begin both end up calling pm_runtime_put when only one of them 
> should.
> 

Thanks for the explanation!

Sorry, But what about the error case (ie ret < 0) With this patch, don't
we end up calling pm_runtime_put_noidle() twice (once inside
pm_runtime_resume_and_get() and again in cpsw_ethtool_op_begin()). How
is that okay?


Regards
Vignesh
