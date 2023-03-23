Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3794D6C5E6F
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCWFJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCWFJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:09:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB9B19119
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:08:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB50CCE2020
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D14C433EF;
        Thu, 23 Mar 2023 05:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548125;
        bh=O+ezgk3Jk7o7eVUUqgYs3nMg+rutiWTNx1RHi+amYUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZcC0Ef6Ff5jMm/Qd618MO5JXCQHY/rlBPNcrtkXGI5LvOLjqCDkf6t9Yy3WEEFRXG
         CaSSNYBtIHOSZBCWcLRSc4/WtVGn1S88aPECj4tXYPZVqrlGOpc4ddAOROupbqvWWj
         gsCs3nHVDSbwEXKdiFIC5V2VynSRJlBp05vNGjwT3Oo9qmo+ZWBtoLhD6def8sTN5L
         8Dkv7mpSpc3Hk311gbZiZAwYMH8f2TgCIUyX1IPlaqvZUcl/K5b5Zpj5JFC9ZxY2sC
         H4xTvrs+bGjGbBiSRtq66wXDLFpkW/oHYSMgRdRSwBt7GXAjztpzoADfn9m8pC8zcf
         ocA11sFOCAAew==
Date:   Wed, 22 Mar 2023 22:08:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, willemb@google.com, alexander.duyck@gmail.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230322220843.6db66d98@kernel.org>
In-Reply-To: <CALs4sv3O73a+KT8wbQvFnGFj7Rzxbxz07j79sUWB4BybMSHDXg@mail.gmail.com>
References: <20230322233028.269410-1-kuba@kernel.org>
        <CALs4sv3O73a+KT8wbQvFnGFj7Rzxbxz07j79sUWB4BybMSHDXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 10:23:32 +0530 Pavan Chebbi wrote:
> > +               /* We need to check again in a case another             \
> > +                * CPU has just made room available.                    \
> > +                */                                                     \
> > +               if (likely(get_desc < start_thrs)) {                    \  
> 
> I am only curious to understand why initializing _res with likely
> result and having a condition to cover only the unlikely case, would
> not be better.
> As in:
>     int _res = 0;
>     if (unlikely(get_desc >= start_thrs) {
>         start_queue()
>         _res = -1
>     }

I don't think it matters.
