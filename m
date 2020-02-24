Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CB616A6F2
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBXNJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:09:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49203 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgBXNJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:09:01 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6DTm-0004on-OG; Mon, 24 Feb 2020 13:08:58 +0000
Date:   Mon, 24 Feb 2020 14:08:57 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/9] sysfs: add
 sysfs_file_change_owner{_by_name}()
Message-ID: <20200224130857.pllstmqb6c2mz7wz@wittgenstein>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
 <20200218162943.2488012-2-christian.brauner@ubuntu.com>
 <20200220112049.GF3374196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200220112049.GF3374196@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 12:20:49PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Feb 18, 2020 at 05:29:35PM +0100, Christian Brauner wrote:
> > +/**
> > + *	sysfs_file_change_owner - change owner of a file.
> > + *	@kobj:	object.
> > + *	@kuid: new owner's kuid
> > + *	@kgid: new owner's kgid
> > + */
> > +int sysfs_file_change_owner(struct kobject *kobj, kuid_t kuid, kgid_t kgid)
> > +{
> > +	struct kernfs_node *kn;
> > +	int error;
> > +
> > +	if (!kobj->state_in_sysfs)
> > +		return -EINVAL;
> > +
> > +	kernfs_get(kobj->sd);
> > +
> > +	kn = kobj->sd;
> > +	error = internal_change_owner(kn, kobj, kuid, kgid);
> > +
> > +	kernfs_put(kn);
> > +
> > +	return error;
> > +}
> > +EXPORT_SYMBOL_GPL(sysfs_file_change_owner);
> 
> Oops, wait, what "file" are you changing here?  You aren't changing the
> kobject's attributes, but rather a file in the kobject's directory,
> right?  But kobj->sd is the directory of the kobject itself, so why
> isn't this function just the same thing as sysfs_change_owner()?

I've moved it directly into sysfs_change_owner(), removed the function,
and renamed "_by_name()" back to sysfs_file_change_owner() which is
easier to parse and makes more sense.
