Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7697A139033
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgAMLel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:34:41 -0500
Received: from mx4.wp.pl ([212.77.101.11]:31104 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgAMLel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 06:34:41 -0500
Received: (wp-smtpd smtp.wp.pl 1922 invoked from network); 13 Jan 2020 12:34:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578915279; bh=iQ0nggdey2ZPVnoSjqedUA+2gwem6PFelkSXn/nb/NI=;
          h=From:To:Cc:Subject;
          b=dG2vVrEhqO3WAXJskzkApZqnb8kuAbcVNQOlXjmUkRE/XZE2nPOWbZQAgRWWpdof+
           YF958KctVfwXUTTcED3UwtMTU89movHFxLJxTmvLk5H9rah/0OKm5010cWgRZlmJP+
           S0oVz4QyhT63NYxgPHxLARd63OkPTWLF5nyVf440=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <linyunsheng@huawei.com>; 13 Jan 2020 12:34:38 +0100
Date:   Mon, 13 Jan 2020 03:34:31 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Alex Vesker <valex@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Message-ID: <20200113033431.1d32dcbe@cakuba>
In-Reply-To: <421f78c2-7713-b931-779e-dfe675fe5f53@huawei.com>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
        <4d8fe881-8d36-06dd-667a-276a717a0d89@huawei.com>
        <1d00deb9-16fc-b2a5-f8f7-5bb8316dbac2@intel.com>
        <fe6c0d5e-5705-1118-1a71-80bd0e26a97e@huawei.com>
        <20200112124521.467fa06a@cakuba>
        <DB6PR0501MB224859D8DC219E81D4CFB17CC33A0@DB6PR0501MB2248.eurprd05.prod.outlook.com>
        <421f78c2-7713-b931-779e-dfe675fe5f53@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 9650bdc1223cf781506c3d4191338ec1
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [YaP0]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 09:39:50 +0800, Yunsheng Lin wrote:
> On 2020/1/13 5:18, Alex Vesker wrote:
> > On 1/12/2020 10:45 PM, Jakub Kicinski wrote:  
> >> I think there is a fundamental difference between health API and
> >> regions in the fact that health reporters allow for returning
> >> structured data from different sources which are associated with 
> >> an event/error condition. That includes information read from the
> >> hardware or driver/software state. Region API (as Jake said) is good
> >> for dumping arbitrary addressable content, e.g. registers. I don't see
> >> much use for merging the two right now, FWIW...  
> 
> The point is that we are beginning to use health API for event/error
> condition, right? Do we use health API or regions API to dump a arbitrary
> addressable content when there is an event/error detected?
> 
> Also we may need to dump both a arbitrary addressable content and the

If the information dumped is pertinent in the context of a health event
it's not arbitrary.

> structured data when there is an event/error detected, the health API or
> regions API can not do both, right?

I think for errors and events health API will be more suitable 99% of
the time.

> It still seems it is a little confusing when deciding to use health or
> regions API.
>
> > Totally agree with Jakub, I think health and region are different and
> > each has its
> > usages as mentioned above. Using words such as recovery and health for
> > exposing
> > registers doesn't sound correct. There are future usages I can think of
> > for region if we
> > will add the trigger support as well as the live region read.  
> 
> health API already has "trigger support" now if region API is merged to
> health API.
> 
> I am not sure I understand "live region" here, what is the usecase of live
> region?

Reading registers of a live system without copying them to a snapshot
first. Some chips have so many registers it's impractical to group them
beyond "registers of IP block X", if that. IMHO that fits nicely with
regions, health is grouped by event, so we'd likely want to dump for
example one or two registers from the MAC there, while the entire set
of MAC registers can be exposed as a region.
