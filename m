Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F396DB939
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 08:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDHGpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 02:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDHGpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 02:45:46 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 564FF9030;
        Fri,  7 Apr 2023 23:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
        Content-Type; bh=D47zQmPvODBH5tr4rjq2FYpqkSG5BmR5CICEGe/y1pM=;
        b=mG4Bc/orqtPCIe0SajihSHXMh3uUk9IeT4UDL4ZGh1K45oyd+JtN/9fO28HVuL
        qp20ETAihgEI2qgvmjgCHNW/ViG0Uh3Oetb2E3Xo3EiKZYr4I+E6q/qOFs5ye8mW
        mzZr3qMDSuriGE2lcr4hyKgw30hmGPgdcXElpJKVyQ6gM=
Received: from localhost.localdomain (unknown [106.39.149.90])
        by zwqz-smtp-mta-g5-4 (Coremail) with SMTP id _____wCHarweDTFkTmiQAw--.53636S2;
        Sat, 08 Apr 2023 14:43:42 +0800 (CST)
From:   Chen Aotian <chenaotian2@163.com>
To:     aahringo@redhat.com, miquel.raynal@bootlin.com
Cc:     alex.aring@gmail.com, chenaotian2@163.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stable@vger.kernel.org,
        stefan@datenfreihafen.org
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leaks
Date:   Sat,  8 Apr 2023 14:43:31 +0800
Message-Id: <20230408064331.46176-1-chenaotian2@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAK-6q+gpRPxquCSCfPB+9Ym+1PTu9Z+qzC+PHj_K94nSGUbTWA@mail.gmail.com>
References: <CAK-6q+gpRPxquCSCfPB+9Ym+1PTu9Z+qzC+PHj_K94nSGUbTWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCHarweDTFkTmiQAw--.53636S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KrWDJryrtFW8Aw43WF1DGFg_yoW8Ar15pF
        WjvasIkF48tr18WayDXw4rA34Sva1fWry8ur1fK3ZY9F12qrW8uF17G3WSvF4FyrZru3Wf
        ZF4qqr1avwn8CrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U489NUUUUU=
X-Originating-IP: [106.39.149.90]
X-CM-SenderInfo: xfkh0tprwlt0qs6rljoofrz/xtbCggdLwGD-z8JIegAAsu
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, 7 Apr 2023 18:20:32 -0400 Alexander Aring <aahringo@redhat.com> wrote:
>
> On Fri, Apr 7, 2023 at 5:55 AM Chen Aotian <chenaotian2@163.com> wrote:
> >
> > After replacing e->info, it is necessary to free the old einfo.
> >
> > Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
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
> >         struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
> > -       struct hwsim_edge_info *einfo;
> > +       struct hwsim_edge_info *einfo, *einfo_old;
> >         struct hwsim_phy *phy_v0;
> >         struct hwsim_edge *e;
> >         u32 v0, v1;
> > @@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
> >         list_for_each_entry_rcu(e, &phy_v0->edges, list) {
> >                 if (e->endpoint->idx == v1) {
> >                         einfo->lqi = lqi;
> > +                       einfo_old = rcu_dereference(e->info);
> >                         rcu_assign_pointer(e->info, einfo);
> 
> nitpick rcu_replace_pointer() can be used here.*

Thank you for your suggestion, Alex. BTW, thanks for Miquèl's patient 
guidance too, I just started trying to submit patches to the kernel, 
I will do batter.

Thanks,
Chen

