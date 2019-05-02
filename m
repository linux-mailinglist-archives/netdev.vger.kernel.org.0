Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A804A1218A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 19:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfEBR7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 13:59:54 -0400
Received: from gosford.compton.nu ([217.169.17.27]:44096 "EHLO
        gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfEBR7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 13:59:54 -0400
Received: from bericote.compton.nu ([2001:8b0:bd:1:1881:14ff:fe46:3cc7]:46810)
        by gosford.compton.nu with esmtps (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <tom@compton.nu>)
        id 1hMFzp-0002zE-7A; Thu, 02 May 2019 18:59:51 +0100
Received: from arden.compton.nu ([2001:8b0:bd:1:9eb6:d0ff:fedf:c161]:46070)
        by bericote.compton.nu with esmtps (TLSv1.3:TLS_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <tom@compton.nu>)
        id 1hMFzp-0001BX-3r; Thu, 02 May 2019 18:59:49 +0100
Subject: Re: ndisc_cache garbage collection issue
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
References: <7ebe8ec1-c407-d907-e99a-adcd89a8e16b@compton.nu>
 <7b7bb95a-9940-54eb-94df-9085d269c431@gmail.com>
From:   Tom Hughes <tom@compton.nu>
Message-ID: <a9d82278-6b38-12ec-c656-e228ddf5cf76@compton.nu>
Date:   Thu, 2 May 2019 18:59:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7b7bb95a-9940-54eb-94df-9085d269c431@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/05/2019 14:19, Eric Dumazet wrote:
> 
> 
> On 5/2/19 5:42 AM, Tom Hughes wrote:
>> I recently upgraded a machine from a 4.20.13 kernel to 5.0.9 and am
>> finding that after a few days I start getting a lot of these messages:
>>
>>    neighbour: ndisc_cache: neighbor table overflow!
>>
>> and IPv6 networking starts to fail intermittently as a result.
>>
>> The neighbour table doesn't appear to have much in it however so I've
>> been looking at the code, and especially your recent changes to garbage
>> collection in the neighbour tables and my working theory is that the
>> value of gc_entries is somehow out of sync with the actual list of what
>> needs to be garbage collected.
>>
>> Looking at the code I think I see a possible way that this could be
>> happening post 8cc196d6ef8 which moved the addition of new entries to
>> the gc list out of neigh_alloc into ___neigh_create.
>>
>> The problem is that neigh_alloc is doing the increment of gc_entries, so
>> if ___neigh_create winds up taking an error path gc_entries will have
>> been incremented but the neighbour will never be added to the gc list.
>>
>> I don't know for sure yet that this is the cause of my problem, but it
>> seems to be incorrect in any case unless I have misunderstood something?
> 
> This seems to match your report : https://patchwork.ozlabs.org/patch/1093973/

That does indeed look like the same thing... I've built a kernel with
that applied now so we'll see how that goes.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://compton.nu/
