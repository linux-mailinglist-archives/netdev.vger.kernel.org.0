Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CA61D8BB9
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgERXnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgERXnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 19:43:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D8AA207D4;
        Mon, 18 May 2020 23:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589845391;
        bh=D24c+IgjnepmdcrjHKSqvthsGvQf/IWTfKzhWqnMPSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GhvHqWN9pZhQTVz8p/anZQUS4EFFC1Kjk+CDKV59646Odq0hQWxR/ZcUbLDyrBip9
         CllXjy5ZBgNokKUxg1ejc06tGKRvCGqjeC0Lmp0iJzx6aCCZwvVAWHoIBjPP/A1ZDv
         ycZKyL9hDo1tpO7QAU5GVEpqpClr7191nz9g3KuU=
Date:   Mon, 18 May 2020 16:43:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200518164309.2065f489@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200518110152.GB2193@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200518110152.GB2193@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 13:01:52 +0200 Jiri Pirko wrote:
> Mon, May 18, 2020 at 10:27:15AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >This patchset adds support for a "enable_hot_fw_reset" generic devlink
> >parameter and use it in bnxt_en driver.
> >
> >Also, firmware spec. is updated to 1.10.1.40.  
> 
> Hi.
> 
> We've been discussing this internally for some time.
> I don't like to use params for this purpose.
> We already have "devlink dev flash" and "devlink dev reload" commands.
> Combination of these two with appropriate attributes should provide what
> you want. The "param" you are introducing is related to either "flash"
> or "reload", so I don't think it is good to have separate param, when we
> can extend the command attributes.
> 
> How does flash&reload work for mlxsw now:
> 
> # devlink flash
> Now new version is pending, old FW is running
> # devlink reload
> Driver resets the device, new FW is loaded
> 
> I propose to extend reload like this:
> 
>  devlink dev reload DEV [ level { driver-default | fw-reset | driver-only | fw-live-patch } ]
>    driver-default - means one of following to, according to what is
>                     default for the driver
>    fw-reset - does FW reset and driver entities re-instantiation
>    driver-only - does driver entities re-instantiation only
>    fw-live-patch - does only FW live patching - no effect on kernel
> 
> Could be an enum or bitfield. Does not matter. The point is to use
> reload with attribute to achieve what user wants. In your usecase, user
> would do:
> 
> # devlink flash
> # devlink reload level fw-live-patch

Unfortunately for SmartNICs and MultiHost systems the reset may not be
initiated locally. I agree it'd be great to have a normal netlink knob
for this instead of a param. But it has to be some form of a policy of
allowing the reset to happen, rather than an action/trigger kind of
thing.

Also user space notification should be generated when reset happens,
IMO. devlink dev info contents will likely change after reset, if
nothing else.

Plus this functionality will need proper documentation.

FWIW - I am unconvinced that applications will be happy to experience
network black outs, rather than being fully killed and re-spawned. For
a micro-service worker shutdown + re-spawn should be bread and butter.
But we already have ionic doing this, so seems like vendors are
convinced otherwise, so a common interface is probably a good step.
