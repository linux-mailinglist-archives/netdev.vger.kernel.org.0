Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2562F33145C
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 18:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhCHRQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 12:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhCHRQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 12:16:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD903650E5;
        Mon,  8 Mar 2021 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615223762;
        bh=QxYEMzG54QcZOmrgyJ2AqQA9tLSJ/6v2ypz9WHTOThM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E44IZ523+lFDyzszdJIegBaAiXmtIa1CXsr/z9E8Eb6kQG8iGqjfZKPOX6pVRZVLw
         nmmbOOuodZvhqDtkcLqR5F6fFojw4LkKeAK5EprBOF5nbbj2U4lRFejmNX1eP0S463
         ety3GeBKwKTsaIJjris1ziuTWPOvwUWmOxHRJ99k25HWSi9tbXMLBINPCxlVVkAo/x
         F0iOZuV+unMv5a9cwNjvfE68J2ZA9LR5dJXos1wjL9R6bKly3s6QnJ1hGHzO3Bj1AM
         sZTaLiybkncF4cWlyIjN9nlBmUlJBr4rRuMQZmgpBE7FVdQSyioVINW5FHhab26dsk
         WVDVB3sG227MA==
Date:   Mon, 8 Mar 2021 09:16:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
Subject: Re: [RFC] devlink: health: add remediation type
Message-ID: <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
References: <20210306024220.251721-1-kuba@kernel.org>
        <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Mar 2021 17:59:58 +0200 Eran Ben Elisha wrote:
