Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9681662F741
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242294AbiKRO0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241141AbiKRO0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:26:19 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10055A6DC;
        Fri, 18 Nov 2022 06:26:16 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VV5iyo6_1668781573;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VV5iyo6_1668781573)
          by smtp.aliyun-inc.com;
          Fri, 18 Nov 2022 22:26:14 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] veth: fix double napi enable
Date:   Fri, 18 Nov 2022 22:24:51 +0800
Message-Id: <20221118142451.66472-1-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <b90034c61b939d18cd7a201c547fb7ddffc91231.1668727939.git.pabeni@redhat.com>
References: <b90034c61b939d18cd7a201c547fb7ddffc91231.1668727939.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> While investigating a related issue I stumbled upon another
> oops, reproducible as the follow:
>
> ip link add type veth
> ip link set dev veth0 xdp object <obj>
> ip link set dev veth0 up
> ip link set dev veth1 up
>
> The first link up command will enable the napi instances on
> veth1 and the second link up common will try again the same
> operation, causing the oops.
>
> This change addresses the issue explicitly checking the peer
> is up before enabling its napi instances.
>
> Fixes: 2e0de6366ac1 ("veth: Avoid drop packets when xdp_redirect performs")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/veth.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 1384134f7100..d541183e0c66 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1343,7 +1343,8 @@ static int veth_open(struct net_device *dev)
> 		if (err)
>  			return err;
>  		/* refer to the logic in veth_xdp_set() */
> -		if (!rtnl_dereference(peer_rq->napi)) {
> +		if (!rtnl_dereference(peer_rq->napi) &&
> +		    (peer->flags & IFF_UP)) {
>  			err = veth_napi_enable(peer);
>  			if (err)
>  				return err;

I have checked the conditions related to enabling and disabling napi for
veth pair. In general, we should check whether napi is disabled before
enabling it, and check whether napi is enabled before disabling it. I am
sorry that my previous test cases didn't do better, and we can work
completely with your patchset. As the your patch in link below does
https://lore.kernel.org/all/c59f4adcdd1296ee37cc6bca4d927b8c79158909.1668727939.git.pabeni@redhat.com/

Is this patch more uniform like the following:

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1348,7 +1348,8 @@ static int veth_open(struct net_device *dev)
                        if (err)
                                return err;
                }
-       } else if (veth_gro_requested(dev) || peer_priv->_xdp_prog) {
+       } else if ((veth_gro_requested(dev) || peer_priv->_xdp_prog) &&
+                   !rtnl_dereference(priv->rq[0].napi)) {
                err = veth_napi_enable(dev);
                if (err)
                        return err;

Thanks.
