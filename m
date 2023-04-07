Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7F76DAB18
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 11:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbjDGJux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 05:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDGJux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 05:50:53 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C43EE49E3;
        Fri,  7 Apr 2023 02:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=/kJ4A
        UDmXEp4Ayc+iiUJ24HqKxCAc5TmL1/CzOAZpjA=; b=H/ssTfAA4m3JynaCfLuHo
        aFTXecc1WHGXyMEFTIHJTV5+Y52CYXEVQg7KlzKUCBNHgiqGkCRWJJTlHOCqZMFd
        DhmQbZ+B7O02rncGBtBF/bPgAif7FllR/Sa7HtzC0qAFdbtG4Akbcc/K0vF3v7Eh
        FWng61N4viEBoBFzD/pclA=
Received: from localhost.localdomain (unknown [119.3.119.19])
        by zwqz-smtp-mta-g0-0 (Coremail) with SMTP id _____wC3qqDv5i9kTOwqAw--.27257S2;
        Fri, 07 Apr 2023 17:48:32 +0800 (CST)
From:   Chen Aotian <chenaotian2@163.com>
To:     miquel.raynal@bootlin.com
Cc:     alex.aring@gmail.com, chenaotian2@163.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefan@datenfreihafen.org
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leaks
Date:   Fri,  7 Apr 2023 17:48:20 +0800
Message-Id: <20230407094820.45798-1-chenaotian2@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230407100148.16a0531e@xps-13>
References: <20230407100148.16a0531e@xps-13>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wC3qqDv5i9kTOwqAw--.27257S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrWxXrWrXr1UKF4xKw1rWFg_yoW8Ary3pF
        Wjv3sIkF4Utr18WayDJw4rAa4SyayUWry8ur4fK3Z5Z3W2qrWxuFn7Gr1Fvr4YyrZFk3Wf
        ZF4qqr1a9wn8ArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UnAwxUUUUU=
X-Originating-IP: [119.3.119.19]
X-CM-SenderInfo: xfkh0tprwlt0qs6rljoofrz/1tbiShFKwGI0XrUdDgAAs-
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> miquel.raynal@bootlin.com wrote on Date: Fri, 7 Apr 2023 10:01:48 +0200:
> > chenaotian2@163.com wrote on Fri,  7 Apr 2023 09:26:26 +0800:

> > After replacing e->info, it is necessary to free the old einfo.
> > 
> > Signed-off-by: Chen Aotian <chenaotian2@163.com>
> > ---
> >  drivers/net/ieee802154/mac802154_hwsim.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> > index 8445c2189..6e7e10b17 100644
> > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > @@ -685,7 +685,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
> >  static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
> >  {
> >  	struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
> > -	struct hwsim_edge_info *einfo;
> > +	struct hwsim_edge_info *einfo, *einfo_old;
> >  	struct hwsim_phy *phy_v0;
> >  	struct hwsim_edge *e;
> >  	u32 v0, v1;
> > @@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
> >  	list_for_each_entry_rcu(e, &phy_v0->edges, list) {
> >  		if (e->endpoint->idx == v1) {
> >  			einfo->lqi = lqi;
> > +			einfo_old = rcu_dereference(e->info);
> >  			rcu_assign_pointer(e->info, einfo);
> >  			rcu_read_unlock();
> > +			kfree_rcu(einfo_old, rcu);
> >  			mutex_unlock(&hwsim_phys_lock);
> >  			return 0;
> >  		}
> 
> I'm not an RCU expert but the fix LGTM.

> What about adding:

> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Cc: stable@vger.kernelorg

Sure, I will resend this patch soon with adding those

Thanks,
Chen

