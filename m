Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D595E5B60
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiIVG11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiIVG1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:27:15 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7252BAF496
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:27:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B567D2057A;
        Thu, 22 Sep 2022 08:27:11 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id K02QvUjAq89c; Thu, 22 Sep 2022 08:27:11 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3C1C22056D;
        Thu, 22 Sep 2022 08:27:11 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2B63A80004A;
        Thu, 22 Sep 2022 08:27:11 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 08:27:10 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 22 Sep
 2022 08:27:10 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 27E693180DDF; Thu, 22 Sep 2022 08:27:10 +0200 (CEST)
Date:   Thu, 22 Sep 2022 08:27:10 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH v2 ipsec 2/2] xfrm: Ensure policy checked for nested ESP
 tunnels
Message-ID: <20220922062710.GE2950045@gauss3.secunet.de>
References: <20220824221252.4130836-1-benedictwong@google.com>
 <20220824221252.4130836-3-benedictwong@google.com>
 <20220830062529.GM2950045@gauss3.secunet.de>
 <CANrj0bYOU0Ekwn6nVQr+c2znbX6wHFry7TUi-Hd4BW78DEw7qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANrj0bYOU0Ekwn6nVQr+c2znbX6wHFry7TUi-Hd4BW78DEw7qA@mail.gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 10:44:42PM -0700, Benedict Wong wrote:
> Thanks for the response; apologies for taking a while to re-patch this
> and verify.
> 
> I think this /almost/ does what we need to. I'm still seeing v6 ESP in v6
> ESP tunnels failing; I think it's due to the fact that the IPv6 ESP
> codepath does not trigger policy checks in the receive codepath until it
> hits the socket, or changes namespace.
> Perhaps if we verify policy unconditionally in xfrmi_rcv_cb? combined
> with your change above, this should ensure IPv6 ESP also checks policies,
> and inside that clear the secpath?

Hm, do you know why this is different to IPv4? IPv4 and IPv6 should
do the same regarding to policy checks.

