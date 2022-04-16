Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8050503658
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 13:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiDPLdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbiDPLdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:33:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB97240A2E
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 04:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650108651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bAG/WM0W5/enoG6FatM/xF/Cjod8FMGsP2hun8D0RyY=;
        b=LhP8sQc4DRTyExLXhrgUjkHnsQc47tcn1xCsspdtHwvogGfZs7vBp7eX0bI2CvPNsGeaIr
        070i9AqwnXy6gXy/LJS3zdcyGEik1heMfe4y60PJChdpjRUtIAttV15ZcMQNz3bNfKquCE
        JQ8Sc5GDRnUOP2jUnvaMvWJwZOzfJbA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-eaKJ0ggBPE2VTwyeBIMTyA-1; Sat, 16 Apr 2022 07:30:46 -0400
X-MC-Unique: eaKJ0ggBPE2VTwyeBIMTyA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 169A41C05ABC;
        Sat, 16 Apr 2022 11:30:46 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 424AE40EC002;
        Sat, 16 Apr 2022 11:30:44 +0000 (UTC)
Date:   Sat, 16 Apr 2022 13:30:43 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Fei Liu <feliu@redhat.com>, <netdev@vger.kernel.org>,
        <mschmidt@redhat.com>, Brett Creeley <brett@pensando.io>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Message-ID: <20220416133043.08b4ee74@ceranb>
In-Reply-To: <248da3d7-cb00-14b6-12f0-6bb9fda6d532@intel.com>
References: <20220413072259.3189386-1-ivecera@redhat.com>
        <YlldFriBVkKEgbBs@boxer>
        <YlldsfrRJURXpp5d@boxer>
        <248da3d7-cb00-14b6-12f0-6bb9fda6d532@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Apr 2022 13:55:06 -0700
Tony Nguyen <anthony.l.nguyen@intel.com> wrote:

> >>> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> >>> index 5612c032f15a..553287a75b50 100644
> >>> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> >>> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> >>> @@ -3625,44 +3625,39 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
> >>>   		return;
> >>>   	}
> >>>   
> >>> +	mutex_lock(&vf->cfg_lock);
> >>> +
> >>>   	/* Check if VF is disabled. */
> >>>   	if (test_bit(ICE_VF_STATE_DIS, vf->vf_states)) {
> >>>   		err = -EPERM;
> >>> -		goto error_handler;
> >>> -	}
> >>> -
> >>> -	ops = vf->virtchnl_ops;
> >>> -
> >>> -	/* Perform basic checks on the msg */
> >>> -	err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg, msglen);
> >>> -	if (err) {
> >>> -		if (err == VIRTCHNL_STATUS_ERR_PARAM)
> >>> -			err = -EPERM;
> >>> -		else
> >>> -			err = -EINVAL;
> >>> +	} else {
> >>> +		/* Perform basic checks on the msg */
> >>> +		err = virtchnl_vc_validate_vf_msg(&vf->vf_ver, v_opcode, msg,
> >>> +						  msglen);
> >>> +		if (err) {
> >>> +			if (err == VIRTCHNL_STATUS_ERR_PARAM)
> >>> +				err = -EPERM;
> >>> +			else
> >>> +				err = -EINVAL;
> >>> +		}  
> >> The chunk above feels a bit like unnecessary churn, no?
> >> Couldn't this patch be simply focused only on extending critical section?  
> 
> Agree, this doesn't seem related to the fix.
> 
> Thanks,
> 
> Tony
Yes, it is not directly related but it's just a conversion of following snippet
to avoid ugly and unnecessary 'goto':

if (A) {
	err = ...
	goto error_handler;
}
if (B) {
	err = ...
	...
}
if (err) {
	...
}

to

if (A) {
	err = ...
} else {
	if (B) {
		...
	}
}
if (err) {
	...
}

If you want to leave the code as is and remove this from the patch
let me know and I will send v2.

Thanks,
Ivan

