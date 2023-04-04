Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B4A6D63B5
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbjDDNrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbjDDNqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:46:52 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A42A469E
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:46:21 -0700 (PDT)
Received: from localhost (unknown [213.194.153.37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: rcn)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 0703D660315A;
        Tue,  4 Apr 2023 14:46:17 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680615978;
        bh=fG+/EBRA4peunCqJNalyuKqvKTwzqXDNG8J1ONsLxlg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLJAHLIBOqQiJzJbddBWiVU9Ub4NIsq40bhHvIjtIP9pAGC/eM4zvXd/KNc0Gv1eX
         JA7Cd8pMlDcur9ozu+6HCJCmdBi1nDg5e7X0w/yfJVCbe96XL4NZP00MmEiK4dUwm9
         ENN1b6xX2z3Z538GHqefE2NgTuhJA0ki52rU3NM0ajrcc+cKLLXn00DIn6Has54vC+
         e55adtDZbtZ5emmSigS/IVhFsleA+dCJ+k5XUUdN2B3uEYOHblozRXn0xOYIXFWSwq
         bwbYUaSfTQyN6hnPsQeQbWP0aOJg6cMHx+9c5gUvtBiXZ4jb0MdenQoXBr+j57EneD
         cUgqlcBziV3pQ==
Date:   Tue, 4 Apr 2023 15:46:13 +0200
From:   Ricardo =?utf-8?Q?Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Mason <jon.mason@broadcom.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Jon Mason <jdmason@kudzu.us>
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Message-ID: <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
References: <20230227091156.19509-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230227091156.19509-1-zajec5@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rafał,

On mar 07-02-2023 23:53:27, Rafał Miłecki wrote:
> While bringing hardware up we should perform a full reset including the
> switch bit (BGMAC_BCMA_IOCTL_SW_RESET aka SICF_SWRST). It's what
> specification says and what reference driver does.
> 
> This seems to be critical for the BCM5358. Without this hardware doesn't
> get initialized properly and doesn't seem to transmit or receive any
> packets.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

KernelCI found this patch causes a regression in the
bootrr.deferred-probe-empty test [1] on sun8i-h3-libretech-all-h3-cc
[2], see the bisection report for more details [3]

Does it make sense to you?

Cheers,
Ricardo

[1] https://github.com/kernelci/bootrr/blob/3ae9fd5dffc667fa96012892ea08532bc6877276/helpers/bootrr-generic-tests#L3
[2] https://linux.kernelci.org/test/case/id/642a0f5c78c0feaf5d62f79c/
[3] https://groups.io/g/kernelci-results/message/40156

#regzbot introduced: f6a95a24957a
