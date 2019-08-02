Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A505A8031B
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 01:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392585AbfHBXTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 19:19:51 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:43518 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389210AbfHBXTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 19:19:51 -0400
Received: from [192.168.1.4] (unknown [222.68.27.146])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7129E41620;
        Sat,  3 Aug 2019 07:19:45 +0800 (CST)
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
 <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
 <20190801161129.25fee619@cakuba.netronome.com>
 <bac5c6a5-8a1b-ee74-988b-6c2a71885761@ucloud.cn>
 <55850b13-991f-97bd-b452-efacd0f39aa4@ucloud.cn>
 <20190802110216.5e1fd938@cakuba.netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <45660f1e-b6a8-1bcb-0d57-7c1790d3fbaf@ucloud.cn>
Date:   Sat, 3 Aug 2019 07:19:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802110216.5e1fd938@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTUhCS0tLS05DSkxPSkhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDo6PAw*Qzg9Ik4ODE4TDhEU
        NzJPCTxVSlVKTk1PTENMQkNOTE9CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUlJSVVN
        Q1VJTFVKT01ZV1kIAVlBSEJJQzcG
X-HM-Tid: 0a6c54a1cd1a2086kuqy7129e41620
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/8/3 2:02, Jakub Kicinski 写道:
> On Fri, 2 Aug 2019 21:09:03 +0800, wenxu wrote:
>>>> We'd have something like the loop in flow_get_default_block():
>>>>
>>>> 	for each (subsystem)
>>>> 		subsystem->handle_new_indir_cb(indr_dev, cb);
>>>>
>>>> And then per-subsystem logic would actually call the cb. Or:
>>>>
>>>> 	for each (subsystem)
>>>> 		block = get_default_block(indir_dev)
>>>> 		indr_dev->ing_cmd_cb(...)  
>>>             nft dev chian is also based on register_netdevice_notifier, So for unregister case,
>>>
>>> the basechian(block) of nft maybe delete before the __tc_indr_block_cb_unregister. is right?
>>>
>>> So maybe we can cache the block as a list of all the subsystem in  indr_dev ?  
>>
>> when the device is unregister the nft netdev chain related to this device will also be delete through netdevice_notifier
>>
>> . So for unregister case,the basechian(block) of nft maybe delete before the __tc_indr_block_cb_unregister.
> Hm, but I don't think that should be an issue. The ordering should be
> like one of the following two:
>
> device unregister:
>   - driver notifier callback
>     - unregister flow cb
>       - UNBIND cb
>         - free driver's block state
>     - free driver's device state
>   - nft block destroy
>     # doesn't see driver's CB any more
>
> Or:
>
> device unregister:
>   - nft block destroy
>     - UNBIND cb
>       - free driver's block state
>   - driver notifier callback
>     - free driver's state
>
> No?

For the second case maybe can't unbind cb? because the nft block is destroied. There is no way

to find the block(chain) in nft.


>
>> cache for the block is not work because the chain already be delete and free. Maybe it improve the prio of
>>
>> rep_netdev_event can help this?
> In theory the cache should work in a similar way as drivers, because
> once the indr_dev is created and the initial block is found, the cached
> value is just recorded in BIND/UNBIND calls. So if BIND/UNBIND works for
> drivers it will also put the right info in the cache.
>
