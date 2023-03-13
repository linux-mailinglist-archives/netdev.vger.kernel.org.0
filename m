Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1AD96B7494
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 11:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjCMKsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 06:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjCMKsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 06:48:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8B3C175;
        Mon, 13 Mar 2023 03:48:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E51B8100B;
        Mon, 13 Mar 2023 10:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6570C433D2;
        Mon, 13 Mar 2023 10:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678704486;
        bh=Bp5TXoOJ/Wv93fmFssCfDV9bpII5nb3PWXt4PA5WmWg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HjDXgua77k09CEmzK0n53WvrXHZumhoHS4CpKeTCOGA4U+PeH/L2csFcjeXIpN+qm
         +AXXBqVGre6TRH3WrSl4bSPL8zRzWeGq/cwm94VH1/wPm3+BtwUb7fKHQxALeE0Xu6
         kH6v+50Rscr2skkXey3OgYv0oms+UifnOArvb41D7sHkURgsyMZTRUG+9qhsQ44zfy
         FHgIEro4OXB+r5LVHhxmxn30bNmCBUvVVy9N8fDbk2aIAa/M0WiTqueU84eIRdtJYQ
         7ez5ZP8KL1Kx0r6vCS4sMRWA4nTvZQ+tFarfQoYpVTcxKP/gPTTRX+zPFwDp6y/05C
         g4XXz6Grsy2wA==
Message-ID: <b719944dbe8b8790524a10c1032dfb09a2182cb8.camel@kernel.org>
Subject: Re: [PATCH v3 0/5] sunrpc: simplfy sysctl registrations
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>, chuck.lever@oracle.com,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 13 Mar 2023 06:48:03 -0400
In-Reply-To: <20230311233944.354858-1-mcgrof@kernel.org>
References: <20230311233944.354858-1-mcgrof@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-03-11 at 15:39 -0800, Luis Chamberlain wrote:
> This is my v3 series to simplify sysctl registration for sunrpc. The
> first series was posted just yesterday [0] but 0-day found an issue with
> CONFIG_SUNRPC_DEBUG. After this fix I poasted a fix for v2 [1] but alas
> 0-day then found an issue when CONFIG_SUNRPC_DEBUG is disabled. This
> fixes both cases... hopefully that's it.
>                                                                          =
                                                                           =
                                         =20
> Changes on v3:
>=20
>    o Fix compilation when CONFIG_SUNRPC_DEBUG is disabled.. forgot to
>      keep all the sysctl stuff under the #ifdef.
>=20
> Changes on v2:
>=20
>    o Fix compilation when CONFIG_SUNRPC_DEBUG is enabled, I forgot to mov=
e the
>      proc routines above, and so the 4th patch now does that too.
>                                                                          =
                                                                           =
                                         =20
> Feel free to take these patches or let me know and I'm happy to also
> take these in through sysctl-next. Typically I use sysctl-next for
> core sysctl changes or for kernel/sysctl.c cleanup to avoid conflicts.
> All these syctls however are well contained to sunrpc so they can also
> go in separately. Let me know how you'd like to go about these patches.
>                                                                          =
                                                                           =
                                         =20
> [0] https://lkml.kernel.org/r/20230310225236.3939443-1-mcgrof@kernel.org
>=20
> Luis Chamberlain (5):
>   sunrpc: simplify two-level sysctl registration for tsvcrdma_parm_table
>   sunrpc: simplify one-level sysctl registration for xr_tunables_table
>   sunrpc: simplify one-level sysctl registration for xs_tunables_table
>   sunrpc: move sunrpc_table and proc routines above
>   sunrpc: simplify one-level sysctl registration for debug_table
>=20
>  net/sunrpc/sysctl.c             | 42 ++++++++++++---------------------
>  net/sunrpc/xprtrdma/svc_rdma.c  | 21 ++---------------
>  net/sunrpc/xprtrdma/transport.c | 11 +--------
>  net/sunrpc/xprtsock.c           | 13 ++--------
>  4 files changed, 20 insertions(+), 67 deletions(-)
>=20

Nice little cleanup.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
