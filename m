Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E99452E4A5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345702AbiETGD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbiETGD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:03:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD3114AC98
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 23:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 945A9CE282C
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B079EC385A9;
        Fri, 20 May 2022 06:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653026635;
        bh=DkWD126GLSPKoPgWWtUW3KbUl4gxcNNfUETmDxvDoXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UJEZSuL2CfbU6B3saIEW9cpcID29UMQnmt3IGHVU3dRwQukAPcZgj03puJ4xnX7ja
         NsnF4fdCqDsOGOvnNmgpmMi3y87h5h3IgfsGamhxjOFAI9Se0M3AlUNavT3IMu3eMl
         2qU+FYFfIF+ubaSM6k+VLofOORdgsOaVm5lJY+0/z44HhTEVPFOOvyXHaPlvHyb7ng
         RkhFNzI5T5V94tKqxFOpEuALne2bHxSXZw/FCExCS4htKFfH1ACOS8OQxdW5wv3FjJ
         WUNS7kUF8ENovOXPhCNHPrSyyFm/MEW4dc7OpnsLjGA0Se6KLpSljcuzg2vxFb4ubj
         xEJHLE5yeLyOA==
Date:   Thu, 19 May 2022 23:03:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH net-next] wwan: iosm: use a flexible array rather than
 allocate short objects
Message-ID: <20220519230353.420c7a46@kernel.org>
In-Reply-To: <20220520060013.2309497-1-kuba@kernel.org>
References: <20220520060013.2309497-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 23:00:13 -0700 Jakub Kicinski wrote:
> GCC array-bounds warns that ipc_coredump_get_list() under-allocates
> the size of struct iosm_cd_table *cd_table.
> 
> This is avoidable - we just need a flexible array. Nothing calls
> sizeof() on struct iosm_cd_list or anything that contains it.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Coincidentally IDK if this:

int ipc_coredump_get_list(struct iosm_devlink *devlink, u16 cmd)

	if (byte_read != MAX_CD_LIST_SIZE)
		goto cd_init_fail;

shouldn't set ret before jumping? Maybe set it to 0 if it's okay for 
it to be zero to make that clear?
