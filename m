Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAFED5FA0
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 12:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfJNKBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 06:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731119AbfJNKBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 06:01:49 -0400
Received: from linux-8ccs (charybdis-ext.suse.de [195.135.221.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5694B207FF;
        Mon, 14 Oct 2019 10:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571047308;
        bh=5/ai+ZkvHjPIjd1PVgKpi0YTLpokodIIj+K2mhHp4YA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NVz7Y6tapstbkQM25HzES+ADj09TP/Wp4jPgVg7IZZYXW2LhEsDj9+r3eKt3paaCV
         Ih9eCLs7Gq+SGaX4h/UQwdm06+AALQ1VJW++lAnAIEkJnPc12mxWxAuuPXa8UtC5xN
         nL2EnUEkQYAhSRYJ5yOYlWlr8V9FdXSIE3lFfVy8=
Date:   Mon, 14 Oct 2019 12:01:44 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191014100143.GA6525@linux-8ccs>
References: <8132cf72-0ae1-48ae-51fb-1a01cf00c693@gmail.com>
 <CAB=NE6XdVXMnq7pgmXxv4Qicu7=xrtQC-b2sXAfVxiAq68NMKg@mail.gmail.com>
 <875eecfb-618a-4989-3b9f-f8272b8d3746@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875eecfb-618a-4989-3b9f-f8272b8d3746@gmail.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.28-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+++ Heiner Kallweit [11/10/19 21:26 +0200]:
>On 10.10.2019 19:15, Luis Chamberlain wrote:
>>
>>
>> On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
>>
>>        MODULE_SOFTDEP("pre: realtek")
>>
>>     Are you aware of any current issues with module loading
>>     that could cause this problem?
>>
>>
>> Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
>>
>> If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
>>
>>   Luis
>>
>Maybe issue is related to a bug in introduction of symbol namespaces, see here:
>https://lkml.org/lkml/2019/10/11/659

If you're running into depmod and module loading issues with kernels >=5.3-rc1,
it's likely due to the namespaces patchset and we're working on
getting all the kinks fixed. Could you please ask the bug reporter to
try the latest -rc kernel with these set of fixes applied on top?

   https://lore.kernel.org/linux-modules/20191010151443.7399-1-maennich@google.com/

They fix a known depmod issue caused by our __ksymtab naming scheme,
which is being reverted in favor of extracting the namespace from
__kstrtabns and __ksymtab_strings. These fixes will be in by -rc4.

Thanks,

Jessica


