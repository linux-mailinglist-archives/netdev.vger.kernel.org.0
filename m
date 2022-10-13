Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301935FD613
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 10:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJMITB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 04:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJMITA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 04:19:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B850A14BB51;
        Thu, 13 Oct 2022 01:18:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E88DDCE1D6A;
        Thu, 13 Oct 2022 08:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EB9C433D6;
        Thu, 13 Oct 2022 08:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665649132;
        bh=O8bSMpuAhrzFMNlzIJLNqAFCoTEKRAUEdtX1d1jZf/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oI9bG5T03ncB9jLi1e2kqXw2BGAPgSC+isQuC6vjnP2idYTUyQJqThSDoWJdpBEgu
         01y2fwFe8MkmzEfsLsNptGYySxWdaZw8qNt4TiM4DhCUNeSmLuNgtrv0jHiRvsERpp
         zgIjJXX6C0/rRqR0+ELf7WHu4uufldY6QgGmR3lrwP231XdZYbf04MQ2Z4N9UZKmv/
         78ZB9f+4Z6WfvBdGOwMj1hzeSVfHWX3eknQ6CwPXLy47C2+GshtgFsQRTchi9OdVB9
         b/r+xBhTONnBabnHd9ZMASI1dRmagt4qtBOiSmnlqXnAF4AGRzBwXsxOv/Q/PG3UT/
         ba2g65P31frug==
Date:   Thu, 13 Oct 2022 11:18:48 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jinpu Wang <jinpu.wang@ionos.com>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
Message-ID: <Y0fJ6P943FuVZ3k1@unreal>
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
> Hi Leon, hi Saeed,
> 
> We have seen crashes during server shutdown on both kernel 5.10 and
> kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
> 
> All of the crashes point to
> 
> 1606                         memcpy(ent->out->first.data,
> ent->lay->out, sizeof(ent->lay->out));
> 
> I guess, it's kind of use after free for ent buffer. I tried to reprod
> by repeatedly reboot the testing servers, but no success  so far.

My guess is that command interface is not flushed, but Moshe and me
didn't see how it can happen.

  1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
  1207         INIT_WORK(&ent->work, cmd_work_handler);
  1208         if (page_queue) {
  1209                 cmd_work_handler(&ent->work);
  1210         } else if (!queue_work(cmd->wq, &ent->work)) {
                          ^^^^^^^ this is what is causing to the splat    
  1211                 mlx5_core_warn(dev, "failed to queue work\n");
  1212                 err = -EALREADY;
  1213                 goto out_free;
  1214         }

<...>
> 
> Is this problem known, maybe already fixed?

I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
Is it possible to reproduce this on latest upstream code?
And what is your FW version?


> I briefly checked the git, don't see anything, could you give me some hint?
> 
> 
> Thanks!
> Jinpu Wang @ IONOS
