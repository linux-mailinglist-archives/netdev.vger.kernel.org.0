Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7C82A8701
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732049AbgKETX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgKETX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 14:23:57 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52EF32078E;
        Thu,  5 Nov 2020 19:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604604236;
        bh=3k6//KuwKs+rVXLHhsgOfv8phTtZpNzR3vN12AlbkP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZGpTr0aOqv4peASmmBi0mWH3deFPAVivDt5Y6PchloQNHLasd5tfYNWjfus1mD+DG
         1xVONr6qz2ms8BusCsKJDl+Dn7zumSB6yXxCVmgz961VuxotVxvCkxk9pLfrE8BGll
         /1mLhbpeZxRHBMJUKhgDs43yX0oexoL8dKAszle0=
Message-ID: <011c4d4e2227df793f615b7638165c266763e24a.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        George Cherian <gcherian@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Date:   Thu, 05 Nov 2020 11:23:54 -0800
In-Reply-To: <20201105090724.761a033d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
         <20201105090724.761a033d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 09:07 -0800, Jakub Kicinski wrote:
> On Thu, 5 Nov 2020 13:36:56 +0000 George Cherian wrote:
> > > Now i am a little bit skeptic here, devlink health reporter
> > > infrastructure was
> > > never meant to deal with dump op only, the main purpose is to
> > > diagnose/dump and recover.
> > > 
> > > especially in your use case where you only report counters, i
> > > don't believe
> > > devlink health dump is a proper interface for this.  
> > These are not counters. These are error interrupts raised by HW
> > blocks.
> > The count is provided to understand on how frequently the errors
> > are seen.
> > Error recovery for some of the blocks happen internally. That is
> > the reason,
> > Currently only dump op is added.
> 
> The previous incarnation was printing messages to logs, so I assume
> these errors are expected to be relatively low rate.
> 
> The point of using devlink health was that you can generate a netlink
> notification when the error happens. IOW you need some calls to
> devlink_health_report() or such.
> 
> At least that's my thinking, others may disagree.

If you report an error without recovering, devlink health will report a
bad device state

$ ./devlink health
   pci/0002:01:00.0:
     reporter npa
       state error error 1 recover 0

So you will need to implement an empty recover op.
so if these events are informational only and they don't indicate
device health issues, why would you report them via devlink health ?

