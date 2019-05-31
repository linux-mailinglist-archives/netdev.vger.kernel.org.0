Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D0831747
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfEaWic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:38:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:42496 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbfEaWib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 18:38:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA030AD81;
        Fri, 31 May 2019 22:38:29 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1539AE00E3; Sat,  1 Jun 2019 00:38:29 +0200 (CEST)
Date:   Sat, 1 Jun 2019 00:38:29 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Subject: Re: [PATCH V1 net-next 02/11] net: ena: ethtool: add extra
 properties retrieval via get_priv_flags
Message-ID: <20190531223829.GH15954@unicorn.suse.cz>
References: <20190529095004.13341-1-sameehj@amazon.com>
 <20190529095004.13341-3-sameehj@amazon.com>
 <20190531081901.GC15954@unicorn.suse.cz>
 <30FE74C2-429B-4837-84D5-E973F33AF35F@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30FE74C2-429B-4837-84D5-E973F33AF35F@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 09:57:51PM +0000, Machulsky, Zorik wrote:
>     >  
>     > +int ena_com_extra_properties_strings_init(struct ena_com_dev *ena_dev)
>     > +{
>     > +	struct ena_admin_get_feat_resp resp;
>     > +	struct ena_extra_properties_strings *extra_properties_strings =
>     > +			&ena_dev->extra_properties_strings;
>     > +	u32 rc;
>     > +
>     > +	extra_properties_strings->size = ENA_ADMIN_EXTRA_PROPERTIES_COUNT *
>     > +		ENA_ADMIN_EXTRA_PROPERTIES_STRING_LEN;
>     > +
>     > +	extra_properties_strings->virt_addr =
>     > +		dma_alloc_coherent(ena_dev->dmadev,
>     > +				   extra_properties_strings->size,
>     > +				   &extra_properties_strings->dma_addr,
>     > +				   GFP_KERNEL);
>     
>     Do you need to fetch the private flag names on each ETHTOOL_GSTRING
>     request? I suppose they could change e.g. on a firmware update but then
>     even the count could change which you do not seem to handle. Is there
>     a reason not to fetch the names once on init rather then accessing the
>     device memory each time?
>     
>     My point is that ethtool_ops::get_strings() does not return a value
>     which indicates that it's supposed to be a trivial operation which
>     cannot fail, usually a simple copy within kernel memory.
> 
> ena_com_extra_properties_strings_init() is called in probe() only, and not for every ETHTOOL_GSTRING
> request. For the latter we use ena_get_strings(). And just to make sure we are on the same page, extra_properties_strings->virt_addr 
> points to the host memory and not to the device memory. I believe this should answer your concern.

That's what I misunderstood. Sorry for the noise then.

>     > +static void get_private_flags_strings(struct ena_adapter *adapter, u8 *data)
>     > +{
>     > +	struct ena_com_dev *ena_dev = adapter->ena_dev;
>     > +	u8 *strings = ena_dev->extra_properties_strings.virt_addr;
>     > +	int i;
>     > +
>     > +	if (unlikely(!strings)) {
>     > +		adapter->ena_extra_properties_count = 0;
>     > +		netif_err(adapter, drv, adapter->netdev,
>     > +			  "Failed to allocate extra properties strings\n");
>     > +		return;
>     > +	}
>     
>     This is a bit confusing, IMHO. I'm aware we shouldn't really get here as
>     with strings null, count would be zero and ethtool_get_strings()
>     wouldn't call the ->get_strings() callback. But if we ever do, it makes
>     little sense to complain about failed allocation (which happened once on
>     init) each time userspace makes ETHTOOL_GSTRINGS request for private
>     flags.
> 
> I believe we still want to check validity of the strings pointer to keep the driver resilient, however I agree that 
> the logged message is confusing. Let us rework this commit  

Yes, I didn't question the check, only the error message.

Michal
