Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683BB63BE4A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiK2K4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiK2K4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:56:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4695F5F872;
        Tue, 29 Nov 2022 02:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669719357; x=1701255357;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=14JeKXWHSLqj+2WYk+/+WfhIsZZ1QfsK4ISNpY3uTsc=;
  b=BOe93m/Jgvz8FLkZ8URJ2uN8AhnakbVuAL+ueVD5nD7HeqIU+m3kpros
   mLYI4H4DBagzO3hHB015Pc4b9a2BsCwynSP2AP5B1Sff+N9YM0FGsGkHS
   W4vrm5eAmPU6/nC4f13TNja7PHA2iUiKQS/K4bAOj4SjN+C+FZGEZ7h+7
   2RwA/+qK7Ez63EORWqXs2vDYAbRYofqF1rpTRtuNYKNFGcRWnWFcznaGI
   crFBCmEYLvhOaFqVixzcMRGLiBEh+UrFx3NsjZA0uGdFro97B6ELK6H+Y
   Ll6wYajSAnLNVQN1j58Uxh3kP6td5p5VGPLTxTBYq02bkp6tBNPw1e30Z
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="190964478"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 03:55:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 03:55:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Tue, 29 Nov 2022 03:55:55 -0700
Date:   Tue, 29 Nov 2022 12:00:58 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <casper.casan@gmail.com>
Subject: Re: [PATCH net-next] net: microchip: vcap: Change how the rule id is
 generated
Message-ID: <20221129110058.uv2zqjscwyvku46t@soft-dev3-1>
References: <20221128142959.8325-1-horatiu.vultur@microchip.com>
 <20221128144042.2097491-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221128144042.2097491-1-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/28/2022 15:40, Alexander Lobakin wrote:

Hi Olek,

> 
> From: Horatiu Vultur <horatiu.vultur@microchip.com>
> Date: Mon, 28 Nov 2022 15:29:59 +0100
> 
> > Currently whenever a new rule id is generated, it picks up the next
> > number bigger than previous id. So it would always be 1, 2, 3, etc.
> > When the rule with id 1 will be deleted and a new rule will be added,
> > it will have the id 4 and not id 1.
> > In theory this can be a problem if at some point a rule will be added
> > and removed ~0 times. Then no more rules can be added because there
> > are no more ids.
> >
> > Change this such that when a new rule is added, search for an empty
> > rule id starting with value of 1 as value 0 is reserved.
> >
> > Fixes: c9da1ac1c212 ("net: microchip: sparx5: Adding initial tc flower support for VCAP API")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  drivers/net/ethernet/microchip/vcap/vcap_api.c | 7 +------
> >  drivers/net/ethernet/microchip/vcap/vcap_api.h | 1 -
> >  2 files changed, 1 insertion(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > index b50d002b646dc..b65819f3a927f 100644
> > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> > @@ -974,17 +974,12 @@ static u32 vcap_next_rule_addr(u32 addr, struct vcap_rule_internal *ri)
> >  /* Assign a unique rule id and autogenerate one if id == 0 */
> >  static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
> >  {
> > -     u32 next_id;
> > -
> >       if (ri->data.id != 0)
> >               return ri->data.id;
> >
> > -     next_id = ri->vctrl->rule_id + 1;
> > -
> > -     for (next_id = ri->vctrl->rule_id + 1; next_id < ~0; ++next_id) {
> > +     for (u32 next_id = 1; next_id < ~0; ++next_id) {
> >               if (!vcap_lookup_rule(ri->vctrl, next_id)) {
> 
> Or you can simply use IDA/IDR/XArray which takes care of all this :)

Thanks for the great suggestion. From what I can see IDR would be a
great match for this. Then we can also change the function
'vcap_lookup_rule' to use IDR.
On the other side, we will not continuously add/remove entries from the
VCAP, so I was not sure if it is worth bringing the IDR(with the radix
tree) for this.
Anyway I am open for IDR suggestion.
But lets wait for the VCAP maintainer to see what he thinks.

> 
> 
> >                       ri->data.id = next_id;
> > -                     ri->vctrl->rule_id = next_id;
> >                       break;
> >               }
> >       }
> > diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
> > index ca4499838306f..689c7270f2a89 100644
> > --- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
> > +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
> > @@ -268,7 +268,6 @@ struct vcap_operations {
> >
> >  /* VCAP API Client control interface */
> >  struct vcap_control {
> > -     u32 rule_id; /* last used rule id (unique across VCAP instances) */
> >       struct vcap_operations *ops;  /* client supplied operations */
> >       const struct vcap_info *vcaps; /* client supplied vcap models */
> >       const struct vcap_statistics *stats; /* client supplied vcap stats */
> > --
> > 2.38.0
> 
> Thanks,
> Olek

-- 
/Horatiu
