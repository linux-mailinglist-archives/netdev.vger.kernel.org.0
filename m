Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D95185EE
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbiECNwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236512AbiECNww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:52:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A037BF4;
        Tue,  3 May 2022 06:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 582C0B81EE9;
        Tue,  3 May 2022 13:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49ADC385A4;
        Tue,  3 May 2022 13:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651585757;
        bh=epxYQZZTmHI4aCAOe7GCT+V+LEIBCbJAeEQ3a0vF/KA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=elhyrzn9VZJ98O3LFHSbVIx6Vybmy/RvPS2ACDxJFJfPHD7ZQGc0erc2FHgJQs87d
         mNDM8rTNowY5an1Grsb8DHjyKDCZqI9bij3hs4Jxd0oP1xR+drXtddY0nDm/rfEL0D
         w63qRCPtBGXBIu1BmfzJiOJEqPTfdjEsI0+qg1lY=
Date:   Tue, 3 May 2022 15:49:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        davem@davemloft.net, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, vladbu@mellanox.com
Subject: Re: [PATCH 4.9.y] net: sched: prevent UAF on tc_ctl_tfilter when
 temporarily dropping rtnl_lock
Message-ID: <YnEy2726cz98I6YC@kroah.com>
References: <20220502204924.3456590-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502204924.3456590-1-cascardo@canonical.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 05:49:24PM -0300, Thadeu Lima de Souza Cascardo wrote:
> When dropping the rtnl_lock for looking up for a module, the device may be
> removed, releasing the qdisc and class memory. Right after trying to load
> the module, cl_ops->put is called, leading to a potential use-after-free.
> 
> Though commit e368fdb61d8e ("net: sched: use Qdisc rcu API instead of
> relying on rtnl lock") fixes this, it involves a lot of refactoring of the
> net/sched/ code, complicating its backport.

What about 4.14.y?  We can not take a commit for 4.9.y with it also
being broken in 4.14.y, and yet fixed in 4.19.y, right?  Anyone who
updates from 4.9 to 4.14 will have a regression.

thanks,

greg k-h
