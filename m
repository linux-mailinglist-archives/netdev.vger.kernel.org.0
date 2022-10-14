Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFBD5FE9C6
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJNHoP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Oct 2022 03:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJNHoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:44:14 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B987B9AFD0
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 00:44:12 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-6nszyrnDOUiIdJtwp5vEkw-1; Fri, 14 Oct 2022 03:44:07 -0400
X-MC-Unique: 6nszyrnDOUiIdJtwp5vEkw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 500BD3814942;
        Fri, 14 Oct 2022 07:44:07 +0000 (UTC)
Received: from hog (unknown [10.39.192.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82E88208DDBD;
        Fri, 14 Oct 2022 07:44:06 +0000 (UTC)
Date:   Fri, 14 Oct 2022 09:43:41 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net 3/5] macsec: fix secy->n_rx_sc accounting
Message-ID: <Y0kTLaz95PUE4uQz@hog>
References: <cover.1665416630.git.sd@queasysnail.net>
 <1879f6c8a7fcb5d7bb58ffb3d9fed26c8d7ec5cb.1665416630.git.sd@queasysnail.net>
 <Y0j+2J2uBqrhqRtg@unreal>
MIME-Version: 1.0
In-Reply-To: <Y0j+2J2uBqrhqRtg@unreal>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-10-14, 09:16:56 +0300, Leon Romanovsky wrote:
[...]
> > @@ -1897,15 +1899,16 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
> >  	secy = &macsec_priv(dev)->secy;
> >  	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
> >  
> > -	rx_sc = create_rx_sc(dev, sci);
> > +
> > +	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
> > +		active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
> 
> You don't need !! to assign to bool variables and can safely omit them.

Yeah, but I'm just moving existing code, see below.

(please trim your replies, nobody wants to scroll through endless
quoting just to find one comment hiding in the middle)

> 
> thanks
> 
> > +
> > +	rx_sc = create_rx_sc(dev, sci, active);
> >  	if (IS_ERR(rx_sc)) {
> >  		rtnl_unlock();
> >  		return PTR_ERR(rx_sc);
> >  	}
> >  
> > -	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
> > -		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);

-- 
Sabrina

