Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2BAC5E57B2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIVBAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiIVBAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:00:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95404832C5;
        Wed, 21 Sep 2022 18:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4163DB82573;
        Thu, 22 Sep 2022 01:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDBEC433C1;
        Thu, 22 Sep 2022 01:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663808444;
        bh=lrVfXnt54IohalTXJ56+6lp4MX9EPl3Ech4umzOq22g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TIt68Gl9Sv7pXI0EwOkLVQMTKM+Xyo3B9TBcIVJMpMXzldNX7toKB+6S6+SP2VACE
         sDqCB7yQ3db/YXJDufmnjfnn5oBrM4Av1TzdbBWoasG9CnpgbUB9olFJgVVtlTLmTW
         X6qXMCmkDsP9HJyiWbyC4IDAzrLtZe1bACjU3YA5zFJ8JumX+OmGt0nlr3jSrX+iEX
         OFzGfzkMrGxqQq3dRjxS/rTR1PxzZA/Qt2OrKbZOCQhDd8GSh2fTPe07+i2edacv9p
         IaJZKpqZ34wKJDXm1Ckzo45OXlcmzYw9tB4EplmZUEFT9dajJV+eLaFKB8qLNHuPHp
         VLo1D/zAmTcjw==
Date:   Wed, 21 Sep 2022 18:00:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 5/7] tsnep: Add EtherType RX flow
 classification support
Message-ID: <20220921180042.440a8b65@kernel.org>
In-Reply-To: <20220915203638.42917-6-gerhard@engleder-embedded.com>
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
        <20220915203638.42917-6-gerhard@engleder-embedded.com>
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

On Thu, 15 Sep 2022 22:36:35 +0200 Gerhard Engleder wrote:
> +static int tsnep_add_rule(struct tsnep_adapter *adapter,
> +			  struct tsnep_rxnfc_rule *rule)
> +{
> +	struct tsnep_rxnfc_rule *pred, *cur;
> +
> +	tsnep_enable_rule(adapter, rule);
> +
> +	pred = NULL;
> +	list_for_each_entry(cur, &adapter->rxnfc_rules, list) {
> +		if (cur->location >= rule->location)
> +			break;
> +		pred = cur;
> +	}
> +
> +	list_add(&rule->list, pred ? &pred->list : &adapter->rxnfc_rules);
> +	adapter->rxnfc_count++;
> +
> +	return 0;

This never fails, perhaps the return code is unnecessary
