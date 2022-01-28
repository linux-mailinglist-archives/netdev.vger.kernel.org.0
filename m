Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D52B49F74D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347828AbiA1Kby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:31:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347786AbiA1Kbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:31:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EE9261E77;
        Fri, 28 Jan 2022 10:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A61CC340E0;
        Fri, 28 Jan 2022 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643365912;
        bh=b1IQLqEH35fsJSCepE7PYeU2mEVrFIiNAs9jucIWrKI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=L6IkNO/COHAk7E/ogEwzsJUT/qW0NEFAQDMzPMnnHYMPROIbBY0U1trcnaXM0d55h
         ZY25Qu6JuPojgoefg7pWAwUOsJh9VY7aHRb9unxtmvR3o00g+u1zrosyKiesXuCI19
         GswBWQ5zpQqUBJiFjZP5jwjuEZE13Ochrj+bKCoQHXJysGugpRsTijHwyYG3QPSti6
         VIKECjVKC3HorDRxFlXYJfRAsD6esd3qchMM28uVX8hkVo7zm4pQn7QoitCeTBdDoZ
         f4oYV9Kt88sWyYK3Mt1NWXppWxPzrfzWKLXoik1JN3fOEgw86ne0Dbj1yU3k7eMPln
         6mxMaQQS+RsVQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Zhou Qingyang <zhou1615@umn.edu>, kjlu@umn.edu,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Angus Ainslie <angus@akkea.ca>,
        "Daniel \(Deognyoun\) Kim" <dekim@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Fix a wild pointer dereference bug in brcmf_chip_recognition()
References: <20220124164847.54002-1-zhou1615@umn.edu>
        <YfPCahElneup1DJS@kroah.com>
Date:   Fri, 28 Jan 2022 12:31:44 +0200
In-Reply-To: <YfPCahElneup1DJS@kroah.com> (Greg KH's message of "Fri, 28 Jan
        2022 11:16:10 +0100")
Message-ID: <875yq4gnhr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Tue, Jan 25, 2022 at 12:48:45AM +0800, Zhou Qingyang wrote:
>> In brcmf_chip_recognition(), the return value of brcmf_chip_add_core()
>> is assigned to core and is passed to brcmf_chip_sb_corerev(). In
>> brcmf_chip_sb_corerev(), there exists dereference of core without check.
>> the return value of brcmf_chip_add_core() could be ERR_PTR on failure of
>> allocation, which could lead to a NULL pointer dereference bug.
>> 
>> Fix this bug by adding IS_ERR check for every variable core.
>> 
>> This bug was found by a static analyzer.
>> 
>> Builds with 'make allyesconfig' show no new warnings,
>> and our static analyzer no longer warns about this code
>> 
>> Fixes: cb7cf7be9eba ("brcmfmac: make chip related functions host
>> interface independent")
>> Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
>> ---
>> The analysis employs differential checking to identify inconsistent 
>> security operations (e.g., checks or kfrees) between two code paths 
>> and confirms that the inconsistent operations are not recovered in the
>> current function or the callers, so they constitute bugs. 
>> 
>> Note that, as a bug found by static analysis, it can be a false
>> positive or hard to trigger. Multiple researchers have cross-reviewed
>> the bug.
>
> As stated before, umn.edu is still not allowed to contribute to the
> Linux kernel.  Please work with your administration to resolve this
> issue.

Thanks Greg, I didn't notice that this is from umn.edu. After seeing
what kind of "research" umn.edu does I will not even look at umn.edu
patches, they all will be automatically rejected without comments.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
