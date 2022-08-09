Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856B958DCDA
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244843AbiHIRLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiHIRK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:10:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C7424084;
        Tue,  9 Aug 2022 10:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+KPJVKlTwuYIORvuCVRCrV6LokfH4QqszDshfU9K54Q=; b=X5z6LKKr7QwM8LZY6AXoIYPfDF
        0C1yUFTluKmCni7s0pYmN595Khet/lFEm8MTLi/Z0ao95MTQQ2FvmnKIZL8a4Chp8seLiQ59txKKU
        vYRH6dFU0aj1Z+Yx7wauBQH7OlbbpbPb646BTO3Sy24FMtjr28mKXgpMM8y5VCBGVvV0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLSki-00CrYV-Om; Tue, 09 Aug 2022 19:10:48 +0200
Date:   Tue, 9 Aug 2022 19:10:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kishon@ti.com,
        vigneshr@ti.com
Subject: Re: [EXTERNAL] Re: [RESEND PATCH] net: ethernet: ti: davinci_mdio:
 Add workaround for errata i2329
Message-ID: <YvKVGJiC9W6nR67f@lunn.ch>
References: <20220808111229.11951-1-r-gunasekaran@ti.com>
 <YvFubdCiU7J8Ufi4@lunn.ch>
 <27860709-db8f-49be-fec7-a76496bfb948@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27860709-db8f-49be-fec7-a76496bfb948@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for reviewing the patch. Since mdiobb_{read,write}() are exported, I
> can invoke these in my mdio read/write implementation. I will rework and
> send the v2 patch

What you should do is fill a struct mdiobb_ops and pass it to
alloc_mdio_bitbang(). It looks like you can provide:

struct mdiobb_ops {
	struct module *owner;

	/* Set the Management Data Clock high if level is one,
	 * low if level is zero.
	 */
	void (*set_mdc)(struct mdiobb_ctrl *ctrl, int level);

	/* Configure the Management Data I/O pin as an input if
	 * "output" is zero, or an output if "output" is one.
	 */
	void (*set_mdio_dir)(struct mdiobb_ctrl *ctrl, int output);

	/* Set the Management Data I/O pin high if value is one,
	 * low if "value" is zero.  This may only be called
	 * when the MDIO pin is configured as an output.
	 */
	void (*set_mdio_data)(struct mdiobb_ctrl *ctrl, int value);

	/* Retrieve the state Management Data I/O pin. */
	int (*get_mdio_data)(struct mdiobb_ctrl *ctrl);
};

Look at ravb_mdio_init() for an example, and there are a few others.

     Andrew
