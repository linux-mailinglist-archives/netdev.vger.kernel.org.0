Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FFA5EE46D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbiI1SdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiI1SdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:33:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F567285D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:33:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 470A161F78
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86302C433D6;
        Wed, 28 Sep 2022 18:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664389982;
        bh=dMVFJL7CfkjUXAsEx3N0RtjWPYHxFdJ5OT4UbRw/Z/g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=N/dIvDNAS97050r1Ytd8QSHCJW60VzGoAb6UTkpGGouFbjevSHxn+F3NXKibAncy2
         ZREyqQrzBOgmxVD4EOi6b3agXPbSTtcWmQGKPADKKvORhUiQEom8+cwnUXbfdCA9Eu
         BAuAOhuIo5IVVtdvv73WuX/rFAjEYOwHznEvWPOJ9DWL/tcvOlD1LMeehnsy6S7rsP
         L/igH+ILHjYjtoVDVvPNob4utMTmnKskcXaKNhEK22aZIodJ33fLBHnIhueN1lPD0Q
         fe60eoKzKIB/zgkdWdxOtBRPPNQm75mwu/uZO1dmqvCPR8iqnyICW3R1FCJkTXYjMQ
         KJD0/pjRu6mxw==
Message-ID: <55fa5039-9273-3f5e-f911-f4baf1b01a4b@kernel.org>
Date:   Wed, 28 Sep 2022 12:33:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>
References: <20220923042000.602250-1-liuhangbin@gmail.com>
 <115c54d7-87fc-2c50-bc27-ad7cdb27bb2c@kernel.org>
 <YzPrjj0h0o0Imsvy@Laptop-X1>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <YzPrjj0h0o0Imsvy@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/22 11:37 PM, Hangbin Liu wrote:
> Hi David,
> 
> On Tue, Sep 27, 2022 at 09:12:35PM -0600, David Ahern wrote:
>>>  
>>> -	if (echo_request)
>>> -		ret = rtnl_talk(&rth, &req.n, &answer);
>>> -	else
>>> -		ret = rtnl_talk(&rth, &req.n, NULL);
>>> -
>>> -	if (ret < 0)
>>> -		return -2;
>>> -
>>> -	if (echo_request) {
>>> -		new_json_obj(json);
>>> -		open_json_object(NULL);
>>> -		print_addrinfo(answer, stdout);
>>> -		close_json_object();
>>> -		delete_json_obj();
>>> -		free(answer);
>>> -	}
>>> -
>>> -	return 0;
>>> +	return rtnl_echo_talk(&rth, &req.n, print_addrinfo);
>>
>> I was thinking something more like:
>>
>> if (echo_request)
>> 	return rtnl_echo_talk(&rth, &req.n, print_addrinfo);
>>
>> return rtnl_talk(&rth, &req.n, NULL);
> 
> OK, I will update the patch. I have one question about the return value.
> In previous code, the function return -2 if rtnl_talk() fails. I don't know
> why we use "-2" here. And you suggested to just return rtnl_talk() directly.
> 
> Does this means we can ignore the -2 return values for all the places safely,
> and just return rtnl_talk()?
> 

I do not recall why '-2'. Seems arbitrary to me.
