Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAF75F0F7A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiI3QC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiI3QCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:02:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF00B1A9A76
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664553717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dSaLrZl2pRqIhF9cHurGbopli303/71ZQUFNstj/m0M=;
        b=RJjIFvr0cXbyYfVHV4U/QORLQkyq91apWNQrACLlvQynycAKPksqaCAi1BeKzYRFiZy/y5
        FttUbvVIaTZRtciyPjoZS2IgTHmiTieO1Fv9NRYfC0DwX1H0L1gaMXZrO8YeVlj1UcXdAl
        SfMa3fSo8GCc/uQxaHanRvYmldwwKxw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-284-aCe8fVFpNUWClUhq7hzJKg-1; Fri, 30 Sep 2022 12:01:55 -0400
X-MC-Unique: aCe8fVFpNUWClUhq7hzJKg-1
Received: by mail-wr1-f72.google.com with SMTP id r22-20020adfa156000000b0022cc3018fbaso1718008wrr.2
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dSaLrZl2pRqIhF9cHurGbopli303/71ZQUFNstj/m0M=;
        b=l1mGXNKV5511AqeAcMIOa5XCVi6ovfjh/KP5c6rkeX6hCX0imm20bM0vRZrSvnStLC
         xCheNXIGM63M96oCdAk789bFuT134pY+t3T05dO9+h3gR6vgFlTT9mcHfgiYiMsv5Vlv
         85k+aINTSSCekDzg6z1jL0AmdRi+q9KOO0HTgPDjboSmAYclOwjT11o+UVOZu1rIOOu6
         iEWMa1D9PLVWfnvfglo1e7k4iFdYdpP013OMlOiSmahLPUP9CV2e/v/SPRsldhL8r27s
         uMvtwsXPQwRKTd9OhrLlYAy+THTH323q+IGQOh9zLRqLDYW5Ntp24WbMLbO7f7Kq12Cz
         eu/g==
X-Gm-Message-State: ACrzQf0XilqNuy0lsFsFj7KfjsaI1TMXcsri/AYZBSbKGn8it9xlD6ls
        a1sQNv94EXcavXgnjvyCgvvs4PvgAqFOht2ZDF0/QO2DfJOUQnH/FqmYSDBsYupeYKvkTf+KdyY
        dTfQBufD9vSIrttB0
X-Received: by 2002:adf:d1cb:0:b0:22a:eae5:5c45 with SMTP id b11-20020adfd1cb000000b0022aeae55c45mr6300319wrd.255.1664553713989;
        Fri, 30 Sep 2022 09:01:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4gYaS2LsErTHtBUTm1K0N/TMQNG++aoXdlLuTqHi0RHmbObrbjweW7UC19SMflo13VeETvcw==
X-Received: by 2002:adf:d1cb:0:b0:22a:eae5:5c45 with SMTP id b11-20020adfd1cb000000b0022aeae55c45mr6300297wrd.255.1664553713790;
        Fri, 30 Sep 2022 09:01:53 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id i9-20020a1c5409000000b003b486027c8asm7348915wmb.20.2022.09.30.09.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 09:01:53 -0700 (PDT)
Date:   Fri, 30 Sep 2022 18:01:50 +0200
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
Subject: Re: [PATCHv5 net-next 1/4] rtnetlink: add new helper
 rtnl_configure_link_notify()
Message-ID: <20220930160150.GD10057@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-2-liuhangbin@gmail.com>
 <ede1abd0-970a-dec8-4dee-290d4a43200f@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ede1abd0-970a-dec8-4dee-290d4a43200f@6wind.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 04:22:19PM +0200, Nicolas Dichtel wrote:
> Le 30/09/2022 à 11:45, Hangbin Liu a écrit :
> > -int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
> > +static int rtnl_configure_link_notify(struct net_device *dev, const struct ifinfomsg *ifm,
> > +				      struct nlmsghdr *nlh, u32 pid)
> But not here. Following patches also use this order instead of the previous one.
> For consistency, it could be good to keep the same order everywhere.

Yes, since a v6 will be necessary anyway, let's be consistent about the
order of parameters. That helps reading the code.

While there, I'd prefer to use 'portid' instead of 'pid'. I know
rtnetlink.c uses both, but 'portid' is more explicit and is what
af_netlink.c generally uses.

