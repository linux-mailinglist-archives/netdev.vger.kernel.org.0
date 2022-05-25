Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6594E533D0D
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237230AbiEYM4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiEYM43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:56:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A835A5F40
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 05:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PUw5uYRAN+UvcaLVGTxSk2VbbG4NH3OKJYNSQ+c1Z5E=; b=LQWS6ZQq4S4M0elU43DWG09afU
        vMJ46/qyeaxGepdI4ZkTHr5SevkrBhT1uDr/GhkdY74+ajPtpl8d5yS96QjIy2aZ2SaZWyip/YI9L
        4AU7YGEfazw7xlIeg9gcaLAiffRLjAe5xCXXHdoMht32xbitB6sDLNa1EDCAdKvsQ+AM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ntqYl-004EdX-IS; Wed, 25 May 2022 14:56:19 +0200
Date:   Wed, 25 May 2022 14:56:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: txgbe: Add build support for txgbe
Message-ID: <Yo4ncweml1gRDlhC@lunn.ch>
References: <20220517092109.8161-1-jiawenwu@trustnetic.com>
 <YoRkONdJlIU0ymd6@lunn.ch>
 <01d001d86fe7$a4f4ba20$eede2e60$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01d001d86fe7$a4f4ba20$eede2e60$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +	/* setup the private structure */
> > > +	err = txgbe_sw_init(adapter);
> > > +	if (err)
> > > +		goto err_sw_init;
> > > +
> > > +	if (pci_using_dac)
> > > +		netdev->features |= NETIF_F_HIGHDMA;
> > 
> > There should probably be a return 0; here, so the probe is successful.
> Without
> > that, you cannot test the remove function.
> > 
> 
> I find that when I execute 'rmmod txgbe', it causes a segmentation fault
> which prints 'iounmap: bad address'.
> But when I try to do 'iounmap' before 'return 0' in the probe function,
> there is no error.
> Could you please tell me the reason for this?

I'm assuming it is this code which is doing the print:

https://elixir.bootlin.com/linux/v5.18/source/arch/x86/mm/ioremap.c#L469

Which suggests the area you are trying to unmap is not actually
mapped.

Your code is a bit confusing:

in probe you have:

+	hw->hw_addr = ioremap(pci_resource_start(pdev, 0),
+			      pci_resource_len(pdev, 0));

and remove:

+	iounmap(adapter->io_addr);

There is an assignment adapter->io_addr = hw->hw_addr; but this is
enough suggestion your structure of adapter and hw is not correct.

What i also notice is that release would normally things in the
opposite order to probe. That is not the case for your code.

> > > +static bool txgbe_check_cfg_remove(struct txgbe_hw *hw, struct
> > > +pci_dev *pdev) {
> > > +	u16 value;
> > > +
> > > +	pci_read_config_word(pdev, PCI_VENDOR_ID, &value);
> > > +	if (value == TXGBE_FAILED_READ_CFG_WORD) {
> > > +		txgbe_remove_adapter(hw);
> > > +		return true;
> > > +	}
> > > +	return false;
> > 
> > This needs a comment to explain what is happening here, because it is not
> > clear to me.
> > 
> 
> It means some kind of problem occur on PCI.

Which does not explain what this function is doing.

It seems like you have two cases to cover:

A PCI problem during probe. This is probably the more likely case. You
just fail the probe.

A PCI problem during run time. What sort of recovery are you going to
do? Just print a warning and keep going, hope for the best? 

    Andrew
