Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051B3AFE34
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfIKN76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:59:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfIKN76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:59:58 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F279215002437;
        Wed, 11 Sep 2019 06:59:56 -0700 (PDT)
Date:   Wed, 11 Sep 2019 15:59:55 +0200 (CEST)
Message-Id: <20190911.155955.1215273750491589577.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     jouni@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: Do not send Layer 2 Update frame before
 authorization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d0de07f0918863c8bc9bebccd8c6a7402a2ad173.camel@sipsolutions.net>
References: <20190911130305.23704-1-jouni@codeaurora.org>
        <d0de07f0918863c8bc9bebccd8c6a7402a2ad173.camel@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 06:59:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 11 Sep 2019 15:06:03 +0200

> On Wed, 2019-09-11 at 16:03 +0300, Jouni Malinen wrote:
>> The Layer 2 Update frame is used to update bridges when a station roams
>> to another AP even if that STA does not transmit any frames after the
>> reassociation. This behavior was described in IEEE Std 802.11F-2003 as
>> something that would happen based on MLME-ASSOCIATE.indication, i.e.,
>> before completing 4-way handshake. However, this IEEE trial-use
>> recommended practice document was published before RSN (IEEE Std
>> 802.11i-2004) and as such, did not consider RSN use cases. Furthermore,
>> IEEE Std 802.11F-2003 was withdrawn in 2006 and as such, has not been
>> maintained amd should not be used anymore.
>> 
>> Sending out the Layer 2 Update frame immediately after association is
>> fine for open networks (and also when using SAE, FT protocol, or FILS
>> authentication when the station is actually authenticated by the time
>> association completes). However, it is not appropriate for cases where
>> RSN is used with PSK or EAP authentication since the station is actually
>> fully authenticated only once the 4-way handshake completes after
>> authentication and attackers might be able to use the unauthenticated
>> triggering of Layer 2 Update frame transmission to disrupt bridge
>> behavior.
>> 
>> Fix this by postponing transmission of the Layer 2 Update frame from
>> station entry addition to the point when the station entry is marked
>> authorized. Similarly, send out the VLAN binding update only if the STA
>> entry has already been authorized.
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Dave, if you were still planning to send a pull request to Linus before
> he closes the tree on Sunday this would be good to include (and we
> should also backport it to stable later).
> 
> If not, I can pick it up afterwards, let me know.

Ok I applied this directly, thanks.
