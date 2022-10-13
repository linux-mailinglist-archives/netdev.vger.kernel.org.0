Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFF45FD7C7
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJMK1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJMK1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2134FFAA65;
        Thu, 13 Oct 2022 03:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8AF661762;
        Thu, 13 Oct 2022 10:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77115C433C1;
        Thu, 13 Oct 2022 10:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665656863;
        bh=8wbssBlCEp10Djd9Flt2stWHRk9h+A7L4/aVq4pm7lE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V5cTXWdcTa2htEBgqxvwVmHjRPkkOaRUUOxMsg01uqMNrMvgCa/L7FhQYwuoRcFz6
         DI8bs+NgI13fvEd/cnDy4x+/FJBc492PjewSM2663skD7WP0VoNjMXVr3x443LLnkY
         zHzi8DZ9eHc/QQ0aI9Tfnp1IzI7oHhl9AaZjR2i45XxJu1P4KsvPek2Z/pIma6z9rH
         yQ5YazCxdtsqwaUIskuEeeIeW02FVkNgeVlPdqZu3SMCEfyyrF/7Pz01e8WhppyzWr
         SztlhI9WfimG/tB7Ox+sga3b6rghUVyleHcuh6LcU2HzrnHFe3qRbojOmFx3FUii47
         xm1iGYgJDdi6g==
Date:   Thu, 13 Oct 2022 13:27:38 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
Message-ID: <Y0foGrlwnYX8lJX2@unreal>
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal>
 <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
> On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
> > > Hi Leon, hi Saeed,
> > >
> > > We have seen crashes during server shutdown on both kernel 5.10 and
> > > kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
> > >
> > > All of the crashes point to
> > >
> > > 1606                         memcpy(ent->out->first.data,
> > > ent->lay->out, sizeof(ent->lay->out));
> > >
> > > I guess, it's kind of use after free for ent buffer. I tried to reprod
> > > by repeatedly reboot the testing servers, but no success  so far.
> >
> > My guess is that command interface is not flushed, but Moshe and me
> > didn't see how it can happen.
> >
> >   1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
> >   1207         INIT_WORK(&ent->work, cmd_work_handler);
> >   1208         if (page_queue) {
> >   1209                 cmd_work_handler(&ent->work);
> >   1210         } else if (!queue_work(cmd->wq, &ent->work)) {
> >                           ^^^^^^^ this is what is causing to the splat
> >   1211                 mlx5_core_warn(dev, "failed to queue work\n");
> >   1212                 err = -EALREADY;
> >   1213                 goto out_free;
> >   1214         }
> >
> > <...>
> > >
> > > Is this problem known, maybe already fixed?
> >
> > I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.

Sorry it is 5.15.32

> > Is it possible to reproduce this on latest upstream code?
> I haven't been able to reproduce it, as mentioned above, I tried to
> reproduce by simply reboot in loop, no luck yet.
> do you have suggestions to speedup the reproduction?

Maybe try to shutdown during filling command interface.
I think that any query command will do the trick.

> Once I can reproduce, I can also try with kernel 6.0.

It will be great.

Thanks
