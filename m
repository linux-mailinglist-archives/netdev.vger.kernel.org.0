Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DCC60701D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 08:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiJUGbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 02:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJUGbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 02:31:21 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134E819A211
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 23:31:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VSiCvao_1666333868;
Received: from 30.221.148.62(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VSiCvao_1666333868)
          by smtp.aliyun-inc.com;
          Fri, 21 Oct 2022 14:31:09 +0800
Message-ID: <3a9b641a-f84d-92e0-a416-43bbde26f866@linux.alibaba.com>
Date:   Fri, 21 Oct 2022 14:31:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:106.0)
 Gecko/20100101 Thunderbird/106.0
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
From:   Heng Qi <hengqi@linux.alibaba.com>
In-Reply-To: <87bkq6v4hn.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/10/21 上午12:34, Toke Høiland-Jørgensen 写道:
> Heng Qi <hengqi@linux.alibaba.com> writes:
>
>> maybe we should consider a simpler method: when loading xdp in veth,
>> we can automatically enable the napi ring of peer veth, which seems to
>> have no performance impact and functional impact on the veth pair, and
>> no longer requires users to do more things for peer veth (after all,
>> they may be unaware of more requirements for peer veth). Do you think
>> this is feasible?
> It could be, perhaps? One issue is what to do once the XDP program is
> then unloaded? We should probably disable NAPI on the peer in this case,
> but then we'd need to track whether it was enabled by loading an XDP
> program; we don't want to disable GRO/NAPI if the user requested it
> explicitly. This kind of state tracking gets icky fast, so I guess it'll
> depend on the patch...

Regarding tracking whether we disable the napi of peer veth when unloading
the veth's xdp program, this can actually be handled cleanly.

We need to note that when peer veth enable GRO, the peer veth device will
update the `dev->wanted_features` with NETIF_F_GRO of peer veth (refer to
__netdev_update_features() and veth_set_features() ).

When veth loads the xdp program and the napi of peer veth is not ready
(that is, peer veth does not load the xdp program or has no enable gro),
at this time, we can choose `ethtool -K veth0 gro on` to enable the napi of
peer veth, this command also makes the peer veth device update their
wanted_features, or choose we automatically enable napi for peer veth.

If we want to unload the xdp program for veth, peer veth cannot directly
disable its napi, because we need to judge whether peer veth is gro_requested
( ref to veth_gro_requested() ) or has its priv->_xdp_prog, if so, just
clean veth's xdp environment and disable the napi of veth instead of
directly disable the napi of peer veth, because of the existence of the
gro_requested and the xdp program loading on peer veth.

But, if peer veth does not have gro_requested or xdp_program loading on itself,
then we can directly disable the napi of peer veth.

Thanks.

> -Toke

