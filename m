Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDFA6ACB0B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjCFRpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjCFRpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:45:21 -0500
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94F43C22;
        Mon,  6 Mar 2023 09:44:55 -0800 (PST)
Received: from momiji.horms.nl (2a02-a46e-7b6b-703-d63d-7eff-fe99-ac9d.fixed6.kpn.net [IPv6:2a02:a46e:7b6b:703:d63d:7eff:fe99:ac9d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 7611C201E2;
        Mon,  6 Mar 2023 17:43:34 +0000 (UTC)
Received: by momiji.horms.nl (Postfix, from userid 7100)
        id 04D48940205; Mon,  6 Mar 2023 18:43:33 +0100 (CET)
Date:   Mon, 6 Mar 2023 18:43:33 +0100
From:   Simon Horman <horms@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jaewan Kim <jaewan@google.com>, gregkh@linuxfoundation.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 3/5] mac80211_hwsim: add PMSR request support via
 virtio
Message-ID: <ZAYmRWFxHEToVpK/@vergenet.net>
References: <20230302160310.923349-1-jaewan@google.com>
 <20230302160310.923349-4-jaewan@google.com>
 <ZAYe4oATHMdqi/H9@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAYe4oATHMdqi/H9@corigine.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.7 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 06:12:02PM +0100, Simon Horman wrote:
> On Thu, Mar 02, 2023 at 04:03:08PM +0000, Jaewan Kim wrote:
> > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
> > time measurement) is the one and only measurement. FTM is measured by
> > RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> > 
> > Add necessary functionalities for mac80211_hwsim to start PMSR request by
> > passthrough the request to wmediumd via virtio. mac80211_hwsim can't
> > measure RTT for real because mac80211_hwsim the software simulator and
> > packets are sent almost immediately for real. This change expect wmediumd
> > to have all the location information of devices, so passthrough requests
> > to wmediumd.
> > 
> > In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> > mac80211_hwsim receives the PMSR start request via
> > ieee80211_ops.start_pmsr, the received cfg80211_pmsr_request is resent to
> > the wmediumd with command HWSIM_CMD_START_PMSR and attribute
> > HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> > nl80211_pmsr_start() expects.
> > 
> > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > ---
> > V7->V8: Export nl80211_send_chandef directly and instead of creating
> >         wrapper.
> > V7: Initial commit (split from previously large patch)
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c | 207 +++++++++++++++++++++++++-
> >  drivers/net/wireless/mac80211_hwsim.h |   6 +
> >  2 files changed, 212 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> > index 79476d55c1ca..691b83140d57 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
> >  
> >  	/* only used when pmsr capability is supplied */
> >  	struct cfg80211_pmsr_capabilities pmsr_capa;
> > +	struct cfg80211_pmsr_request *pmsr_request;
> > +	struct wireless_dev *pmsr_request_wdev;
> >  
> >  	struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_LINKS];
> >  };
> > @@ -3139,6 +3141,208 @@ static int mac80211_hwsim_change_sta_links(struct ieee80211_hw *hw,
> >  	return 0;
> >  }
> >  
> > +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg,
> > +						     struct cfg80211_pmsr_ftm_request_peer *request)
> > +{
> > +	struct nlattr *ftm;
> > +
> > +	if (!request->requested)
> > +		return -EINVAL;
> > +
> > +	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> > +	if (!ftm)
> > +		return -ENOBUFS;
> > +
> > +	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request->preamble))
> 
> nit: I suspect that you need to invoke nla_nest_cancel() in
>      error paths to unwind nla_nest_start() calls.
> 
> > +		return -ENOBUFS;
> > +
> 
> ...
> 
> > +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> > +					    struct cfg80211_pmsr_request *request)
> > +{
> > +	int err;
> > +	struct nlattr *pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
> nit: reverse xmas tree - longest line to shortest - for local variable
>      declarations.

Sorry, I meant to delete this one.
I don't think it is the practice in this driver.

> 
> > +
> > +	if (!pmsr)
> > +		return -ENOBUFS;
> > +
> > +	if (nla_put_u32(msg, NL80211_ATTR_TIMEOUT, request->timeout))
> > +		return -ENOBUFS;
> > +
> > +	if (!is_zero_ether_addr(request->mac_addr)) {
> > +		if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, request->mac_addr))
> > +			return -ENOBUFS;
> > +		if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN, request->mac_addr_mask))
> > +			return -ENOBUFS;
> > +	}
> > +
> > +	for (int i = 0; i < request->n_peers; i++) {
> 
> nit: the scope of err can be reduced to this block.
> 
> > +		err = mac80211_hwsim_send_pmsr_request_peer(msg, &request->peers[i]);
> > +		if (err)
> > +			return err;
> > +	}
> > +
> > +	nla_nest_end(msg, pmsr);
> > +
> > +	return 0;
> > +}
> 
