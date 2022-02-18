Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81074BB0E9
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 05:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiBREwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 23:52:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiBREvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 23:51:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B0E17C106;
        Thu, 17 Feb 2022 20:51:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA71461E26;
        Fri, 18 Feb 2022 04:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31ACC340E9;
        Fri, 18 Feb 2022 04:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645159887;
        bh=z9kkrvc2NL5Tbv39j6C/dwiZlTKTgsn2J4KabKbaxaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mQhLDUn7BMecoLlljM5/8LRUQylO7fGKoFu+B/AoyUZW9vlz2Itz+UzbX2RZAHa7p
         +XQkKoHce4tKp3bdyenhLoSCOJI7lduCSGFEm1G7CA6BZjR5Y5kiM6+AbRNjj/aEP9
         CW2TrEFxM5ONokSWr39ZWED9l1AQNLdGQ59GU2SdxCvwkf0Lgl+zHq6Hea5TFhNTt0
         LVb8qYHAn0OuD4Ovx18djQhj8F4YE8WMzE9THb2eVx4pJMLvRHgFpbGcLTsaYHovey
         mHzi0f+JmqEzlw4f27ORYlMfd826mJruOpwQaEvKXLGnE7ptAjqRkN/Ozmk0PodkMi
         qnTJRcE+/5H9g==
Date:   Thu, 17 Feb 2022 20:51:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: prestera: flower: fix destroy tmpl in
 chain
Message-ID: <20220217205125.7c63432e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1645022624-2010-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1645022624-2010-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 16:43:44 +0200 Volodymyr Mytnyk wrote:
> +	list_for_each_safe(pos, n, &block->template_list) {
> +		template = list_entry(pos, typeof(*template), list);

nit: list_for_each_entry_safe()

> +		if (template->chain_index == f->common.chain_index) {
> +			/* put the reference to the ruleset kept in create */
> +			prestera_flower_template_free(template);
> +			return;
> +		}
> +	}
