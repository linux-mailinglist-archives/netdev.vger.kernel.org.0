Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E9867C4E2
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233024AbjAZHaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjAZH2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:28:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF34617CDA;
        Wed, 25 Jan 2023 23:28:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F0CBB819AE;
        Thu, 26 Jan 2023 07:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386EBC433EF;
        Thu, 26 Jan 2023 07:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674718087;
        bh=FP9vuXTK892fNGc55uvufWHZKaEX/J0FjCpiBCeGi28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahanLAX1jHk2265b+uqA+hNuR4qWvgo2XQ8DgoPW1fhBpx3U/md7lhcB5uVvG2aBz
         ewBTvWBB0UFZvZQEs8a1Hox8blCimFkmeMveP+r3xVPULc68P7m3R/g6RI2OPtksIO
         oh5LM5BNVdd6OZoNY/gPsKVmW7WNU9IUpC7BzEDIpyKCcfwbVfdzhCmE4W58Z4L68P
         OGlEQpS1YmaKofixwlx3mHha+mbnTgXmsTPYx6s6BpCMruQsHKpn6z14eDmaEzh6AT
         0QVOSED+Vn1VjoIR1g34IvH+sQHOEc0o/wYxbs+zJDd4VuU+0JIKUNJRpzILAukx31
         9f2kVcePtzJcg==
Date:   Thu, 26 Jan 2023 09:28:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next v1 01/10] xfrm: extend add policy callback to
 set failure reason
Message-ID: <Y9Irgrgf3uxOjwUm@unreal>
References: <cover.1674560845.git.leon@kernel.org>
 <c182cae29914fa19ce970859e74234d3de506853.1674560845.git.leon@kernel.org>
 <20230125110226.66dc7eeb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125110226.66dc7eeb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 11:02:26AM -0800, Jakub Kicinski wrote:
> On Tue, 24 Jan 2023 13:54:57 +0200 Leon Romanovsky wrote:
> > -	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp);
> > +	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
> >  	if (err) {
> >  		xdo->dev = NULL;
> >  		xdo->real_dev = NULL;
> >  		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
> >  		xdo->dir = 0;
> >  		netdev_put(dev, &xdo->dev_tracker);
> > -		NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
> 
> In a handful of places we do:
> 
> if (!extack->msg)
> 	NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
> 
> in case the device did not provide the extack.
> Dunno if it's worth doing here.

Honestly, I followed devlink.c which didn't do that, but looked again
and found that devlink can potentially overwrite messages :)

For example in this case:
    997         err = ops->port_fn_state_get(port, &state, &opstate, extack);
    998         if (err) {
    999                 if (err == -EOPNOTSUPP)
   1000                         return 0;
   1001                 return err;
   1002         }
   1003         if (!devlink_port_fn_state_valid(state)) {
   1004                 WARN_ON_ONCE(1);
   1005                 NL_SET_ERR_MSG_MOD(extack, "Invalid state read from driver");
   1006                 return -EINVAL;
   1007         }


So what do you think about the following change, so we can leave
NL_SET_ERR_MSG_MOD() in devlink and xfrm intact? 

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 38f6334f408c..d6f3a958e30b 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -101,7 +101,7 @@ struct netlink_ext_ack {
                                                        \
        do_trace_netlink_extack(__msg);                 \
                                                        \
-       if (__extack)                                   \
+       if (__extack && !__extack->msg)                 \
                __extack->_msg = __msg;                 \
 } while (0)

@@ -111,7 +111,7 @@ struct netlink_ext_ack {
 #define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {                         \
        struct netlink_ext_ack *__extack = (extack);                           \
                                                                               \
-       if (!__extack)                                                         \
+       if (!__extack || __extack->msg)                                        \
                break;                                                         \
        if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,               \
                     "%s" fmt "%s", "", ##args, "") >=                         \


