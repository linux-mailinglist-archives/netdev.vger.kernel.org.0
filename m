Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9972A5F2C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 09:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgKDIPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 03:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgKDIPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 03:15:32 -0500
Received: from localhost (host-213-179-129-39.customer.m-online.net [213.179.129.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793D922384;
        Wed,  4 Nov 2020 08:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604477732;
        bh=znTuSh2MZarrT9XQfjVV7kEfJ1h//tiqqUjMylJUUac=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ph7Tvm9I7bXM+F5Kz0wnyGXWS6dNfUmX8ru/sXnN03SCxykE8wYr/cm5LcB3fJB3m
         T1zvb8uryMUeWpZrc934QHhTFad99r0/clXKSfQqy7hd1VSVWrUlwOBClzViT8lNnv
         2qVb7zqEeg0NgTDvAM5lpHmJWLf8t0NXJ1q6ZCRY=
Date:   Wed, 4 Nov 2020 10:15:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Machata <me@pmachata.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add
 print_on_off_bool()
Message-ID: <20201104081528.GL5429@unreal>
References: <cover.1604059429.git.me@pmachata.org>
 <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
 <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com>
 <87o8kihyy9.fsf@nvidia.com>
 <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com>
 <20201102063752.GE5429@unreal>
 <87h7q7iclr.fsf@nvidia.com>
 <20201103062406.GH5429@unreal>
 <874km6i28j.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874km6i28j.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 10:01:32PM +0100, Petr Machata wrote:
>
> Leon Romanovsky <leon@kernel.org> writes:
>
> > On Tue, Nov 03, 2020 at 12:05:20AM +0100, Petr Machata wrote:
> >>
> >> Leon Romanovsky <leon@kernel.org> writes:
> >>
> >> > On Sun, Nov 01, 2020 at 04:55:42PM -0700, David Ahern wrote:
> >> >
> >> >> yes, the rdma utils are using generic function names. The rdma version
> >> >> should be renamed; perhaps rd_print_on_off. That seems to be once common
> >> >> prefix. Added Leon.
> >> >
> >> > I made fast experiment and the output for the code proposed here and existed
> >> > in the RDMAtool - result the same. So the good thing will be to delete the
> >> > function from the RDMA after print_on_off_bool() will be improved.
> >>
> >> The RDMAtool uses literal "on" and "off" as values in JSON, not
> >> booleans. Moving over to print_on_off_bool() would be a breaking change,
> >> which is problematic especially in JSON output.
> >
> > Nothing prohibits us from adding extra parameter to this new
> > function/json logic/json type that will control JSON behavior. Personally,
> > I don't think that json and stdout outputs should be different, e.g. 1/0 for
> > the json and on/off for the stdout.
>
> Emitting on/off in JSON as true booleans (true / false, not 1 / 0) does
> make sense. It's programmatically-consumed interface, the values should
> be of the right type.

As long as you don't need to use those fields to "set .." after that.

>
> On the other hand, having a FP output use literal "on" and "off" makes
> sense as well. It's an obvious reference to the command line, you can
> actually cut'n'paste it back to shell and it will do the right thing.

Maybe it is not so bad to change RDMAtool to general function, this
on/of print is not widely use yet, just need to decide what is the right one.

>
> Many places in iproute2 do do this dual output, and ideally all new
> instances would behave this way as well. So no toggles, please.

Good example why all utilities in iproute2 are better to use same
input/output code and any attempt to make custom variants should be
banned.

>
> >> I think the current function does handle JSON context, what else do
> >> you have in mind?
> >
> > It handles, but does it twice, first time for is_json_context() and
> > second time inside print_bool.
>
> Gotcha.
