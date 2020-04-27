Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C531BAC0E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgD0SMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:12:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgD0SMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 14:12:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40FE5206D4;
        Mon, 27 Apr 2020 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588011142;
        bh=7g5uBwzZZ5gA420LyHwxU5xUr0TGoYW6+NPEExUiiL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=15Q+QTEmerKu1Vs5lDmRInBFY2DM3mvRihDbN7B/MLY4+VkGucIhHU8mktsRg1IyD
         DBN2LhVeB1Lblim8kSnA+GGUzjH9VQjdfEyJaCeUIWUOuM8JAaIoE8s+EAb51N2TF4
         53GSHiF7Rr94/SgtJCtV4usGsQaxgOS4TDatQWsE=
Date:   Mon, 27 Apr 2020 11:12:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200427111220.7b07aae1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4f242df0-26c1-472c-c526-557ff50ef1e0@solarflare.com>
References: <20200420090505.pr6wsunozfh7afaj@salvia>
        <20200420091302.GB6581@nanopsycho.orion>
        <20200420100341.6qehcgz66wq4ysax@salvia>
        <20200420115210.GE6581@nanopsycho.orion>
        <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
        <20200420123915.nrqancwjb7226l7e@salvia>
        <20200420134826.GH6581@nanopsycho.orion>
        <20200420135754.GD32392@breakpoint.cc>
        <20200420141422.GK6581@nanopsycho.orion>
        <20200420191832.ppxjjebls2idrshh@salvia>
        <20200422183701.GN6581@nanopsycho.orion>
        <4f242df0-26c1-472c-c526-557ff50ef1e0@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 15:31:48 +0100 Edward Cree wrote:
> On 22/04/2020 19:37, Jiri Pirko wrote:
> > "Any" can't be "don't care". TC User expects stats. That's default.
> >
> > Let's have "don't care" bit only and set it for
> > ethtool/netfilter/flowtable. Don't change any. Teach the drivers to deal
> > with "don't care", most probably using the default checker. =20
> I think the right solution is either this, or the semantically-similar
> =C2=A0approach of "0 means don't care, we have a bit for disabled, and ANY
> =C2=A0(the TC default) is "all the bits except disabled", i.e.
> =C2=A0DELAYED | IMMEDIATE.=C2=A0 That seems slightly cleaner to me, as th=
en non-
> =C2=A0zero settings are always "here is a bitmask of options, driver may
> =C2=A0choose any of them".=C2=A0 (And 0 differs from DELAYED | IMMEDIATE =
| DISABLED
> =C2=A0only in that if new bits are added to kernel, 0 includes them.)

+1

> And of course either way the TC uAPI needs to be able to specify the
> =C2=A0new "don't care" option.

