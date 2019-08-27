Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9569F37A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 21:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbfH0TuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 15:50:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbfH0TuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 15:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g5YcAJTDw7ZOoH+1PHowGqAutoR9GsZhyJRGntJLWSY=; b=w5HbRPmhQdyFsdc0ynsXtsj16A
        R2WK503XTfnU5QZoiTYoW+WtyMHRz0JK1bZHscw4RMTBhYr783WjVQDWPa8WoLap7zwu1O8e3rCGh
        RM7B7eMeipZy6fNa03cBDAKKNaifP8H3VxNlxdyUVTWvJRMSnvZGFw1R3/kDdK7z4ISU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2hTt-0005tN-OF; Tue, 27 Aug 2019 21:50:17 +0200
Date:   Tue, 27 Aug 2019 21:50:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190827195017.GR2168@lunn.ch>
References: <20190826213339.56909-1-snelson@pensando.io>
 <20190826213339.56909-3-snelson@pensando.io>
 <20190827022628.GD13411@lunn.ch>
 <ab2d6525-e1e1-ef87-7150-dabfaee5b6ff@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab2d6525-e1e1-ef87-7150-dabfaee5b6ff@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 10:39:20AM -0700, Shannon Nelson wrote:
> On 8/26/19 7:26 PM, Andrew Lunn wrote:
> >On Mon, Aug 26, 2019 at 02:33:23PM -0700, Shannon Nelson wrote:
> >>+void ionic_debugfs_add_dev(struct ionic *ionic)
> >>+{
> >>+	struct dentry *dentry;
> >>+
> >>+	dentry = debugfs_create_dir(ionic_bus_info(ionic), ionic_dir);
> >>+	if (IS_ERR_OR_NULL(dentry))
> >>+		return;
> >>+
> >>+	ionic->dentry = dentry;
> >>+}
> >Hi Shannon
> >
> >There was recently a big patchset from GregKH which removed all error
> >checking from drivers calling debugfs calls. I'm pretty sure you don't
> >need this check here.
> 
> With this check I end up either with a valid dentry value or NULL in
> ionic->dentry.  Without this check I possibly get an error value in
> ionic->dentry, which can get used later as the parent dentry to try to make
> a new debugfs node.

Hi Shannon

What you should find is that every debugfs function will have
something like:

	if (IS_ERR(dentry))
	   return dentry;
or
	if (IS_ERR(parent))
	   return parent;

If you know of a API which is missing such protection, i'm sure GregKH
would like to know. Especially since he just ripped all such
protection in driver out. Meaning he just broken some drivers if such
IS_ERR() calls are missing in the debugfs core.

> >I would be happier if there was a privacy statement, right here,
> >saying what this information is used for, and an agreement it is not
> >used for anything else. If that gets violated, you can then only blame
> >yourself when we ripe this out and hard code it to static values.
> 
> That makes perfect sense.
> 
> I can add a full description here of how the information will be used, which
> should help most folks, but I'm sure there will still be some that don't
> want this info released.
> 
> What I'd like to propose here is that I do the hardcoded strings myself for
> now, and I work up a way for the users to enable the feature as desired,
> with a reasonable comment here in the code and in the
> Documentation/.../ionic.rst file.  This might end up as an ethtool priv-flag
> that defaults to off and can set a NIC value that is remembered for later.
> 
> Does that sound reasonable?

Yes, that sounds reasonable.

Thanks
	Andrew
