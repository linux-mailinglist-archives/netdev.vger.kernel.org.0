Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009FC574211
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiGND6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGND6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:58:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F20726ADE;
        Wed, 13 Jul 2022 20:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 92226CE2358;
        Thu, 14 Jul 2022 03:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C31DC34115;
        Thu, 14 Jul 2022 03:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657771106;
        bh=oo63PaGjPpwIVhi/pmHBgQPiQmqbOpRR7v0EHyoS0Tg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QIeYv8YcxlMDJrwSoqk6B3PrfnNHl9b7zTww1m7GhJdryiyDFihSYcx/jytelcXkA
         Qiv6ixVNE9yGH8H67D4NGtDwtWZynoR6aq2MsiHdGP3DmtSdFs6y+kR7ECMJcJFK/p
         dYtsu0MVEmr691XCw9WkxHLaUUoJDfpkBPYHCxjIfrRSWbXbmeY34tLO1J3dJoDTNN
         FyvYKcfo1Gp5ETvy6ti1gXIkddObNlUeHlrDWSDIcqpufrpbw54eoaTwSgWDX6liWh
         5LSLkraiM6j9HIozN3M+sDukWfLiCPo6bv+a6WJouVTaRYXHjUuDjZ8/8YTofbVR8n
         tBz+6iHfxW2Tw==
Date:   Wed, 13 Jul 2022 20:58:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Khalid Masum <khalid.masum.92@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        syzbot+1fa91bcd05206ff8cbb5@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 0/1][RESEND] Fix KASAN: slab-out-of-bounds Read in
 sk_psock_get
Message-ID: <20220713205825.33ea6e9c@kernel.org>
In-Reply-To: <CAABMjtG9PDPUm9vrK-Kho7WW+V5h9MmMox1EiLuvfKfiCNp=xw@mail.gmail.com>
References: <20220713181324.14228-1-khalid.masum.92@gmail.com>
        <20220713115622.25672f01@kernel.org>
        <CAABMjtG9PDPUm9vrK-Kho7WW+V5h9MmMox1EiLuvfKfiCNp=xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 09:55:18 +0600 Khalid Masum wrote:
> On Thu, Jul 14, 2022 at 12:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 14 Jul 2022 00:13:23 +0600 Khalid Masum wrote:  
> > > Using size of sk_psock as the size for kcm_psock_cache size no longer
> > > reproduces the issue. There might be a better way to solve this issue
> > > though so I would like to ask for feedback.
> > >
> > > The patch was sent to the wrong mailing list so resending it. Please
> > > ignore the previous one.  
> >
> > What happened to my other off-list feedback?
> >
> > I pointed you at another solution which was already being discussed -
> > does it solve the issue you're fixing?  
> 
> Yes, this patch solves the issue I am fixing.

Thanks for checking! You can send your

Tested-by:

tag in reply to the most recent posting if you'd like:

https://lore.kernel.org/all/165772238175.1757.4978340330606055982.stgit@oracle-102.nfsv4.dev/
