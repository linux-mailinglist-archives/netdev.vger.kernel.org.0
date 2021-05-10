Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB254379729
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 20:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhEJSsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 14:48:10 -0400
Received: from blyat.fensystems.co.uk ([54.246.183.96]:59918 "EHLO
        blyat.fensystems.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhEJSsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 14:48:10 -0400
Received: from dolphin.home (unknown [IPv6:2a00:23c6:5495:5e00:72b3:d5ff:feb1:e101])
        by blyat.fensystems.co.uk (Postfix) with ESMTPSA id 28319442C3;
        Mon, 10 May 2021 18:47:02 +0000 (UTC)
Subject: Re: [PATCH] xen-netback: Check for hotplug-status existence before
 watching
To:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, wei.liu@kernel.org, pdurrant@amazon.com
References: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
 <20210413152512.903750-1-mbrown@fensystems.co.uk> <YJl8IC7EbXKpARWL@mail-itl>
From:   Michael Brown <mbrown@fensystems.co.uk>
Message-ID: <404130e4-210d-2214-47a8-833c0463d997@fensystems.co.uk>
Date:   Mon, 10 May 2021 19:47:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YJl8IC7EbXKpARWL@mail-itl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        blyat.fensystems.co.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2021 19:32, Marek Marczykowski-Górecki wrote:
> On Tue, Apr 13, 2021 at 04:25:12PM +0100, Michael Brown wrote:
>> The logic in connect() is currently written with the assumption that
>> xenbus_watch_pathfmt() will return an error for a node that does not
>> exist.  This assumption is incorrect: xenstore does allow a watch to
>> be registered for a nonexistent node (and will send notifications
>> should the node be subsequently created).
>>
>> As of commit 1f2565780 ("xen-netback: remove 'hotplug-status' once it
>> has served its purpose"), this leads to a failure when a domU
>> transitions into XenbusStateConnected more than once.  On the first
>> domU transition into Connected state, the "hotplug-status" node will
>> be deleted by the hotplug_status_changed() callback in dom0.  On the
>> second or subsequent domU transition into Connected state, the
>> hotplug_status_changed() callback will therefore never be invoked, and
>> so the backend will remain stuck in InitWait.
>>
>> This failure prevents scenarios such as reloading the xen-netfront
>> module within a domU, or booting a domU via iPXE.  There is
>> unfortunately no way for the domU to work around this dom0 bug.
>>
>> Fix by explicitly checking for existence of the "hotplug-status" node,
>> thereby creating the behaviour that was previously assumed to exist.
> 
> This change is wrong. The 'hotplug-status' node is created _only_ by a
> hotplug script and done so when it's executed. When kernel waits for
> hotplug script to be executed it waits for the node to _appear_, not
> _change_. So, this change basically made the kernel not waiting for the
> hotplug script at all.

That doesn't sound plausible to me.  In the setup as you describe, how 
is the kernel expected to differentiate between "hotplug script has not 
yet created the node" and "hotplug script does not exist and will 
therefore never create any node"?

Michael
