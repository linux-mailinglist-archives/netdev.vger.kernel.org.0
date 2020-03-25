Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFDC192E79
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCYQnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbgCYQnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 12:43:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD9962073E;
        Wed, 25 Mar 2020 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585154587;
        bh=7TMtuySruvHHcchF36FPpNb2QqP1TWDds4GwT4C/1HQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nQ6K429B3smQECECGxav7S/4s34FmU7p9PzZXUnC4qJxn8J8Ei06gNIPZ99OS2GPN
         kUERmV5VjEl/1J0HwUJIFWckXoIhDtf2hvTgXyzKJkmz7CKJOj390Z0UHMfWPYzENs
         ICV9HPOqtJZkMfobLSTrvgszOKUEcba0I1Qy1sM8=
Date:   Wed, 25 Mar 2020 09:43:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/15] devlink: Add packet trap policers
 support
Message-ID: <20200325094305.15f9ea24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325094143.GA1332836@splinter>
References: <20200324193250.1322038-1-idosch@idosch.org>
        <20200324193250.1322038-2-idosch@idosch.org>
        <20200324203109.71e1efc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200325094143.GA1332836@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 11:41:43 +0200 Ido Schimmel wrote:
> On Tue, Mar 24, 2020 at 08:31:09PM -0700, Jakub Kicinski wrote:
> > On Tue, 24 Mar 2020 21:32:36 +0200 Ido Schimmel wrote:  
> > > +/**
> > > + * devlink_trap_policers_register - Register packet trap policers with devlink.
> > > + * @devlink: devlink.
> > > + * @policers: Packet trap policers.
> > > + * @policers_count: Count of provided packet trap policers.
> > > + *
> > > + * Return: Non-zero value on failure.
> > > + */
> > > +int
> > > +devlink_trap_policers_register(struct devlink *devlink,
> > > +			       const struct devlink_trap_policer *policers,
> > > +			       size_t policers_count)
> > > +{
> > > +	int i, err;
> > > +
> > > +	mutex_lock(&devlink->lock);
> > > +	for (i = 0; i < policers_count; i++) {
> > > +		const struct devlink_trap_policer *policer = &policers[i];
> > > +
> > > +		if (WARN_ON(policer->id == 0)) {
> > > +			err = -EINVAL;
> > > +			goto err_trap_policer_verify;
> > > +		}
> > > +
> > > +		err = devlink_trap_policer_register(devlink, policer);
> > > +		if (err)
> > > +			goto err_trap_policer_register;
> > > +	}
> > > +	mutex_unlock(&devlink->lock);
> > > +
> > > +	return 0;
> > > +
> > > +err_trap_policer_register:
> > > +err_trap_policer_verify:  
> > 
> > nit: as you probably know the label names are not really in compliance
> > with:
> > https://www.kernel.org/doc/html/latest/process/coding-style.html#centralized-exiting-of-functions
> > ;)  
> 
> Hi Jakub, thanks for the thorough review!
> 
> I assume you're referring to the fact that the label does not say what
> the goto does? It seems that the coding style guide also allows for
> labels that indicate why the label exists: "Choose label names which say
> what the goto does or why the goto exists".

Hm, why the label exists to me does not mean identify the source of the
jump. It's quite logical to name the label after the target, because
then you can just read the body of the function, and validate the jumps
undo the right things based on their names. Is the reason to name
labels after source so that the label doesn't have to be renamed if
steps are inserted in the middle? Can't think of anything else.

Anyway, it's not a big deal, but please be prepared for me to keep
bringing this up :)

> This is the form I'm used to, but I do adjust the names in code that
> uses the other form (such as in netdevsim).
> 
> I already used this form in previous devlink submissions, so I would
> like to stick to it unless you/Jiri have strong preference here.