> On 3/6/2021 4:42 AM, Jakub Kicinski wrote:
> > Currently devlink health does not give user any clear information
> > of what kind of remediation ->recover callback will perform. This
> > makes it difficult to understand the impact of enabling auto-
> > -remediation, and the severity of the error itself.
> > 
> > To allow users to make more informed decision, as well as stretch
> > the applicability of devlink health beyond what can be fixed by
> > resetting things - add a new remediation type attribute.
> > 
> > Note that we only allow one remediation type per reporter, this
> > is intentional. devlink health is not built for mixing issues
> > of different severity into one reporter since it only maintains
> > one dump, of the first event and a single error counter.
> > Nudging vendors towards categorizing issues beyond coarse
> > groups is an added bonus.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >   include/net/devlink.h        |  2 ++
> >   include/uapi/linux/devlink.h | 30 ++++++++++++++++++++++++++++++
> >   net/core/devlink.c           |  7 +++++--
> >   3 files changed, 37 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/devlink.h b/include/net/devlink.h
> > index 853420db5d32..70b5fd6a8c0d 100644
> > --- a/include/net/devlink.h
> > +++ b/include/net/devlink.h
> > @@ -664,6 +664,7 @@ enum devlink_health_reporter_state {
> >   /**
> >    * struct devlink_health_reporter_ops - Reporter operations
> >    * @name: reporter name
> > + * remedy: severity of the remediation required
> >    * @recover: callback to recover from reported error
> >    *           if priv_ctx is NULL, run a full recover
> >    * @dump: callback to dump an object
> > @@ -674,6 +675,7 @@ enum devlink_health_reporter_state {
> >   
> >   struct devlink_health_reporter_ops {
> >   	char *name;
> > +	enum devlink_health_reporter_remedy remedy;
> >   	int (*recover)(struct devlink_health_reporter *reporter,
> >   		       void *priv_ctx, struct netlink_ext_ack *extack);
> >   	int (*dump)(struct devlink_health_reporter *reporter,
> > diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> > index f6008b2fa60f..bd490c5536b1 100644
> > --- a/include/uapi/linux/devlink.h
> > +++ b/include/uapi/linux/devlink.h
> > @@ -534,6 +534,9 @@ enum devlink_attr {
> >   	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
> >   
> >   	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
> > +
> > +	DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,	/* u32 */
> > +
> >   	/* add new attributes above here, update the policy in devlink.c */
> >   
> >   	__DEVLINK_ATTR_MAX,
> > @@ -608,4 +611,31 @@ enum devlink_port_fn_opstate {
> >   	DEVLINK_PORT_FN_OPSTATE_ATTACHED,
> >   };
> >   
> > +/**
> > + * enum devlink_health_reporter_remedy - severity of remediation procedure
> > + * @DLH_REMEDY_NONE: transient error, no remediation required  
> DLH_REMEDY_LOCAL_FIX: associated component will undergo a local 
> un-harmful fix attempt.
> (e.g look for lost interrupt in mlx5e_tx_reporter_timeout_recover())

Should we make it more specific? Maybe DLH_REMEDY_STALL: device stall
detected, resumed by re-trigerring processing, without reset?

> > + * @DLH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
> > + *			will be reset
> > + * @DLH_REMEDY_RESET: full device reset, will result in temporary unavailability
> > + *			of the device, device configuration should not be lost
> > + * @DLH_REMEDY_REINIT: device will be reinitialized and configuration lost
> > + * @DLH_REMEDY_POWER_CYCLE: device requires a power cycle to recover
> > + * @DLH_REMEDY_REIMAGE: device needs to be reflashed
> > + * @DLH_REMEDY_BAD_PART: indication of failing hardware, device needs to be
> > + *			replaced
> > + *
> > + * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
> > + * by the severity of the required remediation, and indicates the remediation
> > + * type to the user if it can't be applied automatically (e.g. "reimage").
> > + */  
> The assumption here is that a reporter's recovery function has one 
> remedy. But it can have few remedies and escalate between them. Did you 
> consider a bitmask?

Yes, I tried to explain in the commit message. If we wanted to support
escalating remediations we'd also need separate counters etc. I think
having a health reporter per remediation should actually work fairly
well.

The major case where escalations would be immediately useful would be
cases where normal remediation failed therefore we need a hard reset.
But in those cases I think having the health reporter in a failed state
should be a sufficient indication to automation to take a machine out
of service and power cycle it.

> > +enum devlink_health_reporter_remedy {
> > +	DLH_REMEDY_NONE = 1,
> > +	DLH_REMEDY_COMP_RESET,
> > +	DLH_REMEDY_RESET,
> > +	DLH_REMEDY_REINIT,
> > +	DLH_REMEDY_POWER_CYCLE,
> > +	DLH_REMEDY_REIMAGE,  
> In general, I don't expect a reported to perform POWER_CYCLE or REIMAGE 
> as part of the recovery.

Right, these are extending the use of health reporters beyond what can
be remediated automatically.

> > +	DLH_REMEDY_BAD_PART,  
> BAD_PART probably indicates that the reporter (or any command line 
> execution) cannot recover the issue.
> As the suggested remedy is static per reporter's recover method, it 
> doesn't make sense for one to set a recover method that by design cannot 
> recover successfully.
> 
> Maybe we should extend devlink_health_reporter_state with POWER_CYCLE, 
> REIMAGE and BAD_PART? To indicate the user that for a successful 
> recovery, it should run a non-devlink-health operation?

Hm, export and extend devlink_health_reporter_state? I like that idea.

> > diff --git a/net/core/devlink.c b/net/core/devlink.c
> > index 737b61c2976e..73eb665070b9 100644
> > --- a/net/core/devlink.c
> > +++ b/net/core/devlink.c
> > @@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
> >   {
> >   	struct devlink_health_reporter *reporter;
> >   
> > -	if (WARN_ON(graceful_period && !ops->recover))
> > +	if (WARN_ON(graceful_period && !ops->recover) ||
> > +	    WARN_ON(!ops->remedy))  
> Here you fail every reported that doesn't have remedy set, not only the 
> ones with recovery callback

Right, DLH_REMEDY_NONE doesn't require a callback. Some health
issues can be remedied by the device e.g. ECC errors or something
along those lines. Obviously non-RFC patch will have to come with
driver changes.

> >   		return ERR_PTR(-EINVAL);
> >   
> >   	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
> > @@ -6263,7 +6264,9 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
> >   	if (!reporter_attr)
> >   		goto genlmsg_cancel;
> >   	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
> > -			   reporter->ops->name))
> > +			   reporter->ops->name) ||
> > +	    nla_put_u32(msg, DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,
> > +			reporter->ops->remedy))  
> Why not new if clause like all other attributes later.

Eh.

> >   		goto reporter_nest_cancel;
> >   	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
> >   		       reporter->health_state))
> >   

