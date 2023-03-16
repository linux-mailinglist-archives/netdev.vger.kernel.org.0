Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720306BC524
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCPENh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCPENf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:13:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A4CF5;
        Wed, 15 Mar 2023 21:13:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9877B81FAE;
        Thu, 16 Mar 2023 04:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034F8C433D2;
        Thu, 16 Mar 2023 04:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678940011;
        bh=/vkENVYbl9rQQb5myrhkfxj3bBDX+uOnK0ur5TU1qcg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rReSarK9Ipn1MEHR+xeV7sFiDYAr3vfrm+P+KyOUzmpxH8gVmtp19iM6PGlJ2jgBy
         Jc5HPSDiLWK5XT2zy5i0gSxZgqwEVwEez7l7pXd93mqWPbohb/EybavQDehtlGNSo+
         l6V8IjlTgMLc7ryxc05ktQkl8ZZwcx39ITJdOgI9sveSTz7k8OjwDw0L6lFawgVPYw
         SkwAdPaAXO1+3JSCBIakY8ugDJvPzRHhUWBTqLxqzah/mzvBK0yxSzicjXvDO0d8/5
         6zA09kdyoOtmLk9OBoz94S0QHGH5jV49OYE0nuAcOEUHVhxm5JU1yPO4XN/AKFzWrC
         L8whxJ35KTa0Q==
Date:   Wed, 15 Mar 2023 21:13:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Message-ID: <20230315211329.1c7b3566@kernel.org>
In-Reply-To: <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
        <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
        <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
        <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
        <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
        <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
        <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
        <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
        <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
        <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
        <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 04:03:52 +0000 Ronak Doshi wrote:
> > Calling netif_receive_skb() with NETIF_F_GRO bit set in netdev->feature=
s will cause
> > confusion for user, IMHO. =20
> As long as LRO is enabled and performed by ESXi (which it will do), I don=
=E2=80=99t think user cares for GRO.
> Even if we use napi_gro_receive() for such case, it degrades the performa=
nce as unnecessary cycles
> are spend on an already LRO'ed packet.

Can you provide some numbers to illustrate what the slow down is?
