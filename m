Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DF76EAC43
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjDUOGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjDUOGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:06:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFAD7A9A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:06:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3323164EDA
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFC9C433D2;
        Fri, 21 Apr 2023 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682085960;
        bh=i+N2V/d50Ft8adm5MoM5vO0MWvFL7k9UnvSDaoi3iq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UWOD5WhmUnpRjIHZ3xZwhj1dAXL+EPdnLzpqy4pA33UwnFlkTxm4tgqA4ODFphzeQ
         pEMZBumXr3eudfIhFAujoK0XeXboyiPe2sGQXHeGSapDwVft0BiDnKDSzkef/GkALY
         X58MOJnOb+gl7VQHZwdxw4RNfaI0VpcRxgrCwNtLcypUGDUXOVsKW7JVQKVpicy8nO
         40WPmHIemPOSGayWLJAe14KjsbMAVL7QWrBuEb46868LX2XXGLbQBnikyTK6NLG7NF
         9i9q0bmxtGwqUIqHK6XPsf1NmvI4Bv41ci/S/Q4Ed+HU9ymUnYuXbfRi44TUZ1Tu3z
         2WNDsOCNwsSjA==
Date:   Fri, 21 Apr 2023 07:05:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 5/5] net: optimize napi_threaded_poll() vs
 RPS/RFS
Message-ID: <20230421070559.36a3e6a0@kernel.org>
In-Reply-To: <d84e9f5056c4945cb4cfcc68c89986d3094b95b7.camel@redhat.com>
References: <20230421094357.1693410-1-edumazet@google.com>
        <20230421094357.1693410-6-edumazet@google.com>
        <d84e9f5056c4945cb4cfcc68c89986d3094b95b7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 15:09:58 +0200 Paolo Abeni wrote:
> >  #endif
> > +
> >  	bool			in_net_rx_action;
> > +	bool			in_napi_threaded_poll; =20
>=20
> If I'm correct only one of the above 2 flags can be set to true at any
> give time. I'm wondering if could use a single flag (possibly with a
> rename - say 'in_napi_polling')?
>=20
> Otherwise LGTM, many thanks!

No strong feelings either way but FWIW my intuition would be that it's
less confusing to keep the two separate (there seems to be no cost to
it at this point) =F0=9F=A4=B7=EF=B8=8F
