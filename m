Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CE5F05FA
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiI3Hry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiI3Hrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:47:53 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB5C1FBC80
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:47:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C3432204A4;
        Fri, 30 Sep 2022 09:47:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LuESBNnM0Y_x; Fri, 30 Sep 2022 09:47:49 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 51E5B2050A;
        Fri, 30 Sep 2022 09:47:49 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 4300180004A;
        Fri, 30 Sep 2022 09:47:49 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 09:47:49 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 30 Sep
 2022 09:47:48 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 376E03182A37; Fri, 30 Sep 2022 09:47:48 +0200 (CEST)
Date:   Fri, 30 Sep 2022 09:47:48 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH v2 ipsec 2/2] xfrm: Ensure policy checked for nested ESP
 tunnels
Message-ID: <20220930074748.GZ2950045@gauss3.secunet.de>
References: <20220824221252.4130836-1-benedictwong@google.com>
 <20220824221252.4130836-3-benedictwong@google.com>
 <20220830062529.GM2950045@gauss3.secunet.de>
 <CANrj0bYOU0Ekwn6nVQr+c2znbX6wHFry7TUi-Hd4BW78DEw7qA@mail.gmail.com>
 <20220922062710.GE2950045@gauss3.secunet.de>
 <CANrj0bZ16_QOr8Tw6Cp6Dv0dM3MzkWKfwFfb7WqT-X3QbvJ8cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANrj0bZ16_QOr8Tw6Cp6Dv0dM3MzkWKfwFfb7WqT-X3QbvJ8cA@mail.gmail.com>
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

On Thu, Sep 22, 2022 at 06:33:55PM -0700, Benedict Wong wrote:
> Ahh, I've never had an IPv4 server without a NAT to test against, I'd presume
> this is identical there. The only comparison that I've been able to do  was IPv4
> UDP-encap vs IPv6 ESP.
> 
> We could instead add the policy check to the ESP input path if that is
> the correct place.

Ok, looks like there is a policy check missing for xfrm_interfaces
when already one (or more) transformations happened.

The best would be to add a separate xfrm_interfaces rcv handler
(in struct xfrm6_protocol/xfrm4_protocol) for esp4/6 and do
the policy check if we have a secpath present.

That should fix it in combination with reseting the secpath in
the policy_check as I did in my previous patch.

