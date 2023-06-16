Return-Path: <netdev+bounces-11347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F2B732AEF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E83E28133F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C1BD519;
	Fri, 16 Jun 2023 09:03:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7BC63D5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:03:55 +0000 (UTC)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35123A9C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:03:45 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VlFXB4._1686906221;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VlFXB4._1686906221)
          by smtp.aliyun-inc.com;
          Fri, 16 Jun 2023 17:03:42 +0800
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
In-Reply-To: <20230616063436.28760-1-cambda@linux.alibaba.com>
Date: Fri, 16 Jun 2023 17:03:28 +0800
Cc: Eric Dumazet <edumazet@google.com>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <3ED53D84-CD06-49F5-A522-DDBE64F7EE8B@linux.alibaba.com>
References: <20230616063436.28760-1-cambda@linux.alibaba.com>
To: netdev@vger.kernel.org,
 Mahesh Bandewar <maheshb@google.com>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On Jun 16, 2023, at 14:34, Cambda Zhu <cambda@linux.alibaba.com> =
wrote:
>=20
> The ipvlan_queue_xmit() should return NET_XMIT_XXX,
> but ipvlan_xmit_mode_l2/l3() returns rx_handler_result_t or NET_RX_XXX
> in some cases. The skb to forward could be treated as xmitted
> successfully.
>=20
> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> ---
> v1:
> - Add Fixes tag.
> ---
> drivers/net/ipvlan/ipvlan_core.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ipvlan/ipvlan_core.c =
b/drivers/net/ipvlan/ipvlan_core.c
> index ab5133eb1d51..e45817caaee8 100644
> --- a/drivers/net/ipvlan/ipvlan_core.c
> +++ b/drivers/net/ipvlan/ipvlan_core.c
> @@ -585,7 +585,8 @@ static int ipvlan_xmit_mode_l3(struct sk_buff =
*skb, struct net_device *dev)
> consume_skb(skb);
> return NET_XMIT_DROP;
> }
> - return ipvlan_rcv_frame(addr, &skb, true);
> + ipvlan_rcv_frame(addr, &skb, true);
> + return NET_XMIT_SUCCESS;
> }
> }
> out:
> @@ -611,7 +612,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff =
*skb, struct net_device *dev)
> consume_skb(skb);
> return NET_XMIT_DROP;
> }
> - return ipvlan_rcv_frame(addr, &skb, true);
> + ipvlan_rcv_frame(addr, &skb, true);
> + return NET_XMIT_SUCCESS;
> }
> }
> skb =3D skb_share_check(skb, GFP_ATOMIC);
> @@ -623,7 +625,8 @@ static int ipvlan_xmit_mode_l2(struct sk_buff =
*skb, struct net_device *dev)
> * the skb for the main-dev. At the RX side we just return
> * RX_PASS for it to be processed further on the stack.
> */
> - return dev_forward_skb(ipvlan->phy_dev, skb);
> + dev_forward_skb(ipvlan->phy_dev, skb);
> + return NET_XMIT_SUCCESS;
>=20
> } else if (is_multicast_ether_addr(eth->h_dest)) {
> skb_reset_mac_header(skb);
> --=20
> 2.16.6

Add CC Mahesh.


