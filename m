Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E8BC37A6
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 16:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389146AbfJAOjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 10:39:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:51096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388932AbfJAOjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 10:39:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 627F5ADFE;
        Tue,  1 Oct 2019 14:39:22 +0000 (UTC)
Subject: Re: [PATCH v2 1/1] xen-netfront: do not use ~0U as error return value
 for xennet_fill_frags()
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, joe.jin@oracle.com,
        linux-kernel@vger.kernel.org
References: <1569938201-23620-1-git-send-email-dongli.zhang@oracle.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <2071a165-c25f-210d-bda3-9090fe0d5c0e@suse.com>
Date:   Tue, 1 Oct 2019 16:39:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569938201-23620-1-git-send-email-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.10.19 15:56, Dongli Zhang wrote:
> xennet_fill_frags() uses ~0U as return value when the sk_buff is not able
> to cache extra fragments. This is incorrect because the return type of
> xennet_fill_frags() is RING_IDX and 0xffffffff is an expected value for
> ring buffer index.
> 
> In the situation when the rsp_cons is approaching 0xffffffff, the return
> value of xennet_fill_frags() may become 0xffffffff which xennet_poll() (the
> caller) would regard as error. As a result, queue->rx.rsp_cons is set
> incorrectly because it is updated only when there is error. If there is no
> error, xennet_poll() would be responsible to update queue->rx.rsp_cons.
> Finally, queue->rx.rsp_cons would point to the rx ring buffer entries whose
> queue->rx_skbs[i] and queue->grant_rx_ref[i] are already cleared to NULL.
> This leads to NULL pointer access in the next iteration to process rx ring
> buffer entries.
> 
> The symptom is similar to the one fixed in
> commit 00b368502d18 ("xen-netfront: do not assume sk_buff_head list is
> empty in error handling").
> 
> This patch changes the return type of xennet_fill_frags() to indicate
> whether it is successful or failed. The queue->rx.rsp_cons will be
> always updated inside this function.
> 
> Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
