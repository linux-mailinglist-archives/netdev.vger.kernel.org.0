Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B505017E823
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgCITR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgCITRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 15:17:25 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D0620848;
        Mon,  9 Mar 2020 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583781445;
        bh=YCYmIyc2IpvONTi3cH/apHZ9jju9R6enSb2WW6eWfdM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pLX1wTOyM3mRAGdwcGU+iSlrVS02l9a6F45nwM+TNFcPeDp1krG+pmTraHQXmQ702
         +smOv1BQDHTIij5+x25JpZqT2uvERxCYWAUMQtGqYrFN+vr64uMe//MEzmmx2wRQte
         HW2UPjNiDesUHYw5yn4mUBhcM+fMiT6bvjlPz6S0=
Date:   Mon, 9 Mar 2020 12:17:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 03/10] flow_offload: check for basic action
 hw stats type
Message-ID: <20200309121722.6f536941@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200307065948.GB2210@nanopsycho.orion>
References: <20200306132856.6041-1-jiri@resnulli.us>
        <20200306132856.6041-4-jiri@resnulli.us>
        <20200306112851.2dc630e7@kicinski-fedora-PC1C0HJN>
        <20200307065948.GB2210@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Mar 2020 07:59:48 +0100 Jiri Pirko wrote:
> >> +static inline bool
> >> +flow_action_hw_stats_types_check(const struct flow_action *action,
> >> +				 struct netlink_ext_ack *extack,
> >> +				 u8 allowed_hw_stats_type)
> >> +{
> >> +	const struct flow_action_entry *action_entry;
> >> +
> >> +	if (!flow_action_has_entries(action))
> >> +		return true;
> >> +	if (!flow_action_mixed_hw_stats_types_check(action, extack))
> >> +		return false;
> >> +	action_entry = flow_action_first_entry_get(action);
> >> +	if (!allowed_hw_stats_type &&
> >> +	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
> >> +		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
> >> +		return false;
> >> +	} else if (allowed_hw_stats_type &&
> >> +		   action_entry->hw_stats_type != allowed_hw_stats_type) {  
> >
> >Should this be an logical 'and' if we're doing it the bitfield way?  
> 
> No. I driver passes allowed_hw_stats_type != 0, means that allowed_hw_stats_type
> should be checked against action_entry->hw_stats_type.

Right, the "allowed_hw_stats_type &&" is fine.

> With bitfield, this is a bit awkward, I didn't figure out to do it
> better though.

The bitfield passed from user space means any of the set bits, right?

Condition would be better as:

allowed_hw_stats_type && (allowed_hw_stats_type & entry->hw_stats_type)

Otherwise passing more than one bit will not work well, no?

Driver can pass IMMEDIATE | DELAYED, action has IMMEDIATE, your
condition would reject it.. Same if driver has only one type and user
space asks for any of a few.

Drivers can't do a straight comparisons either, but:

if (act->stats & TYPE1) {
   /* preferred stats type*/
} else if (act->stats & TYPE2) {
   /* also supported, lower prio */
} else if (act->Stats & TYPE3) {
   /* lowest prio */
}
