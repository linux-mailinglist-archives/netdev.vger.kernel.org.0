Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4273E6E5780
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjDRCag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjDRCaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:30:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A463172C
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 19:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A829B62C4A
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 02:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF873C433EF;
        Tue, 18 Apr 2023 02:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681785033;
        bh=Ni5V56sFiSc07lyYljvYXB0pPuDcb4mas6a/lPY9Flc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ivWqBnUtqoJ/mwFDoIpDJqdrqjWPumhX/h0p8mGv8edG6VxmpW9ZH7jVeK96j3LlJ
         KDfIaXWq4vhqXtZW0ViNXX8yqqlUvsqLKhnfzOL6WxyzqtDrEEVPyInaIGMr7548ZD
         JOqp2efb/aa8fAvCujjMy5bxBgf0YFmR0wh9CicwbgK7CFN0jT8Zq9b0eJ5btuwjnb
         7+WmPgrjX2mBVAaZwZm9wjQo69NDfsKyu2+dyq+jLKGTmkXuH6y+QY5G9h9NRGFTSv
         rWioZ5xQRbpeIAUnO5PeOcWTdGfeb083fsunE9YmSuGh4q075TmZBJBPM81squmpeW
         buohdcQRQN3qw==
Date:   Mon, 17 Apr 2023 19:30:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: sch_fq: fix integer overflow of "credit"
Message-ID: <20230417193031.3ab4ee2a@kernel.org>
In-Reply-To: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
References: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 13:02:40 +0200 Davide Caratti wrote:
> +		u32 initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
> +
> +		if (initial_quantum <= INT_MAX) {
> +			q->initial_quantum = initial_quantum;
> +		} else {
> +			NL_SET_ERR_MSG_MOD(extack, "invalid initial quantum");
> +			err = -EINVAL;
> +		}

Please set the right policy in fq_policy[] instead.
