Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976DF618B57
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiKCWYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiKCWYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:24:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1AF14D39
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 15:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=L+GigL+/ZthWsNrgZU3wQyuNFPzc0NpHkrNiF7cn2K4=; b=juufz8RLjeAShwMg097z74s5fu
        Filj/h4VCKfJ8iZP4kCZUBLmEJ6X+YAvsqBOwRJDaz1cY51kHNgpJZ0CdOH8cb3m2Dl/CPIpXDjPX
        TFDUx4RdolkrU9Eki/WFlIrcUOUnhRTFU/suy0cdurN1vCK0M/Zkr+9auMt0zXJLpHpw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oqid0-001M6t-3S; Thu, 03 Nov 2022 23:24:02 +0100
Date:   Thu, 3 Nov 2022 23:24:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, corbet@lwn.net,
        mkubecek@suse.cz, sridhar.samudrala@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next] ethtool: add netlink based get rxfh support
Message-ID: <Y2Q/gmS0v8i6SNi4@lunn.ch>
References: <20221103211419.2615321-1-sudheer.mogilappagari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103211419.2615321-1-sudheer.mogilappagari@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int rxfh_prepare_data(const struct ethnl_req_info *req_base,
> +			     struct ethnl_reply_data *reply_base,
> +			     struct genl_info *info)
> +{

...

> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Some drivers don't handle rss_context */
> +	if (rxfh->rss_context && !ops->get_rxfh_context)
> +		return -EOPNOTSUPP;

You called ethnl_ops_begin(). Just returning here is going to mess up
rumtime power control, and any driver which expects is
ethtool_ops->complete() call to be called.

	Andrew
