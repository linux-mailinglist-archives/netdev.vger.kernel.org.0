Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7840E47BD07
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhLUJku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:40:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236423AbhLUJku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 04:40:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=C8gLk23HObP+MNu+rJdZ+1w/QBxkoOZDopUdqlCDZrI=; b=4SxhqyDKu3SiGhBJqha2gXkLWq
        Cl8S8h1M08vUg24ofr6/2NVYO2E0QG634JCg4iSxRghV5KfdXvsszvSku+oQtFGbMeTI+eFSkJghw
        or+PRUHlrqRgpp9FgpxkIR6s++zXV7IK+7aLWmmT2meLvTX69svKLGtcyeKBaxPMI2Qw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzbdT-00H7Cf-So; Tue, 21 Dec 2021 10:40:43 +0100
Date:   Tue, 21 Dec 2021 10:40:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, dan.j.williams@intel.com,
        pierre-louis.bossart@linux.intel.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Message-ID: <YcGhG8bdUi4WyXAf@lunn.ch>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 1. Before a scheduling domain is created/enabled, a set of parameters are
> passed to the kernel driver via configfs attribute files in an configfs domain
> directory (say $domain) created by user. Each attribute file corresponds to
> a configuration parameter of the domain. After writing to all the attribute
> files, user writes 1 to "create" attribute, which triggers an action (i.e.,
> domain creation) in the kernel driver. Since multiple processes/users can
> access the $domain directory, multiple users can write to the attribute files
> at the same time.  How do we guarantee an atomic update/configuration of a
> domain? In other words, if user A wants to set attributes 1 and 2, how can we
> prevent user B from changing attribute 1 and 2 before user A writes 1 to
> "create"? A configfs directory with individual attribute files seems to not
> be able to provide atomic configuration in this case. One option to solve this
> issue could be write a structured data (with a set of parameters) to a single
> attribute file. This would guarantee the atomic configuration, but may not be
> a conventional configfs operation.

How about throw away configfs and use netlink? Messages are atomic,
and you can add an arbitrary number of attributes to a single netlink
message. It will also make your code more network like, since nothing
else in the network stack uses configfs, as far as i know.

    Andrew
