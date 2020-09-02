Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381CB25A276
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgIBAxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIBAxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 20:53:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08EBC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 17:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=+pZI/CCYJReCcgk+nn5h2TnHsqKMsn1N5IVNp9AhvL8=; b=GATgOJ0pe1raLTR03T+V9OxBkb
        ENqMP1OJJKTzLGOVT4a9cZ0lVJSWOH4whBpeS7lfZgdFGTgbu96a1H1+5JQqolumZ2nPWCE/mX4nV
        Zkk5fNiYZMDx/DBckp0RGoi5Mg2wb++5sEcAIlnUtD6ekXdjOHdrdNMzzpaNaOyyoQhVbRm5fYiXB
        J/X70KDxeGZel1m3DpUR+p1cXSfmr6NbfYwBiF+mb1515eiKpWEBk8kVZHIncSx8zvVjwZRsXKkxT
        NYFpvk5WqI4F/RlzaXu3oSQJTiEfxVe37xj7W0ZZUsqmJ1YHB7IUKnpl+aJfMOW9W7tWulhXFHcxh
        eFd8cWxg==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDH1K-00053M-U8; Wed, 02 Sep 2020 00:53:03 +0000
Subject: Re: COMPILE_TEST
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alex Elder <elder@linaro.org>, Networking <netdev@vger.kernel.org>
References: <d615e441-dcee-52a8-376b-f1b83eef0789@linaro.org>
 <20200901214852.GA3050651@lunn.ch>
 <20200901171738.23af6c63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <18f4418f-0ca0-bd5d-10fc-998b4689f9e5@infradead.org>
Date:   Tue, 1 Sep 2020 17:52:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200901171738.23af6c63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 5:17 PM, Jakub Kicinski wrote:
> On Tue, 1 Sep 2020 23:48:52 +0200 Andrew Lunn wrote:
>> On Tue, Sep 01, 2020 at 03:22:31PM -0500, Alex Elder wrote:
>>> Jakub, you suggested/requested that the Qualcomm IPA driver get
>>> built when the COMPILE_TEST config option is enabled.  I started
>>> working on this a few months ago but didn't finish, and picked
>>> it up again today.  I'd really like to get this done soon.
>>>
>>> The QCOM_IPA config option depends on and selects other things,
>>> and those other things depend on and select still more config
>>> options.  I've worked through some of these, but now question
>>> whether this is even the right approach.  Should I try to ensure
>>> all the code the IPA driver depends on and selects *also* gets
>>> built when COMPILE_TEST is enabled?  Or should I try to minimize
>>> the impact on other code by making IPA config dependencies and
>>> selections also depend on the value of COMPILE_TEST?
>>>
>>> Is there anything you know of that describes best practice for
>>> enabling a config option when COMPILE_TEST is enabled?  
>>
>> Hi Alex
>>
>> In general everything which can be build with COMPILE_TEST should be
>> built with COMPILE_TEST. So generally it just works, because
>> everything selected should already be selected because they already
>> have COMPILE_TEST.
>>
>> Correctly written drivers should compile for just about any
>> architecture. If they don't it suggests they are not using the APIs
>> correctly, and should be fixed.
>>
>> If the dependencies have not had COMPILE_TEST before, you are probably
>> in for some work, but in the end all the drivers will be of better
>> quality, and get build tested a lot more.
> 
> Nothing to add :) I'm not aware of any codified best practices.
> 

I have a little to add, but maybe some can complete this more
than I can.

Several subsystem header files add stubs for when that subsystem is not
enabled.  I know <linux/of.h> works with CONFIG_OF=y or =n, with lots of stubs.

Same is true for <linux/gpio.h> and CONFIG_GPIOLIB.

It would be good to know which other CONFIG symbols and header files
are known to work (or expected to work) like this.

Having these stubs allows us to always either omit e.g.
	depends on GPIOLIB
or make it say
	depends on GPIOLIB || COMPILE_TEST


Also, there are $ARCH conditions whose drivers also usually
could benefit from COMPILE_TEST, so we often see for a driver:

	depends on MIPS || COMPILE_TEST
or
	depends on ARCH_some_arm_derivative || COMPILE_TEST
or
	depends on *PLATFORM* || COMPILE_TEST
or
	depends on ARCH_TEGRA || COMPILE_TEST

So if a driver is destined (or designed) for one h/w environment,
we very much want to build it with COMPILE_TEST for other h/w platforms.


HTH.
-- 
~Randy

