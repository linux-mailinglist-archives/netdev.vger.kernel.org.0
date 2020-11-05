Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EBF2A8B08
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 00:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgKEXwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 18:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730895AbgKEXwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 18:52:35 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0512C20739;
        Thu,  5 Nov 2020 23:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604620354;
        bh=zVN6qcOZyRn/6G2pAEK9dZgGcVU1Xsvgk0SwNKZ3JdY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FVkYF3p4Xaw853vnm3cExPWB3x42IussfibeA4j5AYEdPrp4sBagcrNoYbmTbFo7T
         agQ3iSIHEoCtos56qI27q2D3bwQFdF1ZnOvqXj7bAzN2B+qQArefknhR0Ms0nRffdx
         AvI7Hlvxk/nJtr+iy23HbHRZy093iRsPdorf9UJ4=
Message-ID: <1b96abb1da9bca4d9f962babad9a0724c1188437.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     George Cherian <gcherian@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
Date:   Thu, 05 Nov 2020 15:52:32 -0800
In-Reply-To: <20201105124204.4dbea042@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <BYAPR18MB2679EC3507BD90B93B37A3F8C5EE0@BYAPR18MB2679.namprd18.prod.outlook.com>
         <20201105090724.761a033d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <011c4d4e2227df793f615b7638165c266763e24a.camel@kernel.org>
         <20201105124204.4dbea042@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 12:42 -0800, Jakub Kicinski wrote:
> On Thu, 05 Nov 2020 11:23:54 -0800 Saeed Mahameed wrote:
> > If you report an error without recovering, devlink health will
> > report a
> > bad device state
> > 
> > $ ./devlink health
> >    pci/0002:01:00.0:
> >      reporter npa
> >        state error error 1 recover 0
> 
> Actually, the counter in the driver is unnecessary, right? Devlink
> counts errors.
>  

if you mean error and recover counters, then yes. they are managed by
devlink health

every call to dl-health-report will do:

devlink_health_report(reporter, err_ctx, msg)
{
      reproter.error++;

      devlink_trigger_event(reporter, msg);

      reporter.dump(err_ctx, msg);
      reporter.diag(err_ctx);

      if (!reporter.recover(err_ctx))
             reporter.recover++;
}

so dl-health reports without a recover op will confuse the user if user
sees error count > recover count.

error count should only be grater than recover count when recover
procedure fails which now will indicate the device is not in a healthy
state.

also i want to clarify one small note about devlink dump.

devlink health dump semantics:
on devlink health dump, the devlink health will check if previous dump
exists and will just return it without actually calling the driver, if
not then it will call the driver to perform a new dump and will cache
it.

user has to explicitly clear the devlink health dump of that reporter
in order to allow for newer dump to get generated.

this is done this way because we want the driver to store the dump of
the previously reported errors at the moment the erorrs are reported by
driver, so when a user issue  a dump command the dump of the previous
error will be reported to user form memory without the need to access
driver/hw who might be in a bad state.

so this is why using devlink dump for reporting counters doesn't really
work, it will only report the first time the counters are accessed via
devlink health dump, after that it will report the same cached values
over and over until the user clears it up.


> > So you will need to implement an empty recover op.
> > so if these events are informational only and they don't indicate
> > device health issues, why would you report them via devlink health
> > ?
> 
> I see devlink health reporters a way of collecting errors reports
> which
> for the most part are just shared with the vendor. IOW firmware (or
> hardware) bugs.
> 
> Obviously as you say without recover and additional context in the
> report the value is quite diminished. But _if_ these are indeed
> "report
> me to the vendor" kind of events then at least they should use our
> current mechanics for such reports - which is dl-health.
> 
> Without knowing what these events are it's quite hard to tell if
> devlink health is an overkill or counter is sufficient.
> 
> Either way - printing these to the logs is definitely the worst
> choice
> :)

Sure, I don't mind using devlink health for dump only, I don't really
have strong feelings against this, they can always extend it in the
future.

it just doesn't make sense to me to have it mainly used for dumping
counters and without using devlik helath utilities, like events,
reports and recover.

so maybe Sunil et al. could polish this patchset and provide more
devlink health support, like diagnose for these errors, dump HW
information and contexts related to these errors so they could debug
root causes, etc .. 
Then the use for dl health in this series can be truly justified.







