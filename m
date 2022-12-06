Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1662C6448FF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiLFQRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235445AbiLFQQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:16:33 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B22A3D927
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:11:57 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-lcRVJWkiNiqOitCyiKt17A-1; Tue, 06 Dec 2022 11:11:37 -0500
X-MC-Unique: lcRVJWkiNiqOitCyiKt17A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A48E1C008B0;
        Tue,  6 Dec 2022 16:11:37 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E3C71121315;
        Tue,  6 Dec 2022 16:11:34 +0000 (UTC)
Date:   Tue, 6 Dec 2022 17:10:32 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Emeel Hakim <ehakim@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] macsec: Add support for IFLA_MACSEC_OFFLOAD
 in the netlink layer
Message-ID: <Y49peLs4FJSFW1HR@hog>
References: <20221206085757.5816-1-ehakim@nvidia.com>
 <Y48IVReEUBmQza81@nanopsycho>
 <IA1PR12MB6353D358E112EE09C4DD770CAB1B9@IA1PR12MB6353.namprd12.prod.outlook.com>
 <Y49FGzwBdyC/xHxH@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y49FGzwBdyC/xHxH@nanopsycho>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-12-06, 14:35:23 +0100, Jiri Pirko wrote:
> Tue, Dec 06, 2022 at 01:31:54PM CET, ehakim@nvidia.com wrote:
> >> Tue, Dec 06, 2022 at 09:57:57AM CET, ehakim@nvidia.com wrote:
> >> >From: Emeel Hakim <ehakim@nvidia.com>
> >> >
> >> >This adds support for configuring Macsec offload through the
> >> 
> >> Tell the codebase what to do. Be imperative in your patch descriptions so it is clear
> >> what are the intensions of the patch.
> >
> >Ack
> >
> >> 
> >> 
> >> >netlink layer by:
> >> >- Considering IFLA_MACSEC_OFFLOAD in macsec_fill_info.
> >> >- Handling IFLA_MACSEC_OFFLOAD in macsec_changelink.
> >> >- Adding IFLA_MACSEC_OFFLOAD to the netlink policy.
> >> >- Adjusting macsec_get_size.
> >> 
> >> 4 patches then?
> >
> >Ack, I will change the commit message to be imperative and will replace the list with a good description.
> >I still believe it should be a one patch since splitting this could break a bisect process.
> 
> Well, when you split, you have to make sure you don't break bisection,
> always. Please try to figure that out.

I think this can be split pretty nicely into 3 patches:
 - add IFLA_MACSEC_OFFLOAD to macsec_rtnl_policy (probably for net
   with a Fixes tag on the commit that introduced IFLA_MACSEC_OFFLOAD)
 - add offload to macsec_fill_info/macsec_get_size
 - add IFLA_MACSEC_OFFLOAD support to changelink

The subject of the last patch should also make it clear that it's only
adding IFLA_MACSEC_OFFLOAD to changelink. As it's written, someone
could assume there's no support at all via rtnl ops and wonder why
this patch isn't doing anything to newlink, and whether/why this
IFLA_MACSEC_OFFLOAD already exists.

-- 
Sabrina

