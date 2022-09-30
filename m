Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA05F0D87
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiI3O3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiI3O3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:29:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2DE1A1E94
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664548157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUFq/MzNjNUZHKM8jFpZHut7cwSTZtUF1F/J3JSyvyo=;
        b=UF+Nej7K4RmQyR9b1CMJTMPBNm+AzrNh+V+RN7nm6dTBXg9jbM+VqSkJERsJQZESnrcxrx
        i6XlbwFeKq72XBCIwKRxOlBiIXox1tlWwS2WAgV3NFpb3jk0sc0CXIxi3igq6/epVcmrp8
        vwL7HM3O5Bqs2+bgyRv7AfYo3G1W7as=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-ebZmDn3PPquymFf87B9g5Q-1; Fri, 30 Sep 2022 10:29:15 -0400
X-MC-Unique: ebZmDn3PPquymFf87B9g5Q-1
Received: by mail-wr1-f72.google.com with SMTP id g27-20020adfa49b000000b0022cd5476cc7so1629350wrb.17
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qUFq/MzNjNUZHKM8jFpZHut7cwSTZtUF1F/J3JSyvyo=;
        b=KLXWAt1Gjo4De3XbwKvCEueGEeU7f9XLkJMmuY+EUD7SSdOXi1ROrKYWkPUjDHzpc5
         t0TUmpVIEpGEHFVBAysjJvlv7MRNRqgqBch9SWVo05Rjy9xTC3fnPFpwVjP93lsr6BrJ
         Fwh2z7YWgxJ85wrPwlgY7f42xzhUdrUtaWTD1yfOAR5DWP3CX4zzSfmDA/ZZws4ViRUF
         UJXvcku48lS39blAoeCkYqMUhdh/HfH+xHtDE7aOp3OmYIHeQ9pypt6hDjgHXCeHQEMR
         sl6Mwbz4/eB4oClGR262mn5aigiaw4pCH8vUp156Dkia6bWC/AQUX7R5va4ZwTXHNKdj
         1aWQ==
X-Gm-Message-State: ACrzQf12bz+iI6d63ipMQkmllZihZ7u/ZbJrlsJDBk++aUBMi2Xy8DQr
        qJFx6/5K9yTbRRVideFiXT2vQyEFopFm0kGqKKNuVb3rGNvjs8I6lRPzObDFxJ764FUMoKHyUfF
        jzaC0aDiON0QLJJ2U
X-Received: by 2002:a5d:5642:0:b0:22e:3a7:1311 with SMTP id j2-20020a5d5642000000b0022e03a71311mr1517383wrw.167.1664548154432;
        Fri, 30 Sep 2022 07:29:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4+JhklRgngzZRBm/VHqe9IpCAXfgZUQWzF+E4VQIN54EySbhUO9Ou4ahhA8I0SkHEjjNXLqA==
X-Received: by 2002:a5d:5642:0:b0:22e:3a7:1311 with SMTP id j2-20020a5d5642000000b0022e03a71311mr1517374wrw.167.1664548154253;
        Fri, 30 Sep 2022 07:29:14 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id r2-20020a05600c2c4200b003b3365b38f9sm2232788wmg.10.2022.09.30.07.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:29:13 -0700 (PDT)
Date:   Fri, 30 Sep 2022 16:29:10 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv5 net-next 2/4] net: add new helper
 unregister_netdevice_many_notify
Message-ID: <20220930142910.GB10057@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-3-liuhangbin@gmail.com>
 <aae1926b-fbc3-41ff-aa80-a1196599eacb@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aae1926b-fbc3-41ff-aa80-a1196599eacb@6wind.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 04:23:07PM +0200, Nicolas Dichtel wrote:
> Le 30/09/2022 à 11:45, Hangbin Liu a écrit :
> > Add new helper unregister_netdevice_many_notify(), pass netlink message
> > header and port id, which could be used to notify userspace when flag
> > NLM_F_ECHO is set.
> > 
> > Make the unregister_netdevice_many() as a wrapper of new function
> > unregister_netdevice_many_notify().
> > 
> > Suggested-by: Guillaume Nault <gnault@redhat.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [snip]
> 
> > @@ -10860,7 +10864,7 @@ void unregister_netdevice_many(struct list_head *head)
> >  			dev->netdev_ops->ndo_uninit(dev);
> >  
> >  		if (skb)
> > -			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, 0, NULL);
> > +			rtmsg_ifinfo_send(skb, dev, GFP_KERNEL, pid, nlh);
> >  
> >  		/* Notifier chain MUST detach us all upper devices. */
> >  		WARN_ON(netdev_has_any_upper_dev(dev));
> > @@ -10883,6 +10887,12 @@ void unregister_netdevice_many(struct list_head *head)
> >  
> >  	list_del(head);
> >  }
> > +EXPORT_SYMBOL(unregister_netdevice_many_notify);
> Is this export really needed?

I was about to make the same comment :). I see no reason to export this
function. Declaring it in net/core/dev.h should be enough.

> > +void unregister_netdevice_many(struct list_head *head)
> > +{
> > +	unregister_netdevice_many_notify(head, NULL, 0);
> > +}
> >  EXPORT_SYMBOL(unregister_netdevice_many);
> >  
> >  /**
> 

