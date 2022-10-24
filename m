Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4460E60A07A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 13:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiJXLUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 07:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiJXLUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 07:20:13 -0400
Received: from out199-14.us.a.mail.aliyun.com (out199-14.us.a.mail.aliyun.com [47.90.199.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B79913CFF
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:20:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VSyP9LL_1666610403;
Received: from 30.221.147.11(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VSyP9LL_1666610403)
          by smtp.aliyun-inc.com;
          Mon, 24 Oct 2022 19:20:04 +0800
Message-ID: <089cff2e-b113-0603-d751-9ca0ad998553@linux.alibaba.com>
Date:   Mon, 24 Oct 2022 19:20:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:106.0)
 Gecko/20100101 Thunderbird/106.0
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
 <87wn9proty.fsf@toke.dk>
 <f760701a-fb9d-11e5-f555-ebcf773922c3@linux.alibaba.com>
 <87v8p7r1f2.fsf@toke.dk>
 <189b8159-c05f-1730-93f3-365999755f72@linux.alibaba.com>
 <567d3635f6e7969c4e1a0e4bc759556c472d1dff.camel@redhat.com>
 <c1831b89-c896-80c3-7258-01bcf2defcbc@linux.alibaba.com>
 <87o7uymlh5.fsf@toke.dk>
 <c128d468-0c87-8759-e7de-b482abf8aab6@linux.alibaba.com>
 <87bkq6v4hn.fsf@toke.dk>
 <3a9b641a-f84d-92e0-a416-43bbde26f866@linux.alibaba.com>
In-Reply-To: <3a9b641a-f84d-92e0-a416-43bbde26f866@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/10/21 下午2:31, Heng Qi 写道:
>
>
> 在 2022/10/21 上午12:34, Toke Høiland-Jørgensen 写道:
>> Heng Qi <hengqi@linux.alibaba.com> writes:
>>
>>> maybe we should consider a simpler method: when loading xdp in veth,
>>> we can automatically enable the napi ring of peer veth, which seems to
>>> have no performance impact and functional impact on the veth pair, and
>>> no longer requires users to do more things for peer veth (after all,
>>> they may be unaware of more requirements for peer veth). Do you think
>>> this is feasible?
>> It could be, perhaps? One issue is what to do once the XDP program is
>> then unloaded? We should probably disable NAPI on the peer in this case,
>> but then we'd need to track whether it was enabled by loading an XDP
>> program; we don't want to disable GRO/NAPI if the user requested it
>> explicitly. This kind of state tracking gets icky fast, so I guess it'll
>> depend on the patch...
>
> Regarding tracking whether we disable the napi of peer veth when 
> unloading
> the veth's xdp program, this can actually be handled cleanly.
>
> We need to note that when peer veth enable GRO, the peer veth device will
> update the `dev->wanted_features` with NETIF_F_GRO of peer veth (refer to
> __netdev_update_features() and veth_set_features() ).
>
> When veth loads the xdp program and the napi of peer veth is not ready
> (that is, peer veth does not load the xdp program or has no enable gro),
> at this time, we can choose `ethtool -K veth0 gro on` to enable the 
> napi of
> peer veth, this command also makes the peer veth device update their
> wanted_features, or choose we automatically enable napi for peer veth.
>
> If we want to unload the xdp program for veth, peer veth cannot directly
> disable its napi, because we need to judge whether peer veth is 
> gro_requested
> ( ref to veth_gro_requested() ) or has its priv->_xdp_prog, if so, just
> clean veth's xdp environment and disable the napi of veth instead of
> directly disable the napi of peer veth, because of the existence of the
> gro_requested and the xdp program loading on peer veth.
>
> But, if peer veth does not have gro_requested or xdp_program loading 
> on itself,
> then we can directly disable the napi of peer veth.

Hi, Toke. Do you think the above solution is effective for the problem 
of veth
xdp_rediect dropping packets? Or is there more to add? If the above solution
seems to be no problem for the time being, I'm ready to start with this idea
and try to make the corresponding patch.

Thanks.

>
> Thanks.
>
>> -Toke
>

