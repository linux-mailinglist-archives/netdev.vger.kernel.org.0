Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A075697B4
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbiGGByY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbiGGByY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:54:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7194D2E9FF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 18:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EA00CCE221C
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 01:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AE1C341C6;
        Thu,  7 Jul 2022 01:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657158859;
        bh=NgXNo2qUlzWqyFs8InHIU9Co6hgatJ/5ramjGfTae7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bJ2+zR0J7lpwX2Y1pUDfcEekQVmTLAYd820YKCp5OakguJf5Ro/CAqiuHMgy5QgFZ
         7GkmEj9Dd9sLJDCUSLp7aTcNi/fSkOzh3CRFJoWEQGun2oBS1jalxyeZcIBRpccRQq
         yQ9cgfHX9JQc1FmPIcEh6f21q9qXOpSYQ/ajFUfmIc/PG+RuLOIGqgOXtZ8jcmK9uF
         CDagefzjKGfvmkc0zl7Y4NZNRsSkoSiOE0feLerfjpWvhr59PP4pYP9x6mS8SspikY
         f6g7lB2x7K2oKJetjPyQTgr3McktTn4yEkSRP45UbrNGuyMxkeA88SYqkG99FfTEK0
         Bt8X5pTmEE6qQ==
Date:   Wed, 6 Jul 2022 18:54:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: rawip: delayed and mis-sequenced transmits
Message-ID: <20220706185417.2fcbcdf0@kernel.org>
In-Reply-To: <433be56da42f4ab2b7722c1caed3a747@AcuMS.aculab.com>
References: <433be56da42f4ab2b7722c1caed3a747@AcuMS.aculab.com>
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

On Wed, 6 Jul 2022 15:54:18 +0000 David Laight wrote:
> Anyone any ideas before I start digging through the kernel code?

If the qdisc is pfifo_fast and kernel is old there could be races.
But I don't think that's likely given you probably run something
recent and next packet tx would usually flush the stuck packet.
In any case - switching qdisc could be a useful test, also bpftrace 
is your friend for catching patckets with long sojourn time.
