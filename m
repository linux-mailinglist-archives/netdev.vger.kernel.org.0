Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF242A26A
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 04:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfEYCkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 22:40:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfEYCkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 22:40:47 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0B0673082DDD;
        Sat, 25 May 2019 02:40:47 +0000 (UTC)
Received: from Hades.local (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0C7019C4F;
        Sat, 25 May 2019 02:40:45 +0000 (UTC)
Subject: Re: [PATCH net] bonding/802.3ad: fix slave link initialization
 transition states
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Heesoon Kim <Heesoon.Kim@stratus.com>
References: <20190524134928.16834-1-jarod@redhat.com>
 <30882.1558732616@famine>
From:   Jarod Wilson <jarod@redhat.com>
Message-ID: <babab0b4-7d12-15f1-e4ae-70a2ed832d78@redhat.com>
Date:   Fri, 24 May 2019 22:40:44 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <30882.1558732616@famine>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 25 May 2019 02:40:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/24/19 5:16 PM, Jay Vosburgh wrote:
> Jarod Wilson <jarod@redhat.com> wrote:
> 
>> Once in a while, with just the right timing, 802.3ad slaves will fail to
>> properly initialize, winding up in a weird state, with a partner system
>> mac address of 00:00:00:00:00:00. This started happening after a fix to
>> properly track link_failure_count tracking, where an 802.3ad slave that
>> reported itself as link up in the miimon code, but wasn't able to get a
>> valid speed/duplex, started getting set to BOND_LINK_FAIL instead of
>> BOND_LINK_DOWN. That was the proper thing to do for the general "my link
>> went down" case, but has created a link initialization race that can put
>> the interface in this odd state.
> 
> 	Reading back in the git history, the ultimate cause of this
> "weird state" appears to be devices that assert NETDEV_UP prior to
> actually being able to supply sane speed/duplex values, correct?
> 
> 	Presuming that this is the case, I don't see that there's much
> else to be done here, and so:
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

Correct, we've got an miimon "device is up", but still can't get speed 
and/or duplex in this case.

-- 
Jarod Wilson
jarod@redhat.com
