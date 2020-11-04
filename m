Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B1D2A6B7F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 18:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgKDRSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 12:18:33 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:42939 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgKDRSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 12:18:33 -0500
Received: from [10.193.177.175] (chethan-pc.asicdesigners.com [10.193.177.175] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A4HIN1p003478;
        Wed, 4 Nov 2020 09:18:24 -0800
Subject: Re: [net v4 07/10] ch_ktls: packet handling prior to start marker
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
References: <20201030180225.11089-1-rohitm@chelsio.com>
 <20201030180225.11089-8-rohitm@chelsio.com>
 <20201103125147.565dbf0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <b9ad82f8-be79-40fe-d782-8cbdd3b42020@chelsio.com>
Date:   Wed, 4 Nov 2020 22:48:22 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20201103125147.565dbf0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 04/11/20 2:21 AM, Jakub Kicinski wrote:
> On Fri, 30 Oct 2020 23:32:22 +0530 Rohit Maheshwari wrote:
>> There could be a case where ACK for tls exchanges prior to start
>> marker is missed out, and by the time tls is offloaded. This pkt
>> should not be discarded and handled carefully. It could be
>> plaintext alone or plaintext + finish as well.
> By plaintext + finish you mean the start of offload falls in the middle
> of a TCP skb? That should never happen. We force EOR when we turn on
> TLS, so you should never see a TCP skb that needs to be half-encrypted.
This happens when re-transmission is issued on a high load system.
First time CCS is and finished message comes to driver one by one.
Problem is, if ACK is not received for both these packets, while
sending for re-transmission, stack sends both these together. Now
the start sequence number will be before the start marker record,
but it also holds data for encryption. This is handled in this
patch.
Are you saying this should not happen?
