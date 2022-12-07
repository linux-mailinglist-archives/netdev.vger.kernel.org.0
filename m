Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7C1645562
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiLGIZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLGIZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:25:15 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BAC25EA5;
        Wed,  7 Dec 2022 00:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670401511; x=1701937511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P7OrcBboMlV8Os7KJfShQiBKCP7NXDohE0LvqziHmvE=;
  b=fDgcPSZngYz97j4Bfmvm7pwsRK3dl2ycy2UpGmnZmL5oFIzd2pVhHIjJ
   9lm8auN5YAaOApaMCHBaZY1rFQB+gTxWrU4hztesQOWRvsZ2ygeP/NpGd
   MNxbyF91O3C/0jwsJN4mhvwxdffvTAUJCd2/ytbIkA8/+C2Gm+hauZJqN
   MsdesOIKGfrNUjhJDG8NZWc9FQq3lNRd34tT1JBqW1zlmMX7PvhjHM/de
   s7uMThJS1gH2aTrPSbA1u3uRExUVwNiI7fIjr2k8cNRcKKHkPnZAIBlSH
   cvopPZktI2OMdAAI/Qg4VBRT308cx5nJaV7YvusTLb+k6BbTkyB7JiYwF
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="126897538"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2022 01:25:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 7 Dec 2022 01:25:08 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 7 Dec 2022 01:25:07 -0700
Date:   Wed, 7 Dec 2022 09:30:14 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <Steen.Hegelund@microchip.com>, <lars.povlsen@microchip.com>,
        <daniel.machon@microchip.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 1/4] net: microchip: vcap: Add vcap_get_rule
Message-ID: <20221207083014.mipiiu6dzgpuayz5@soft-dev3-1>
References: <20221203104348.1749811-1-horatiu.vultur@microchip.com>
 <20221203104348.1749811-2-horatiu.vultur@microchip.com>
 <256f533f019b6392b41701707eb7aa056b2f16c0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <256f533f019b6392b41701707eb7aa056b2f16c0.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/06/2022 13:31, Paolo Abeni wrote:
> 
> Hello,

Hi Paolo,

> 
> On Sat, 2022-12-03 at 11:43 +0100, Horatiu Vultur wrote:
> > @@ -632,32 +264,22 @@ static int vcap_show_admin(struct vcap_control *vctrl,
> >                          struct vcap_admin *admin,
> >                          struct vcap_output_print *out)
> >  {
> > -     struct vcap_rule_internal *elem, *ri;
> > +     struct vcap_rule_internal *elem;
> > +     struct vcap_rule *vrule;
> >       int ret = 0;
> >
> >       vcap_show_admin_info(vctrl, admin, out);
> > -     mutex_lock(&admin->lock);
> >       list_for_each_entry(elem, &admin->rules, list) {
> 
> Not strictly related to this patch, as the patter is AFAICS already
> there in other places, but I'd like to understand the admin->rules
> locking schema.

According to the commit message that introduced this lock [0] and the
comment to the lock, this lock is used to protect the access to the
admin->rules, admin->enabled and the caches which means the access to
the HW (to read/write the rules).
> 
> It looks like addition/removal are protected by admin->lock, but
> traversal is usually lockless, which in turn looks buggy ?!?

Thanks for the observation! You are correct, there seems to be some bugs
regarding the usage of this lock. We will look over this and will send a
patch to fix this.

> 
> Note: as this patch does not introduce the mentioned behavior, I'm not
> going to block the series for the above.

[0] 71c9de995260 ("net: microchip: sparx5: Add VCAP locking to protect rules")
> 
> Thanks,
> 
> Paolo
> > -             ri = vcap_dup_rule(elem);
> > -             if (IS_ERR(ri)) {
> > -                     ret = PTR_ERR(ri);
> > -                     goto err_unlock;
> > +             vrule = vcap_get_rule(vctrl, elem->data.id);
> > +             if (IS_ERR_OR_NULL(vrule)) {
> > +                     ret = PTR_ERR(vrule);
> > +                     break;
> >               }
> > -             /* Read data from VCAP */
> > -             ret = vcap_read_rule(ri);
> > -             if (ret)
> > -                     goto err_free_rule;
> > +
> >               out->prf(out->dst, "\n");
> > -             vcap_show_admin_rule(vctrl, admin, out, ri);
> > -             vcap_free_rule((struct vcap_rule *)ri);
> > +             vcap_show_admin_rule(vctrl, admin, out, to_intrule(vrule));
> > +             vcap_free_rule(vrule);
> >       }
> > -     mutex_unlock(&admin->lock);
> > -     return 0;
> > -
> > -err_free_rule:
> > -     vcap_free_rule((struct vcap_rule *)ri);
> > -err_unlock:
> > -     mutex_unlock(&admin->lock);
> >       return ret;
> >  }
> 

-- 
/Horatiu
