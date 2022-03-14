Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AA64D8B2A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243492AbiCNR5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240191AbiCNR5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:57:10 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515362DD62;
        Mon, 14 Mar 2022 10:56:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r29so11864710edc.0;
        Mon, 14 Mar 2022 10:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8z4v8YxtWANrTWb6RFPyfnlW/ootQzYbnhWcATbHWQ=;
        b=AjMTYWO0eXv50h4Efspnrs7DrZdGLyTZb5SWWsRCQUMcCXc1oNqULW6PhRKMLgap58
         B4Krs3qCdiKdxIBQwTlcfDKIX9Hcb/6cnL2UJqNXK2S0+3a1WTdaeEGnylXLthn65qo/
         lah1W+eNY1Leu9LzmbypCiIaZGNz0wy5QR6f6SR/g306mIXdHgIQLbNuVHOKNBFe66Sz
         SrZdOLdgZ91VgLzbtP147JkR4lv0B1cburt4PRocOahUCRM6l9TIherZOKfA3v+z0Rqf
         iyUvAAosQnmzynDKWwVA6QY+xt+DNMQUQb6Tg26+frCQSkIhjFkeafwyQkd3km1GsRhC
         mpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8z4v8YxtWANrTWb6RFPyfnlW/ootQzYbnhWcATbHWQ=;
        b=Ah3lShP/t+d6IoJQDnkWvU7Qh42ibzBE//v8ldHa6qFlD5Ve2+DjcAFCwCcQew63E6
         gxwop/V9Ho84kpbK1Vzpi52Lvrjy1EKTkaR042Z+TGyow73b6I5wm5/bDjDiSDUe8ZHU
         JQHVjHuGiO5Wkljn4XDaNnkDnJfwHNabetnaCfd7KMybmA7lUMkq/2vs3K0RMIyCHpJO
         hGT2BeWn9AQRKBAuwSw6aWp5+CJiYvtzsQm4WRv4Z0hRu/KKMp3uf+2TieEwjMHSzHxT
         NidqkzeP9nQTsflFMPZzQBT/ul2EDHMtiwc7FDdhZpGxlpwCHvORlnF/UovmW/bPmwr5
         uvjQ==
X-Gm-Message-State: AOAM532DnpL9oC1qEdm+4gS9oT0UpJxjS0SNV7nFsEuyOXQp0q9YuvHq
        pi6hGhkNspV+Rcak8X9/UIA=
X-Google-Smtp-Source: ABdhPJy926fQG3oSQirbFPmeHBjqAmigNyVHn6+Yl5vzV7K2iNg9nGN5w2v8rujJyYp+vq/t/MAGtg==
X-Received: by 2002:a05:6402:4301:b0:418:585b:cfe1 with SMTP id m1-20020a056402430100b00418585bcfe1mr12030306edc.250.1647280558842;
        Mon, 14 Mar 2022 10:55:58 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id e9-20020a170906c00900b006d4a45869basm7154199ejz.199.2022.03.14.10.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 10:55:58 -0700 (PDT)
Date:   Mon, 14 Mar 2022 19:55:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 09/14] net: dsa: Validate hardware support
 for MST
Message-ID: <20220314175556.7mjr4tui4vb4i5qn@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-10-tobias@waldekranz.com>
 <20220314165649.vtsd3xqv7htut55d@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314165649.vtsd3xqv7htut55d@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 06:56:49PM +0200, Vladimir Oltean wrote:
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index 58291df14cdb..1a17a0efa2fa 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -240,6 +240,10 @@ static int dsa_port_switchdev_sync_attrs(struct dsa_port *dp,
> >  	if (err && err != -EOPNOTSUPP)
> >  		return err;
> >  
> > +	err = dsa_port_mst_enable(dp, br_mst_enabled(br), extack);
> > +	if (err && err != -EOPNOTSUPP)
> > +		return err;
> 
> Sadly this will break down because we don't have unwinding on error in
> place (sorry). We'd end up with an unoffloaded bridge port with
> partially synced bridge port attributes. Could you please add a patch
> previous to this one that handles this, and unoffloads those on error?

Actually I would rather rename the entire dsa_port_mst_enable() function
to dsa_port_mst_validate() and move it to the beginning of dsa_port_bridge_join().
This simplifies the unwinding that needs to take place quite a bit.
