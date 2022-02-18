Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B05C4BB06D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiBRD4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:56:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiBRD4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:56:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E3012757A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:56:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4B3B61DE1
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1FAC340E9;
        Fri, 18 Feb 2022 03:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645156567;
        bh=N4q9MeZTXVw0J4NL6oVYkINB6JFjIXGjgl5vdqtasXE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=l+hwR3HRiDbpWVUKBOOSQK7xSYvjfBGV3F8Kphg6Kgy3Kktjc3NiL8+myWrVzdmaL
         my0Wf+sXBrCncbV+Qm66k5EA+lqJEfyTZ1jLHgkp/Bx3bqq2s/tYJnWy6N52qSad80
         0uX9AaJ7WTHKPp6DkEv+mXqHAxqX+tWF1PFxDlm9I7896qRC1+MM+zrsFFLU+tQblT
         cKxIMBAh3j1KrMNdmegxJFFWYXhEfj+c93gQv/ETMitRABQJHnsWTZybE2a8iOYbKz
         CJl807IbQEoj2Y2hQjdYvJ3C7xOC0qJeDPD5ZJZQeUK4lDGtFA/faIe7AR8o9Jjuew
         ChBXbrBC+sdBg==
Message-ID: <9095c706-01f1-5b81-658a-a4288a864a0a@kernel.org>
Date:   Thu, 17 Feb 2022 20:56:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: Why vlan_dev can not follow real_dev mtu change from smaller to
 bigger
Content-Language: en-US
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pablo@netfilter.org, keescook@chromium.org, alobakin@pm.me,
        nbd@nbd.name, herbert@gondor.apana.org.au
References: <6ffd8030-28ff-396b-5f94-a2e9fd8ef9fd@huawei.com>
 <47003762-f5bc-6677-9fa1-8a3d6bc51ab3@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <47003762-f5bc-6677-9fa1-8a3d6bc51ab3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 11:44 PM, Ziyang Xuan (William) wrote:
>> Hello,
>>
>> Recently, I did some tests about mtu change for vlan device
>> and real_dev. I found that vlan_dev's mtu could not follow its
>> real_dev's mtu change from smaller to bigger.
>>
>> For example:
>> Firstly, change real_dev's mtu from 1500 to 256, vlan_dev's mtu
>> follow change from 1500 to 256.
>> Secondly, change real_dev's mtu from 256 to 1500, but vlan_dev's
>> mtu is still 256.
>>
>> I fond the code as following. But I could not understand the
>> limitations. Is there anyone can help me?
>>
>> static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>> 			     void *ptr)
>> {
>> 	...
>>
>> 	case NETDEV_CHANGEMTU:
>> 		vlan_group_for_each_dev(grp, i, vlandev) {
>> 			if (vlandev->mtu <= dev->mtu)
>> 				continue;
>>
>> 			dev_set_mtu(vlandev, dev->mtu);
>> 		}
>> 		break;
>> 	...
>> }
>>
>> Thank you for your reply.
>>
> commit: 2e477c9bd2bb ("vlan: Propagate physical MTU changes") wanted
> to ensure that all existing VLAN device MTUs do not exceed the new
> underlying MTU. Make VLAN device MTUs equal to the new underlying MTU
> follow this rule. So I think the following modification is reasonable
> and can solve the above problem.
> 
> @@ -418,12 +418,8 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>                 break;
> 
>         case NETDEV_CHANGEMTU:
> -               vlan_group_for_each_dev(grp, i, vlandev) {
> -                       if (vlandev->mtu <= dev->mtu)
> -                               continue;
> -
> +               vlan_group_for_each_dev(grp, i, vlandev)
>                         dev_set_mtu(vlandev, dev->mtu);
> -               }
>                 break;
> 

vlans must work within the mtu of the underlying device, so shrinking
the mtu of the vlan device when the real device changes is appropriate.

vlan devices do not necessarily have to operate at the same mtu as the
real device, so when the real device mtu is increased it might not be
appropriate to raise the mtu of the vlan devices. Admin needs to manage
that.
