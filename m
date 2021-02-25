Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BCF324B53
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhBYHfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:35:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:48102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232014AbhBYHe1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 02:34:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614238421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3BRihie3lifIDroDr4++Mfc0UHcnu/N2fnqw+5haSM=;
        b=GpU8DlBsevf+eVkPZ94CbGcv1uB6uRZI+tW6SJTwFPOhzG3UUXUI5dxuPLatvLOelAIVDc
        XHr8Htmb6stblsr5FBv+Ne2JFlTnn3tyndhJVoHYEP9avlnkyhJmZYer9l6FnNH2mS1SX4
        JcM6RrDa50deZWu7GY4nKXEnQVDSiqU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 22A84AD6B;
        Thu, 25 Feb 2021 07:33:41 +0000 (UTC)
Subject: Re: [PATCH] xen-netback: correct success/error reporting for the
 SKB-with-fraglist case
To:     paul@xen.org
Cc:     "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Liu <wl@xen.org>
References: <4dd5b8ec-a255-7ab1-6dbf-52705acd6d62@suse.com>
 <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <76c94541-21a8-7ae5-c4c4-48552f16c3fd@suse.com>
Date:   Thu, 25 Feb 2021 08:33:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <67bc0728-761b-c3dd-bdd5-1a850ff79fbb@xen.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2021 17:39, Paul Durrant wrote:
> On 23/02/2021 16:29, Jan Beulich wrote:
>> When re-entering the main loop of xenvif_tx_check_gop() a 2nd time, the
>> special considerations for the head of the SKB no longer apply. Don't
>> mistakenly report ERROR to the frontend for the first entry in the list,
>> even if - from all I can tell - this shouldn't matter much as the overall
>> transmit will need to be considered failed anyway.
>>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>
>> --- a/drivers/net/xen-netback/netback.c
>> +++ b/drivers/net/xen-netback/netback.c
>> @@ -499,7 +499,7 @@ check_frags:
>>   				 * the header's copy failed, and they are
>>   				 * sharing a slot, send an error
>>   				 */
>> -				if (i == 0 && sharedslot)
>> +				if (i == 0 && !first_shinfo && sharedslot)
>>   					xenvif_idx_release(queue, pending_idx,
>>   							   XEN_NETIF_RSP_ERROR);
>>   				else
>>
> 
> I think this will DTRT, but to my mind it would make more sense to clear 
> 'sharedslot' before the 'goto check_frags' at the bottom of the function.

That was my initial idea as well, but
- I think it is for a reason that the variable is "const".
- There is another use of it which would then instead need further
  amending (and which I believe is at least part of the reason for
  the variable to be "const").

Jan
