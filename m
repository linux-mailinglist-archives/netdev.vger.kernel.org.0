Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CF960FE5C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbiJ0REi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbiJ0REf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:04:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A339EB2;
        Thu, 27 Oct 2022 10:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=7b7C/ijuroDIL3g2LJeA1erBrGymNSgI0ci8IdF68Qg=; b=WfryvM1m33ygkKW/yTjZ79jLbI
        LOxsz57Rpn/jQxWde0O9UrFzTRSojqZN1rDY3Ptaefb0Ncsx7VWcB/587VLefdpRpqRJnln/fGKli
        TK6lIYLC2iy2F67nT1vAEmAD8x2GoiS2fsPGR1KLflaUEVabqPH7fguSWyzj9Bj6tztfZg9CRxRt0
        eXz6pngq8nUdxVKQ83rxHIJ6GTu5sZuuWImwWhjU3dnOpoY9bfGbniJNNk1UlMTjoGf5/8ixavmzb
        MFfbokKNWSpPiVSUcaL0se7/H3UZSNthZWiAiwx/gVyxFs6p1fO/X/uX6GmYjir5VfZR0W9qojx6f
        rHKnsmaA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oo6Ht-00EI0i-Sg; Thu, 27 Oct 2022 17:03:25 +0000
Date:   Thu, 27 Oct 2022 10:03:25 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        Russ Weight <russell.h.weight@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <Y1q53XlLE2n9yGH7@bombadil.infradead.org>
References: <20221026232943.never.775-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221026232943.never.775-kees@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
