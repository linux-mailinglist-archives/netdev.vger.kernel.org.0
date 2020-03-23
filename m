Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BB618F2CC
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgCWK1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:27:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:40474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbgCWK1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 06:27:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2EE5EADF1;
        Mon, 23 Mar 2020 10:27:28 +0000 (UTC)
Subject: Re: [PATCH net-next v4] xen networking: add basic XDP support for
 xen-netfront
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        wei.liu@kernel.org, paul@xen.org
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
 <f75365c7-a3ca-cf12-b2fc-e48652071795@suse.com>
 <CAOJe8K3gDJrdKz9zVZNj=N76GygMnPbCKM0-kVfoV53fASAefg@mail.gmail.com>
 <250783b3-4949-d00a-70e2-dbef1791a6c4@suse.com>
 <CAOJe8K0fBBi-M+Tdv2kC+ZaNvjx92tzYaU1QX2zr8QOBRLwu3g@mail.gmail.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <9eb74bee-8434-62aa-8158-bae130353670@suse.com>
Date:   Mon, 23 Mar 2020 11:27:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOJe8K0fBBi-M+Tdv2kC+ZaNvjx92tzYaU1QX2zr8QOBRLwu3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.03.20 11:15, Denis Kirjanov wrote:
> On 3/18/20, Jürgen Groß <jgross@suse.com> wrote:
>> On 18.03.20 13:50, Denis Kirjanov wrote:
>>> On 3/18/20, Jürgen Groß <jgross@suse.com> wrote:
>>>> On 16.03.20 14:09, Denis Kirjanov wrote:
>>>>> The patch adds a basic XDP processing to xen-netfront driver.
>>>>>
>>>>> We ran an XDP program for an RX response received from netback
>>>>> driver. Also we request xen-netback to adjust data offset for
>>>>> bpf_xdp_adjust_head() header space for custom headers.
>>>>
>>>> This is in no way a "verbose patch descriprion".
>>>>
>>>> I'm missing:
>>>>
>>>> - Why are you doing this. "Add XDP support" is not enough, for such
>>>>      a change I'd like to see some performance numbers to get an idea
>>>>      of the improvement to expect, or which additional functionality
>>>>      for the user is available.
>>> Ok, I'll try to measure  some numbers.
>>>
>>>>
>>>> - A short description for me as a Xen maintainer with only basic
>>>>      networking know-how, what XDP programs are about (a link to some
>>>>      more detailed doc is enough, of course) and how the interface
>>>>      is working (especially for switching between XDP mode and normal
>>>>      SKB processing).
>>>
>>> You can search for the "A practical introduction to XDP" tutorial.
>>> Actually there is a lot of information available regarding XDP, you
>>> can easily find it.
>>>
>>>>
>>>> - A proper description of the netfront/netback communication when
>>>>      enabling or disabling XDP mode (who is doing what, is silencing
>>>>      of the virtual adapter required, ...).
>>> Currently we need only a header offset from netback driver so that we can
>>> put
>>> custom encapsulation header if required and that's done using xen bus
>>> state switching,
>>> so that:
>>> - netback tells that it can adjust the header offset
>>> - netfront part reads it
>>
>> Yes, but how is this synchronized with currently running network load?
>> Assume you are starting without XDP being active and then you are
>> activating it. How is the synchronization done from which request on
>> the XDP headroom is available?
> 
> Hi Jurgen,
> 
> basically XDP is activated when you've assigned an xdp program to the
> networking device.
> Assigning an xdp program means that we have to adjust a pointer which
> is RCU protected.

This doesn't answer my question.

You have basically two communication channels: the state of the frontend
and backend for activation/deactivation of XDP, and the ring pages with
the rx and tx requests and responses. How is the synchronization between
those two channels done? So how does the other side know which of the
packets in flight will then have XDP on or off?


Juergen
