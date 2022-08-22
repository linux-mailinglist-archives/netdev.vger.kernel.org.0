Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F330859C2AB
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbiHVPZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiHVPYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:24:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209C065FF
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eyUSN3lXWS/kRTj6v/uan0HzkMc+IpsfdEzt2udu6gE=; b=Eo8bbC/X9Anp2kzQhZagSg89EW
        578KIR/Rm+Z3ZbDNkt1PP9GBH05+h68hVu8ehKPyBrWhxsD/nmept2V8g1ZNQntxsTv5/qnqxoo5A
        3jTALCC5pe6rcT8XJwKFbslURP5EVerWtps/dOv8pRqVrd+H8f6cOzpua6ocFjzq2P6k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQ9Ek-00EEch-OF; Mon, 22 Aug 2022 17:21:10 +0200
Date:   Mon, 22 Aug 2022 17:21:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/3] net: sparx5: add list for mdb entries in
 driver
Message-ID: <YwOe5hNa1PJFr077@lunn.ch>
References: <20220822140800.2651029-1-casper.casan@gmail.com>
 <20220822140800.2651029-3-casper.casan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822140800.2651029-3-casper.casan@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct sparx5_mdb_entry {
> +	struct list_head list;
> +	unsigned char addr[ETH_ALEN];
> +	u16 vid;
> +	DECLARE_BITMAP(port_mask, SPX5_PORTS);
> +	bool cpu_copy;
> +	u16 pgid_idx;
> +};

You have a number of holes in that structure. Maybe this is better:

> +struct sparx5_mdb_entry {
> +	struct list_head list;
> +	DECLARE_BITMAP(port_mask, SPX5_PORTS);
> +	unsigned char addr[ETH_ALEN];
> +	bool cpu_copy;
> +	u16 vid;
> +	u16 pgid_idx;
> +};

Hopefully the compiler can pack the bool straight after the 6 byte MAC
address. And the two u16 should make one u32.

> +static int sparx5_alloc_mdb_entry(struct sparx5 *sparx5,
> +				  const unsigned char *addr,
> +				  u16 vid,
> +				  struct sparx5_mdb_entry **entry_out)
> +{
> +	struct sparx5_mdb_entry *entry;
> +	u16 pgid_idx;
> +	int err;
> +
> +	entry = devm_kzalloc(sparx5->dev, sizeof(struct sparx5_mdb_entry), GFP_ATOMIC);

Does devm_kzalloc make sense here? A MDB entry has a much shorter life
time than the driver. devm has overheads, so it is good for large
allocations which last as long as the device, but less so for lots of
small short lives structures.

      Andrew
