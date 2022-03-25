Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239D34E7DCE
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiCYXNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 19:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbiCYXNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 19:13:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF71522E4;
        Fri, 25 Mar 2022 16:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00E7A61744;
        Fri, 25 Mar 2022 23:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE0AC2BBE4;
        Fri, 25 Mar 2022 23:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648249925;
        bh=rca50a/MBSKGcXibi+6OsSu/0GluBeVQE48yXlUn5Wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ek59Z3uvGRyrKysXMw8xAX+tagCv00LsHDEQHKWoo7rLCFOZbpWGiXxfTCATZzISl
         d+1ieHRRfPCVS2ImeDrqxvWebuoJdEt1NfC8YJ6VImsZQR+XGgoxNVXvUrFKQJM+KE
         F0Stp4aK1LSQ4B+7NR5makSJTHf5I0ye4iJ0KZ7UFkuPb3F7JEw6br4fQsLCaPxSuu
         PWoYUuF4WGN+f4cRC8DSuI21O0x+sObWbilAbqUwz9zM47AhjoxGKdpSVaTCMC+25x
         MzZe/p6I5zcPh8t/BlxiuHnROYvz67z74cOjlJ+MpucQpk4AN6he4gFT7Q8UAM4imV
         EagBhg5l+iChg==
Date:   Fri, 25 Mar 2022 16:12:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>
Subject: Re: kselftest: net: tls: hangs
Message-ID: <20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
References: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
        <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 16:13:33 -0600 Shuah Khan wrote:
> > # #  RUN           tls.13_sm4_gcm.splice_cmsg_to_pipe ...
> > # # tls.c:688:splice_cmsg_to_pipe:Expected splice(self->cfd, NULL,
> > p[1], NULL, send_len, 0) (10) == -1 (-1)
> > # # tls.c:689:splice_cmsg_to_pipe:Expected errno (2) == EINVAL (22)
> > # # splice_cmsg_to_pipe: Test terminated by timeout
> > # #          FAIL  tls.13_sm4_gcm.splice_cmsg_to_pipe
> > # not ok 217 tls.13_sm4_gcm.splice_cmsg_to_pipe
> > # #  RUN           tls.13_sm4_gcm.splice_dec_cmsg_to_pipe ...
> > # # tls.c:708:splice_dec_cmsg_to_pipe:Expected recv(self->cfd, buf,
> > send_len, 0) (10) == -1 (-1)
> > # # tls.c:709:splice_dec_cmsg_to_pipe:Expected errno (2) == EIO (5)
> > [  661.901558] kworker/dying (49) used greatest stack depth: 10576 bytes left  
> 
> This seems to be the problem perhaps.
>
> Jakub, any thoughts. The last change to tls.c was a while back.

Yes, sorry, kicked off a build and got distracted.

I can repro the failures, TLS=n in the config I must have not tested
that in the new cases.

But I can't repro the hung, and we have a timer at the hardness level
IIUC so IDK how this could "hang"?

Naresh, is there any stack trace in the logs? Can you repro on Linus's
tree?
