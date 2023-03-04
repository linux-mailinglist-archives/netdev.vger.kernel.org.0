Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5036D6AA6BE
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 02:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjCDBGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 20:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCDBGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 20:06:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B0C60D71;
        Fri,  3 Mar 2023 17:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15C7D6198B;
        Sat,  4 Mar 2023 01:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386EFC433D2;
        Sat,  4 Mar 2023 01:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677891969;
        bh=UXbys7Cz4LeFgY1F56ERVnCp6cgKc61f/aBxSSGYwAc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fdr+LhsH9XQRmRXOvgQAs7uD3zHtmBzVoKYBmaYr7BSU9oUS8lCZJ8nOs7MhSmXXP
         watGo+4te3ESQyvhFhO+++xvIX939cUj4t0n7lAMf1r3c/anxzC8CJ+QxfDwPJh/Rd
         GfyCX3VffYgN8KSfU8fuv9y/fZj2oXQzb+IHNKSTwZJ7ZkcTd4gMzBD7zfrT6wj6Nw
         MInd4aWNlg9HEA4BxXcPwBCGejiYR6a0KXD3VhI7T74MxTICFPjO6Qa6qWaNVvLBfc
         vIpBckf4RgL0ZIbOJ+zjTCMvFijvJXm95EtLiEgCMPabV8yx2KARZTwisfnmBIb0dm
         hQ6JKPV7w8fmw==
Date:   Fri, 3 Mar 2023 17:06:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "liujian (CE)" <liujian56@huawei.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [Qestion] abort backport commit ("net/ulp: prevent ULP without
 clone op from entering the LISTEN status") in stable-4.19.x
Message-ID: <20230303170608.5ffe9181@kernel.org>
In-Reply-To: <ea1af62dfc3e43859c1cb278f39d1a6f@huawei.com>
References: <ea1af62dfc3e43859c1cb278f39d1a6f@huawei.com>
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

On Fri, 3 Mar 2023 10:52:15 +0000 liujian (CE) wrote:
> When I was working on CVE-2023-0461, I found the below backport commit in stable-4.19.x maybe something wrong?
> 
> 755193f2523c ("net/ulp: prevent ULP without clone op from entering the LISTEN status") 
> 
> 1.  err = -EADDRINUSE in inet_csk_listen_start() was removed. But it
>     is the error code when get_port() fails. 

I think you're right, we should add setting the err back.

>  2. The change in __tcp_set_ulp() should not be discarded?

That part should be fine, all ULPs in 4.19 (i.e. TLS) should fail
the ->init() call if sk_state != ESTABLISHED.
