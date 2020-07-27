Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BCA22FC93
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgG0XEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:04:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG0XEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:04:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9239A2070B;
        Mon, 27 Jul 2020 23:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595891049;
        bh=erGUF5up7lxHEPkIOTNR7tdrHvl6VA8w3uZK0M6IVmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0HLMm7f71Z4RT3RjaTFYybeoKUSuIDwPWnUKXdHAiMt/tKbmpzaTkM3/DX+BcGm9f
         EHDpNNVpwQtHKyIzwGipOvGjJoLQnPpLI+g2okryjs8POWlvViEpO4tNZ5MaVbHWLz
         +2XsMkWHjJY10hsFhKQrVf51liiDRVdBhN2zr/ug=
Date:   Mon, 27 Jul 2020 16:04:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Herbert <tom@herbertland.com>
Cc:     "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>,
        "Wang, Haiyue" <haiyue.wang@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>
Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Message-ID: <20200727160406.4d2bc1c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALx6S36K0kES3b7dWmyigpSLgBmU2jf7FfCSYXBFOeBJkbQ+rw@mail.gmail.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
        <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200714112421.06f20c5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR11MB3795DABBB0D6A1E08585DF45F77E0@BN8PR11MB3795.namprd11.prod.outlook.com>
        <20200715110331.54db6807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8026dce002758d509b310afa330823be0c8191ec.camel@intel.com>
        <20200722180705.23196cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALx6S36K0kES3b7dWmyigpSLgBmU2jf7FfCSYXBFOeBJkbQ+rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jul 2020 09:39:07 -0700 Tom Herbert wrote:
> Jakub,
> 
> The fundamental problem we have wrt DPDK is that they are not just
> satisfied to just bypass the kernel datapath, they are endeavouring to
> bypass the kernel control path as well with things like RTE flow API.
> The purpose of this patch set, AFAICT, is to keep the kernel in the
> control plane path so that we can maintain one consistent management
> view of device resources. The unpleasant alternative is that DPDK will
> send control messages directly to the device thereby bypassing the
> kernel control plane and thus resulting in two independent entities
> managing the same device and forcing a bifurcated control plane in the
> device (which of course results in a complete mess!).

Sorry for a late reply.

I try to do my best to predict what effect the community pushing back
on merging features will have. It does appear that the unpleasant
alternative you mention is becoming more and more prevalent. I believe
this is a result of multiple factors - convenience of the single point
of control, backward/forward compat, the growing size of the driver SW
stack, relative SW vs Si development cost in a NIC project, software
distribution models..

My day to day experience working with NICs shows that FW has already
taken over high perf NICs, and I hate it. I'd take DPDK over closed
source FW any time of the day, but I will not fool myself into thinking
that expansion of FW control can be stopped by the kernel opening the
floodgates to anything the vendors want to throw at us. 

Ergo the lesser evil argument does not apply.


In this case, I'm guessing, Intel can reuse RTE flow -> AQ code written
to run on PFs on the special VF.

This community has selected switchdev + flower for programming flows.
I believe implementing flower offloads would solve your use case, and
at the same time be most beneficial to the netdev community.
