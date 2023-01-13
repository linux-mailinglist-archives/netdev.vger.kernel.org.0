Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BB366A384
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjAMTlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAMTkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:40:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9737A218;
        Fri, 13 Jan 2023 11:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 880806230A;
        Fri, 13 Jan 2023 19:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D026C433D2;
        Fri, 13 Jan 2023 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638809;
        bh=waX/JA6eiJ5hDp/ud/Y/Vuyo9m1cQdYSF7z+G90JTkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WkXpj155J406AN6oBp+RCxDg1dK59zl3/seLtmwPbB+G1TQ5thsjjwF55m11/7chs
         TkPskThXZEJllpzvK7wUSCPZitCrrXg1i2PY/4Cd9XFFn5lTh4aAD4V9ItEshjAJJ2
         LnpfcV18CNce6OXWfQfVrzXCl5S/UoxgVDQCx0lfEgW4VDVVmpn0mrdyYy+VULvMTZ
         68fwwyFGBHWyrrBFU9siN09cxypIybQ7Fm+2KpYhoyUH1uQ74q6m9Nwb718M/eKgXE
         t0i93cuWXzO3+djyQgP7gRdY0lq9pcKyYcSfCuSi8Ytd/q/2N7q0CwJZNSyUJYtswc
         FQv+J7tHZbnDg==
Date:   Fri, 13 Jan 2023 11:40:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        Dan Carpenter <error27@gmail.com>,
        kernel test robot <lkp@intel.com>,
        syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix wrong error return in
 rxrpc_connect_call()
Message-ID: <20230113113959.75b0fe38@kicinski-fedora-PC1C0HJN>
In-Reply-To: <2438405.1673460435@warthog.procyon.org.uk>
References: <2438405.1673460435@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 18:07:15 +0000 David Howells wrote:
> Fix rxrpc_connect_call() to return -ENOMEM rather than 0 if it fails to
> look up a peer.
> 
> This generated a smatch warning:
>         net/rxrpc/call_object.c:303 rxrpc_connect_call() warn: missing error code 'ret'
> 
> I think this also fixes a syzbot-found bug:
> 
>         rxrpc: Assertion failed - 1(0x1) == 11(0xb) is false
>         ------------[ cut here ]------------
>         kernel BUG at net/rxrpc/call_object.c:645!
> 
> where the call being put is in the wrong state - as would be the case if we
> failed to clear up correctly after the error in rxrpc_connect_call().

Applied, thanks!
