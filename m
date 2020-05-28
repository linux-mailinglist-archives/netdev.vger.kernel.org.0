Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891971E54E0
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 06:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgE1EGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 00:06:51 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:48755 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgE1EGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 00:06:51 -0400
Received: from [10.193.177.210] (komali.asicdesigners.com [10.193.177.210] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04S46hnw004208;
        Wed, 27 May 2020 21:06:43 -0700
Subject: Re: [PATCH net v2] cxgb4/chcr: Enable ktls settings at run time
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
References: <20200526140634.21043-1-rohitm@chelsio.com>
 <20200526154241.24447b41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <00b63ada-06d0-5298-e676-1c02e8676d61@chelsio.com>
 <20200527140406.420ed7fd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <475fb577-a8cc-d1dc-e522-13333c7975a2@chelsio.com>
Date:   Thu, 28 May 2020 09:36:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200527140406.420ed7fd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 28/05/20 2:34 AM, Jakub Kicinski wrote:
> On Wed, 27 May 2020 10:02:42 +0530 rohit maheshwari wrote:
>> On 27/05/20 4:12 AM, Jakub Kicinski wrote:
>>> On Tue, 26 May 2020 19:36:34 +0530 Rohit Maheshwari wrote:
>>>> Current design enables ktls setting from start, which is not
>>>> efficient. Now the feature will be enabled when user demands
>>>> TLS offload on any interface.
>>>>
>>>> v1->v2:
>>>> - taking ULD module refcount till any single connection exists.
>>>> - taking rtnl_lock() before clearing tls_devops.
>>> Callers of tls_devops don't hold the rtnl_lock.
>> I think I should correct the statement here, " taking rtnl_lock()
>> before clearing tls_devops and device flags". There won't be any
>> synchronization issue while clearing tls_devops now, because I
>> am incrementing module refcount of CRYPTO ULD, so this will
>> never be called if there is any connection (new connection
>> request) exists.
> Please take a look at tls_set_device_offload():
>
> 	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
> 		rc = -EOPNOTSUPP;
> 		goto release_netdev;
> 	}
>
> 	/* Avoid offloading if the device is down
> 	 * We don't want to offload new flows after
> 	 * the NETDEV_DOWN event
> 	 *
> 	 * device_offload_lock is taken in tls_devices's NETDEV_DOWN
> 	 * handler thus protecting from the device going down before
> 	 * ctx was added to tls_device_list.
> 	 */
> 	down_read(&device_offload_lock);
> 	if (!(netdev->flags & IFF_UP)) {
> 		rc = -EINVAL;
> 		goto release_lock;
> 	}
>
> 	ctx->priv_ctx_tx = offload_ctx;
> 	rc = netdev->tlsdev_ops->tls_dev_add(netdev, sk, TLS_OFFLOAD_CTX_DIR_TX,
> 					     &ctx->crypto_send.info,
> 					     tcp_sk(sk)->write_seq);
>
> This does not hold rtnl_lock. If you clear the ops between the feature
> check and the call - there will be a crash. Never clear tls ops on a
> registered netdev.
>
> Why do you clear the ops in the first place? It shouldn't be necessary.
CHCR driver is a ULD driver, and if user requests to remove chcr alone,
this cleanup will be done. This is why I am taking module refcount until
tls offload flag is set, or any single tls offload connection exists.  
So, now,
when this cleanup will be triggered, TLS offload won't be enabled, and
this crash situation can never occur.
