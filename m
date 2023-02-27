Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5646A4AC2
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjB0TYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjB0TYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:24:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F841ACD0;
        Mon, 27 Feb 2023 11:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30C7A60F0E;
        Mon, 27 Feb 2023 19:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEF3C433D2;
        Mon, 27 Feb 2023 19:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677525841;
        bh=9MJGWDl5+aT/Iiz66NQqX9NKb5ztwpFg8OnofQzOnAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aQ+qhfADwzMQExYOQ1FESqIlkt5WZGzd29xXML7W0/JEcK8TTQBixbfG1yoy0ZdTO
         6bcKc4TsL/H6gQOWDCWBAfRRpZHxTuh2VynbGdx0mNyA8Cjc7eICPleFE1xOV0fZh5
         rM4ha+PW74RF8qdw70lCTXtqPtGyzl4h53ZTtVPmcjPzoFvmBrClUCnU41716I/23m
         StGA3gnqlP93z1+1gxHrlB1EhJHtK9PnidWN36CbwtwPN95MrET5Qdn5EqdgjqLrwL
         txO9oNrDs4fCH1ZHQ659gsG9SKP/CFYDvl+PKdg9adjKnPTKbrDdDyP0pvKFR8+hoz
         gsFhOEZSUVOfw==
Date:   Mon, 27 Feb 2023 11:23:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
Subject: Re: [PATCH] nfc: fix memory leak of se_io context in nfc_genl_se_io
Message-ID: <20230227112359.6df702e3@kernel.org>
In-Reply-To: <20230225105614.379382-1-pchelkin@ispras.ru>
References: <20230225105614.379382-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Feb 2023 13:56:14 +0300 Fedor Pchelkin wrote:
> The callback context for sending/receiving APDUs to/from the selected
> secure element is allocated inside nfc_genl_se_io and supposed to be
> eventually freed in se_io_cb callback function. However, there are several
> error paths where the bwi_timer is not charged to call se_io_cb later, and
> the cb_context is leaked.
> 
> The patch proposes to free the cb_context explicitly on those error paths.
> 
> At the moment we can't simply check 'dev->ops->se_io()' return value as it
> may be negative in both cases: when the timer was charged and was not.

FWIW this patch has already been applied, please send the next changes
on top:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=25ff6f8a5a3b8dc48e8abda6f013e8cc4b14ffea
