Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639BA6A0223
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 05:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbjBWEyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 23:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjBWEx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 23:53:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E5A1E5F6
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 20:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30689B818D7
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 04:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B643BC433EF;
        Thu, 23 Feb 2023 04:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677128033;
        bh=1KJsaeq4lYPIt4GZx0sC0LNqiqPbMJZfwVPFAlcD0fA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O6y7TLzzyLIR8PjiuvChfAyNRFv1AtyvxalPP0e9cg3o1O/HG62Y0xPy/gsqf/k8G
         3eF1df2/6+sL+p9oLgNQPyKkR/vc7RLJk2QHG5PcbHM4G7X1gibJB2AU9Y29CCooMW
         Tb7saGJayBZaA6jYJkXNwKnc9SPvj1ee+Qv/fkSWt1fqotKfVkckZjmtdPGoEhzm0o
         FkPGswsLCDlJJ5KzJPdaF6tDSCHtwfdF0Z9rem8bnvsxes3BEKfDcOOxciQwPt//pF
         QMEYkOq//8PRZWynTp42JQJaqC+SaovtvahC2pWCFOR65WLMduxBlNqlvKeGCjNbpq
         jI48V/SUXVNqA==
Date:   Wed, 22 Feb 2023 20:53:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] net: add no-op for napi_busy_loop if
 CONFIG_NET_RX_BUSY_POLL=n
Message-ID: <20230222205352.74737c2a@kernel.org>
In-Reply-To: <20230223012258.1701175-1-jacob.e.keller@intel.com>
References: <20230223012258.1701175-1-jacob.e.keller@intel.com>
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

On Wed, 22 Feb 2023 17:22:58 -0800 Jacob Keller wrote:
> Commit 7db6b048da3b ("net: Commonize busy polling code to focus on napi_id
> instead of socket") introduced napi_busy_loop and refactored sk_busy_loop
> to call this new function. The commit removed the no-op implementation of
> sk_busy_loop in the #else block for CONFIG_NET_RX_BUSY_POLL, and placed the
> declaration of napi_busy_poll inside the # block where sk_busy_loop used to
> be declared.
> 
> Because of this, if a module tries to use napi_busy_loop it must wrap the
> use inside a IS_ENABLED(CONFIG_NET_RX_BUSY_POLL) check, as the function is
> not declared when this is false.
> 
> The original sk_busy_loop function had both a declaration and a no-op
> variant when the config flag was set to N. Do the same for napi_busy_loop
> by adding a no-op implementation in the #else block as expected.
> 
> Fixes: 7db6b048da3b ("net: Commonize busy polling code to focus on napi_id instead of socket")

We need a reference to which module needs this or a Kconfig snippet 
+ build failure output.
