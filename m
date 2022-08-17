Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3016C596EAE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiHQMnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiHQMnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:43:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E0F6E898;
        Wed, 17 Aug 2022 05:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7F2960B78;
        Wed, 17 Aug 2022 12:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2BCC433C1;
        Wed, 17 Aug 2022 12:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660740212;
        bh=P8dzIB6z9ULz5JdX7NsNy556/nb7bdo5QwU2w5AaOdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eh5UOsm3JKInvaIdzkcuPePBtvl3iaFrl+McsEBiFesgxM08TS4cg2yaraXsDxY1K
         m2mAuiTki4RDuH+hftVvzEqfIR0EjIifVKgrvppAS9CmVON6HJFnhkKS88B8FbfjNX
         DMKc2ubd+LQ8ARqvJlchkNDcDUexCv8JKjB/gXzs=
Date:   Wed, 17 Aug 2022 14:43:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, johannes@sipsolutions.net,
        rafael@kernel.org
Subject: Re: [PATCH v7 1/2] devcoredump: remove the useless gfp_t parameter
 in dev_coredumpv and dev_coredumpm
Message-ID: <YvzicURy8t2JdQke@kroah.com>
References: <cover.1660739276.git.duoming@zju.edu.cn>
 <b861ce56ba555109a67f85a146a785a69f0a3c95.1660739276.git.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b861ce56ba555109a67f85a146a785a69f0a3c95.1660739276.git.duoming@zju.edu.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 08:39:12PM +0800, Duoming Zhou wrote:
> The dev_coredumpv() and dev_coredumpm() could not be used in atomic
> context, because they call kvasprintf_const() and kstrdup() with
> GFP_KERNEL parameter. The process is shown below:
> 
> dev_coredumpv(.., gfp_t gfp)
>   dev_coredumpm(.., gfp_t gfp)
>     dev_set_name
>       kobject_set_name_vargs
>         kvasprintf_const(GFP_KERNEL, ...); //may sleep
>           kstrdup(s, GFP_KERNEL); //may sleep
> 
> This patch removes gfp_t parameter of dev_coredumpv() and dev_coredumpm()
> and changes the gfp_t parameter of kzalloc() in dev_coredumpm() to
> GFP_KERNEL in order to show they could not be used in atomic context.
> 
> Fixes: 833c95456a70 ("device coredump: add new device coredump class")
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
> Changes in v7:
>   - Remove gfp_t flag in amdgpu device.

Again, this creates a "flag day" where we have to be sure we hit all
users of this api at the exact same time.  This will prevent any new
driver that comes into a maintainer tree during the next 3 months from
ever being able to use this api without cauing build breakages in the
linux-next tree.

Please evolve this api to work properly for everyone at the same time,
like was previously asked for so that we can take this change.  It will
take 2 releases, but that's fine.

thanks,

greg k-h
