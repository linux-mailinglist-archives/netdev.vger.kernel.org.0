Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BE852A0AE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbiEQLpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbiEQLp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E52E647AF2
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652787928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Yer4G23hVK3UUoGD9YsPEhXZ4kfN4P+jWY6PiFJPXI=;
        b=McIa/9EFN74yhtQ0ot4U2ea0JUukVpIU1a9Y/c/4Y4AluRA37Ql6Qo1GnhH30OwAQlwHmr
        XjiiQqkKGfjODq26BkCwloNT8n3V4CqSvQecbMgZMoPaIPwgQJggjyZsM17Rh6TT1bjldl
        Id4sCQpb19qQlzmugnb5FwBIw7ju+l8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-FZT0t6O0N02tRQQUigfmaA-1; Tue, 17 May 2022 07:45:27 -0400
X-MC-Unique: FZT0t6O0N02tRQQUigfmaA-1
Received: by mail-wr1-f69.google.com with SMTP id e11-20020adffc4b000000b0020d059c2347so1211453wrs.18
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3Yer4G23hVK3UUoGD9YsPEhXZ4kfN4P+jWY6PiFJPXI=;
        b=o6N9dtUohKnCnHMdeteW5zYZBOVXm/ywSSy2xiHo9PqUXGofawDgYWlUlYD06OKZD0
         tWdEvUSHFdY75SbA2jF+XKSvhByqXCnMt/QfgwZbokBOiM9dMW68Gp8MW5JPCz0NZnNZ
         EEBxqeZmL7275GAv7ovpBHhPg/MO6Y8W1H/saanxK9luQWbCE4LCKOwvaoTLD5O9RMdV
         C3pR4gUk0q8oSCMuU59X3KR9LgwR7u+M0j1saOBiyvKD180+L+qtH/r1/5N0TslH/XIl
         BLWkduDNBGRRfm7LP1TVv0rznOBYZIWn+yjAJUeOWSZqe4sKF7NJaCFor4r1xk0kur5/
         RSkw==
X-Gm-Message-State: AOAM5305LnufYZ3P5ZppdByOryhJskoKHjeX6fG1ywhYL//LAKEIcbsY
        9UFqFy3F5gkFjmH01rfAcvfjajFpqQepqrSGuUViHodcEpfMCP+Kx4zxQeXuRIrG/6R0HPD6XEv
        Q4QyDpIthc9OW3nPj
X-Received: by 2002:a5d:6d09:0:b0:20c:53a9:cc30 with SMTP id e9-20020a5d6d09000000b0020c53a9cc30mr17833151wrq.513.1652787925880;
        Tue, 17 May 2022 04:45:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZxXHXeNKnElnTtoNZnjV4kWpt06lRF9Z82TMsIJZBoldCff9hKh6ax6+E07WFmigwUDN7Mg==
X-Received: by 2002:a5d:6d09:0:b0:20c:53a9:cc30 with SMTP id e9-20020a5d6d09000000b0020c53a9cc30mr17833134wrq.513.1652787925674;
        Tue, 17 May 2022 04:45:25 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id f26-20020a7bcd1a000000b003942a244ee2sm1606501wmj.39.2022.05.17.04.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 04:45:25 -0700 (PDT)
Message-ID: <08745e06d59008c1ac8a9d74f16440408990e630.camel@redhat.com>
Subject: Re: [PATCH v2] net: phy: marvell: Add errata section 5.1 for Alaska
 PHY
From:   Paolo Abeni <pabeni@redhat.com>
To:     Stefan Roese <sr@denx.de>, netdev@vger.kernel.org
Cc:     Leszek Polak <lpolak@arri.de>,
        Marek =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Date:   Tue, 17 May 2022 13:45:24 +0200
In-Reply-To: <c8e782cb-49cc-e792-9573-8fd2e5515c50@denx.de>
References: <20220516070859.549170-1-sr@denx.de>
         <163e90e736803c670ce88f2b2b1174eddc1060a2.camel@redhat.com>
         <c8e782cb-49cc-e792-9573-8fd2e5515c50@denx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-17 at 13:21 +0200, Stefan Roese wrote:
> On 17.05.22 13:01, Paolo Abeni wrote:
> > On Mon, 2022-05-16 at 09:08 +0200, Stefan Roese wrote:
> > > From: Leszek Polak <lpolak@arri.de>
> > > 
> > > As per Errata Section 5.1, if EEE is intended to be used, some register
> > > writes must be done once after every hardware reset. This patch now adds
> > > the necessary register writes as listed in the Marvell errata.
> > > 
> > > Without this fix we experience ethernet problems on some of our boards
> > > equipped with a new version of this ethernet PHY (different supplier).
> > > 
> > > The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
> > > Rev. A0.
> > > 
> > > Signed-off-by: Leszek Polak <lpolak@arri.de>
> > > Signed-off-by: Stefan Roese <sr@denx.de>
> > > Cc: Marek Behún <kabel@kernel.org>
> > > Cc: Andrew Lunn <andrew@lunn.ch>
> > > Cc: Heiner Kallweit <hkallweit1@gmail.com>
> > > Cc: Russell King <linux@armlinux.org.uk>
> > > Cc: David S. Miller <davem@davemloft.net>
> > 
> > It's not clear to me if you are targeting -net or net-next, could you
> > please clarify? In case this is for -net, please add a suitable fixes
> > tag, thanks!
> 
> Sorry for not being clear on this. net-next is good AFAICT.
> 
> Should I re-submit to net-next?

Not needed, I'm applying it. 

Thanks!

Paolo

