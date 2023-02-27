Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A236A4ACA
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjB0TZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB0TZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:25:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7685F1D92C;
        Mon, 27 Feb 2023 11:25:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E506B60F08;
        Mon, 27 Feb 2023 19:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7FAC433EF;
        Mon, 27 Feb 2023 19:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677525922;
        bh=Vh7dHdYhOi+3z93RYe3EDKV3xZU/PUURtI1C0KIVf7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yuq5dc9gS9w73YlPDau35cLGMTKqxCEc819IpqW81vdolbTmyKpKf4W59x+o1IHIV
         mBs05Z1RD2k0CoSF1k/LaeEiMWydWRu/ZZlTYh9j5aq7v4iXtvoJLm8etqje1NVEaI
         AL4b9RyvGCoVJtAO+vNZVlPPPx1nRQ2O7nnj6fYTU95L4Phx2nxGErHePwdNymmFr3
         lS+YJ5KOYusDeYgleMqydLc6iaCLLNgx9XG1HvHnASW3fiRwtg4DSr/LXVIm0VZQBm
         nOQO3kNwajX939QxuzQzsQPMZriRDdxvIhkl5LxAdY97GZWmdNgUWJqRrTNl3L4yH3
         VbjxZ2553fTng==
Date:   Mon, 27 Feb 2023 11:25:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        paulb@nvidia.com, simon.horman@corigine.com,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/sched: cls_api: Move call to
 tcf_exts_miss_cookie_base_destroy()
Message-ID: <20230227112520.5ac534fa@kernel.org>
In-Reply-To: <20230224-cls_api-wunused-function-v1-1-12c77986dc2d@kernel.org>
References: <20230224-cls_api-wunused-function-v1-1-12c77986dc2d@kernel.org>
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

On Fri, 24 Feb 2023 11:18:49 -0700 Nathan Chancellor wrote:
> When CONFIG_NET_CLS_ACT is disabled:
> 
>   ../net/sched/cls_api.c:141:13: warning: 'tcf_exts_miss_cookie_base_destroy' defined but not used [-Wunused-function]
>     141 | static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
>         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Due to the way the code is structured, it is possible for a definition
> of tcf_exts_miss_cookie_base_destroy() to be present without actually
> being used. Its single callsite is in an '#ifdef CONFIG_NET_CLS_ACT'
> block but a definition will always be present in the file. The version
> of tcf_exts_miss_cookie_base_destroy() that actually does something
> depends on CONFIG_NET_TC_SKB_EXT, so the stub function is used in both
> CONFIG_NET_CLS_ACT=n and CONFIG_NET_CLS_ACT=y + CONFIG_NET_TC_SKB_EXT=n
> configurations.
> 
> Move the call to tcf_exts_miss_cookie_base_destroy() in
> tcf_exts_destroy() out of the '#ifdef CONFIG_NET_CLS_ACT', so that it
> always appears used to the compiler, while not changing any behavior
> with any of the various configuration combinations.
> 
> Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied, thanks!
