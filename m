Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA0A51B506
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 03:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbiEEBIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 21:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbiEEBIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 21:08:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80F447AFB;
        Wed,  4 May 2022 18:04:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 699D6B82A69;
        Thu,  5 May 2022 01:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997EFC385A4;
        Thu,  5 May 2022 01:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651712663;
        bh=pZLuMeNAgUNcbS/PanWHI1lSbd0SgUz6JW2DMcazGG0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rYn3rfEdkA8gadJ6zmJtrML2lFdBln8AGWwm2PtGmxDlAwODtPQNB70e62V/st4ah
         83NPMZYoYBEs/uD+Et3WM8gT6jLs7DcDNjFVusWn/hTD3rsC5hENPHDaThdSDfuwvn
         wfO6/EXAhEFg/4Cq5gQXwohKP7KuXcddQCQ0va7FcxOTcy5lpkOckhlJLaemo9CNNG
         IzxSp5xN3I4QhLJhLVhj8RA7FG4j388C3YrSsnxieE+/fYfBkwEPBSm3cxHM18B7t3
         e1GUl2uEgZ2DovQIGThk9pjBuO/APX28BHEb3YSmXYWb1PfaC+d7Q2U+9krj8kQD8n
         O9rpBNG4qo7rg==
Date:   Wed, 4 May 2022 18:04:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        patchwork-bot+netdevbpf@kernel.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH] net: rds: use maybe_get_net() when acquiring refcount
 on TCP sockets
Message-ID: <20220504180421.52517113@kernel.org>
In-Reply-To: <63dab11e-2aeb-5608-6dcb-6ebc3e98056e@I-love.SAKURA.ne.jp>
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
        <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
        <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
        <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
        <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
        <CANn89iJOt9oC_sSmVhRx8fyyvJ2hWzYKcTfH1Rvbzpt5aP0qNA@mail.gmail.com>
        <bf5ce176-35e6-0a75-1ada-6bed071a6a75@I-love.SAKURA.ne.jp>
        <5f3feecc-65ad-af5f-0ecd-94b2605ab67e@I-love.SAKURA.ne.jp>
        <63dab11e-2aeb-5608-6dcb-6ebc3e98056e@I-love.SAKURA.ne.jp>
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

On Thu, 5 May 2022 09:45:49 +0900 Tetsuo Handa wrote:
> Subject: [PATCH] net: rds: use maybe_get_net() when acquiring refcount on TCP  sockets

Please tag the next version as [PATCH net v2], and make sure it applies
cleanly on top of net/master, 'cause reportedly this one didn't?
https://patchwork.kernel.org/project/netdevbpf/patch/63dab11e-2aeb-5608-6dcb-6ebc3e98056e@I-love.SAKURA.ne.jp/
