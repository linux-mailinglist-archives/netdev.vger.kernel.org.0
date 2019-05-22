Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D40B268C0
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbfEVQ7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:59:05 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34962 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbfEVQ7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 12:59:05 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x4MGwpB7046647;
        Wed, 22 May 2019 11:58:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1558544331;
        bh=J5ibzTbdtqfTFgmWX8EHoNTWjJYZbj/NEFkcBc9RpCM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=omVIjEtW/za1Kfxgta3pdMdCfg6XzQuSUdhgGWpbfS98bqJhAP+JfGLEcK/SB7KPW
         oF0U66u7triwkSH8UGqcAZ62qkCOeyeYp+JIMYWg/VwX4uc4w/+FP0jM6ir4DnXZ9o
         c+riwetdOxiH6EPExk+Jq8uWBIKto829k2AhjUv0=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x4MGwp90008031
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 May 2019 11:58:51 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 22
 May 2019 11:58:50 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 22 May 2019 11:58:50 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x4MGwoSO021390;
        Wed, 22 May 2019 11:58:50 -0500
Subject: Re: [PATCH] hsr: fix don't prune the master node from the node_db
To:     Andreas Oetken <andreas.oetken@siemens.com>
CC:     <andreas@oetken.name>, <a-kramer@ti.com>,
        Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190522060746.30074-1-andreas.oetken@siemens.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <ca9ad005-211b-8e96-fc73-e77063b0f229@ti.com>
Date:   Wed, 22 May 2019 13:02:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190522060746.30074-1-andreas.oetken@siemens.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andreas,

On 05/22/2019 02:07 AM, Andreas Oetken wrote:
> Don't prune master node in the hsr_prune_nodes function.
> Neither time_in[HSR_PT_SLAVE_A], nor time_in[HSR_PT_SLAVE_B],
> will ever be updated by hsr_register_frame_in for the master port.
> Thus the master node will be repeatedly pruned leading to
> repeated packet loss.
> This bug never appeared because the hsr_prune_nodes function
> was only called once. Since commit 5150b45fd355
> ("net: hsr: Fix node prune function for forget time expiry") this issue
> is fixed unvealing the issue described above.
> 
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
> ---
>   net/hsr/hsr_framereg.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 9fa9abd83018..2d7a19750436 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -365,6 +365,14 @@ void hsr_prune_nodes(struct timer_list *t)
>   
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(node, &hsr->node_db, mac_list) {
> +		/* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
> +		 * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
> +		 * the master port. Thus the master node will be repeatedly
> +		 * pruned leading to packet loss.
> +		 */
> +		if (hsr_addr_is_self(hsr, node->macaddress_A))
> +			continue;
> +
>   		/* Shorthand */
>   		time_a = node->time_in[HSR_PT_SLAVE_A];
>   		time_b = node->time_in[HSR_PT_SLAVE_B];
> 
Thanks for the patch!

I have applied this at the tip of master branch and it has passed my
tests. See Test logs https://pastebin.ubuntu.com/p/hQ6JmfQmkz/

But few things to take care in the patch.

1) Whenever you send an updated patch, I believe you need to increment
    the version number. So this should have been v2
2) As per Submitting patches, if a commit fixes another commit, need to
    add a "Fixes " statement as per Documentation/process/submitting-
    patches.rst

See below statements in the above documentation
======================================================================
    If your patch fixes a bug in a specific commit, e.g. you found an
   issue using ``git bisect``, please use the 'Fixes:' tag with the first
   12 characters of the SHA-1 ID, and the one line summary.  Do not split
   the tag across multiple lines, tags are exempt from the "wrap at 75
   columns" rule in order to simplify parsing scripts.  For example::

	Fixes: 54a4f0239f2e ("KVM: MMU: make kvm_mmu_zap_page() return
   the number of pages it actually freed")
=======================================================================

So after fixing the above, you may add below for next revision.

Tested-by: Murali Karicheri <m-karicheri2@ti.com>
