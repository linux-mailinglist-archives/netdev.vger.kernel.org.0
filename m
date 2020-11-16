Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202B72B41A6
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbgKPKpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729478AbgKPKpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:45:21 -0500
Received: from iam.tj (soggy.cloud [IPv6:2a01:7e00:e000:151::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B840C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 02:45:21 -0800 (PST)
Received: from [10.0.40.123] (unknown [51.155.44.233])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id D1D57340AD;
        Mon, 16 Nov 2020 10:45:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=elloe.vision; s=2019;
        t=1605523520; bh=yGroCdZLhn2HqEMw7T1Oi+tK+hJQmdvMS0jFSZv14dU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=X1pg5hMX4yxSuL/lV6LgaQaIEKmcUcPZ4AwMOr6zXldCVdtCouKkFqU+MUVSYNAiT
         5GBKBxRa55uoXZIB3W3V6AW5b2Ul4UtjeNYvYmjgqKKlMBMs7iafqqciTA2VNAwESz
         9buBS3QlcNzqJwuks21dflvJ9q4wxzyhvfK6sQDpBowyVyc+bzKWJM7cc3I81PfnD8
         K8QAUSfroc+GnRvJ/TRXHInWcxvEKkloqJ2PjlRZmKj6dUcWbroWyJykatcGziq22r
         x946yvnM6Z0xAlnkBgpI0IjPd1WiFtf0FbtILPtcom0pLX+wgiOOuH21ZnhxJY6s2D
         oq8wFH7+GpD0w==
Subject: Re: dsa: mv88e6xxx not receiving IPv6 multicast packets
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz, f.fainelli@gmail.com,
        marek.behun@nic.cz, vivien.didelot@gmail.com, info <info@turris.cz>
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
 <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
 <3390878f-ca70-7714-3f89-c4455309d917@elloe.vision>
 <20201114184915.fv5hfoobdgqc7uxq@skbuf>
 <c0bb216e-0717-a131-f96d-c5194b281746@elloe.vision>
 <20201115160244.GD1701029@lunn.ch>
 <79ad87d1-15e0-7ccc-e1ad-4aab3fdf0d20@elloe.vision>
 <20201115172705.GF1701029@lunn.ch>
From:   "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Organization: Elloe CIC
Message-ID: <b57ae7a7-e510-4d63-0b31-973bdbc953c6@elloe.vision>
Date:   Mon, 16 Nov 2020 10:45:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201115172705.GF1701029@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/11/2020 17:27, Andrew Lunn wrote:

> So check if you have an IGMP querier in the network. If not, try
> turning it on in the bridge,
> 
> ip link set br0 type bridge mcast_querier 
Thankfully it turns out this is totally unrelated to Linux - our TP-Link
Jetstream T1600G-PS has some unfortunate default behaviour and a bug.

Specifically, we are operating an IPv6-only network and Layer 2 MLD
snooping was enabled and set to forward unknown multicast groups and as
such the switch should be broadcasting all multicast packets.

However, buried in the TP-Link manual there's a note that says:

"Note: IGMP Snooping and MLD Snooping share the setting of Unknown
Multicast Groups, so you have to enable IGMP Snooping globally on the L2
FEATURES > Multicast > IGMP Snooping > Global Config page at the same
time."

We hadn't enabled IGMP snooping since we don't use IPv4!

Many thanks for the help resolving this and apologies for mis-reporting it.
