Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306951EB224
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 01:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgFAXYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 19:24:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgFAXYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 19:24:19 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E084320663;
        Mon,  1 Jun 2020 23:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591053859;
        bh=ergccIyoCMuEvMoRxmnvMTMpWUMthaO4EMSsVlyRjdc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QTi/ly4jprPCPk+eroF5J3zaYkzGoprzd6TWKeJwsh3XXk3vydZr0DaYVtblkmBbv
         eq+Z5ODcCoSnew9YUYKzJaDSS3muB6dBfchnKHXbPmI57YdiqI0hVzHi1JBLcJuEtp
         R7+gR3CR3gFVmRUf2LpTSFC/4jvknj83zmOBqVr8=
Date:   Mon, 1 Jun 2020 16:24:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset'
 and 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601162416.386937b2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAACQVJomhn1p2L=ZQakwSRXAci2oK0EG0HQsTVhRz6NLFZEHqw@mail.gmail.com>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <20200601061819.GA2282@nanopsycho>
        <20200601064323.GF2282@nanopsycho>
        <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
        <20200601100411.GL2282@nanopsycho>
        <CAACQVJomhn1p2L=ZQakwSRXAci2oK0EG0HQsTVhRz6NLFZEHqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 21:01:42 +0530 Vasundhara Volam wrote:
> > I think that the legacy ethtool should stick with the "ordinary fw reset",
> > becase that is what user expects. You should add an attribute to
> > "devlink dev reload" to trigger the "live fw reset"  
> 
> Okay.
> 
> I am planning to add a type field with "driver-only | fw-reset |
> live-fw-reset | live-fw-patch" to "devlink dev reload" command.
> 
> driver-only - Resets host driver instance of the 'devlink dev'
> (current behaviour). This will be default, if the user does not
> provide the type option.
> fw-reset - Initiate the reset command for the currently running
> firmware and wait for the driver reload for completing the reset.
> (This is similar to the legacy "ethtool --reset all" command).
> live-fw-reset - Resets the currently running firmware and driver entities.
> live-fw-patch - Loads the currently pending flashed firmware and
> reloads all driver entities. If no pending flashed firmware, resets
> currently loaded firmware.

FWIW I'd prefer to extend the ethtool semantics. Ethtool reset has two
reset "depths" already - single port, entire adapter, we could just add
"entire sled" here. IOW we'd have reset which can affect only given
port, then reset which can affect multiple ports, and reset which may
affect multiple systems.

The mechanism of the reset and whether old or new version of FW is
activated is a detail, which I believe will be entirely uninteresting 
to the user. Whether other systems or ports are affected is _very_
important, OTOH.
