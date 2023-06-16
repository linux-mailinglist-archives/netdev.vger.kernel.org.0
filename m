Return-Path: <netdev+bounces-11348-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B59A732B05
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49DD81C20E92
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAB1D520;
	Fri, 16 Jun 2023 09:05:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E443D30F
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:05:56 +0000 (UTC)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B73049EC
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:05:50 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VlFXCIA_1686906345;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VlFXCIA_1686906345)
          by smtp.aliyun-inc.com;
          Fri, 16 Jun 2023 17:05:46 +0800
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net] ipvlan: Fix return value of ipvlan_queue_xmit()
From: Cambda Zhu <cambda@linux.alibaba.com>
In-Reply-To: <CANn89iKDceTf_fgpmyv9Dq+1_kVb3zAnSdmnRxZ_5E+xjkjJCQ@mail.gmail.com>
Date: Fri, 16 Jun 2023 17:05:35 +0800
Cc: Mahesh Bandewar <maheshb@google.com>,
 netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <30061768-8B85-4E10-AEEC-1A8D4C09D626@linux.alibaba.com>
References: <20230616033317.26635-1-cambda@linux.alibaba.com>
 <CANn89iKDceTf_fgpmyv9Dq+1_kVb3zAnSdmnRxZ_5E+xjkjJCQ@mail.gmail.com>
To: Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On Jun 16, 2023, at 16:05, Eric Dumazet <edumazet@google.com> wrote:
>=20
> On Fri, Jun 16, 2023 at 5:34=E2=80=AFAM Cambda Zhu =
<cambda@linux.alibaba.com> wrote:
>>=20
>> The ipvlan_queue_xmit() should return NET_XMIT_XXX,
>> but ipvlan_xmit_mode_l2/l3() returns rx_handler_result_t or =
NET_RX_XXX
>> in some cases. The skb to forward could be treated as xmitted
>> successfully.
>>=20
>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>=20
> Please make sure to CC ipvlan author ?
>=20
> CC Mahesh
>=20
>> ---
>> drivers/net/ipvlan/ipvlan_core.c | 9 ++++++---
>> 1 file changed, 6 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/net/ipvlan/ipvlan_core.c =
b/drivers/net/ipvlan/ipvlan_core.c
>> index ab5133eb1d51..e45817caaee8 100644
>> --- a/drivers/net/ipvlan/ipvlan_core.c
>> +++ b/drivers/net/ipvlan/ipvlan_core.c
>> @@ -585,7 +585,8 @@ static int ipvlan_xmit_mode_l3(struct sk_buff =
*skb, struct net_device *dev)
>>                                consume_skb(skb);
>>                                return NET_XMIT_DROP;
>>                        }
>> -                       return ipvlan_rcv_frame(addr, &skb, true);
>> +                       ipvlan_rcv_frame(addr, &skb, true);
>> +                       return NET_XMIT_SUCCESS;
>>                }
>>        }
>> out:
>> @@ -611,7 +612,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff =
*skb, struct net_device *dev)
>>                                        consume_skb(skb);
>>                                        return NET_XMIT_DROP;
>>                                }
>> -                               return ipvlan_rcv_frame(addr, &skb, =
true);
>> +                               ipvlan_rcv_frame(addr, &skb, true);
>> +                               return NET_XMIT_SUCCESS;
>>                        }
>>                }
>>                skb =3D skb_share_check(skb, GFP_ATOMIC);
>> @@ -623,7 +625,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff =
*skb, struct net_device *dev)
>>                 * the skb for the main-dev. At the RX side we just =
return
>>                 * RX_PASS for it to be processed further on the =
stack.
>>                 */
>> -               return dev_forward_skb(ipvlan->phy_dev, skb);
>> +               dev_forward_skb(ipvlan->phy_dev, skb);
>> +               return NET_XMIT_SUCCESS;
>>=20
>>        } else if (is_multicast_ether_addr(eth->h_dest)) {
>>                skb_reset_mac_header(skb);
>> --
>> 2.16.6

I have resubmitted v1 patch with Fixes tag and CC Mahesh via reply.

Thanks!
Cambda


