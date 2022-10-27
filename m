Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF1760F096
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 08:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbiJ0GsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 02:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbiJ0GsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 02:48:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B98148FE4;
        Wed, 26 Oct 2022 23:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D40621A6;
        Thu, 27 Oct 2022 06:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD611C433C1;
        Thu, 27 Oct 2022 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666853302;
        bh=WfnvbZ0ZCG3kuH4jEsDaJ1/vqilkTKeoMzcOu0I4SPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kysx0dc6L/J0j3nGVVM2jJFOtqJIRbGQx5Y3yxQpNzm7DLQpaQQZjKTg4Iv01dVxS
         ALAPc63FhXCIsLFO3+dSkJEfWZwktJpfSSygdudzkl2vgFq6o4YbPdQAIrSqkj22Cu
         d2S2Dr8xeqVfH7UfulHYlNpfKSyx9LYqSRuGJzko=
Date:   Thu, 27 Oct 2022 08:49:15 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Russ Weight <russell.h.weight@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] cred: Do not default to init_cred in
 prepare_kernel_cred()
Message-ID: <Y1op6wgDSPu4MGB8@kroah.com>
References: <20221026232943.never.775-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221026232943.never.775-kees@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 04:31:11PM -0700, Kees Cook wrote:
> A common exploit pattern for ROP attacks is to abuse prepare_kernel_cred()
> in order to construct escalated privileges[1]. Instead of providing a
> short-hand argument (NULL) to the "daemon" argument to indicate using
> init_cred as the base cred, require that "daemon" is always set to
> an actual task. Replace all existing callers that were passing NULL
> with &init_task.
> 
> Future attacks will need to have sufficiently powerful read/write
> primitives to have found an appropriately privileged task and written it
> to the ROP stack as an argument to succeed, which is similarly difficult
> to the prior effort needed to escalate privileges before struct cred
> existed: locate the current cred and overwrite the uid member.
> 
> This has the added benefit of meaning that prepare_kernel_cred() can no
> longer exceed the privileges of the init task, which may have changed from
> the original init_cred (e.g. dropping capabilities from the bounding set).
> 
> [1] https://google.com/search?q=commit_creds(prepare_kernel_cred(0))
> 
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Russ Weight <russell.h.weight@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Ronnie Sahlberg <lsahlber@redhat.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> Cc: Anna Schumaker <anna@kernel.org>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Michal Koutný" <mkoutny@suse.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Cc: linux-nfs@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
