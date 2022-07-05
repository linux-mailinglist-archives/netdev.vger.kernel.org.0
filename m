Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202CE5661A4
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 04:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiGEC6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 22:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234636AbiGEC6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 22:58:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2B1EA8
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 19:58:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6F4617FF
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 02:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E4AC3411E;
        Tue,  5 Jul 2022 02:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656989920;
        bh=BUfpGnRceY1qLcmHZTB4+k6pAmKzq7u3SN0qmg+6Sj0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lyY4Slfvoj3PCXFVIV8+h6wBKXHCZAPIxOg71vGittqbSqLSOGkGTsyoV/LowkT/w
         EMqu24IZI1O9parT486uU1RGXF2bJiwfQUIO46GNPcQRDDqFEIH1cVKQf6TsMFdTbI
         atGKP9GSFewOo+0BXQMSeu7dqGOh9mjEcfjfRMpQ9p/93QfC3ZuiLZCMgLteKFbyrW
         +sf9oF2XBNTUO+cRUbdkDNNy8/x2kfjL1yw9QNgivQfsNqzMJRxu7AdQtdPryfRdQx
         Ho21/VtvRp/gFkIBQlVlCRsItjxN7MpSDHuLrH66cz/lh7p8Oxx/mBoKErkROrFTd6
         qXyVl5POZS4Bw==
Date:   Mon, 4 Jul 2022 19:58:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 2/3] net: devlink: call lockdep_assert_held()
 for devlink->lock directly
Message-ID: <20220704195839.34128dd3@kernel.org>
In-Reply-To: <YsKGZZ8ZggAf+jGT@nanopsycho>
References: <20220701095926.1191660-1-jiri@resnulli.us>
        <20220701095926.1191660-3-jiri@resnulli.us>
        <20220701093316.410157f3@kernel.org>
        <YsBrDhZuV4j3uCk3@nanopsycho>
        <20220702122946.7bfc387a@kernel.org>
        <YsKGZZ8ZggAf+jGT@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jul 2022 08:19:17 +0200 Jiri Pirko wrote:
> Jakub, I don't really care. If you say we should do it differently, I
> will do it differently. I just want the use to be consistent. From the
> earlier reactions of DaveM on such helpers, I got an impression we don't
> want them if possible. If this is no longer true, I'm fine with it. Just
> tell me what I should do.

As I said - my understanding is that we want to discourage (driver)
authors from wrapping locks in lock/unlock helpers. Which was very
fashionable at some point (IDK why, but it seem to have mostly gone
away?).

If the helper already exists I think consistency wins and we should use
it.
