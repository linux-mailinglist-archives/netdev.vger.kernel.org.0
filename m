Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4353B6A2BD9
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjBYVPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBYVPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:15:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C33EB55;
        Sat, 25 Feb 2023 13:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E1B60B83;
        Sat, 25 Feb 2023 21:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B57C433D2;
        Sat, 25 Feb 2023 21:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677359730;
        bh=BpARRTf6rfSnrbYTS3JhjbbD0rRqVzMgAzySjmTujaE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eW/VvIWtrdKm6TFABFItNxDj9LjVdVhS3YUZob5rVdGDxAZYy3egVPnGfmoFFqokB
         Hxv4vAXnWrLD6trFC6sRzBqRlPVgSX7yFw0b13ZhSK2N48eEwvVoWWhBQLJoVFVY9m
         0HFDH+VkrTUx8MntpurXdow845n1yKfv4kDNGCyvxV/9WbSiaSZ2pAbUHRCXlZ/UwI
         y5kaB8brNYmePy5lPUNvVt0q4hRERM7Ln51S+uSRPo9MUfshcRCNYDupPST7AQjYCc
         pbgWJZRM9sE4f1V1Tb2DtXSIOvMRX1pHaYoHOuvramjm8p8L3AS6e2nA3NpMRE+wFV
         f4GVKl0DXliQQ==
Date:   Sat, 25 Feb 2023 14:15:27 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, paulb@nvidia.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/sched: cls_api: Move call to
 tcf_exts_miss_cookie_base_destroy()
Message-ID: <Y/p6b4rGiUqGHSsW@dev-arch.thelio-3990X>
References: <20230224-cls_api-wunused-function-v1-1-12c77986dc2d@kernel.org>
 <Y/oycX7fMP8yJAdd@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/oycX7fMP8yJAdd@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 05:08:17PM +0100, Simon Horman wrote:
> On Fri, Feb 24, 2023 at 11:18:49AM -0700, Nathan Chancellor wrote:
> > When CONFIG_NET_CLS_ACT is disabled:
> > 
> >   ../net/sched/cls_api.c:141:13: warning: 'tcf_exts_miss_cookie_base_destroy' defined but not used [-Wunused-function]
> >     141 | static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
> >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Due to the way the code is structured, it is possible for a definition
> > of tcf_exts_miss_cookie_base_destroy() to be present without actually
> > being used. Its single callsite is in an '#ifdef CONFIG_NET_CLS_ACT'
> > block but a definition will always be present in the file. The version
> > of tcf_exts_miss_cookie_base_destroy() that actually does something
> > depends on CONFIG_NET_TC_SKB_EXT, so the stub function is used in both
> > CONFIG_NET_CLS_ACT=n and CONFIG_NET_CLS_ACT=y + CONFIG_NET_TC_SKB_EXT=n
> > configurations.
> > 
> > Move the call to tcf_exts_miss_cookie_base_destroy() in
> > tcf_exts_destroy() out of the '#ifdef CONFIG_NET_CLS_ACT', so that it
> > always appears used to the compiler, while not changing any behavior
> > with any of the various configuration combinations.
> > 
> > Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks Nathan,
> 
> I think the #ifdefs in this file could do with some work.

Yes, it is definitely an eye sore. I thought about cleaning it up but it
felt like net-next material to me, plus I have no other interest in this
code other than making the warning in my builds go away, if I am being
honest :)

> But as a fix this looks good to me.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Thanks for the quick review!

Cheers,
Nathan
