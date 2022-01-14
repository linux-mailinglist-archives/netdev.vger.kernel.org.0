Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE87A48EEBE
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbiANQvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:51:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234458AbiANQvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:51:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642179101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=912e1eTIK4JPbQHZk/1krckW0H7nOEZ7D/D65ylc5E0=;
        b=MoTwUK0DI1OwDgN3E+0s9hV0nosXouiUddFib+VelwxQMQm4N11Cyc6iQd1yIrQPTuKdbM
        jTSSVqXiyh730UHbGvb1wjbbABec8wOr28pdFEFr4+UCO1CwWmQZQjSwNdRExk5fC0WWBY
        HyicH4xZgpL0MA9iv/95OEJzJbla3DQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-J63XQOwXNQKM6UpdvpEpJQ-1; Fri, 14 Jan 2022 11:51:38 -0500
X-MC-Unique: J63XQOwXNQKM6UpdvpEpJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDA17185303B;
        Fri, 14 Jan 2022 16:51:36 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E3852DE79;
        Fri, 14 Jan 2022 16:51:36 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 06027A80ED6; Fri, 14 Jan 2022 17:51:35 +0100 (CET)
Date:   Fri, 14 Jan 2022 17:51:34 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 2/2 net-next v2] igb: refactor XDP registration
Message-ID: <YeGqFq2oJqIzar53@calimero.vinschen.de>
Mail-Followup-To: Denis Kirjanov <dkirjanov@suse.de>,
        intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220114114354.1071776-1-vinschen@redhat.com>
 <20220114114354.1071776-3-vinschen@redhat.com>
 <5521e35f-3adf-2949-f360-12e2f7946480@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5521e35f-3adf-2949-f360-12e2f7946480@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 14 17:13, Denis Kirjanov wrote:
> 1/14/22 14:43, Corinna Vinschen пишет:
> > On changing the RX ring parameters igb uses a hack to avoid a warning
> > when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
> > clears the struct xdp_rxq_info content.
> > 
> > Change this to unregister if we're already registered instead.  ALign
> > code to the igc code.
> > 
> > Fixes: 9cbc948b5a20c ("igb: add XDP support")
> > Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> > ---
> >   drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
> >   drivers/net/ethernet/intel/igb/igb_main.c    | 15 +++++++++++----
> >   2 files changed, 11 insertions(+), 8 deletions(-)
> > [...]
> > +	if (res < 0) {
> > +		netdev_err(rx_ring->netdev,
> > +			   "Failed to register xdp_rxq index %u\n",
> > +			   rx_ring->queue_index);
> nit: would be nice to have the same printing functions like dev_err()
> in the error case

Thanks, I pushed a v3.


Corinna

