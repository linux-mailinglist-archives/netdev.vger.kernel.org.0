Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391114AF09C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiBIMDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiBIMDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:03:12 -0500
Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF00AC050CD8;
        Wed,  9 Feb 2022 03:37:41 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4.4WIx_1644406657;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V4.4WIx_1644406657)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 19:37:38 +0800
Date:   Wed, 9 Feb 2022 19:37:37 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v5 5/5] net/smc: Add global configure for auto
 fallback by netlink
Message-ID: <YgOngV93e8IYr8bv@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <f54ee9f30898b998edf8f07dabccc84efaa2ab8b.1644323503.git.alibuda@linux.alibaba.com>
 <YgOGg9Ud5N7LOOV6@TonyMac-Alibaba>
 <df2fa023-833d-e4a7-23b4-4f6427223ff5@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df2fa023-833d-e4a7-23b4-4f6427223ff5@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 05:53:18PM +0800, D. Wythe wrote:
> 
> 
> ÔÚ 2022/2/9 ÏÂÎç5:16, Tony Lu Ð´µÀ:
> > On Tue, Feb 08, 2022 at 08:53:13PM +0800, D. Wythe wrote:
> > > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > > 
> > > @@ -248,6 +248,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
> > >   		goto errattr;
> > >   	if (nla_put_u8(skb, SMC_NLA_SYS_IS_SMCR_V2, true))
> > >   		goto errattr;
> > > +	if (nla_put_u8(skb, SMC_NLA_SYS_AUTO_FALLBACK, smc_auto_fallback))
> > 
> > READ_ONCE(smc_auto_fallback) ?
> 
> 
> No READ_ONCE() will cause ?

Make sure that we read the current value.
 
> 
> > > +		goto errattr;
> > >   	smc_clc_get_hostname(&host);
> > >   	if (host) {
> > >   		memcpy(hostname, host, SMC_MAX_HOSTNAME_LEN);
> > > diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
> > > index f13ab06..a7de517 100644
> > > --- a/net/smc/smc_netlink.c
> > > +++ b/net/smc/smc_netlink.c
> > > @@ -111,6 +111,16 @@
> > >   		.flags = GENL_ADMIN_PERM,
> > >   		.doit = smc_nl_disable_seid,
> > >   	},
> > > +	{
> > > +		.cmd = SMC_NETLINK_ENABLE_AUTO_FALLBACK,
> > > +		.flags = GENL_ADMIN_PERM,
> > > +		.doit = smc_enable_auto_fallback,
> > > +	},
> > > +	{
> > > +		.cmd = SMC_NETLINK_DISABLE_AUTO_FALLBACK,
> > > +		.flags = GENL_ADMIN_PERM,
> > > +		.doit = smc_disable_auto_fallback,
> > > +	},
> > >   };
> > 
> > Consider adding the separated cmd to query the status of this config,
> > just as SEID does?
> > 
> > It is common to check this value after user-space setted. Combined with
> > sys_info maybe a little heavy in this scene.
> 
> 
> Add a independent dumpit is quite okay, but is there have really scenarios
> that access this value frequently? With more and more such switches in the
> future, is is necessary for us to repeat on each switch ? I do have a plan
> to put them unified within a NLA attributes, but I don't have much time yet.

Yes, I think spreading them make code clean, and we can keep ABI
compatibility if we have more than one interface. If we want to change
one knob, we can change itself functions and data structures. Also, it
makes userspace tools easy to maintainer. TCP's procfs, like /proc/net/netstat,
is a summary knob, but not easy to parse and extend. Given that we
choose modern netlink, we can avoid it from the beginning.

Thanks,
Tony Lu
