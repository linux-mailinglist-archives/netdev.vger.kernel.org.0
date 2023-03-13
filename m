Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DCF6B8086
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCMS3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjCMS3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:29:32 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC201420A;
        Mon, 13 Mar 2023 11:28:50 -0700 (PDT)
Received: from [172.18.236.247] (unknown [46.183.103.17])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E9CF361CC457B;
        Mon, 13 Mar 2023 19:27:01 +0100 (CET)
Message-ID: <12d1ab7d-c4fd-44b5-7e53-e80cd4b00a21@molgen.mpg.de>
Date:   Mon, 13 Mar 2023 19:26:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH net] ice: fix invalid check for empty
 list in ice_sched_assoc_vsi_to_agg()
Content-Language: en-US
To:     Jakob Koschel <jkl820.git@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        linux-kernel@vger.kernel.org, "Bos, H.J." <h.j.bos@vu.nl>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        intel-wired-lan@lists.osuosl.org
References: <20230301-ice-fix-invalid-iterator-found-check-v1-1-87c26deed999@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230301-ice-fix-invalid-iterator-found-check-v1-1-87c26deed999@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakob,


Thank you for the patch.

Am 13.03.23 um 17:31 schrieb Jakob Koschel:
> The code implicitly assumes that the list iterator finds a correct
> handle. If 'vsi_handle' is not found the 'old_agg_vsi_info' was
> pointing to an bogus memory location. For safety a separate list
> iterator variable should be used to make the != NULL check on
> 'old_agg_vsi_info' correct under any circumstances.
> 
> Additionally Linus proposed to avoid any use of the list iterator
> variable after the loop, in the attempt to move the list iterator
> variable declaration into the macro to avoid any potential misuse after
> the loop. Using it in a pointer comparision after the loop is undefined

compar*i*son

> behavior and should be omitted if possible [1].

(It took me a short time to find the reference number at the end of the 
URL.)

> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_sched.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
> index 4eca8d195ef0..b7682de0ae05 100644
> --- a/drivers/net/ethernet/intel/ice/ice_sched.c
> +++ b/drivers/net/ethernet/intel/ice/ice_sched.c
> @@ -2788,7 +2788,7 @@ static int
>   ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
>   			   u16 vsi_handle, unsigned long *tc_bitmap)
>   {
> -	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
> +	struct ice_sched_agg_vsi_info *agg_vsi_info, *iter, *old_agg_vsi_info = NULL;
>   	struct ice_sched_agg_info *agg_info, *old_agg_info;
>   	struct ice_hw *hw = pi->hw;
>   	int status = 0;
> @@ -2806,11 +2806,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
>   	if (old_agg_info && old_agg_info != agg_info) {
>   		struct ice_sched_agg_vsi_info *vtmp;
>   
> -		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
> +		list_for_each_entry_safe(iter, vtmp,
>   					 &old_agg_info->agg_vsi_list,
>   					 list_entry)
> -			if (old_agg_vsi_info->vsi_handle == vsi_handle)
> +			if (iter->vsi_handle == vsi_handle) {
> +				old_agg_vsi_info = iter;
>   				break;
> +			}
>   	}
>   
>   	/* check if entry already exist */

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
