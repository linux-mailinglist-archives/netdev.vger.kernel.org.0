Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CC66608E1
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 22:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjAFVlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 16:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjAFVli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 16:41:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2259213F9E
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 13:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C31ABB81EDF
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 21:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F82AC433D2;
        Fri,  6 Jan 2023 21:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673041294;
        bh=EeZ99Z1fwQ91K3kZunv2lV9EYPEPHphe7F3QdrENLWw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B/t7Qvyja6mAbJLohWMcDHazPzCl1Bo40AhddRVHOv5awPpNMerQY+QWBmXO+npce
         HZTJAIFr+9o7wiIeDeo2TTC/OCxniWaX9UNitWErAErY+tFUipMSFcW8UDUm8E3Oqt
         S3dB80jW0rpYvG2XwJE6BYoPp0L9i/Ye15pc4DL3wT8x/cgxXnfQR23mc2Y/67icJs
         lA/4e0jKmNrUigG2ReZ5Chy2UCV08fN8xNyBdsrAeTzW6NTNF95BAZN5yb7SCYgNDT
         H78GoidjQ2TNojbIdlbg9zJSBEsE4Gu57KQ4uGkbw3Hv6I+6jNZe64fqEY8pFQKhR4
         q8zIJmub/yKqg==
Date:   Fri, 6 Jan 2023 13:41:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH ethtool-next v4 2/2] netlink: add netlink handler for
 get rss (-x)
Message-ID: <20230106134133.75f76043@kernel.org>
In-Reply-To: <IA1PR11MB62668007BA5BA017F5B46708E4FB9@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221229011243.1527945-1-sudheer.mogilappagari@intel.com>
        <20221229011243.1527945-3-sudheer.mogilappagari@intel.com>
        <20230102163326.4b982650@kernel.org>
        <IA1PR11MB62668007BA5BA017F5B46708E4FB9@IA1PR11MB6266.namprd11.prod.outlook.com>
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

On Fri, 6 Jan 2023 17:41:39 +0000 Mogilappagari, Sudheer wrote:
> > > +	rss_hfunc = mnl_attr_get_u32(tb[ETHTOOL_A_RSS_HFUNC]);
> > > +
> > > +	indir_bytes = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_INDIR]);
> > > +	indir_table = mnl_attr_get_str(tb[ETHTOOL_A_RSS_INDIR]);
> > > +
> > > +	hkey_bytes = mnl_attr_get_payload_len(tb[ETHTOOL_A_RSS_HKEY]);
> > > +	hkey = mnl_attr_get_str(tb[ETHTOOL_A_RSS_HKEY]);  
> > 
> > All elements of tb can be NULL, AFAIU.  
> 
> Didn't get this. Do you mean the variables need to be checked 
> for NULL here? If yes, am checking before printing later on.  

tb[ETHTOOL_A_RSS_HKEY] can be NULL. I just realized now that the kernel
always fills in the attrs:

	if (nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc) ||
	    nla_put(skb, ETHTOOL_A_RSS_INDIR,
		    sizeof(u32) * data->indir_size, data->indir_table) ||
	    nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey))
		return -EMSGSIZE;

but that's not a great use of netlink. If there is nothing to report
the attribute should simply be skipped, like this:

	if (nla_put_u32(skb, ETHTOOL_A_RSS_HFUNC, data->hfunc)) ||
	    (data->indir_size && 
	     nla_put(skb, ETHTOOL_A_RSS_INDIR,
		     sizeof(u32) * data->indir_size, data->indir_table)) ||
	    (data->hkey_size &&
	     nla_put(skb, ETHTOOL_A_RSS_HKEY, data->hkey_size, data->hkey)))
		return -EMSGSIZE;

I think we should fix the kernel side.

> > > +int get_channels_cb(const struct nlmsghdr *nlhdr, void *data) {  
> 
> > > +	silent = nlctx->is_dump || nlctx->is_monitor;
> > > +	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
> > > +	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
> > > +	if (ret < 0)
> > > +		return err_ret;
> > > +	nlctx->devname = get_dev_name(tb[ETHTOOL_A_CHANNELS_HEADER]);  
> > 
> > We need to check that the kernel has filled in the attrs before
> > accessing them, no?  
> 
> Didn't get this one either. similar code isn't doing any checks 
> like you suggested.

Same point, really. Even if the kernel always populates the attribute
today, according to netlink rules it's not guaranteed to do so in the
future, so any tb[] access should be NULL-checked.

> > The correct value is combined + rx, I think I mentioned this before.  
> 
> Have changed it to include rx too like below. 
> args->num_rings = mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT]);
> args->num_rings += mnl_attr_get_u32(tb[ETHTOOL_A_CHANNELS_RX_COUNT]);

Related to previous comments - take a look at channels_fill_reply().
tb[ETHTOOL_A_CHANNELS_RX_COUNT] will be NULL for most devices.
mnl_attr_get_u32(NULL) will crash.

> Slightly unrelated, where can I find the reason behind using combined + rx?
> Guess it was discussed in mailing list but not able to find it.

Yes, it's been discussed on the list multiple times but man ethtool 
is the only source of documentation I know of.

The reason is that the channels API refers to interrupts more than
queues. So rx means an _irq_ dedicated to Rx processing, not an Rx
queue. Unfortunately the author came up with the term "channel" which
most people take to mean "queue" :(

> > +	return MNL_CB_OK;
> > 
> > I'm also not sure if fetching the channel info shouldn't be done over
> > the nl2 socket, like the string set. If we are in monitor mode we may
> > confuse ourselves trying to parse the wrong messages.  
> 
> Are you suggesting we need to use ioctl for fetching ring info to avoid
> mix-up. Is there alternative way to do it ?  

No no, look how the strings for hfunc names are fetched - they are
fetched over a different socket, right?
