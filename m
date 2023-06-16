Return-Path: <netdev+bounces-11357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B4B732C2D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A4E1C20F9A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B9C16402;
	Fri, 16 Jun 2023 09:40:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6316117
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:40:46 +0000 (UTC)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6940B30D1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:40:44 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlFm5oV_1686908439;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VlFm5oV_1686908439)
          by smtp.aliyun-inc.com;
          Fri, 16 Jun 2023 17:40:40 +0800
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net v1] ipvlan: Fix return value of ipvlan_queue_xmit()
From: Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <ZIwnVEiGlLgD1qcG@corigine.com>
Date: Fri, 16 Jun 2023 17:40:29 +0800
Cc: netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>,
 Lu Wei <luwei32@huawei.com>,
 "t.feng" <fengtao40@huawei.com>,
 Xin Long <lucien.xin@gmail.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: 7bit
Message-Id: <6A7B6A47-7453-4D30-938E-B4AEC55906CE@linux.alibaba.com>
References: <20230616063436.28760-1-cambda@linux.alibaba.com>
 <ZIwnVEiGlLgD1qcG@corigine.com>
To: Simon Horman <simon.horman@corigine.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On Jun 16, 2023, at 17:11, Simon Horman <simon.horman@corigine.com> wrote:
> 
> On Fri, Jun 16, 2023 at 02:34:36PM +0800, Cambda Zhu wrote:
>> The ipvlan_queue_xmit() should return NET_XMIT_XXX,
>> but ipvlan_xmit_mode_l2/l3() returns rx_handler_result_t or NET_RX_XXX
>> in some cases. The skb to forward could be treated as xmitted
>> successfully.
>> 
>> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> 
> Hi Cambda Zhu,
> 
> ipvlan_rcv_frame can return two distinct values - RX_HANDLER_CONSUMED and
> RX_HANDLER_ANOTHER. Is it correct to treat these both as NET_XMIT_SUCCESS
> in the xmit path? If so, perhaps it would be useful to explain why
> in the commit message.

The ipvlan_rcv_frame() will only return RX_HANDLER_CONSUMED in
ipvlan_xmit_mode_l2/l3() for local is true. It's equal to NET_XMIT_SUCCESS.
The dev_forward_skb() can return NET_RX_SUCCESS and NET_RX_DROP, and
returning NET_RX_DROP(NET_XMIT_DROP) will increase both ipvlan and
ipvlan->phy_dev drops counter. I think the drops should belong to
the rcv side, and the xmit side should return NET_XMIT_SUCCESS even
if rcv failed. However, I'm not sure if my opinion is right.

Thanks,
Cambda

