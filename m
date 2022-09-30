Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1805F1037
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiI3QpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbiI3QpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE02720345
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664556315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zmbr3gJDV3F0Fh9lVRnRW0kauBFTuawq6kMOb4DIFBY=;
        b=VM6xFhgweUVON4crOvJTI0vpeSvGAU8jn9IZyyyv1Ps7IafGW4QQodZjMOSv1YGMphnMXT
        DRGyJilFJ49t07A88IIkIgTivDTnSnWOK2pZg6QmYBwcCyM/Ikcff5RCBn3N57RJHLf8wu
        zu6NTex7+yt8NcQGflexTf8nkwBapFg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-V11h-niBNN6Uo3jt1ajTuQ-1; Fri, 30 Sep 2022 12:45:14 -0400
X-MC-Unique: V11h-niBNN6Uo3jt1ajTuQ-1
Received: by mail-wr1-f71.google.com with SMTP id q28-20020adfab1c000000b0022e0399964dso595259wrc.8
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=zmbr3gJDV3F0Fh9lVRnRW0kauBFTuawq6kMOb4DIFBY=;
        b=MrKU2dvUIa3IvGf/fZV/1Xh88ec9Ey2VcOBnXqtVguEZ5G7esR8M0MXx2W95cLAZZ9
         dlyYH7xaNtk19xnH55OEoGqWnZjFHT9JZWeXyz7bTCcRkyI899sUe1QJuOyGWB/G3rQw
         Qhg8parwau4GUuJdJc12ytP0uTESldDDfVuTquZnna+3a0C4vn58aVqNTp0UUh9e9ETb
         w/fO/TqAJ8dN5i+917xeR+KgUiLXOww7MWW5/ZNi77+VDNC0xr4iMovd/+EtBNj61jo3
         0sRothCmnu/JJHW8xVcJxVjg//KCWVKhidti2JR33XF2DPlm1LLmlN83rE9/1tfnS/YX
         aPzw==
X-Gm-Message-State: ACrzQf2pRLvsASW7qdfGSpBme2He2VXs0CfGrEEtNz8jsJOnq3ISFz1K
        sjugrlH2xHcA9LejBikL7m5jOZcKAHN+1bKw67BuorCsyJuDGai6Fqc1gCZa0Z/N9SweJu4WyCr
        OHzl2b64ROINTjSAO
X-Received: by 2002:a1c:7412:0:b0:3b4:7a81:e7e4 with SMTP id p18-20020a1c7412000000b003b47a81e7e4mr6140223wmc.15.1664556313445;
        Fri, 30 Sep 2022 09:45:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Wp8A7houJ9AKsVRMb6T7+aFKZVedb/unrhr0Fh3KONY3TTEzLSMdKuTB54eOqIoy+c8GS/g==
X-Received: by 2002:a1c:7412:0:b0:3b4:7a81:e7e4 with SMTP id p18-20020a1c7412000000b003b47a81e7e4mr6140202wmc.15.1664556313233;
        Fri, 30 Sep 2022 09:45:13 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id h6-20020adfe986000000b0022cd6e852a2sm2914094wrm.45.2022.09.30.09.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 09:45:12 -0700 (PDT)
Date:   Fri, 30 Sep 2022 18:45:10 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv5 net-next 2/4] net: add new helper
 unregister_netdevice_many_notify
Message-ID: <20220930164510.GA16408@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-3-liuhangbin@gmail.com>
 <20220930163139.GF10057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930163139.GF10057@localhost.localdomain>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 06:31:42PM +0200, Guillaume Nault wrote:
> On Fri, Sep 30, 2022 at 05:45:04PM +0800, Hangbin Liu wrote:
> > @@ -10779,11 +10779,14 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
> >  /**
> >   *	unregister_netdevice_many - unregister many devices
> >   *	@head: list of devices
> > + *	@nlh: netlink message header
> > + *	@pid: destination netlink portid for reports
> >   *
> >   *  Note: As most callers use a stack allocated list_head,
> >   *  we force a list_del() to make sure stack wont be corrupted later.
> >   */
> > -void unregister_netdevice_many(struct list_head *head)
> > +void unregister_netdevice_many_notify(struct list_head *head,
> > +				      struct nlmsghdr *nlh, u32 pid)
> 
> Let's use portid (not pid) here too.

...and make 'nlh' const.

