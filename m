Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986E63DF14C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhHCPXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:23:41 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57960
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236145AbhHCPXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:23:39 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id BE1D43F07E;
        Tue,  3 Aug 2021 15:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628004207;
        bh=AAtFa3uqU80R71CuDcjQT6vhZ/7Aa3Do+6cYN2ykiig=;
        h=To:Cc:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=AN+sUgU8X+kJSPIFvbEy02kCsEG6PetoUJHJ8aLMKqUuu4f3vAdxVofgt/ojdjsUc
         i1GEb0g8A7WbMSoPoP2ddfQqYWL29HJeSiiahPWTYjo5uschzIGCf1kmhtp1ZfVJZk
         i2BMt3UBaUa/XYDjC3bhVCpwCa8NERSUoy19YLK0IV2vujrnfoI814q511W+NSMZaA
         qVsYXbScN+yIjau8PmrNbB+RqrwXpvgk2cQ7W20hP52NhUyxamzjRtH9oK5ur1j4g2
         unK5vk0pQaoCx7DLCXU7jQPxh6Q7Lb+/gnmBjfncO0/1k6cg0YtEa5fOPOYUnscXKG
         PUBvhxu8vwOZg==
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: can: flexcan: add mcf5441x support
Message-ID: <7c80c17f-e38a-8fb1-f3c7-987187a2c4d8@canonical.com>
Date:   Tue, 3 Aug 2021 16:23:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis of linux-next with Coverity has detected a potential
issue with the following commit:

commit d9cead75b1c66b4660b4f87ff339234042d7c6a5
Author: Angelo Dureghello <angelo@kernel-space.org>
Date:   Fri Jul 2 11:48:41 2021 +0200

    can: flexcan: add mcf5441x support

The analysis is as follows:

650 static int flexcan_clks_enable(const struct flexcan_priv *priv)
651 {

   1. var_decl: Declaring variable err without initializer.

652        int err;
653

   2. Condition priv->clk_ipg, taking false branch.

654        if (priv->clk_ipg) {
655                err = clk_prepare_enable(priv->clk_ipg);
656                if (err)
657                        return err;
658        }
659

   3. Condition priv->clk_per, taking false branch.

660        if (priv->clk_per) {
661                err = clk_prepare_enable(priv->clk_per);
662                if (err)
663                        clk_disable_unprepare(priv->clk_ipg);
664        }
665

   Uninitialized scalar variable (UNINIT)
   4. uninit_use: Using uninitialized value err.

666        return err;
667 }

I'm not sure if it's possible for priv->clk_ipg and priv_clk_per to both
be null, so I'm not sure if err can end up being not set. However, it
does seem that either err should be zero or some err value, but I was
unsure how err should be initialized in this corner case. As it stands,
err probably needs to be set just to be safe.

Colin
