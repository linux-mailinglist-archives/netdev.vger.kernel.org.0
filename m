Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B1990385
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfHPN7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:59:24 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:45574 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfHPN7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:59:23 -0400
Received: from tux.wizards.de (p5DE2B998.dip0.t-ipconnect.de [93.226.185.152])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 3C6C24160F17;
        Fri, 16 Aug 2019 15:59:22 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 7A259F015E2;
        Fri, 16 Aug 2019 15:59:21 +0200 (CEST)
Subject: Re: r8169: Performance regression and latency instability
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        netdev@vger.kernel.org
Cc:     hkallweit1@gmail.com
References: <72898d5b-9424-0bcd-3d8a-fc2e2dd0dbf1@intra2net.com>
 <217e3fa9-7782-08c7-1f2b-8dabacaa83f9@gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <792d3a56-32aa-afee-f2b4-1f867b9cf75f@applied-asynchrony.com>
Date:   Fri, 16 Aug 2019 15:59:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <217e3fa9-7782-08c7-1f2b-8dabacaa83f9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 2:35 PM, Eric Dumazet wrote:
..snip..
> I also see this relevant commit : I have no idea why SG would have any relation with TSO.
> 
> commit a7eb6a4f2560d5ae64bfac98d79d11378ca2de6c
> Author: Holger Hoffstätte <holger@applied-asynchrony.com>
> Date:   Fri Aug 9 00:02:40 2019 +0200
> 
>      r8169: fix performance issue on RTL8168evl
>      
>      Disabling TSO but leaving SG active results is a significant
>      performance drop. Therefore disable also SG on RTL8168evl.
>      This restores the original performance.
>      
>      Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>      Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
>      Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>      Signed-off-by: David S. Miller <davem@davemloft.net>

It does not - and admittedly none of this makes sense, but stay with me here.

The commit 93681cd7d94f to net-next enabled rx/tx HW checksumming and TSO
by default, but disabled TSO for one specific chip revision - the most popular
one, of course. Enabling rx/tx checksums by default while leaving SG on turned
out to be the performance issue (~780 MBit max) that I found & fixed in the
quoted commit. SG *can* be enabled when rx/tx checkusmming is *dis*abled
(I just verified again), we just had to sanitize the new default.

An alternative strategy could still be to (again?) disable everything by default
and just let people manually enable whatever settings work for their random
chip revision + BIOS combination. I'll let Heiner chime in here.

Basically these chips are dumpster fires and should not be used for anything
ever, which of course means they are everywhere.

AFAICT none of this has anything to do with Juliana's problem..

-h
