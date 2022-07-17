Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD315776D1
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 16:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiGQOy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 10:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGQOy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 10:54:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAD712D2C
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 07:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9oCAJEIq7LCg9hKK+74BKivzoQaWNjQVbwEglbt5c/U=; b=v/hanVZk6t8tBtaIL6qDldIczM
        +0xNW1PtBHqUvgu4oQTbgmX+pFAIU1o3jL5iuG+tQoXEDP9Abrxb0emFUDr5a5sma4NLYYUZRXHBn
        P6j3wQ7Jy2fOnn1Ta/O9C/3p0E8L8MuRgiyzxYG6P58mbbAQ5cbYp6/f+unPBfk+Ln0o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oD5f2-00AcmH-JG; Sun, 17 Jul 2022 16:54:20 +0200
Date:   Sun, 17 Jul 2022 16:54:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrey Turkin <andrey.turkin@gmail.com>
Cc:     netdev@vger.kernel.org, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: Re: [PATCH] vmxnet3: Implement ethtool's get_channels command
Message-ID: <YtQinGiQHiSg1oiC@lunn.ch>
References: <20220717022050.822766-1-andrey.turkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220717022050.822766-1-andrey.turkin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#if defined(CONFIG_PCI_MSI)
> +	if (adapter->intr.type == VMXNET3_IT_MSIX) {
> +		if (adapter->share_intr == VMXNET3_INTR_BUDDYSHARE) {
> +			ec->combined_count = adapter->num_tx_queues;
> +			ec->rx_count = 0;
> +			ec->tx_count = 0;
> +		} else {
> +			ec->combined_count = 0;
> +			ec->rx_count = adapter->num_rx_queues;
> +			ec->tx_count =
> +				adapter->share_intr == VMXNET3_INTR_TXSHARE ?
> +					       1 : adapter->num_tx_queues;
> +		}
> +	} else {
> +#endif
> +		ec->rx_count = 0;
> +		ec->tx_count = 0;
> +		ec->combined_count = 1;
> +#if defined(CONFIG_PCI_MSI)
> +	}
> +#endif

This is pretty messy. Could you use IS_ENABLED(CONFIG_PCE_MSI)
instead?

	Andrew
