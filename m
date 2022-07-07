Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF705697BE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiGGCCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbiGGCCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3F42F03D;
        Wed,  6 Jul 2022 19:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC0376208C;
        Thu,  7 Jul 2022 02:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96DAC3411C;
        Thu,  7 Jul 2022 02:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657159359;
        bh=abt2fnMs2RLeFsNRDbZp4ICtDX00jnIhZbJrTMIbwro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dfkB/ry2ouo+vFAA83fScF1vliSCTQLU9aRmNkJYJZmA01OKIGpBtccjixQeqtZZm
         q8eHDkQStzqYwREHb4NwveofynUWl3jLZubWCENVsJ9B8OQ3uLe1T1wyIph/Z/L+vF
         te/8KVbE6Jv4X6Mmoyg+RgRKYAFwdhM6AolkSRSm6WkR1quhpp2dcbqxJaDkKKwSiP
         n92v24MccNdaPjC9n4XGpFigZlWGMzvr4ljOI7UwChVJm6X7a+NOL2jo1nNPuoP6i+
         yITHWhzmH7xKFRnHrtzIKBt1VwVBkpXsq4rNJdBSgWL/H4/jH+wpYmYHtl7YOWfvd3
         qId/SQrGUtUkg==
Date:   Wed, 6 Jul 2022 19:02:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net v2] net: rose: fix UAF bug caused by
 rose_t0timer_expiry
Message-ID: <20220706190237.477f24ee@kernel.org>
In-Reply-To: <20220705125610.77971-1-duoming@zju.edu.cn>
References: <20220705125610.77971-1-duoming@zju.edu.cn>
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

On Tue,  5 Jul 2022 20:56:10 +0800 Duoming Zhou wrote:
> +	del_timer_sync(&rose_neigh->t0timer);

/**
 * del_timer_sync - deactivate a timer and wait for the handler to finish.
[...]
 * Synchronization rules: Callers must prevent restarting of the timer,
 * otherwise this function is meaningless.

how is the restarting prevented? If I'm looking right 
rose_t0timer_expiry() rearms the timer.
