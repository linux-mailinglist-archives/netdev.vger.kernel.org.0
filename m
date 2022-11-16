Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3CE62CEA4
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbiKPXUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiKPXUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:20:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E7F623A4;
        Wed, 16 Nov 2022 15:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13ED86201F;
        Wed, 16 Nov 2022 23:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AFEC433C1;
        Wed, 16 Nov 2022 23:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668640834;
        bh=o+VByynSeoTOtbxxqGW88pHtPLAYkDbDYL2ejaugK5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vo2WlpWiBNqo6NvDjaOMy0R26oBiKme/8b7U3aRpZZpWjfevhHiqcJaRWhs8YAvVX
         gPos+QeomRrfbc37iBHqNvzviu7HnGy15a87mJJzQ/hEdyDTSnL9UKfLBSsBhzNhdh
         EB9yFOoN0IGAuRAdU5U6AHbkGS2YpY0YNronMcPmFHWRbBU8F885Eu97PvXG4YDvty
         jZLT5dWxqUz8Ubuahc9Naujw605R00a6TLHOjS0LSZPQWcRSuX8lbk0WQGyuYl+kjb
         KJg8p/+hDhwea0YbPkpnvjg2NPigbVvm3gMfg8Ap1aWMlKu1hM5ZorZnVemkdSgSyW
         rTBSxHy3rBwlA==
Date:   Wed, 16 Nov 2022 15:20:33 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 2/3] can: etas_es58x: export firmware, bootloader and
 hardware versions in sysfs
Message-ID: <Y3VwQdZoStfryz3q@x130.lan>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-3-mailhol.vincent@wanadoo.fr>
 <Y3QW/ufhuYnHWcli@x130.lan>
 <CAMZ6RqKUKLUf1Y6yL=J6n+N2Uz+JuFnHXdfVDXTZaDQ89=9DzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKUKLUf1Y6yL=J6n+N2Uz+JuFnHXdfVDXTZaDQ89=9DzQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16 Nov 09:36, Vincent MAILHOL wrote:
>On Wed. 16 Nov. 2022 at 07:50, Saeed Mahameed <saeed@kernel.org> wrote:
>> On 13 Nov 13:01, Vincent Mailhol wrote:
>> >ES58x devices report below information in their usb product info
>> >string:
>> >
>> >  * the firmware version
>> >  * the bootloader version
>> >  * the hardware revision
>> >
>> >Parse this string, store the results in struct es58x_dev and create
>> >three new sysfs entries.
>> >
>>
>> will this be the /sys/class/net/XXX sysfs  ?
>
>I am dropping the idea of using sysfs and I am now considering using
>devlink following Andrew's message:
>https://lore.kernel.org/linux-can/Y3Ef4K5lbilY3EQT@lunn.ch/
>

+1

>> We try to avoid adding device specific entries in there,
>>
>> Couldn't you just squeeze the firmware and hw version into the
>> ethtool->drvinfo->fw_version
>>
>> something like:
>> fw_version: %3u.%3u.%3u (%c.%3u.%3u)
>
>This looks like a hack. There is no way for the end user to know, just
>from the ethtool output, what these in brackets values would mean.

it's not, there is no well defined format for what to put in the version,
as long as it clearly describes what FW is currently running.
at the end of the day, it's just a text you copy&paste when you contact
customer support.

>
>> and bootloader into ethtool->drvinfo->erom_version:
>>   * @erom_version: Expansion ROM version string; may be an empty string
>
>Same. I considered doing this in the early draft of this series and
>dropped the idea because an expansion ROM and a boot loader are two
>things different.
>
>I will continue to study devlink and only use the drvinfo only for the
>firmware version.
>

100% devlink is a great options.
