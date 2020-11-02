Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CCA2A3727
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgKBX1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgKBX1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:27:53 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C1A322268;
        Mon,  2 Nov 2020 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604359673;
        bh=UuAkJfEzaECXbsjNNFRbJE8yk5SU++cPwgM2Re7WKuU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zi9hhVtgXC2SYgH3NSRVhpt8luwsK69GiYg87Yp9c50ApYFjrBOAfr3aONNyJymwS
         BBmRZm9GSjNQp32Ct2c0hKBm0EFsUJbw/OkmlKfjEWchLBkasdjwAKtl1kPA1UK4bi
         PdUfBaYXGGaF5iR+LzspG2kDhs/RjglNlyB70t3k=
Message-ID: <33cde8903dbe09a8abda1cd2ae7a9d3fdc2bc5e8.camel@kernel.org>
Subject: Re: [PATCH net-next v2 0/3] net: introduce rps_default_mask
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Date:   Mon, 02 Nov 2020 15:27:51 -0800
In-Reply-To: <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <cover.1604055792.git.pabeni@redhat.com>
         <20201102145447.0074f272@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-11-02 at 14:54 -0800, Jakub Kicinski wrote:
> On Fri, 30 Oct 2020 12:16:00 +0100 Paolo Abeni wrote:
> > Real-time setups try hard to ensure proper isolation between time
> > critical applications and e.g. network processing performed by the
> > network stack in softirq and RPS is used to move the softirq 
> > activity away from the isolated core.
> > 
> > If the network configuration is dynamic, with netns and devices
> > routinely created at run-time, enforcing the correct RPS setting
> > on each newly created device allowing to transient bad
> > configuration
> > became complex.
> > 
> > These series try to address the above, introducing a new
> > sysctl knob: rps_default_mask. The new sysctl entry allows
> > configuring a systemwide RPS mask, to be enforced since receive 
> > queue creation time without any fourther per device configuration
> > required.
> > 

The whole thing can be replaced with a user daemon scripts that
monitors all newly created devices and assign to them whatever rps mask
(call it default).

So why do we need this special logic in kernel ? 

I am not sure about this, but if rps queues sysfs are available before
the netdev is up, then you can also use udevd to assign the rps masks
before such devices are even brought up, so you would avoid the race
conditions that you described, which are not really clear to me to be
honest.

> > Additionally, a simple self-test is introduced to check the 
> > rps_default_mask behavior.
> 
> RPS is disabled by default, the processing is going to happen
> wherever
> the IRQ is mapped, and one would hope that the IRQ is not mapped to
> the
> core where the critical processing runs.
> 
> Would you mind elaborating further on the use case?

