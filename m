Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C223A4270AB
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 20:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhJHSX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhJHSX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D78360F02;
        Fri,  8 Oct 2021 18:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633717320;
        bh=TciaTrj54lp6qBJCXrKVosKbY1g/Wgir15vVcrHSNlM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bwfDCuj7UPyIXNiK0As/R+MsJkIBWD1WYPhMzpsSnPCKdQWEA1JT15WwwyPupuRAK
         xi77g7ulDnaWofMHgwgNppU1pbUamEEYJFSu9qVWO+5lY5MZWYCOHJ4Ixr8Om7rS0U
         zA/0X3kUzMyf/RGbFbAgPZkFRjV9o428edGBgE4WHOCc3ZPV9TOVLTv4ouHNBfL8Ii
         ILotANmM1YCVTClwn7ujmBNOtRZdt/PLwxn5ZPUepNFlhqWn5IXPsk+ndr/E3NHco8
         Xt4GuRuLu2wO04J5Sdh/REH+gvtKuA8mcCnH6jXp/8Qyw+s1HlmZUv0wlJ/qdoL7Tn
         wxK941tIcJanA==
Date:   Fri, 8 Oct 2021 11:21:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
Message-ID: <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YWA7keYHnhlHCkKT@nanopsycho>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Oct 2021 14:37:37 +0200 Jiri Pirko wrote:
> Fri, Oct 08, 2021 at 12:41:11PM CEST, jacob.e.keller@intel.com wrote:
> >This is an implementation of a previous idea I had discussed on the list at
> >https://lore.kernel.org/netdev/51a6e7a33c7d40889c80bf37159f210e@intel.com/
> >
> >The idea is to allow user space to query whether a given destructive devlink
> >command would work without actually performing any actions. This is commonly
> >referred to as a "dry run", and is intended to give tools and system
> >administrators the ability to test things like flash image validity, or
> >whether a given option is valid without having to risk performing the update
> >when not sufficiently ready.
> >
> >The intention is that all "destructive" commands can be updated to support
> >the new DEVLINK_ATTR_DRY_RUN, although this series only implements it for
> >flash update.
> >
> >I expect we would want to support this for commands such as reload as well
> >as other commands which perform some action with no interface to check state
> >before hand.
> >
> >I tried to implement the DRY_RUN checks along with useful extended ACK
> >messages so that even if a driver does not support DRY_RUN, some useful
> >information can be retrieved. (i.e. the stack indicates that flash update is
> >supported and will validate the other attributes first before rejecting the
> >command due to inability to fully validate the run within the driver).  
> 
> Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
> really dry run. I guess that user might be surprised in that case...

Would it be enough to do a policy dump in user space to check attr is
recognized and add a warning that this is required next to the attr
in the uAPI header?
