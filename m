Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4F02AFAFC
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgKKWEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgKKWEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:04:33 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B9E72087D;
        Wed, 11 Nov 2020 22:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605132271;
        bh=6sleayhcVSfEphEOzhpuo8Eufu2Br31APK/mDMajiVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XexDvTYqp3OouX1/Z/04MLFD5u672r2C60j23FibwvCTyNsSn9tU5Cl+SJHXhhJi0
         XppzT6YkmVgAup5pdxAVSK6XKqDHryQNMlB/fpH+0oynZ/cT8H5XND1sO+jWFm+zFQ
         AGzn08AOYYd6hz4GQpzUqFAyD5J18XaF0ITC8NxM=
Date:   Wed, 11 Nov 2020 14:04:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/5] bonding: rename bond components
Message-ID: <20201111140429.25ab20b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <10065.1605125636@famine>
References: <20201106200436.943795-1-jarod@redhat.com>
        <10065.1605125636@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 12:13:56 -0800 Jay Vosburgh wrote:
> Jarod Wilson <jarod@redhat.com> wrote:
> 
> >The bonding driver's use of master and slave, while largely understood
> >in technical circles, poses a barrier for inclusion to some potential
> >members of the development and user community, due to the historical
> >context of masters and slaves, particularly in the United States. This
> >is a first full pass at replacing those phrases with more socially
> >inclusive ones, opting for bond to replace master and port to
> >replace slave, which is congruent with the bridge and team drivers.
> >
> >There are a few problems with this change. First up, "port" is used in
> >the bonding 802.3ad code, so the first step here is to rename port to
> >ad_port, so we can reuse port. Second, we have the issue of not wanting
> >to break any existing userspace, which I believe this patchset
> >accomplishes, preserving all existing sysfs and procfs interfaces, and
> >adding module parameter aliases where necessary.
> >
> >Third, we do still have the issue of ease of backporting fixes to
> >-stable trees. I've not had a huge amount of time to spend on it, but
> >brief forays into coccinelle didn't really pay off (since it's meant to
> >operate on code, not patches), and the best solution I can come up with
> >is providing a shell script someone could run over git-format-patch
> >output before git-am'ing the result to a -stable tree, though scripting
> >these changes in the first place turned out to be not the best thing to
> >do anyway, due to subtle cases where use of master or slave can NOT yet
> >be replaced, so a large amount of work was done by hand, inspection,
> >trial and error, which is why this set is a lot longer in coming than
> >I'd originally hoped. I don't expect -stable backports to be horrible to
> >figure out one way or another though, and I don't believe that a bit of
> >inconvenience on that front is enough to warrant not making these
> >changes.  
> 
> 	I think this undersells the impact a bit; this will most likely
> break the majority of cherry-picks for the bonding driver to stable
> going forward should this patch set be committed.  Yes, the volume of
> patches to bonding is relatively low, and the manual backports are not
> likely to be technically difficult.  Nevertheless, I expect that most
> bonding backports to stable that cross this patch set will require
> manual intervention.
> 
> 	As such, I'd still like to see explicit direction from the
> kernel development community leadership that change sets of this nature
> (not technically driven, with long term maintenance implications) are
> changes that should be undertaken rather than are merely permitted.

Yeah, IDK. I think it's up to you as the maintainer of this code to
make a call based on the specific circumstances. All we have AFAIK
is the coding style statement which discourages new uses:

  For symbol names and documentation, avoid introducing new usage of
  'master / slave' (or 'slave' independent of 'master') and 'blacklist /
  whitelist'.

  Recommended replacements for 'master / slave' are:
    '{primary,main} / {secondary,replica,subordinate}'
    '{initiator,requester} / {target,responder}'
    '{controller,host} / {device,worker,proxy}'
    'leader / follower'
    'director / performer'

  Recommended replacements for 'blacklist/whitelist' are:
    'denylist / allowlist'
    'blocklist / passlist'

  Exceptions for introducing new usage is to maintain a userspace ABI/API,
  or when updating code for an existing (as of 2020) hardware or protocol
  specification that mandates those terms. For new specifications
  translate specification usage of the terminology to the kernel coding
  standard where possible.
