Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5DC48E855
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 11:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240421AbiANK1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 05:27:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237771AbiANK1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 05:27:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642156070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xw8iKaLj3nJD+szzIIhU69FW+tIoZI0k6jaTf1rOw+4=;
        b=WVpkVC2VG3ZXStmG/tMNW2YCJvzWe8HjEA8xqs/loPJnHFhG+R4CXUpcjF+6oWLbZYBWue
        pwlSEKtgG/Bw/QAVvH3OFmMWSt2ysBo/A5wm8Op3tdSdpNN+4iq+tH+tZQc+f9yH26podk
        zJye777mQDupd2okH3T1DZGNsd0V7kw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-AOSJnuNIPBqP8NrnrYmxug-1; Fri, 14 Jan 2022 05:27:46 -0500
X-MC-Unique: AOSJnuNIPBqP8NrnrYmxug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D33118C89CF;
        Fri, 14 Jan 2022 10:27:45 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E93496D036;
        Fri, 14 Jan 2022 10:27:44 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 5AE5DA80ED6; Fri, 14 Jan 2022 11:27:43 +0100 (CET)
Date:   Fri, 14 Jan 2022 11:27:43 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Andre Guedes <andre.guedes@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next] igc: avoid kernel warning
 when changing RX ring parameters
Message-ID: <YeFQH0/LY9R9GWxF@calimero.vinschen.de>
Mail-Followup-To: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Andre Guedes <andre.guedes@intel.com>
References: <20220113160021.1027704-1-vinschen@redhat.com>
 <87sftr6tle.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87sftr6tle.fsf@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jan 13 16:37, Vinicius Costa Gomes wrote:
> Corinna Vinschen <vinschen@redhat.com> writes:
> 
> > Calling ethtool changing the RX ring parameters like this:
> >
> >   $ ethtool -G eth0 rx 1024
> >
> > triggers the "Missing unregister, handled but fix driver" warning in
> > xdp_rxq_info_reg().
> >[...]
> 
> Reaching "inside" xdp_rxq to reset it doesn't feel right in this
> context, even if it's going to work fine (for now).
> 
> I think that the suggestion that Alexander gave in that other thread is
> the best approach. And thanks for noticing that igb '_set_ringparam()'
> has the same underlying problem and also needs to be fixed.

Yeah, it didn't sit overly well with me either, but I thought if it's
good for igb...

Either way, the better approach should be sth. like this in both,
ig[bc]_setup_rx_resources:

	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
			       rx_ring->q_vector->napi.napi_id);

And while at it, wouldn't it make sense to move the xdp_rxq_info_reg
call in igc_setup_rx_resources down to be the last action, so the error
path doesn't have to call xdp_rxq_info_unreg, just like in
igb_setup_rx_resources?


Thanks,
Corinna

