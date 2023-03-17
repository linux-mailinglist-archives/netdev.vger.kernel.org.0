Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E51C6BDFF5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCQEHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCQEHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAAB77E00;
        Thu, 16 Mar 2023 21:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF1A06217B;
        Fri, 17 Mar 2023 04:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BED7C433D2;
        Fri, 17 Mar 2023 04:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679026058;
        bh=/b2B5+/FwUKNsDoGOdk1UsLaw/L5lZ/Qy3rlD/KbRhM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QhiCKwT7mutCc7Kc2gmEYaqywdb01qXWmHbAcNBoolsXd/BIPO1ybdk2r2qTKbdIr
         vl1rkGdj+XFx4ldbVK7QAKl2HNBUbZGi38/w7q6SNNEnZN8nrLyTkJQBHUZeyGcjN3
         PiEgt2TxFsYvtPMo3hooWd6PZh3GWEiorx5hq7Osf3x+Os66CPtvHcrP5QwsfFf4ON
         kGFz1FoSSLbP736BEogWU53vrxBE0wTkmpSXW3s5OOHINji3/kfCC9fo6Jdmw5oJXQ
         F2LplUUkfcVNmHB9b13858S3aG2M6CYpm1UrZi0dmoamocLZANg4OwI34DMvkWbrJ6
         FS40+Xriv0caA==
Date:   Thu, 16 Mar 2023 21:07:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Message-ID: <20230316210736.1910b195@kernel.org>
In-Reply-To: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
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

On Wed, 15 Mar 2023 14:09:15 +0100 Ahmad Fatoum wrote:
> -	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> +	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv) + var->chip_data_sz, GFP_KERNEL);

size_add() ?
Otherwise some static checker is going to soon send us a patch saying
this can overflow. Let's save ourselves the hassle.
