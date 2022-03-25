Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3EA4E73E4
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 14:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359211AbiCYNGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 09:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353651AbiCYNGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 09:06:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10EDB9A9B2
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 06:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648213473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tE/eAfmAjD6lTZj7wBC76uZYxkyvkom3vjRY4fsJkcM=;
        b=NwWW1Ub2Gs5z0r/Yl11yIChxLRIVZicdXU9+sb5k9hkQ3RVbrx7CW8FrXylki+JbntO1V/
        dd3l5UbOCCKfTflWOIVUBr1mFGN2ZrMQcr1X30/pVtgSeMdrd8bm+Qg3WbMsCv4c9JsNy+
        to12d/u07SB2uap2I3aMv1i3m8r3pSM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-TomwG3uSNUuzrcPOhW2nZA-1; Fri, 25 Mar 2022 09:04:30 -0400
X-MC-Unique: TomwG3uSNUuzrcPOhW2nZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DCF9802809;
        Fri, 25 Mar 2022 13:04:29 +0000 (UTC)
Received: from ceranb (unknown [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 374C42166B2D;
        Fri, 25 Mar 2022 13:04:25 +0000 (UTC)
Date:   Fri, 25 Mar 2022 14:04:24 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] ice: Fix broken IFF_ALLMULTI handling
Message-ID: <20220325140424.696e8abc@ceranb>
In-Reply-To: <eb6538d9-4667-f1f5-492c-e1e113a6da35@linux.intel.com>
References: <20220321191731.2596414-1-ivecera@redhat.com>
        <eb6538d9-4667-f1f5-492c-e1e113a6da35@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 21:05:20 +0100
Marcin Szycik <marcin.szycik@linux.intel.com> wrote:

> > @@ -3482,18 +3503,44 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __always_unused __be16 proto,
> >  	if (!vid)
> >  		return 0;
> >  
> > +	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
> > +		usleep_range(1000, 2000);
> > +
> >  	/* Make sure ice_vsi_kill_vlan is successful before updating VLAN
> >  	 * information
> >  	 */
> >  	ret = ice_vsi_kill_vlan(vsi, vid);
> >  	if (ret)
> > -		return ret;
> > +		goto finish;
> >  
> > -	/* Disable pruning when VLAN 0 is the only VLAN rule */
> > -	if (vsi->num_vlan == 1 && ice_vsi_is_vlan_pruning_ena(vsi))
> > -		ret = ice_cfg_vlan_pruning(vsi, false);
> > +	/* Remove multicast promisc rule for the removed VLAN ID if
> > +	 * all-multicast is enabled.
> > +	 */
> > +	if (vsi->current_netdev_flags & IFF_ALLMULTI)
> > +		ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
> > +					   ICE_MCAST_VLAN_PROMISC_BITS, vid);
> > +
> > +	if (vsi->num_vlan == 1) {
> > +		/* Disable pruning when VLAN 0 is the only VLAN rule */
> > +		if (ice_vsi_is_vlan_pruning_ena(vsi))
> > +			ice_cfg_vlan_pruning(vsi, false);  
> 
> Why was `ret = ...` removed here?

Because we are in ice_vlan_rx_kill_vid() that is used to remove VLAN and at this
the VLAN ID was removed from VLAN filter so we cannot return value other than 0.
Network stack would think that the VLAN ID is still present in VLAN filter.

Ivan

