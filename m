Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4FA6AAC47
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 21:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCDUBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 15:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCDUBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 15:01:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE63F1027D
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 12:01:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80A82B80066
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 20:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE628C433EF;
        Sat,  4 Mar 2023 20:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677960069;
        bh=XHUkjlGl6YMveNo/D5NHcDsDijIjGM/aC5XPwcQueN4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wp/c9I9L3/I7Q/kouNmWupSrMjxag1Np3yWjwPD7FPRGDdz4xDPwRj7G2Rn6AGj3k
         JyT2JSIdQ2Ne/5H0QO1yMgymFQM8ZYe4VnI4uvbyFL1/7HhqFv/EgMMJ0z6pmPLfgF
         qzOYxu2P/0Y1sKs+c4uGAFP16lDuJI+brjLMnTTILLimWQu8Z9JuxM2kHlzPUhmI/b
         D3RI8BUsA1pHyZFAfh7dgH2/7SLKV8kg34KFYipXPOLNfDGf6UsqrRzp1E0fRlwWsm
         N7FBXwgOQ4OmiJUEsfN7OHVWB7mXBdOvh7whzEeJjxl9tgyeAjnQ+LxoQZPMQT2WNA
         mZ1cPZpmR1ttA==
Date:   Sat, 4 Mar 2023 12:01:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230304120108.05dd44c5@kernel.org>
In-Reply-To: <C236CECE-702B-4410-A509-9D33F51392C2@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
        <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
        <20230303182131.1d1dd4d8@kernel.org>
        <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
        <83CDD55A-703B-4A61-837A-C98F1A28BE17@oracle.com>
        <20230304111616.1b11acea@kernel.org>
        <C236CECE-702B-4410-A509-9D33F51392C2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 Mar 2023 19:48:51 +0000 Chuck Lever III wrote:
> >>> 2. The SPDX tags in the generated source files is "BSD
> >>>  3-clause", but the tag in my spec is "GPL-2.0 with
> >>>  syscall note". Oddly, the generated uapi header still
> >>>  has the latter (correct) tag.  
> > 
> > I was trying to go with least restrictive licenses for the generated
> > code. Would BSD-3-clause everywhere be okay with you?  
> 
> IIUC we cannot generate source code from a GPL-encumbered
> specification and label that code with a less-restrictive
> license. Isn't generated source code a "derived" artifact?
> 
> The spec lives in the kernel tree, therefore it's covered.
> Plus, my employer requires that all of my contributions
> to the Linux kernel are under GPL v2.
> 
> I'd prefer to see all my generated files get a license
> that matches the spec's license.
> 
> You could add an spdx object in the YAML schema, and output
> the value of that object as part of code generation.
> 
> To be safe, I'd also find a suitably informed lawyer who
> can give us an opinion about how this needs to work. I've
> had a similar discussion about the license status of a
> spec derived from source code, so I'm skeptical that we
> can simply replace the license when going to code from
> spec.
> 
> If you need to require BSD-3-clause in this area, I can
> request an exception from my employer for the YAML that
> is contributed as part of the handshake mechanism.

The choice of BSD was to make the specs as easy to use as possible.
Some companies may still be iffy about GPL, and it's all basically
an API, not "real code".

If your lawyers agree we should require BSD an all Netlink specs,
document that and make the uAPI also BSD.

> Sorry to make trouble -- hopefully this discussion is also
> keeping you out of trouble too.

I was hoping choice of BSD would keep me out of trouble :)
My second choice was to make them public domain.. but lawyers should
like BSD-3-clause more because of the warranty statement.
