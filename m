Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056304DCA2E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiCQPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbiCQPma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:42:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E0820DB0E
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 08:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCF43619B6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 15:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E762FC340E9;
        Thu, 17 Mar 2022 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647531672;
        bh=9I2dAWgxXLxBOXiWW+TdpoXCVZtG08SYonWZxFAvx84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r1mVBzybsbmqL/oCwZL6lpg9VMmUqEzMY+vOpO8ICJ9xiDcIqAXN0856zO4v80RBA
         KxGcMWqtx01P/Y1I0pWH3W08ZDWK9XZ9lCnc1f4f93f+HOncjSXanbELyt+SP1LpxA
         Q3QiLydBUZlxYk2bn4xiO13i4/55hkTNXTgWU2ccb2sDokoOKV1xTJ/l0FtJVQPEEB
         +TvoEibQsEfQvMv+uO1PRVKC/7CwAFpNsVTjJ76i64oK43KbhoGoaLaOK32xoZ2UGk
         Ojiji0URB86Ayaig7ftka1/J2TWET93FX2CfVtvZ6l9zaGk1XAwaI6smu2YF6jRWoC
         uI2lvXeGH7dLQ==
Date:   Thu, 17 Mar 2022 08:41:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next 5/5] devlink: hold the instance lock during
 eswitch_mode callbacks
Message-ID: <20220317084110.76b3ba2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YjLoqpwsgJdXeIGq@unreal>
References: <20220317042023.1470039-1-kuba@kernel.org>
        <20220317042023.1470039-6-kuba@kernel.org>
        <YjLoqpwsgJdXeIGq@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Mar 2022 09:52:10 +0200 Leon Romanovsky wrote:
> On Wed, Mar 16, 2022 at 09:20:23PM -0700, Jakub Kicinski wrote:
> > Make the devlink core hold the instance lock during eswitch_mode
> > callbacks. Cheat in case of mlx5 (see the cover letter).  
> 
> And this is one the main difference between your and mine proposals/solutions.
> I didn't want to cheat as it doesn't help to the end goal - remove devlink_mutex.
> 
> Can you please change the comments in mlx5 to be more direct?
> "/* TODO: convert the driver to devl_* */"
> ->  
> "/* FIXME: devl_unlock() followed by devl_lock() inside driver callback
>   * never correct and prone to races. Never repeat this pattern.
>   *
>   * This code MUST be fixed before removing devlink_mutex as it is safe
>   * to do only because of that mutex.
>   */"
> 
> Something like that.

Should I add this comment in all the spots I'm adding the re-locking?
Does it make sense to add a wrapper:

/* FIXME: devl_unlock() followed by devl_lock() inside driver callback
 * never correct and prone to races. Never repeat this pattern.
 *
 * This code MUST be fixed before removing devlink_mutex as it is safe
 * to do only because of that mutex.
 */
static void mlx5_eswtich_mode_callback_enter(...)
{
	devl_unlock(devlink);
 	down_write(&esw->mode_lock);
}

and respective helper for "leave" ?

> The code is correct, but like I said before, I don't like the direction.
> I expect that this anti-pattern is going to be copy/pasted very soon.

Yeah, this is most certainly a very temporary hack.

BTW is there a chance for me to access a fully featured mlx5 system
somehow to test the future conversion patches? Or perhaps you or
someone on the team would be interested in doing the conversion?

> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Thanks!
