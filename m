Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F29663FF0
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 13:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238345AbjAJMIo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Jan 2023 07:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjAJMHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 07:07:51 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE1163399
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:05:28 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-e2WrLi2uMGWu-p0JCJ0khQ-1; Tue, 10 Jan 2023 07:04:45 -0500
X-MC-Unique: e2WrLi2uMGWu-p0JCJ0khQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27136185A78B;
        Tue, 10 Jan 2023 12:04:45 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C2602166B26;
        Tue, 10 Jan 2023 12:04:44 +0000 (UTC)
Date:   Tue, 10 Jan 2023 13:03:20 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH main 1/1] macsec: Fix Macsec replay protection
Message-ID: <Y71UCProYz73JVCW@hog>
References: <20230110080218.18799-1-ehakim@nvidia.com>
 <Y703mx5EEjQyH8Fu@hog>
 <IA1PR12MB635369F750521C87790D328AABFF9@IA1PR12MB6353.namprd12.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <IA1PR12MB635369F750521C87790D328AABFF9@IA1PR12MB6353.namprd12.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-10, 11:23:26 +0000, Emeel Hakim wrote:
> 
> 
> > -----Original Message-----
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > Sent: Tuesday, 10 January 2023 12:02
> > To: Emeel Hakim <ehakim@nvidia.com>
> > Cc: dsahern@kernel.org; netdev@vger.kernel.org; Raed Salem
> > <raeds@nvidia.com>
> > Subject: Re: [PATCH main 1/1] macsec: Fix Macsec replay protection
> > 
> > External email: Use caution opening links or attachments
> > 
> > 
> > 2023-01-10, 10:02:19 +0200, ehakim@nvidia.com wrote:
> > > @@ -1516,7 +1515,7 @@ static int macsec_parse_opt(struct link_util *lu, int
> > argc, char **argv,
> > >               addattr_l(n, MACSEC_BUFLEN, IFLA_MACSEC_ICV_LEN,
> > >                         &cipher.icv_len, sizeof(cipher.icv_len));
> > >
> > > -     if (replay_protect != -1) {
> > > +     if (replay_protect) {
> > 
> > This will silently break disabling replay protection on an existing device. This:
> >
> 
> Thanks for catching that.
> 
> >     ip link set macsec0 type macsec replay off
> > 
> > would now appear to succeed but will not do anything. That's why I used an int with
> > -1 in iproute, and a U8 netlink attribute rather a flag.
> > 
> > I think this would be a better fix:
> > 
> >         if (replay_protect != -1) {
> > -               addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
> > +               if (replay_protect)
> > +                       addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW,
> > + window);
> >                 addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
> >                          replay_protect);
> >         }
> > 
> > Does that work for all your test cases?
> 
> The main test case works however I wonder if it should be allowed to pass a window with replay off
> for example:
> ip link set macsec0 type macsec replay off window 32 
> 
> because now this will silently ignore the window attribute
> 
> a possible scenario:
> we start with a macsec device with replay enabled and window set to 64
> now we perform:
> ip link set macsec0 type macsec replay off window 32
> ip link set macsec0 type macsec replay on
> 
> we expect to move to a 32-bit window but we silently failed to do so.
> 
> what do you think?

The kernel currently doesn't allow that. From macsec_validate_attr:

	if ((data[IFLA_MACSEC_REPLAY_PROTECT] &&
	     nla_get_u8(data[IFLA_MACSEC_REPLAY_PROTECT])) &&
	    !data[IFLA_MACSEC_WINDOW])
		return -EINVAL;

So we can set the size of the replay window, but it's ignored and will
be overwritten when we enable replay protection.

We could check for window != -1 instead of replay_protect before
adding IFLA_MACSEC_WINDOW, and I think that should take care of both
cases.

> 
> > 
> > >               addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
> > >               addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
> > >                        replay_protect);
> > 
> > --
> > Sabrina
> 

-- 
Sabrina

