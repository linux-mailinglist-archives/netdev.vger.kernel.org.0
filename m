Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882794D19EC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240996AbiCHOBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235070AbiCHOB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:01:29 -0500
X-Greylist: delayed 531 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 06:00:32 PST
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899BD4A3D1
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 06:00:32 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1C057201CA;
        Tue,  8 Mar 2022 14:51:39 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Y0EPV2PysOVL; Tue,  8 Mar 2022 14:51:38 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3BC0C2006F;
        Tue,  8 Mar 2022 14:51:38 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 29C2780004A;
        Tue,  8 Mar 2022 14:51:38 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 8 Mar 2022 14:51:37 +0100
Received: from moon.secunet.de (172.18.149.2) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 8 Mar
 2022 14:51:37 +0100
Date:   Tue, 8 Mar 2022 14:51:30 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Eyal Birger <eyal.birger@gmail.com>,
        Antony Antony <antony.antony@secunet.com>
Subject: Re: Regression in add xfrm interface
Message-ID: <YidTpIty2fVKTBzM@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20220307121123.1486c035@hermes.local>
 <20220308075013.GD1791239@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220308075013.GD1791239@gauss3.secunet.de>
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

As Steffen explained bellow if_id = 0 is likely to cause problems in the long
term. Should we revert the commit because it broke userspace tools?

I notice the Debian bug is in a iproute2 testsuite, also it is in Debian testing! How about fixing test case than reverting the kernel commit?

Another option is revert the commit in current kernel development cycle.
And send the same fix to ipsec-next without "Fixes" tag.
Would that be acceptable for Debian testsuite usecase?

regards,
-antony

On Tue, Mar 08, 2022 at 08:50:13 +0100, Steffen Klassert wrote:
> On Mon, Mar 07, 2022 at 12:11:23PM -0800, Stephen Hemminger wrote:
> > There appears to be a regression between 5.10 (Debian 11) and 5.16 (Debian testing)
> > kernel in handling of ip link xfrm create. This shows up in the iproute2 testsuite
> > which now fails. This is kernel (not iproute2) regression.
> > 
> > 
> > Running ip/link/add_type_xfrm.t [iproute2-this/5.16.0-1-amd64]: FAILED
> > 
> > 
> > Good log:
> > ::::::::::::::
> > link/add_type_xfrm.t.iproute2-this.out
> > ::::::::::::::
> > [Testing Add XFRM Interface, With IF-ID]
> > tests/ip/link/add_type_xfrm.t: Add dev-ktyXSm xfrm interface succeeded
> > tests/ip/link/add_type_xfrm.t: Show dev-ktyXSm xfrm interface succeeded with output:
> > 2: dev-ktyXSm@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >     link/none  promiscuity 0 minmtu 68 maxmtu 65535 
> >     xfrm if_id 0xf addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
> > test on: "dev-ktyXSm" [SUCCESS]
> > test on: "if_id 0xf" [SUCCESS]
> > tests/ip/link/add_type_xfrm.t: Del dev-ktyXSm xfrm interface succeeded
> > [Testing Add XFRM Interface, No IF-ID]
> > tests/ip/link/add_type_xfrm.t: Add dev-tkUDaA xfrm interface succeeded
> > tests/ip/link/add_type_xfrm.t: Show dev-tkUDaA xfrm interface succeeded with output:
> > 3: dev-tkUDaA@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >     link/none  promiscuity 0 minmtu 68 maxmtu 65535 
> >     xfrm if_id 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
> > test on: "dev-tkUDaA" [SUCCESS]
> > test on: "if_id 0xf" [SUCCESS]
> > tests/ip/link/add_type_xfrm.t: Del dev-tkUDaA xfrm interface succeeded
> > 
> > Failed log:
> > 
> > [Testing Add XFRM Interface, With IF-ID]
> > tests/ip/link/add_type_xfrm.t: Add dev-pxNsUc xfrm interface succeeded
> > tests/ip/link/add_type_xfrm.t: Show dev-pxNsUc xfrm interface succeeded with output:
> > 2: dev-pxNsUc@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >     link/none  promiscuity 0 minmtu 68 maxmtu 65535 
> >     xfrm if_id 0xf addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
> > test on: "dev-pxNsUc" [SUCCESS]
> > test on: "if_id 0xf" [SUCCESS]
> > tests/ip/link/add_type_xfrm.t: Del dev-pxNsUc xfrm interface succeeded
> > [Testing Add XFRM Interface, No IF-ID]
> 
> No IF-ID is an invalid configuration, the interface does not work
> with IF-IF 0. Such an interface will blackhole all packets routed
> to it. That is because policies and states with no IF-ID are meant
> for a setup without xfrm interfaces, they will not match the interface.
> 
> Unfortunately we did not catch this invalid configuration from the
> beginning and userspace seems to use (or do some tests tests with)
> xfrm interfaces with IF-ID 0. In that case, I fear we eventually
> have to revert the cange that catches the invalid configuration.
> 
